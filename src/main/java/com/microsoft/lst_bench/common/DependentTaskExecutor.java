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
import com.microsoft.lst_bench.client.QueryResult;
import com.microsoft.lst_bench.exec.FileExec;
import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.StringUtils;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Custom task executor implementation that allows users to execute dependent tasks. We call a
 * dependent task a task that iteratively executes a) a statement that is expected to return a
 * result; and b) a statement repeatedly that is expected to use that result. The result of the
 * first statement is stored in an intermediate object that can be specific to the connection. The
 * expected object for a JDBC connection is of type List<Map<String, Object>>, handling of other
 * objects would need to be added to the if-clause that checks the instance of the object.
 */
public class DependentTaskExecutor extends TaskExecutor {

  private static final Logger LOGGER = LoggerFactory.getLogger(DependentTaskExecutor.class);
  // TODO: Add functionality to use custom replacement markers.
  private static final String DEFAULT_REPLACEMENT_MARKER = "dependent_replace";

  private final Integer dependentBatchSize;

  public DependentTaskExecutor(
      SQLTelemetryRegistry telemetryRegistry,
      String experimentStartTime,
      Integer dependentBatchSize) {
    super(telemetryRegistry, experimentStartTime);
    // Set to a default of '1' if not otherwise specified.
    if (dependentBatchSize == null) {
      this.dependentBatchSize = 1;
    } else {
      this.dependentBatchSize = dependentBatchSize;
    }
  }

  @Override
  public void executeTask(Connection connection, TaskExec task, Map<String, Object> values)
      throws ClientException {
    for (FileExec file : task.getFiles()) {
      Instant fileStartTime = Instant.now();
      try {
        for (int i = 0; i < file.getStatements().size(); i += 2) {
          StatementExec statement = file.getStatements().get(i);

          // Execute first query that retrieves the iterable input for the second query.
          Instant statementStartTime = Instant.now();
          QueryResult queryResult =
              connection.executeQuery(
                  StringUtils.replaceParameters(statement, values).getStatement());
          writeStatementEvent(statementStartTime, statement.getId(), Status.SUCCESS);

          // Execute second query repeatedly with the parameters extracted from the first query.
          int size = queryResult.getValueListSize();
          statement = file.getStatements().get(i + 1);
          for (int j = 0; j < size; j += this.dependentBatchSize) {
            int localMax =
                (j + this.dependentBatchSize) > size ? size : (j + this.dependentBatchSize);
            Map<String, Object> localValues = new HashMap<>(values);
            localValues.put(
                DEFAULT_REPLACEMENT_MARKER, this.createReplacementString(queryResult, j, localMax));

            statementStartTime = Instant.now();
            connection.execute(
                StringUtils.replaceParameters(statement, localValues).getStatement());
            writeStatementEvent(statementStartTime, statement.getId(), Status.SUCCESS);
          }
        }
      } catch (Exception e) {
        LOGGER.error("Exception executing file: " + file.getId());
        writeFileEvent(fileStartTime, file.getId(), Status.FAILURE);
        throw e;
      }
      writeFileEvent(fileStartTime, file.getId(), Status.SUCCESS);
    }
  }

  private String createReplacementString(QueryResult queryResult, int listMin, int listMax) {
    // TODO: Currently insensitive to types, can only do strings.
    List<String> replacementTuples = new ArrayList<>();
    for (int i = listMin; i < listMax; i++) {
      replacementTuples.add(queryResult.getStringTuple(i));
    }

    return "(" + String.join("),(", replacementTuples) + ")";
  }
}
