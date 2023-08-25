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
import com.microsoft.lst_bench.input.BenchmarkObjectFactory;
import com.microsoft.lst_bench.input.ImmutableTaskLibrary;
import com.microsoft.lst_bench.input.ImmutableWorkload;
import com.microsoft.lst_bench.input.TaskLibrary;
import com.microsoft.lst_bench.input.Workload;
import com.microsoft.lst_bench.input.config.ExperimentConfig;
import com.microsoft.lst_bench.input.config.ImmutableExperimentConfig;
import com.microsoft.lst_bench.input.config.ImmutableJDBCConnectionConfig;
import com.microsoft.lst_bench.input.config.TelemetryConfig;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.FileParser;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.UUID;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;
import org.mockito.Mockito;

@DisabledIfSystemProperty(named = "lst-bench.test.db", matches = ".*")
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

    File telemetryDbWalFile = new File(telemetryDbFileName.toString() + ".wal");
    if (telemetryDbWalFile.exists()) {
      telemetryDbWalFile.delete();
    }
  }

  /**
   * This is a no-op test that does not actually run any tasks. It tests that the benchmark executor
   * can be created and run without any exceptions, even without a valid workload. It also captures
   * the minimum configuration required to run the benchmark executor.
   */
  @Test
  void testNoOpSetup() throws Exception {
    var idToConnectionManager = new ArrayList<ConnectionManager>();
    ExperimentConfig experimentConfig =
        ImmutableExperimentConfig.builder().id("nooptest").version(1).repetitions(1).build();
    TaskLibrary taskLibrary = ImmutableTaskLibrary.builder().version(1).build();
    Workload workload = ImmutableWorkload.builder().id("nooptest").version(1).build();

    var config = BenchmarkObjectFactory.benchmarkConfig(experimentConfig, taskLibrary, workload);

    SQLTelemetryRegistry telemetryRegistry = getTelemetryRegistry();

    LSTBenchmarkExecutor benchmark =
        new LSTBenchmarkExecutor(idToConnectionManager, config, telemetryRegistry);
    benchmark.run();
  }

  /**
   * This test runs a sample benchmark workload with a mock connection manager. The mock connection
   * manager does not execute any sql. As such the test can validate the telemetry events that are
   * generated by the benchmark executor. The test events are fetched from the telemetry database.
   */
  @Test
  void testExperimentTimelineTelemetry() throws Exception {

    Connection mockConnection = Mockito.mock(Connection.class);
    ConnectionManager mockConnectionManager = Mockito.mock(ConnectionManager.class);
    Mockito.when(mockConnectionManager.createConnection()).thenReturn(mockConnection);

    // Current workload relies on 2 connection managers
    var connectionManagers = new ArrayList<ConnectionManager>();
    connectionManagers.add(mockConnectionManager);
    connectionManagers.add(mockConnectionManager);

    ExperimentConfig experimentConfig =
        ImmutableExperimentConfig.builder().id("telemetryTest").version(1).repetitions(1).build();

    URL taskLibFile =
        getClass().getClassLoader().getResource("./config/samples/task_library_0.yaml");
    Assertions.assertNotNull(taskLibFile);
    TaskLibrary taskLibrary = FileParser.createObject(taskLibFile.getFile(), TaskLibrary.class);

    URL workloadFile =
        getClass().getClassLoader().getResource("./config/spark/w_all_tpcds-delta.yaml");
    Assertions.assertNotNull(workloadFile);
    Workload workload = FileParser.createObject(workloadFile.getFile(), Workload.class);

    var config = BenchmarkObjectFactory.benchmarkConfig(experimentConfig, taskLibrary, workload);

    SQLTelemetryRegistry telemetryRegistry = getTelemetryRegistry();

    LSTBenchmarkExecutor benchmark =
        new LSTBenchmarkExecutor(connectionManagers, config, telemetryRegistry);
    benchmark.run();

    try (var validationConnection =
        DriverManager.getConnection("jdbc:duckdb:./" + telemetryDbFileName)) {
      ResultSet resultset =
          validationConnection.createStatement().executeQuery("SELECT * FROM experiment_telemetry");
      int totalEvents = 0;
      while (resultset.next()) {
        totalEvents++;
      }
      Assertions.assertEquals(170, totalEvents);

      // TODO improve event validation
    }
  }

  private SQLTelemetryRegistry getTelemetryRegistry() throws ClientException, IOException {
    URL telemetryConfigFile =
        getClass().getClassLoader().getResource("./config/spark/telemetry_config.yaml");
    Assertions.assertNotNull(telemetryConfigFile);
    TelemetryConfig telemetryConfig =
        FileParser.createObject(telemetryConfigFile.getFile(), TelemetryConfig.class);

    var uniqueTelemetryDbName =
        ImmutableJDBCConnectionConfig.builder()
            .from(telemetryConfig.getConnection())
            .url("jdbc:duckdb:./" + telemetryDbFileName)
            .build();

    return new SQLTelemetryRegistry(
        BenchmarkObjectFactory.connectionManager(uniqueTelemetryDbName),
        telemetryConfig.isExecuteDDL(),
        telemetryConfig.getDDLFile(),
        telemetryConfig.getInsertFile(),
        telemetryConfig.getParameterValues());
  }
}
