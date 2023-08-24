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
import com.microsoft.lst_bench.client.ConnectionManager;
import com.microsoft.lst_bench.exec.PhaseExec;
import com.microsoft.lst_bench.exec.SessionExec;
import com.microsoft.lst_bench.exec.WorkloadExec;
import com.microsoft.lst_bench.telemetry.EventInfo;
import com.microsoft.lst_bench.telemetry.EventInfo.EventType;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.ImmutableEventInfo;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.DateTimeFormatter;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

  private final List<ConnectionManager> connectionManagers;
  private final BenchmarkConfig config;
  private final SQLTelemetryRegistry telemetryRegistry;

  // timestamp of the start of the first iteration of an experiment.
  private String experimentStartTime;

  public LSTBenchmarkExecutor(
      List<ConnectionManager> connectionManagers,
      BenchmarkConfig config,
      SQLTelemetryRegistry telemetryRegistry) {
    super();
    this.connectionManagers = Collections.unmodifiableList(connectionManagers);
    this.config = config;
    this.telemetryRegistry = telemetryRegistry;
  }

  /** This method runs the experiment. */
  public void execute() throws Exception {
    this.experimentStartTime = DateTimeFormatter.U_FORMATTER.format(Instant.now());
    LOGGER.info("Running experiment: {}, start-time: {}", config.getId(), experimentStartTime);

    final WorkloadExec workload = config.getWorkload();
    // Thread pool size to max number of concurrent sessions
    int maxConcurrentSessions = 1;
    for (PhaseExec phase : workload.getPhases()) {
      if (phase.getSessions().size() > maxConcurrentSessions) {
        maxConcurrentSessions = phase.getSessions().size();
      }
    }
    
    ExecutorService executor = null;
    for (int i = 0; i < config.getRepetitions(); i++) {
      LOGGER.info("Starting repetition: {}", i);
      final Instant repetitionStartTime = Instant.now();
      Map<String, Object> experimentMetadata = new HashMap<>(config.getMetadata());
      try {
        executor = Executors.newFixedThreadPool(maxConcurrentSessions);

        // Fill in specific runtime parameter values
        Map<String, Object> runtimeParameterValues = new HashMap<>();
        runtimeParameterValues.put("repetition", i);
        runtimeParameterValues.put("experiment_start_time", experimentStartTime);
        experimentMetadata.putAll(runtimeParameterValues);
        // Go over phases and execute
        Map<String, Instant> phaseIdToEndTime = new HashMap<>();
        for (PhaseExec phase : workload.getPhases()) {
          LOGGER.info("Running " + phase.getId() + " phase...");
          final Instant phaseStartTime = Instant.now();
          EventInfo eventInfo;
          try {
            final List<SessionExecutor> threads = new ArrayList<>();
            for (SessionExec session : phase.getSessions()) {
              threads.add(
                  new SessionExecutor(
                      connectionManagers.get(session.getTargetEndpoint()),
                      this.telemetryRegistry,
                      session,
                      runtimeParameterValues,
                      phaseIdToEndTime,
                      this.experimentStartTime));
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
        if (executor != null) {
          executor.shutdown();
          Validate.isTrue(executor.awaitTermination(1, TimeUnit.MINUTES));
        }
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
                experimentStartTime,
                startTime,
                Instant.now(),
                id,
                EventType.EXEC_EXPERIMENT,
                status)
            .withPayload(payload);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }

  private EventInfo writePhaseEvent(Instant startTime, String id, Status status) {
    EventInfo eventInfo =
        ImmutableEventInfo.of(
            experimentStartTime, startTime, Instant.now(), id, EventType.EXEC_PHASE, status);
    telemetryRegistry.writeEvent(eventInfo);
    return eventInfo;
  }
}
