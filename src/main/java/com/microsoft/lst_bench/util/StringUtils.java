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

import com.microsoft.lst_bench.exec.FileExec;
import com.microsoft.lst_bench.exec.ImmutableFileExec;
import com.microsoft.lst_bench.exec.ImmutableStatementExec;
import com.microsoft.lst_bench.exec.StatementExec;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.io.FileUtils;
import org.apache.commons.text.StringSubstitutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** Utility class for string operations. */
public class StringUtils {

  private static final Logger LOGGER = LoggerFactory.getLogger(StringUtils.class);

  private StringUtils() {
    // Defeat instantiation
  }

  public static String format(String format, Map<String, Object> values) {
    return StringSubstitutor.replace(format, values);
  }

  public static String quote(String str) {
    if (str == null) {
      return null;
    }
    return "'" + str + "'";
  }

  public static StatementExec replaceParameters(
      StatementExec statement, Map<String, Object> parameterValues) {
    if (parameterValues == null || parameterValues.isEmpty()) {
      // Nothing to do
      return statement;
    }
    return ImmutableStatementExec.of(
        statement.getId(), StringUtils.format(statement.getStatement(), parameterValues));
  }

  public static FileExec replaceParameters(FileExec file, Map<String, Object> parameterValues) {
    if (parameterValues == null || parameterValues.isEmpty()) {
      // Nothing to do
      return file;
    }
    return ImmutableFileExec.of(
        file.getId(),
        file.getStatements().stream()
            .map(s -> replaceParameters(s, parameterValues))
            .collect(Collectors.toList()));
  }

  public static FileExec replaceRegex(FileExec f, String regex, String replacement) {
    Pattern pattern = Pattern.compile(regex);
    return ImmutableFileExec.of(
        f.getId(),
        f.getStatements().stream()
            .map(
                s ->
                    ImmutableStatementExec.of(
                        s.getId(), pattern.matcher(s.getStatement()).replaceAll(replacement)))
            .collect(Collectors.toList()));
  }

  /**
   * Reads the contents of the `sourceFile` and replaces any environment variables if present. If
   * the environment variable is not set, the default value is used if specified. All other
   * parameters are ignored.
   */
  public static String replaceEnvVars(File sourceFile) throws IOException {
    if (sourceFile == null || !sourceFile.isFile()) {
      // Nothing to do.
      LOGGER.debug("replaceEnvVars received a null or missing file.");
      return null;
    }
    StringSubstitutor envSub = new StringSubstitutor(System.getenv());
    return envSub.replace(FileUtils.readFileToString(sourceFile, StandardCharsets.UTF_8));
  }
}
