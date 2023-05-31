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

import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.lst_bench.exec.FileExec;
import com.microsoft.lst_bench.exec.PhaseExec;
import com.microsoft.lst_bench.exec.SessionExec;
import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.exec.WorkloadExec;
import com.microsoft.lst_bench.sql.ConnectionManager;
import com.microsoft.lst_bench.telemetry.EventInfo;
import com.microsoft.lst_bench.telemetry.EventInfo.EventType;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.ImmutableEventInfo;
import com.microsoft.lst_bench.telemetry.JDBCTelemetryRegistry;
import com.microsoft.lst_bench.util.DateTimeFormatter;
import com.microsoft.lst_bench.util.StringUtils;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import org.apache.commons.lang3.Validate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** Benchmark executor implementation. */
public class LSTBenchmarkExecutor extends BenchmarkRunnable {

  private static final Logger LOGGER = LoggerFactory.getLogger(LSTBenchmarkExecutor.class);

  private final Map<String, ConnectionManager> idToConnectionManager;
  private final BenchmarkConfig config;
  private final JDBCTelemetryRegistry telemetryRegistry;

  // UUID to identify the experiment run. The experiment telemetry will be tagged with this UUID.
  private final UUID experimentRunId;

  public LSTBenchmarkExecutor(
      Map<String, ConnectionManager> idToConnectionManager,
      BenchmarkConfig config,
      JDBCTelemetryRegistry telemetryRegistry) {
    super();
    this.idToConnectionManager = Collections.unmodifiableMap(idToConnectionManager);
    this.config = config;
    this.telemetryRegistry = telemetryRegistry;
    this.experimentRunId = UUID.randomUUID();
  }

  /** This method runs the experiment. */
  public void execute() throws Exception {
    LOGGER.info("Running experiment: {}, run-id: {}", config.getId(), experimentRunId);

    final WorkloadExec workload = config.getWorkload();
    final String experimentStartTimeStr = DateTimeFormatter.U_FORMATTER.format(Instant.now());
    LOGGER.info("Experiment start time: {}", experimentStartTimeStr);

    for (int i = 0; i < config.getRepetitions(); i++) {
      LOGGER.info("Starting repetition: {}", i);
      final Instant repetitionStartTime = Instant.now();
      Map<String, Object> experimentMetadata = new HashMap<>(config.getMetadata());
      try {
        // Thread pool size to max number of concurrent sessions
        int maxConcurrentSessions = 1;
        for (PhaseExec phase : workload.getPhases()) {
          if (phase.getSessions().size() > maxConcurrentSessions) {
            maxConcurrentSessions = phase.getSessions().size();
          }
        }
        final ExecutorService executor = Executors.newFixedThreadPool(maxConcurrentSessions);
        // Fill in specific runtime parameter values
        Map<String, Object> runtimeParameterValues = new HashMap<>();
        runtimeParameterValues.put("repetition", i);
        runtimeParameterValues.put("experiment_start_time", experimentStartTimeStr);
        experimentMetadata.putAll(runtimeParameterValues);
        // Go over phases and execute
        Map<String, Instant> phaseIdToEndTime = new HashMap<>();
        for (PhaseExec phase : workload.getPhases()) {
          LOGGER.info("Running " + phase.getId() + " phase...");
          final Instant phaseStartTime = Instant.now();
          EventInfo eventInfo;
          try {
            final List<Worker> threads = new ArrayList<>();
            for (SessionExec session : phase.getSessions()) {
              threads.add(
                  new Worker(
                      // TODO: Multiple connections
                      idToConnectionManager.values().iterator().next(),
                      session,
                      runtimeParameterValues,
                      phaseIdToEndTime));
            }
            checkResults(executor.invokeAll(threads));
            eventInfo = writePhaseEvent(phaseStartTime, phase.getId(), Status.SUCCESS);
          } catch (Exception e) {
            LOGGER.error("Exception executing phase: " + phase.getId());
            writePhaseEvent(phaseStartTime, phase.getId(), Status.FAILURE);
            throw e;
          } finally {
            telemetryRegistry.flush();
          }
          LOGGER.info(
              "Phase {} finished in {} seconds.",
              phase.getId(),
              ChronoUnit.SECONDS.between(phaseStartTime, eventInfo.getEndTime()));
          phaseIdToEndTime.put(phase.getId(), eventInfo.getEndTime());
        }

        executor.shutdown();
        Validate.isTrue(executor.awaitTermination(1, TimeUnit.MINUTES));

        // Log end-to-end execution of experiment.
        writeExperimentEvent(
            repetitionStartTime,
            config.getId(),
            Status.SUCCESS,
            new ObjectMapper().writeValueAsString(experimentMetadata));
      } catch (Exception e) {
        LOGGER.error("Exception executing experiment: " + config.getId());
        writeExperimentEvent(
            repetitionStartTime,
            config.getId(),
            Status.FAILURE,
            new ObjectMapper().writeValueAsString(experimentMetadata));
        throw e;
      } finally {
        telemetryRegistry.flush();
      }
      LOGGER.info("Finished repetition {}", i);
    }
    LOGGER.info("Finished experiment: {}", config.getId());
  }

