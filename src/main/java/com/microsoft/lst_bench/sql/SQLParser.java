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
package com.microsoft.lst_bench.sql;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

/** Utility class with methods to parse files with a list of SQL statements. */
public class SQLParser {

  private SQLParser() {
    // Defeat instantiation
  }

  public static List<String> getStatements(String filepath) {
    return getStatements(new File(filepath));
  }

  public static List<String> getStatements(File file) {
    final List<String> statements = new ArrayList<>();
    try (BufferedReader br =
        new BufferedReader(
            new InputStreamReader(Files.newInputStream(file.toPath()), StandardCharsets.UTF_8))) {
      for (; ; ) {
        String statement;
        try {
          statement = nextStatement(br);
        } catch (IOException e) {
          throw new RuntimeException("Error while reading next statement", e);
        }
        if (statement == null) {
          break;
        }
        statements.add(statement);
      }
    } catch (IOException e) {
      throw new RuntimeException("Cannot read query in file: " + file, e);
    }
    return statements;
  }

  private static String nextStatement(BufferedReader reader) throws IOException {
    final StringBuilder sb = new StringBuilder();
    for (; ; ) {
      String line = reader.readLine();
      if (line == null) {
        if (sb.length() != 0) {
          throw new RuntimeException("End of file reached before end of SQL statement");
        }
        return null;
      }
      if (line.startsWith("#") || line.startsWith("--") || line.isEmpty()) {
        continue;
      }
      boolean last = false;
      if (line.endsWith(";")) {
        last = true;
        line = line.substring(0, line.length() - 1);
      }
      sb.append(line);
      if (last) {
        String statement = sb.toString();
        sb.setLength(0);
        return statement;
      }
      sb.append("\n");
    }
  }
}
