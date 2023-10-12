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

import com.microsoft.lst_bench.client.ClientException;
import com.microsoft.lst_bench.client.Connection;
import com.microsoft.lst_bench.client.ConnectionManager;
import com.microsoft.lst_bench.exec.SessionExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.task.TaskExecutor;
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
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Callable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Default executor for sessions. Iterates over all tasks contained in the session and executes them
 * sequentially.
 */
public class SessionExecutor implements Callable<Boolean> {

  private static final Logger LOGGER = LoggerFactory.getLogger(SessionExecutor.class);

  private final ConnectionManager connectionManager;
  private final SQLTelemetryRegistry telemetryRegistry;
  private final SessionExec session;
  private final Map<String, Object> runtimeParameterValues;
  private final Map<String, Instant> phaseIdToEndTime;
  private String experimentStartTime;

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
  public Boolean call() throws ClientException {
    Instant sessionStartTime = Instant.now();
    try (Connection connection = connectionManager.createConnection()) {
      for (TaskExec task : session.getTasks()) {
        Map<String, Object> values = updateRuntimeParameterValues(task);
        TaskExecutor taskExecutor = getTaskExecutor(task);
        Instant taskStartTime = Instant.now();
        try {
          taskExecutor.executeTask(connection, task, values);
        } catch (Exception e) {
          LOGGER.error("Exception executing task: " + task.getId());
          writeTaskEvent(taskStartTime, task.getId(), Status.FAILURE);
          throw e;
        }
        writeTaskEvent(taskStartTime, task.getId(), Status.SUCCESS);
      }
    } catch (Exception e) {
      LOGGER.error("Exception executing session: " + session.getId());
      writeSessionEvent(sessionStartTime, session.getId(), Status.FAILURE);
      throw e;
    }
    writeSessionEvent(sessionStartTime, session.getId(), Status.SUCCESS);
    return true;
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
    } else {
      values.put("asof", "");
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
                .getDeclaredConstructor(SQLTelemetryRegistry.class, String.class, Map.class);
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

  private EventInfo writeTaskEvent(Instant startTime, String id, Status status) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
            experimentStartTime, startTime, Instant.now(), id, EventType.EXEC_TASK, status);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }
}
