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
import com.microsoft.lst_bench.exec.FileExec;
import com.microsoft.lst_bench.exec.ImmutableStatementExec;
import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.input.BenchmarkObjectFactory;
import com.microsoft.lst_bench.input.Task.CustomTaskExecutorArguments;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.StringUtils;
import java.time.Instant;
import java.util.Map;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Custom task executor implementation that allows users to execute concurrent tasks for specfic
 * performance stress testing. This type of testing focuses on queries that a) get enhanced with
 * additional joins (number specified by the user) and b) get augmented with query padding (empty
 * characters) at the end of the query, if specified by the user.
 */
public class ConcurrentPerfStresstestTaskExecutor extends CustomTaskExecutor {

  private static final Logger LOGGER =
      LoggerFactory.getLogger(ConcurrentPerfStresstestTaskExecutor.class);

  public ConcurrentPerfStresstestTaskExecutor(
      SQLTelemetryRegistry telemetryRegistry,
      String experimentStartTime,
      CustomTaskExecutorArguments arguments) {
    super(telemetryRegistry, experimentStartTime, arguments);
  }

  @Override
  public void executeTask(Connection connection, TaskExec task, Map<String, Object> values)
      throws ClientException {
    // Will never be null since they are set to default values.
    int numJoins = this.getArguments().getConcurrentTaskNumJoins();
    int minQueryLength = this.getArguments().getConcurrentTaskMinQueryLength();

    for (FileExec file : task.getFiles()) {
      Instant fileStartTime = Instant.now();

      if (file.getStatements().size() != 1) {
        writeFileEvent(fileStartTime, file.getId(), Status.FAILURE);
        throw new ClientException("Concurrent task execution requires one statement per file.");
      }
      StatementExec statement = file.getStatements().get(0);

      if (statement.getStatement().contains("WHERE")
          || statement.getStatement().contains("ORDER")
          || statement.getStatement().contains(";")) {
        writeStatementEvent(
            fileStartTime,
            file.getId(),
            Status.FAILURE,
            /* payload= */ "Query contains invalid key words (WHERE, ORDER, etc.): "
                + statement.getStatement());
        throw new ClientException(
            "Query contains invalid key words (WHERE, ORDER, etc.): " + statement.getStatement());
      } else if (!statement.getStatement().contains("FROM")) {
        writeStatementEvent(
            fileStartTime,
            file.getId(),
            Status.FAILURE,
            /* payload= */ "Query does not contain keyword 'FROM': " + statement.getStatement());
        throw new ClientException(
            "Query does not contain keyword 'FROM': " + statement.getStatement());
      }

      try {
        String query = statement.getStatement().split(";")[0];
        String join_clause = query.split("FROM")[1].trim();
        // Adjust number of joins.
        for (int i = 0; i < numJoins; i++) {
          query += ", " + join_clause + i;
        }
        // Adjust query padding.
        int queryPadding = minQueryLength - query.length();
        if (queryPadding > 0) {
          query += new String(new char[queryPadding]).replace('\0', ' ');
        }

        StatementExec mod_statement =
            ImmutableStatementExec.of(
                statement.getId()
                    + BenchmarkObjectFactory.DEFAULT_ID_SEPARATOR
                    + "numJoins"
                    + numJoins
                    + BenchmarkObjectFactory.DEFAULT_ID_CONNECTOR
                    + "minQueryLength"
                    + minQueryLength,
                query);
        executeStatement(connection, values, mod_statement);
      } catch (ClientException e) {
        LOGGER.error("Exception executing file: " + file.getId());
        writeFileEvent(fileStartTime, file.getId(), Status.FAILURE);
        throw e;
      }
      writeFileEvent(fileStartTime, file.getId(), Status.SUCCESS);
    }
  }

  private void executeStatement(
      Connection connection, Map<String, Object> values, StatementExec statement)
      throws ClientException {
    Instant statementStartTime = Instant.now();
    try {
      connection.execute(StringUtils.replaceParameters(statement, values).getStatement());
    } catch (Exception e) {
      String error_msg =
          "Exception executing statement: "
              + statement.getId()
              + "; "
              + ExceptionUtils.getStackTrace(e);
      LOGGER.error(error_msg);
      writeStatementEvent(statementStartTime, statement.getId(), Status.FAILURE, error_msg);
      throw new ClientException(error_msg);
    }
    writeStatementEvent(statementStartTime, statement.getId(), Status.SUCCESS, /* payload= */ null);
  }
}
