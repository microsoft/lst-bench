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
import java.nio.file.Files;
import java.nio.file.Paths;
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

  private static final String SCHEMAS_PATH =
      "src"
          + File.separator
          + "main"
          + File.separator
          + "resources"
          + File.separator
          + "schemas"
          + File.separator;

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
    ObjectMapper mapper = new YAMLMapper();
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(Files.newInputStream(Paths.get(SCHEMAS_PATH + "experiment_config.json")));
    JsonNode jsonNodeObject = mapper.convertValue(experimentConfig, JsonNode.class);
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
    ObjectMapper mapper = new YAMLMapper();
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(
            Files.newInputStream(Paths.get(SCHEMAS_PATH + "connections_config.json")));
    JsonNode jsonNodeObject = mapper.convertValue(connectionsConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(
      strings = {
        "src/main/resources/config/spark/tpcds/library.yaml",
        "src/main/resources/config/trino/tpcds/library.yaml",
        "src/main/resources/config/spark/tpch/library.yaml"
      })
  public void testValidationLibraryUnix(String libraryPath) throws IOException {
    testValidationLibrary(libraryPath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {
        "src\\main\\resources\\config\\spark\\tpcds\\library.yaml",
        "src\\main\\resources\\config\\trino\\tpcds\\library.yaml",
        "src\\main\\resources\\config\\spark\\tpch\\library.yaml"
      })
  public void testValidationLibraryWin(String libraryPath) throws IOException {
    testValidationLibrary(libraryPath);
  }

  private void testValidationLibrary(String libraryPath) throws IOException {
    // Validate YAML file contents and create POJO object
    Library taskLibrary = FileParser.loadLibrary(libraryPath);
    // Validate YAML generated from POJO object
    ObjectMapper mapper = new YAMLMapper();
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(Files.newInputStream(Paths.get(SCHEMAS_PATH + "library.json")));
    JsonNode jsonNodeObject = mapper.convertValue(taskLibrary, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(
      strings = {
        "src/main/resources/config/spark/tpcds/w0_tpcds-delta.yaml",
        "src/main/resources/config/spark/tpcds/w0_tpcds-hudi.yaml",
        "src/main/resources/config/spark/tpcds/w0_tpcds-iceberg.yaml",
        "src/main/resources/config/spark/tpcds/wp1_longevity.yaml",
        "src/main/resources/config/spark/tpcds/wp2_resilience.yaml",
        "src/main/resources/config/spark/tpcds/wp3_rw_concurrency.yaml",
        "src/main/resources/config/spark/tpcds/wp3_rw_concurrency_multi.yaml",
        "src/main/resources/config/spark/tpcds/wp4_time_travel.yaml",
        "src/main/resources/config/trino/tpcds/w0_tpcds.yaml",
        "src/main/resources/config/trino/tpcds/wp1_longevity.yaml",
        "src/main/resources/config/trino/tpcds/wp2_resilience.yaml",
        "src/main/resources/config/trino/tpcds/wp3_rw_concurrency.yaml",
        "src/main/resources/config/spark/tpch/w0_tpch-delta.yaml",
        "src/main/resources/config/spark/tpch/w0_tpch-hudi.yaml",
        "src/main/resources/config/spark/tpch/w0_tpch-iceberg.yaml"
      })
  public void testValidationWorkloadUnix(String workloadFilePath) throws IOException {
    testValidationWorkload(workloadFilePath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {
        "src\\main\\resources\\config\\spark\\tpcds\\w0_tpcds-delta.yaml",
        "src\\main\\resources\\config\\spark\\tpcds\\w0_tpcds-hudi.yaml",
        "src\\main\\resources\\config\\spark\\tpcds\\w0_tpcds-iceberg.yaml",
        "src\\main\\resources\\config\\spark\\tpcds\\wp1_longevity.yaml",
        "src\\main\\resources\\config\\spark\\tpcds\\wp2_resilience.yaml",
        "src\\main\\resources\\config\\spark\\tpcds\\wp3_rw_concurrency.yaml",
        "src\\main\\resources\\config\\spark\\tpcds\\wp3_rw_concurrency_multi.yaml",
        "src\\main\\resources\\config\\spark\\tpcds\\wp4_time_travel.yaml",
        "src\\main\\resources\\config\\trino\\tpcds\\w0_tpcds.yaml",
        "src\\main\\resources\\config\\trino\\tpcds\\wp1_longevity.yaml",
        "src\\main\\resources\\config\\trino\\tpcds\\wp2_resilience.yaml",
        "src\\main\\resources\\config\\trino\\tpcds\\wp3_rw_concurrency.yaml",
        "src\\main\\resources\\config\\spark\\tpch\\w0_tpch-delta.yaml",
        "src\\main\\resources\\config\\spark\\tpch\\w0_tpch-hudi.yaml",
        "src\\main\\resources\\config\\spark\\tpch\\w0_tpch-iceberg.yaml"
      })
  public void testValidationWorkloadWin(String workloadFilePath) throws IOException {
    testValidationWorkload(workloadFilePath);
  }

  private void testValidationWorkload(String workloadFilePath) throws IOException {
    // Validate YAML file contents and create POJO object
    Workload workload = FileParser.loadWorkload(workloadFilePath);
    // Validate YAML generated from POJO object
    ObjectMapper mapper = new YAMLMapper();
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(Files.newInputStream(Paths.get(SCHEMAS_PATH + "workload.json")));
    JsonNode jsonNodeObject = mapper.convertValue(workload, JsonNode.class);
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
    ObjectMapper mapper = new YAMLMapper();
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(Files.newInputStream(Paths.get(SCHEMAS_PATH + "telemetry_config.json")));
    JsonNode jsonNodeObject = mapper.convertValue(telemetryConfig, JsonNode.class);
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
        ImmutableTask.builder().preparedTaskId("pt_id").tasksSequenceId("ts_id").templateId("t_id");
    Assertions.assertThrows(IllegalStateException.class, builder::build);
    builder = ImmutableTask.builder().tasksSequenceId("ts_id").templateId("t_id");
    Assertions.assertThrows(IllegalStateException.class, builder::build);
    builder = ImmutableTask.builder();
    Assertions.assertThrows(IllegalStateException.class, builder::build);
  }

  @Test
  public void testIncorrectSessionCreation() {
    ImmutableSession.Builder builder =
        ImmutableSession.builder().templateId("t_id").tasks(new ArrayList<>());
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
