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
package com.microsoft.lst_bench.util;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;
import com.microsoft.lst_bench.input.Library;
import com.microsoft.lst_bench.input.Workload;
import com.microsoft.lst_bench.input.config.ConnectionsConfig;
import com.microsoft.lst_bench.input.config.ExperimentConfig;
import com.microsoft.lst_bench.input.config.TelemetryConfig;
import com.networknt.schema.JsonSchema;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.SpecVersion;
import com.networknt.schema.ValidationMessage;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

/** Utility class with methods to parse auxiliary files for the benchmark. */
public class FileParser {

  private static final ObjectMapper YAML_MAPPER = new YAMLMapper();
  private static final String SCHEMAS_PATH =
      "src"
          + File.separator
          + "main"
          + File.separator
          + "resources"
          + File.separator
          + "schemas"
          + File.separator;

  private FileParser() {
    // Defeat instantiation
  }

  public static List<String> getPermutationOrder(String permutationOrdersDirectory, int counter) {
    File directory = new File(permutationOrdersDirectory);
    File[] files = directory.listFiles();
    if (files == null) {
      throw new IllegalArgumentException(
          "Cannot find permutation order files in directory: " + permutationOrdersDirectory);
    }
    if (counter >= files.length) {
      throw new IllegalArgumentException(
          "Cannot find permutation order file with index: " + counter);
    }
    File file = files[counter];
    List<String> permutationOrder = new ArrayList<>();
    try (BufferedReader br =
        new BufferedReader(
            new InputStreamReader(Files.newInputStream(file.toPath()), StandardCharsets.UTF_8))) {
      String filename;
      while ((filename = br.readLine()) != null) {
        if (filename.startsWith("#") || filename.startsWith("--") || filename.isEmpty()) {
          continue;
        }
        permutationOrder.add(filename);
      }
    } catch (IOException e) {
      throw new RuntimeException(
          "Cannot read permutation order file: " + file.getAbsolutePath(), e);
    }
    return permutationOrder;
  }

  public static Map<String, Object> getParameterValues(String parameterValuesFile, int counter) {
    Map<String, Object> values = new HashMap<>();
    File file = new File(parameterValuesFile);
    if (!file.exists()) {
      throw new IllegalArgumentException(
          "Cannot find parameter values file: " + parameterValuesFile);
    }
    try (BufferedReader br =
        new BufferedReader(
            new InputStreamReader(Files.newInputStream(file.toPath()), StandardCharsets.UTF_8))) {
      String header = br.readLine();
      String line = null;
      for (int j = 1; j <= counter; j++) {
        line = br.readLine();
      }
      if (line == null) {
        throw new IllegalArgumentException("Cannot find parameter values with index: " + counter);
      }
      StringTokenizer stHeader = new StringTokenizer(header, "|");
      StringTokenizer stLine = new StringTokenizer(line, "|");
      while (stHeader.hasMoreTokens()) {
        String headerToken = stHeader.nextToken();
        String lineToken = stLine.nextToken();
        values.put(headerToken, lineToken);
      }
      if (stLine.hasMoreTokens()) {
        throw new IllegalArgumentException(
            "Parameter values line " + counter + " has more values than header");
      }
    } catch (IOException e) {
      throw new RuntimeException("Cannot read parameter values file: " + file.getAbsolutePath(), e);
    }
    return values;
  }

  /**
   * Reads the YAML file and replaces all environment variables (if present). Validates the YAML
   * file according to the schema. Creates and returns a `TaskLibrary` object.
   */
  public static Library loadLibrary(String filePath) throws IOException {
    return createObject(filePath, Library.class, SCHEMAS_PATH + "library.json");
  }

  /**
   * Reads the YAML file and replaces all environment variables (if present). Validates the YAML
   * file according to the schema. Creates and returns a `Workload` object.
   */
  public static Workload loadWorkload(String filePath) throws IOException {
    return createObject(filePath, Workload.class, SCHEMAS_PATH + "workload.json");
  }

  /**
   * Reads the YAML file and replaces all environment variables (if present). Validates the YAML
   * file according to the schema. Creates and returns a `ConnectionsConfig` object.
   */
  public static ConnectionsConfig loadConnectionsConfig(String filePath) throws IOException {
    return createObject(
        filePath, ConnectionsConfig.class, SCHEMAS_PATH + "connections_config.json");
  }

  /**
   * Reads the YAML file and replaces all environment variables (if present). Validates the YAML
   * file according to the schema. Creates and returns a `ExperimentConfig` object.
   */
  public static ExperimentConfig loadExperimentConfig(String filePath) throws IOException {
    return createObject(filePath, ExperimentConfig.class, SCHEMAS_PATH + "experiment_config.json");
  }

  /**
   * Reads the YAML file and replaces all environment variables (if present). Validates the YAML
   * file according to the schema. Creates and returns a `TelemetryConfig` object.
   */
  public static TelemetryConfig loadTelemetryConfig(String filePath) throws IOException {
    return createObject(filePath, TelemetryConfig.class, SCHEMAS_PATH + "telemetry_config.json");
  }

  /**
   * Reads the YAML file and replaces all environment variables (if present). Validates the YAML
   * file according to the schema (if validation is enabled). Creates and returns an object of
   * `objectType` class.
   */
  private static <T> T createObject(String filePath, Class<T> objectType, String schemaFilePath)
      throws IOException {

    // Verify that files exist
    File file = new File(filePath);
    File schemaFile = new File(schemaFilePath);
    if (!file.exists()) {
      throw new IllegalArgumentException("File does not exist: " + filePath);
    }
    if (!schemaFile.exists()) {
      throw new IllegalArgumentException("Schema file does not exist: " + schemaFilePath);
    }

    String resolvedYAMLContent = StringUtils.replaceEnvVars(file);

    if (resolvedYAMLContent == null) {
      throw new IllegalArgumentException("Error resolving environment variables in YAML file");
    }

    // Validate YAML file contents
    JsonSchemaFactory factory =
        JsonSchemaFactory.builder(JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V202012))
            .objectMapper(YAML_MAPPER)
            .build();
    JsonSchema schema = factory.getSchema(Files.newInputStream(schemaFile.toPath()));
    JsonNode jsonNodeDirect = YAML_MAPPER.readTree(resolvedYAMLContent);
    Set<ValidationMessage> errorsFromFile = schema.validate(jsonNodeDirect);
    if (!errorsFromFile.isEmpty()) {
      throw new IllegalArgumentException("Errors found in YAML validation: " + errorsFromFile);
    }
    // Create and return POJO
    return YAML_MAPPER.treeToValue(jsonNodeDirect, objectType);
  }
}
