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
package com.microsoft.lst_bench;

import com.microsoft.lst_bench.input.TaskLibrary;
import com.microsoft.lst_bench.input.Workload;
import com.microsoft.lst_bench.input.config.ConnectionsConfig;
import com.microsoft.lst_bench.input.config.ExperimentConfig;
import com.microsoft.lst_bench.input.config.ImmutableExperimentConfig;
import com.microsoft.lst_bench.input.config.TelemetryConfig;
import com.microsoft.lst_bench.util.FileParser;
import java.io.File;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;
import org.junit.jupiter.api.io.TempDir;

/** Unit test for LST-Bench driver running on Spark. */
@EnabledIfSystemProperty(named = "lst-bench.test.db", matches = "spark")
public class DriverSparkTest {

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "delta")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "jdbc")
  public void testJDBCTPCDSAllTasksDelta() throws Exception {
    runDriver(
        "src/test/resources/config/spark/jdbc_connection_config.yaml",
        "src/test/resources/config/spark/experiment_config-delta.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        "src/main/resources/config/spark/tpcds/task_library.yaml",
        "src/test/resources/config/spark/w_all_tpcds-delta.yaml");
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "hudi")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "jdbc")
  public void testJDBCTPCDSAllTasksHudi() throws Exception {
    runDriver(
        "src/test/resources/config/spark/jdbc_connection_config.yaml",
        "src/test/resources/config/spark/experiment_config-hudi.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        "src/main/resources/config/spark/tpcds/task_library.yaml",
        "src/test/resources/config/spark/w_all_tpcds-hudi.yaml");
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "iceberg")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "jdbc")
  public void testJDBCTPCDSAllTasksIceberg() throws Exception {
    runDriver(
        "src/test/resources/config/spark/jdbc_connection_config.yaml",
        "src/test/resources/config/spark/experiment_config-iceberg.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        "src/main/resources/config/spark/tpcds/task_library.yaml",
        "src/test/resources/config/spark/w_all_tpcds-iceberg.yaml");
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "delta")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "jdbc")
  public void testJDBCMultiConnectionDelta() throws Exception {
    runDriver(
        "src/test/resources/config/spark/jdbc_connection_config.yaml",
        "src/test/resources/config/spark/experiment_config-delta.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        "src/test/resources/config/spark/simplified_task_library.yaml",
        "src/test/resources/config/spark/w_multi_connection-delta.yaml");
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "hudi")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "jdbc")
  public void testJDBCMultiConnectionHudi() throws Exception {
    runDriver(
        "src/test/resources/config/spark/jdbc_connection_config.yaml",
        "src/test/resources/config/spark/experiment_config-hudi.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        "src/test/resources/config/spark/simplified_task_library.yaml",
        "src/test/resources/config/spark/w_multi_connection-hudi.yaml");
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "iceberg")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "jdbc")
  public void testJDBCMultiConnectionIceberg() throws Exception {
    runDriver(
        "src/test/resources/config/spark/jdbc_connection_config.yaml",
        "src/test/resources/config/spark/experiment_config-iceberg.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        "src/test/resources/config/spark/simplified_task_library.yaml",
        "src/test/resources/config/spark/w_multi_connection-iceberg.yaml");
  }

  private void runDriver(String arg0, String arg1, String arg2, String arg3, String arg4)
      throws Exception {
    Driver.main(new String[] {"-c", arg0, "-e", arg1, "-t", arg2, "-l", arg3, "-w", arg4});
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "delta")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "spark")
  public void testSparkSessionDelta(@TempDir Path tempDir) throws Exception {
    testSparkSession(
        "src/main/resources/config/spark/tpcds/task_library.yaml",
        "src/test/resources/config/spark/w_all_tpcds_single_session-delta.yaml",
        "src/test/resources/config/spark/spark_connection_config-delta.yaml",
        "src/test/resources/config/spark/experiment_config-delta.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        tempDir);
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "hudi")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "spark")
  public void testSparkSessionHudi(@TempDir Path tempDir) throws Exception {
    testSparkSession(
        "src/main/resources/config/spark/tpcds/task_library.yaml",
        "src/test/resources/config/spark/w_all_tpcds_single_session-hudi.yaml",
        "src/test/resources/config/spark/spark_connection_config-hudi.yaml",
        "src/test/resources/config/spark/experiment_config-hudi.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        tempDir);
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "iceberg")
  @EnabledIfSystemProperty(named = "lst-bench.test.connection", matches = "spark")
  public void testSparkSessionIceberg(@TempDir Path tempDir) throws Exception {
    testSparkSession(
        "src/main/resources/config/spark/tpcds/task_library.yaml",
        "src/test/resources/config/spark/w_all_tpcds_single_session-iceberg.yaml",
        "src/test/resources/config/spark/spark_connection_config-iceberg.yaml",
        "src/test/resources/config/spark/experiment_config-iceberg.yaml",
        "src/test/resources/config/spark/telemetry_config.yaml",
        tempDir);
  }

  private void testSparkSession(
      String arg0, String arg1, String arg2, String arg3, String arg4, Path tempDir)
      throws Exception {
    // Create Java objects from input files
    TaskLibrary taskLibrary = FileParser.createObject(arg0, TaskLibrary.class);
    Workload workload = FileParser.createObject(arg1, Workload.class);
    ConnectionsConfig connectionsConfig = FileParser.createObject(arg2, ConnectionsConfig.class);
    ExperimentConfig experimentConfig = FileParser.createObject(arg3, ExperimentConfig.class);
    TelemetryConfig telemetryConfig = FileParser.createObject(arg4, TelemetryConfig.class);

    // Setup path
    experimentConfig = ingestTempDir(experimentConfig, tempDir);
    createTempDirs(
        Path.of(
            Objects.requireNonNull(experimentConfig.getParameterValues())
                .get("external_data_path")
                .toString()));

    // Run driver
    Driver.run(taskLibrary, workload, connectionsConfig, experimentConfig, telemetryConfig);
  }

  private ExperimentConfig ingestTempDir(ExperimentConfig experimentConfig, Path tempDir) {
    Map<String, Object> parameterValues =
        new HashMap<>(Objects.requireNonNull(experimentConfig.getParameterValues()));
    parameterValues.compute("external_data_path", (k, value) -> tempDir.toString() + value);
    parameterValues.compute("data_path", (k, value) -> tempDir.toString() + value);
    return ImmutableExperimentConfig.builder()
        .from(experimentConfig)
        .parameterValues(parameterValues)
        .build();
  }

  private void createTempDirs(Path tempDir) {
    List<String> tableDirs =
        Arrays.asList(
            "/call_center",
            "/catalog_page",
            "/catalog_returns",
            "/catalog_sales",
            "/customer",
            "/customer_address",
            "/customer_demographics",
            "/date_dim",
            "/household_demographics",
            "/income_band",
            "/inventory",
            "/item",
            "/promotion",
            "/reason",
            "/ship_mode",
            "/store",
            "/store_returns",
            "/store_sales",
            "/time_dim",
            "/warehouse",
            "/web_page",
            "/web_returns",
            "/web_sales",
            "/web_site");
    for (String tableDir : tableDirs) {
      File dir = new File(tempDir + tableDir);
      dir.mkdirs();
    }
  }
}
