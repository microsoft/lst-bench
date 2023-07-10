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

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;
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
import java.util.StringTokenizer;

/** Utility class with methods to parse auxiliary files for the benchmark. */
public class FileParser {

  private static final ObjectMapper yamlMapper = new YAMLMapper();

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
   * Reads the YAML file and replaces all environment variables (if present). Creates and returns an
   * object of `objectType` class.
   */
  public static <T> T createObject(String filePath, Class<T> objectType) throws IOException {
    return yamlMapper.readValue(StringUtils.replaceEnvVars(new File(filePath)), objectType);
  }
}
