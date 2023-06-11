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
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;
import com.microsoft.lst_bench.client.ConnectionManager;
import com.microsoft.lst_bench.input.ImmutableTaskLibrary;
import com.microsoft.lst_bench.input.ImmutableWorkload;
import com.microsoft.lst_bench.input.InputToBench;
import com.microsoft.lst_bench.input.TaskLibrary;
import com.microsoft.lst_bench.input.Workload;
import com.microsoft.lst_bench.input.config.ExperimentConfig;
import com.microsoft.lst_bench.input.config.ImmutableExperimentConfig;
import com.microsoft.lst_bench.input.config.ImmutableJDBCConnectionConfig;
import com.microsoft.lst_bench.input.config.TelemetryConfig;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import java.io.File;
import java.net.URL;
import java.util.HashMap;
import java.util.UUID;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class LSTBenchmarkExecutorTest {

  private UUID telemetryDbFileName;

  @BeforeEach
  void setUp() {
    telemetryDbFileName = UUID.randomUUID();
  }

  @AfterEach
  void tearDown() {
    File telemetryDbFile = new File(telemetryDbFileName.toString());
    if (telemetryDbFile.exists()) {
      telemetryDbFile.delete();
    }
  }

  /**
   * This is a no-op test that does not actually run any tasks. It tests that the benchmark executor
   * can be created and run without any exceptions, even without a valid workload. It also captures
   * the minimum configuration required to run the benchmark executor.
   */
  @Test
  void testNoOpSetup() throws Exception {
    var idToConnectionManager = new HashMap<String, ConnectionManager>();
    ExperimentConfig experimentConfig =
        ImmutableExperimentConfig.builder().id("telemetryTest").version(1).repetitions(1).build();
    TaskLibrary taskLibrary = ImmutableTaskLibrary.builder().version(1).build();
    Workload workload = ImmutableWorkload.builder().id("telemetryTest").version(1).build();

    var config = InputToBench.benchmarkConfig(experimentConfig, taskLibrary, workload);

    URL telemetryConfigFile =
        getClass().getClassLoader().getResource("./config/spark/telemetry_config.yaml");
    Assertions.assertNotNull(telemetryConfigFile);
    ObjectMapper mapper = new YAMLMapper();
    TelemetryConfig telemetryConfig =
        mapper.readValue(new File(telemetryConfigFile.getFile()), TelemetryConfig.class);

    var uniqueTelemetryDbName =
        ImmutableJDBCConnectionConfig.builder()
            .from(telemetryConfig.getConnection())
            .url("jdbc:duckdb:./" + telemetryDbFileName)
            .build();

    final SQLTelemetryRegistry telemetryRegistry =
        new SQLTelemetryRegistry(
            InputToBench.connectionManager(uniqueTelemetryDbName),
            telemetryConfig.isExecuteDDL(),
            telemetryConfig.getDDLFile(),
            telemetryConfig.getInsertFile(),
            telemetryConfig.getParameterValues());

    LSTBenchmarkExecutor benchmark =
        new LSTBenchmarkExecutor(idToConnectionManager, config, telemetryRegistry);
    benchmark.run();
  }
}
