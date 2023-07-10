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
import java.util.Set;
import org.junit.jupiter.api.Assertions;
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
    ObjectMapper mapper = new YAMLMapper();
    // Read schema
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(Files.newInputStream(Paths.get(SCHEMAS_PATH + "experiment_config.json")));
    // Validate YAML file contents
    JsonNode jsonNodeDirect =
        mapper.readTree(Files.newInputStream(Paths.get(experimentConfigFilePath)));
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    Assertions.assertEquals(
        0, errorsFromFile.size(), () -> "Errors found in validation: " + errorsFromFile);
    // Validate YAML generated from POJO object
    ExperimentConfig experimentConfig =
        FileParser.createObject(experimentConfigFilePath, ExperimentConfig.class);
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
    ObjectMapper mapper = new YAMLMapper();
    // Read schema
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(
            Files.newInputStream(Paths.get(SCHEMAS_PATH + "connections_config.json")));
    // Validate YAML file contents
    JsonNode jsonNodeDirect = mapper.readTree(Files.newInputStream(Paths.get(configFilePath)));
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    Assertions.assertEquals(
        0, errorsFromFile.size(), () -> "Errors found in validation: " + errorsFromFile);
    // Validate YAML generated from POJO object
    ConnectionsConfig connectionsConfig =
        FileParser.createObject(configFilePath, ConnectionsConfig.class);
    JsonNode jsonNodeObject = mapper.convertValue(connectionsConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(strings = {"src/main/resources/config/spark/", "src/main/resources/config/trino/"})
  public void testValidationTaskLibraryUnix(String configPath) throws IOException {
    testValidationTaskLibrary(configPath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {"src\\main\\resources\\config\\spark\\", "src\\main\\resources\\config\\trino\\"})
  public void testValidationTaskLibraryWin(String configPath) throws IOException {
    testValidationTaskLibrary(configPath);
  }

  private void testValidationTaskLibrary(String configPath) throws IOException {
    ObjectMapper mapper = new YAMLMapper();
    // Read schema
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(Files.newInputStream(Paths.get(SCHEMAS_PATH + "task_library.json")));
    // Validate YAML file contents
    JsonNode jsonNodeDirect =
        mapper.readTree(
            Files.newInputStream(
                Paths.get(configPath + "tpcds" + File.separator + "task_library.yaml")));
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    Assertions.assertEquals(
        0, errorsFromFile.size(), () -> "Errors found in validation: " + errorsFromFile);
    // Validate YAML generated from POJO object
    TaskLibrary taskLibrary =
        FileParser.createObject(
            configPath + "tpcds" + File.separator + "task_library.yaml", TaskLibrary.class);
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
        "src/main/resources/config/trino/tpcds/wp3_rw_concurrency.yaml"
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
        "src\\main\\resources\\config\\trino\\tpcds\\wp3_rw_concurrency.yaml"
      })
  public void testValidationWorkloadWin(String workloadFilePath) throws IOException {
    testValidationWorkload(workloadFilePath);
  }

  private void testValidationWorkload(String workloadFilePath) throws IOException {
    ObjectMapper mapper = new YAMLMapper();
    // Read schema
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(Files.newInputStream(Paths.get(SCHEMAS_PATH + "workload.json")));
    // Validate YAML file contents
    JsonNode jsonNodeDirect = mapper.readTree(Files.newInputStream(Paths.get(workloadFilePath)));
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    Assertions.assertEquals(
        0, errorsFromFile.size(), () -> "Errors found in validation: " + errorsFromFile);
    // Validate YAML generated from POJO object
    Workload workload = FileParser.createObject(workloadFilePath, Workload.class);
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
    ObjectMapper mapper = new YAMLMapper();
    // Read schema
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(mapper)
            .build();
    JsonSchema schema =
        factory.getSchema(Files.newInputStream(Paths.get(SCHEMAS_PATH + "telemetry_config.json")));
    // Validate YAML file contents
    JsonNode jsonNodeDirect =
        mapper.readTree(
            Files.newInputStream(Paths.get(configPath + "sample_telemetry_config.yaml")));
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    Assertions.assertEquals(
        0, errorsFromFile.size(), () -> "Errors found in validation: " + errorsFromFile);
    // Validate YAML generated from POJO object
    TelemetryConfig telemetryConfig =
        FileParser.createObject(configPath + "sample_telemetry_config.yaml", TelemetryConfig.class);
    JsonNode jsonNodeObject = mapper.convertValue(telemetryConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }
}
