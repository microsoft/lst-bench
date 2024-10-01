/*
 * Copyright (c) Microsoft Corporation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.microsoft.lst_bench.common;

import com.microsoft.lst_bench.client.Connection;
import com.microsoft.lst_bench.client.ConnectionManager;
import com.microsoft.lst_bench.exec.SessionExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.task.TaskExecutor;
import com.microsoft.lst_bench.task.util.TaskExecutorArguments;
import com.microsoft.lst_bench.telemetry.EventInfo;
import com.microsoft.lst_bench.telemetry.EventInfo.EventType;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.ImmutableEventInfo;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.DateTimeFormatter;
import com.microsoft.lst_bench.util.StringUtils;
import java.lang.reflect.Constructor;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.Validate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** Default executor for sessions. */
public class SessionExecutor implements Callable<Boolean> {

  private static final Logger LOGGER = LoggerFactory.getLogger(SessionExecutor.class);

  private final ConnectionManager connectionManager;
  private final SQLTelemetryRegistry telemetryRegistry;
  private final SessionExec session;
  private final Map<String, Object> runtimeParameterValues;
  private final Map<String, Instant> phaseIdToEndTime;
  private final String experimentStartTime;

  public SessionExecutor(
      ConnectionManager connectionManager,
      SQLTelemetryRegistry telemetryRegistry,
      SessionExec session,
      Map<String, Object> runtimeParameterValues,
      Map<String, Instant> phaseIdToEndTime,
      String experimentStartTime) {
    this.connectionManager = connectionManager;
    this.telemetryRegistry = telemetryRegistry;
    this.session = session;
    this.runtimeParameterValues = runtimeParameterValues;
    this.phaseIdToEndTime = phaseIdToEndTime;
    this.experimentStartTime = experimentStartTime;
  }

  @Override
  public Boolean call() throws Exception {
    Instant sessionStartTime = Instant.now();

    try (Connection connection = connectionManager.createConnection()) {
      handleTasksExecution(connection, session.getMaxConcurrency());
    } catch (Exception e) {
      LOGGER.error("Exception executing session: {}", session.getId());
      writeSessionEvent(sessionStartTime, session.getId(), Status.FAILURE);
      throw e;
    }
    writeSessionEvent(sessionStartTime, session.getId(), Status.SUCCESS);
    return true;
  }

  private void handleTasksExecution(Connection connection, int maxConcurrentTasks)
      throws Exception {
    // Create a thread pool to manage concurrent execution.
    // By default, the limit of concurrent tasks executed in LST-Bench was set to 1 and all tasks
    // are executed sequentially.
    // However, with introduction of start time for tasks, now it is possible to have multiple tasks
    // running concurrently, and we limit the number of concurrent tasks to maxConcurrentTasks.
    // If the number of tasks is greater than maxConcurrentTasks, we will execute maxConcurrentTasks
    // tasks concurrently and wait for any of them to finish before starting the next task. If two
    // tasks have the same start time, they are guaranteed to be executed in the same order as they
    // are defined in the session specification.
    ScheduledExecutorService executor = Executors.newScheduledThreadPool(maxConcurrentTasks);

    // Store Futures to track task execution and check for exceptions later
    List<Future<Boolean>> results = new ArrayList<>();
    try {
      for (TaskExec task : session.getTasks()) {
        long delay = ObjectUtils.<Long>defaultIfNull(task.getStart(), 0L);
        Instant expectedStartTime = Instant.now().plusMillis(delay);
        Future<Boolean> result =
            executor.schedule(
                () -> {
                  Map<String, Object> values = updateRuntimeParameterValues(task);
                  TaskExecutor taskExecutor = getTaskExecutor(task);
                  Instant taskStartTime = Instant.now();
                  try {
                    taskExecutor.executeTask(connection, task, values);
                  } catch (Exception e) {
                    LOGGER.error("Exception executing task: {}", task.getId());
                    writeTaskEvent(
                        taskStartTime,
                        task.getId(),
                        Status.FAILURE,
                        "{expectedStartTime=" + expectedStartTime + "}");
                    throw e;
                  }
                  writeTaskEvent(
                      taskStartTime,
                      task.getId(),
                      Status.SUCCESS,
                      "{expectedStartTime=" + expectedStartTime + "}");
                  return true;
                },
                delay,
                TimeUnit.MILLISECONDS);
        results.add(result);
      }

      // Check for exceptions in any of the submitted tasks
      for (Future<Boolean> result : results) {
        try {
          Validate.isTrue(result.get());
        } catch (InterruptedException | ExecutionException e) {
          throw new RuntimeException("Task did not finish correctly", e);
        }
      }
    } finally {
      executor.shutdown();
      Validate.isTrue(executor.awaitTermination(1, TimeUnit.MINUTES));
    }
  }

  private Map<String, Object> updateRuntimeParameterValues(TaskExec task) {
    Map<String, Object> values = new HashMap<>(this.runtimeParameterValues);
    if (task.getTimeTravelPhaseId() != null) {
      Instant ttPhaseEndTime = this.phaseIdToEndTime.get(task.getTimeTravelPhaseId());
      if (ttPhaseEndTime == null) {
        throw new RuntimeException(
            "Time travel phase identifier not found: " + task.getTimeTravelPhaseId());
      }
      // We round to the next second to make sure we are capturing the changes in case
      // are consecutive phases
      String timeTravelValue =
          DateTimeFormatter.AS_OF_FORMATTER.format(
              ttPhaseEndTime.truncatedTo(ChronoUnit.SECONDS).plusSeconds(1));
      values.put("asof", "TIMESTAMP AS OF " + StringUtils.quote(timeTravelValue));
      // Snowflake requires a different syntax for the asof clause
      values.put(
          "asof_sf", "AT(TIMESTAMP => " + StringUtils.quote(timeTravelValue) + "::TIMESTAMP_LTZ)");
    } else {
      values.put("asof", "");
      values.put("asof_sf", "");
    }
    return values;
  }

  private TaskExecutor getTaskExecutor(TaskExec task) {
    if (task.getCustomTaskExecutor() == null) {
      return new TaskExecutor(
          this.telemetryRegistry, this.experimentStartTime, task.getTaskExecutorArguments());
    } else {
      try {
        Constructor<?> constructor =
            Class.forName(task.getCustomTaskExecutor())
                .getDeclaredConstructor(
                    SQLTelemetryRegistry.class, String.class, TaskExecutorArguments.class);
        return (TaskExecutor)
            constructor.newInstance(
                this.telemetryRegistry, this.experimentStartTime, task.getTaskExecutorArguments());
      } catch (Exception e) {
        throw new IllegalArgumentException(
            "Unable to load custom task class: " + task.getCustomTaskExecutor(), e);
      }
    }
  }

  private EventInfo writeSessionEvent(Instant startTime, String id, Status status) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
            experimentStartTime, startTime, Instant.now(), id, EventType.EXEC_SESSION, status);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }

  private EventInfo writeTaskEvent(Instant startTime, String id, Status status, String payload) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
                experimentStartTime, startTime, Instant.now(), id, EventType.EXEC_TASK, status)
            .withPayload(payload);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }
}
