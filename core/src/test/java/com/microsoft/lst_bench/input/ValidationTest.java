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
package com.microsoft.lst_bench.input;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;
import com.microsoft.lst_bench.input.config.ConnectionsConfig;
import com.microsoft.lst_bench.input.config.ExperimentConfig;
import com.microsoft.lst_bench.input.config.TelemetryConfig;
import com.microsoft.lst_bench.util.FileParser;
import com.networknt.schema.JsonSchema;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.SpecVersion;
import com.networknt.schema.ValidationMessage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Set;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;
import org.junit.jupiter.api.condition.EnabledOnOs;
import org.junit.jupiter.api.condition.OS;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

/** Tests for POJO representation matching to YAML schema. */
@DisabledIfSystemProperty(named = "lst-bench.test.db", matches = ".*")
public class ValidationTest {

  private static final ObjectMapper YAML_MAPPER = new YAMLMapper();
  private static final String SCHEMAS_PATH = "schemas" + File.separator;

  private JsonSchema getSchema(String filePath) {
    InputStream schemaInputStream = FileParser.class.getClassLoader().getResourceAsStream(filePath);
    if (schemaInputStream == null) {
      throw new IllegalArgumentException("Schema file does not exist: " + filePath);
    }
    // Validate YAML file contents
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(YAML_MAPPER)
            .build();
    return factory.getSchema(schemaInputStream);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(
      strings = {
        "src/main/resources/config/spark/sample_experiment_config.yaml",
        "src/main/resources/config/trino/sample_experiment_config-delta.yaml",
        "src/main/resources/config/trino/sample_experiment_config-hudi.yaml",
        "src/main/resources/config/trino/sample_experiment_config-iceberg.yaml"
      })
  public void testValidationExperimentConfigUnix(String experimentConfigFilePath)
      throws IOException {
    testValidationExperimentConfig(experimentConfigFilePath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {
        "src\\main\\resources\\config\\spark\\sample_experiment_config.yaml",
        "src\\main\\resources\\config\\trino\\sample_experiment_config-delta.yaml",
        "src\\main\\resources\\config\\trino\\sample_experiment_config-hudi.yaml",
        "src\\main\\resources\\config\\trino\\sample_experiment_config-iceberg.yaml"
      })
  public void testValidationExperimentConfigWin(String experimentConfigFilePath)
      throws IOException {
    testValidationExperimentConfig(experimentConfigFilePath);
  }

  private void testValidationExperimentConfig(String experimentConfigFilePath) throws IOException {
    // Validate YAML file contents and create POJO object
    ExperimentConfig experimentConfig = FileParser.loadExperimentConfig(experimentConfigFilePath);
    // Validate YAML generated from POJO object
    JsonSchema schema = getSchema(SCHEMAS_PATH + "experiment_config.json");
    JsonNode jsonNodeObject = YAML_MAPPER.convertValue(experimentConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(
      strings = {
        "src/test/resources/config/samples/connections_config_test0.yaml",
        "src/main/resources/config/spark/sample_connections_config.yaml",
        "src/main/resources/config/trino/sample_connections_config.yaml"
      })
  public void testValidationConnectionsConfigUnix(String configFilePath) throws IOException {
    testValidationConnectionsConfig(configFilePath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {
        "src\\main\\resources\\config\\spark\\sample_connections_config.yaml",
        "src\\test\\resources\\config\\samples\\connections_config_test0.yaml",
        "src\\main\\resources\\config\\trino\\sample_connections_config.yaml"
      })
  public void testValidationConnectionsConfigWin(String configFilePath) throws IOException {
    testValidationConnectionsConfig(configFilePath);
  }

  private void testValidationConnectionsConfig(String configFilePath) throws IOException {
    // Validate YAML file contents and create POJO object
    ConnectionsConfig connectionsConfig = FileParser.loadConnectionsConfig(configFilePath);
    // Validate YAML generated from POJO object
    JsonSchema schema = getSchema(SCHEMAS_PATH + "connections_config.json");
    JsonNode jsonNodeObject = YAML_MAPPER.convertValue(connectionsConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(
      strings = {
        "run/spark-3.3.1/config/tpcds/library.yaml",
        "run/trino-420/config/tpcds/library.yaml",
        "run/spark-3.3.1/config/tpch/library.yaml"
      })
  public void testValidationLibraryUnix(String libraryPath) throws IOException {
    testValidationLibrary(libraryPath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {
        "run\\spark-3.3.1\\config\\tpcds\\library.yaml",
        "run\\trino-420\\config\\tpcds\\library.yaml",
        "run\\spark-3.3.1\\config\\tpch\\library.yaml"
      })
  public void testValidationLibraryWin(String libraryPath) throws IOException {
    testValidationLibrary(libraryPath);
  }

  private void testValidationLibrary(String libraryPath) throws IOException {
    // Validate YAML file contents and create POJO object
    Library taskLibrary = FileParser.loadLibrary(libraryPath);
    // Validate YAML generated from POJO object
    JsonSchema schema = getSchema(SCHEMAS_PATH + "library.json");
    JsonNode jsonNodeObject = YAML_MAPPER.convertValue(taskLibrary, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(
      strings = {
        "run/spark-3.3.1/config/tpcds/w0_tpcds-delta-2.2.0.yaml",
        "run/spark-3.3.1/config/tpcds/w0_tpcds-hudi-0.12.2.yaml",
        "run/spark-3.3.1/config/tpcds/w0_tpcds-iceberg-1.1.0.yaml",
        "run/spark-3.3.1/config/tpcds/wp1_longevity-delta-2.2.0.yaml",
        "run/spark-3.3.1/config/tpcds/wp2_resilience-delta-2.2.0.yaml",
        "run/spark-3.3.1/config/tpcds/wp3_rw_concurrency-delta-2.2.0.yaml",
        "run/spark-3.3.1/config/tpcds/wp3_rw_concurrency_multi-delta-2.2.0.yaml",
        "run/spark-3.3.1/config/tpcds/wp4_time_travel-delta-2.2.0.yaml",
        "run/trino-420/config/tpcds/w0_tpcds.yaml",
        "run/trino-420/config/tpcds/wp1_longevity.yaml",
        "run/trino-420/config/tpcds/wp2_resilience.yaml",
        "run/trino-420/config/tpcds/wp3_rw_concurrency.yaml",
        "run/spark-3.3.1/config/tpch/w0_tpch-delta.yaml",
        "run/spark-3.3.1/config/tpch/w0_tpch-hudi.yaml",
        "run/spark-3.3.1/config/tpch/w0_tpch-iceberg.yaml"
      })
  public void testValidationWorkloadUnix(String workloadFilePath) throws IOException {
    testValidationWorkload(workloadFilePath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {
        "run\\spark-3.3.1\\config\\tpcds\\w0_tpcds-delta-2.2.0.yaml",
        "run\\spark-3.3.1\\config\\tpcds\\w0_tpcds-hudi-0.12.2.yaml",
        "run\\spark-3.3.1\\config\\tpcds\\w0_tpcds-iceberg-1.1.0.yaml",
        "run\\spark-3.3.1\\config\\tpcds\\wp1_longevity-delta-2.2.0.yaml",
        "run\\spark-3.3.1\\config\\tpcds\\wp2_resilience-delta-2.2.0.yaml",
        "run\\spark-3.3.1\\config\\tpcds\\wp3_rw_concurrency-delta-2.2.0.yaml",
        "run\\spark-3.3.1\\config\\tpcds\\wp3_rw_concurrency_multi-delta-2.2.0.yaml",
        "run\\spark-3.3.1\\config\\tpcds\\wp4_time_travel-delta-2.2.0.yaml",
        "run\\trino-420\\config\\tpcds\\w0_tpcds.yaml",
        "run\\trino-420\\config\\tpcds\\wp1_longevity.yaml",
        "run\\trino-420\\config\\tpcds\\wp2_resilience.yaml",
        "run\\trino-420\\config\\tpcds\\wp3_rw_concurrency.yaml",
        "run\\spark-3.3.1\\config\\tpch\\w0_tpch-delta.yaml",
        "run\\spark-3.3.1\\config\\tpch\\w0_tpch-hudi.yaml",
        "run\\spark-3.3.1\\config\\tpch\\w0_tpch-iceberg.yaml"
      })
  public void testValidationWorkloadWin(String workloadFilePath) throws IOException {
    testValidationWorkload(workloadFilePath);
  }

  private void testValidationWorkload(String workloadFilePath) throws IOException {
    // Validate YAML file contents and create POJO object
    Workload workload = FileParser.loadWorkload(workloadFilePath);
    // Validate YAML generated from POJO object
    JsonSchema schema = getSchema(SCHEMAS_PATH + "workload.json");
    JsonNode jsonNodeObject = YAML_MAPPER.convertValue(workload, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(strings = {"src/main/resources/config/spark/", "src/main/resources/config/trino/"})
  public void testValidationTelemetryConfigUnix(String configPath) throws IOException {
    testValidationTelemetryConfig(configPath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {"src\\main\\resources\\config\\spark\\", "src\\main\\resources\\config\\trino\\"})
  public void testValidationTelemetryConfigWin(String configPath) throws IOException {
    testValidationTelemetryConfig(configPath);
  }

  private void testValidationTelemetryConfig(String configPath) throws IOException {
    // Validate YAML file contents and create POJO object
    TelemetryConfig telemetryConfig =
        FileParser.loadTelemetryConfig(configPath + "sample_telemetry_config.yaml");
    // Validate YAML generated from POJO object
    JsonSchema schema = getSchema(SCHEMAS_PATH + "telemetry_config.json");
    JsonNode jsonNodeObject = YAML_MAPPER.convertValue(telemetryConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(
      strings = {
        "src/test/resources/config/samples/incorrect_telemetry_config_test0.yaml",
        "src/test/resources/config/samples/incorrect_telemetry_config_test1.yaml"
      })
  public void testValidationIncorrectTelemetryConfigUnix(String configFilePath) {
    testValidationIncorrectTelemetryConfig(configFilePath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {
        "src\\test\\resources\\config\\samples\\incorrect_telemetry_config_test0.yaml",
        "src\\test\\resources\\config\\samples\\incorrect_telemetry_config_test1.yaml"
      })
  public void testValidationIncorrectTelemetryConfigWin(String configFilePath) {
    testValidationIncorrectTelemetryConfig(configFilePath);
  }

  private void testValidationIncorrectTelemetryConfig(String configFilePath) {
    // Try to create POJO object, which should fail at validation time
    Assertions.assertThrows(
        IllegalArgumentException.class, () -> FileParser.loadTelemetryConfig(configFilePath));
  }

  @Test
  public void testIncorrectTaskCreation() {
    ImmutableTask.Builder builder =
        ImmutableTask.builder().preparedTaskId("pt_id").templateId("t_id");
    Assertions.assertThrows(IllegalStateException.class, builder::build);
    builder = ImmutableTask.builder();
    Assertions.assertThrows(IllegalStateException.class, builder::build);
  }

  @Test
  public void testIncorrectTasksSequenceCreation() {
    ImmutableTasksSequence.Builder builder =
        ImmutableTasksSequence.builder().preparedTasksSequenceId("pts_id").tasks(new ArrayList<>());
    Assertions.assertThrows(IllegalStateException.class, builder::build);
    builder = ImmutableTasksSequence.builder();
    Assertions.assertThrows(IllegalStateException.class, builder::build);
  }

  @Test
  public void testIncorrectSessionCreation() {
    ImmutableSession.Builder builder =
        ImmutableSession.builder()
            .templateId("t_id")
            .tasksSequences(new ArrayList<>())
            .tasks(new ArrayList<>());
    Assertions.assertThrows(IllegalStateException.class, builder::build);
    builder = ImmutableSession.builder().templateId("t_id").tasks(new ArrayList<>());
    Assertions.assertThrows(IllegalStateException.class, builder::build);
    builder = ImmutableSession.builder();
    Assertions.assertThrows(IllegalStateException.class, builder::build);
  }

  @Test
  public void testIncorrectPhaseCreation() {
    ImmutablePhase.Builder builder =
        ImmutablePhase.builder().templateId("t_id").sessions(new ArrayList<>());
    Assertions.assertThrows(IllegalStateException.class, builder::build);
    builder = ImmutablePhase.builder();
    Assertions.assertThrows(IllegalStateException.class, builder::build);
  }
}