  private void checkResults(List<Future<Boolean>> results) {
    for (Future<Boolean> result : results) {
      try {
        Validate.isTrue(result.get());
      } catch (InterruptedException | ExecutionException e) {
        throw new RuntimeException("Thread did not finish correctly", e);
      }
    }
  }

  private EventInfo writeExperimentEvent(
      Instant startTime, String id, Status status, String payload) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
                experimentRunId, startTime, Instant.now(), id, EventType.EXEC_EXPERIMENT, status)
            .withPayload(payload);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }

  private EventInfo writePhaseEvent(Instant startTime, String id, Status status) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
            experimentRunId, startTime, Instant.now(), id, EventType.EXEC_PHASE, status);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }

  private EventInfo writeSessionEvent(Instant startTime, String id, Status status) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
            experimentRunId, startTime, Instant.now(), id, EventType.EXEC_SESSION, status);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }

  private EventInfo writeTaskEvent(Instant startTime, String id, Status status) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
            experimentRunId, startTime, Instant.now(), id, EventType.EXEC_TASK, status);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }

  private EventInfo writeFileEvent(Instant startTime, String id, Status status) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
            experimentRunId, startTime, Instant.now(), id, EventType.EXEC_FILE, status);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }

  private EventInfo writeStatementEvent(Instant startTime, String id, Status status) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
            experimentRunId, startTime, Instant.now(), id, EventType.EXEC_STATEMENT, status);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }

  public class Worker implements Callable<Boolean> {

    private final ConnectionManager connectionManager;
    private final SessionExec session;
    private final Map<String, Object> runtimeParameterValues;
    private final Map<String, Instant> phaseIdToEndTime;

    public Worker(
        ConnectionManager connectionManager,
        SessionExec session,
        Map<String, Object> runtimeParameterValues,
        Map<String, Instant> phaseIdToEndTime) {
      this.connectionManager = connectionManager;
      this.session = session;
      this.runtimeParameterValues = runtimeParameterValues;
      this.phaseIdToEndTime = phaseIdToEndTime;
    }

    @Override
    public Boolean call() throws SQLException {
      Instant sessionStartTime = Instant.now();
      try (Connection connection = connectionManager.createConnection()) {
        for (TaskExec task : session.getTasks()) {
          Instant taskStartTime = Instant.now();
          try {
            Map<String, Object> values = getRuntimeParameterValues(task);
            executeTask(connection, task, values);
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

    private void executeTask(Connection connection, TaskExec task, Map<String, Object> values)
        throws SQLException {
      for (FileExec file : task.getFiles()) {
        Instant fileStartTime = Instant.now();
        try {
          for (StatementExec statement : file.getStatements()) {
            Instant statementStartTime = Instant.now();
            try (Statement s = connection.createStatement()) {
              boolean hasResults =
                  s.execute(StringUtils.replaceParameters(statement, values).getStatement());
              if (hasResults) {
                ResultSet rs = s.getResultSet();
                while (rs.next()) {
                  // do nothing
                }
              }
            } catch (Exception e) {
              LOGGER.error("Exception executing statement: " + statement.getId());
              writeStatementEvent(statementStartTime, statement.getId(), Status.FAILURE);
              throw e;
            }
            writeStatementEvent(statementStartTime, statement.getId(), Status.SUCCESS);
          }
        } catch (Exception e) {
          LOGGER.error("Exception executing file: " + file.getId());
          writeFileEvent(fileStartTime, file.getId(), Status.FAILURE);
          throw e;
        }
        writeFileEvent(fileStartTime, file.getId(), Status.SUCCESS);
      }
    }

    private Map<String, Object> getRuntimeParameterValues(TaskExec task) {
      Map<String, Object> values = new HashMap<>(this.runtimeParameterValues);
      if (task.getTimeTravelPhaseId() != null) {
        Instant ttPhaseEndTime = phaseIdToEndTime.get(task.getTimeTravelPhaseId());
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
      }
      return values;
    }
  }
}
