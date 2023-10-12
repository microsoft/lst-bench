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
package com.microsoft.lst_bench.task.custom;

import com.microsoft.lst_bench.client.ClientException;
import com.microsoft.lst_bench.client.Connection;
import com.microsoft.lst_bench.client.QueryResult;
import com.microsoft.lst_bench.exec.FileExec;
import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.task.TaskExecutor;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.StringUtils;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Custom task executor implementation that allows users to execute dependent tasks. We call a
 * dependent task a task that iteratively executes a) a statement that is expected to return a
 * result; and b) a statement repeatedly that is expected to use that result. The result of the
 * first statement is stored in a QueryResult object which is then used and interpreted by the
 * second statement. For this task executor, we allow the second statement to be executed in
 * batches. The batch size can be set via the 'task_executor_arguments' property that is part of the
 * workload configuration. The parameter name is 'dependent_task_batch_size'.
 */
public class DependentTaskExecutor extends TaskExecutor {

  private static final Logger LOGGER = LoggerFactory.getLogger(DependentTaskExecutor.class);

  private final int DEFAULT_BATCH_SIZE = 1;
  private final String DEPENDENT_TASK_BATCH_SIZE = "dependent_task_batch_size";

  public DependentTaskExecutor(
      SQLTelemetryRegistry telemetryRegistry,
      String experimentStartTime,
      Map<String, String> arguments) {
    super(telemetryRegistry, experimentStartTime, arguments);
  }

  @Override
  public void executeTask(Connection connection, TaskExec task, Map<String, Object> values)
      throws ClientException {
    int batchSize;
    if (this.getArguments() == null || this.getArguments().get(DEPENDENT_TASK_BATCH_SIZE) == null) {
      batchSize = DEFAULT_BATCH_SIZE;
    } else {
      batchSize = Integer.valueOf(this.getArguments().get(DEPENDENT_TASK_BATCH_SIZE));
    }

    QueryResult queryResult = null;
    for (FileExec file : task.getFiles()) {
      Instant fileStartTime = Instant.now();

      if (file.getStatements().size() != 1) {
        writeFileEvent(fileStartTime, file.getId(), Status.FAILURE);
        throw new ClientException(
            "For dependent task execution, statements have to be in separate files.");
      }

      StatementExec statement = file.getStatements().get(0);
      try {
        if (queryResult == null) {
          // Execute first query that retrieves the iterable input for the second query.
          Instant statementStartTime = Instant.now();
          queryResult =
              connection.executeQuery(
                  StringUtils.replaceParameters(statement, values).getStatement());
          writeStatementEvent(
              statementStartTime, statement.getId(), Status.SUCCESS, /* payload= */ null);
          if (queryResult == null || queryResult.containsEmptyResultColumnOnly()) {
            // Reset queryResult variable if result is (intentionally) empty.
            queryResult = null;
          }
        } else {
          // Execute second query repeatedly with the parameters extracted from the first query.
          Integer size = queryResult.getValueListSize();
          for (int j = 0; j < size; j += batchSize) {
            int localMax = (j + batchSize) > size ? size : (j + batchSize);
            Map<String, Object> localValues = new HashMap<>(values);
            localValues.putAll(queryResult.getStringMappings(j, localMax));

            Instant statementStartTime = Instant.now();
            connection.execute(
                StringUtils.replaceParameters(statement, localValues).getStatement());
            writeStatementEvent(
                statementStartTime, statement.getId(), Status.SUCCESS, /* payload= */ null);
          }
          // Reset query result.
          queryResult = null;
        }
      } catch (Exception e) {
        String loggedError =
            "Exception executing statement: "
                + statement.getId()
                + ", statement text: "
                + statement.getStatement()
                + "; error message: "
                + e.getMessage();
        LOGGER.error(loggedError);
        writeStatementEvent(
            fileStartTime, statement.getId(), Status.FAILURE, /* payload= */ loggedError);

        LOGGER.error("Exception executing file: " + file.getId());
        writeStatementEvent(
            fileStartTime, file.getId(), Status.FAILURE, /* payload= */ loggedError);
        throw e;
      }
      writeFileEvent(fileStartTime, file.getId(), Status.SUCCESS);
    }
  }
}
