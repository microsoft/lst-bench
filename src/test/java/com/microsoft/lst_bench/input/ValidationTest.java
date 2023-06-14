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
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;
import org.junit.jupiter.api.condition.EnabledOnOs;
import org.junit.jupiter.api.condition.OS;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

/** Tests for POJO representation matching to YAML schema. */
@DisabledIfSystemProperty(named = "lst-bench.test.db", matches = ".*")
public class ValidationTest {

  private static final String CONFIG_PATH =
      "src"
          + File.separator
          + "main"
          + File.separator
          + "resources"
          + File.separator
          + "config"
          + File.separator
          + "spark"
          + File.separator;

  private static final String SCHEMAS_PATH =
      "src"
          + File.separator
          + "main"
          + File.separator
          + "resources"
          + File.separator
          + "schemas"
          + File.separator;

  @Test
  public void testValidationExperimentConfig() throws IOException {
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
        mapper.readTree(
            Files.newInputStream(Paths.get(CONFIG_PATH + "sample_experiment_config.yaml")));
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    Assertions.assertEquals(
        0, errorsFromFile.size(), () -> "Errors found in validation: " + errorsFromFile);
    // Validate YAML generated from POJO object
    ExperimentConfig experimentConfig =
        mapper.readValue(
            new File(CONFIG_PATH + "sample_experiment_config.yaml"), ExperimentConfig.class);
    JsonNode jsonNodeObject = mapper.convertValue(experimentConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.LINUX, OS.MAC})
  @ValueSource(
      strings = {
        "src/main/resources/config/sample_connections_config.yaml",
        "src/test/resources/config/validation/connections_config_test0.yaml"
      })
  public void testValidationConnectionsConfigUnix(String configFilePath) throws IOException {
    testValidationConnectionsConfig(configFilePath);
  }

  @ParameterizedTest
  @EnabledOnOs({OS.WINDOWS})
  @ValueSource(
      strings = {
        "src\\main\\resources\\config\\sample_connections_config.yaml",
        "src\\test\\resources\\config\\validation\\connections_config_test0.yaml"
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
        mapper.readValue(new File(configFilePath), ConnectionsConfig.class);
    JsonNode jsonNodeObject = mapper.convertValue(connectionsConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @Test
  public void testValidationTaskLibrary() throws IOException {
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
                Paths.get(CONFIG_PATH + "tpcds" + File.separator + "task_library.yaml")));
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    Assertions.assertEquals(
        0, errorsFromFile.size(), () -> "Errors found in validation: " + errorsFromFile);
    // Validate YAML generated from POJO object
    TaskLibrary taskLibrary =
        mapper.readValue(
            new File(CONFIG_PATH + "tpcds" + File.separator + "task_library.yaml"),
            TaskLibrary.class);
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
        "src/main/resources/config/spark/tpcds/wp4_time_travel.yaml"
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
        "src\\main\\resources\\config\\spark\\tpcds\\wp4_time_travel.yaml"
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
    Workload workload = mapper.readValue(new File(workloadFilePath), Workload.class);
    JsonNode jsonNodeObject = mapper.convertValue(workload, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }

  @Test
  public void testValidationTelemetryConfig() throws IOException {
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
            Files.newInputStream(Paths.get(CONFIG_PATH + "sample_telemetry_config.yaml")));
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    Assertions.assertEquals(
        0, errorsFromFile.size(), () -> "Errors found in validation: " + errorsFromFile);
    // Validate YAML generated from POJO object
    TelemetryConfig telemetryConfig =
        mapper.readValue(
            new File(CONFIG_PATH + "sample_telemetry_config.yaml"), TelemetryConfig.class);
    JsonNode jsonNodeObject = mapper.convertValue(telemetryConfig, JsonNode.class);
    Set<ValidationMessage> errorsFromPOJO = schema.validate(jsonNodeObject);
    Assertions.assertEquals(
        0, errorsFromPOJO.size(), () -> "Errors found in validation: " + errorsFromPOJO);
  }
}
