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
import com.microsoft.lst_bench.exec.FileExec;
import com.microsoft.lst_bench.exec.ImmutableStatementExec;
import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.StringUtils;
import java.time.Instant;
import java.util.Map;
import java.util.regex.Pattern;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Custom task executor implementation that allows users to execute concurrent tasks for specfic
 * performance stress testing. This type of testing focuses on queries that a) get enhanced with
 * additional joins (number specified by the user) and b) get augmented with query padding (empty
 * characters) at the end of the query, if specified by the user. This augmentation requires a
 * specific query of the form "SELECT ... FROM ..." without additional clauses such as "WHERE" or
 * "ORDER" to allow for join extensions. The properties of this class are defined via the
 * 'custom_task_executor_arguments' property that are part of the workload configuration. Valid
 * parameter names are 'concurrent_task_num_joins' and 'concurrent_task_min_query_length', their
 * defaults are set to '0'. The user may further choose to specify parameters
 * 'concurrent_id_separator' and 'concurrent_id_connector' which are used to build the id of the
 * newly generated queries. The default for these parameters is set to ';' resp. '-'.
 */
public class ConcurrentPerfStresstestTaskExecutor extends CustomTaskExecutor {

  private static final Logger LOGGER =
      LoggerFactory.getLogger(ConcurrentPerfStresstestTaskExecutor.class);

  private final int DEFAULT_CONCURRENT_TASK_NUM_JOINS = 0;
  private final int DEFAULT_CONCURRENT_TASK_MIN_QUERY_LENGTH = 0;
  private final String CONCURRENT_TASK_NUM_JOINS = "concurrent_task_num_joins";
  private final String CONCURRENT_TASK_MIN_QUERY_LENGTH = "concurrent_task_min_query_length";
  private final String DEFAULT_CONCURRENT_ID_SEPARATOR = ";";
  private final String DEFAULT_CONCURRENT_ID_CONNECTOR = "-";
  private final String CONCURRENT_ID_SEPARATOR = "concurrent_id_separator";
  private final String CONCURRENT_ID_CONNECTOR = "concurrent_id_connector";

  private final Pattern WHERE_PATTERN = Pattern.compile("WHERE|where|Where");
  private final Pattern ORDER_PATTERN = Pattern.compile("ORDER|order|Order");
  private final Pattern FROM_PATTERN = Pattern.compile("FROM|from|From");

  private final String QUERY_END_TOKEN = ";";

  public ConcurrentPerfStresstestTaskExecutor(
      SQLTelemetryRegistry telemetryRegistry,
      String experimentStartTime,
      Map<String, String> arguments) {
    super(telemetryRegistry, experimentStartTime, arguments);
  }

  @Override
  public void executeTask(Connection connection, TaskExec task, Map<String, Object> values)
      throws ClientException {
    // Set default values.
    int numJoins;
    if (this.getArguments() == null || this.getArguments().get(CONCURRENT_TASK_NUM_JOINS) == null) {
      numJoins = DEFAULT_CONCURRENT_TASK_NUM_JOINS;
    } else {
      numJoins = Integer.valueOf(this.getArguments().get(CONCURRENT_TASK_NUM_JOINS));
    }
    int minQueryLength;
    if (this.getArguments() == null
        || this.getArguments().get(CONCURRENT_TASK_MIN_QUERY_LENGTH) == null) {
      minQueryLength = DEFAULT_CONCURRENT_TASK_MIN_QUERY_LENGTH;
    } else {
      minQueryLength = Integer.valueOf(this.getArguments().get(CONCURRENT_TASK_MIN_QUERY_LENGTH));
    }

    for (FileExec file : task.getFiles()) {
      Instant fileStartTime = Instant.now();

      if (file.getStatements().size() != 1) {
        writeFileEvent(fileStartTime, file.getId(), Status.FAILURE);
        throw new ClientException("Concurrent task execution requires one statement per file.");
      }
      StatementExec statement = file.getStatements().get(0);

      if (WHERE_PATTERN.matcher(statement.getStatement()).find()
          || ORDER_PATTERN.matcher(statement.getStatement()).find()) {
        writeStatementEvent(
            fileStartTime,
            file.getId(),
            Status.FAILURE,
            /* payload= */ "Query contains invalid key words (WHERE, ORDER, etc.): "
                + statement.getStatement());
        throw new ClientException(
            "Query contains invalid key words (WHERE, ORDER, etc.): " + statement.getStatement());
      } else if (!FROM_PATTERN.matcher(statement.getStatement()).find()) {
        writeStatementEvent(
            fileStartTime,
            file.getId(),
            Status.FAILURE,
            /* payload= */ "Query does not contain keyword 'FROM': " + statement.getStatement());
        throw new ClientException(
            "Query does not contain keyword 'FROM': " + statement.getStatement());
      }

      try {
        String query = statement.getStatement().split(QUERY_END_TOKEN)[0];
        String join_clause = query.split(FROM_PATTERN.pattern())[1].trim();
        // Adjust number of joins.
        for (int i = 0; i < numJoins; i++) {
          query += ", " + join_clause + i;
        }
        // Adjust query padding.
        int queryPadding = minQueryLength - query.length();
        if (queryPadding > 0) {
          query += new String(new char[queryPadding]).replace('\0', ' ');
        }
        query += QUERY_END_TOKEN;

        StatementExec mod_statement =
            ImmutableStatementExec.of(
                statement.getId()
                    + getIdSeparator()
                    + "numJoins"
                    + numJoins
                    + getIdConnector()
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
      writeStatementEvent(statementStartTime, statement.getId(), Status.FAILURE, error_msg);
      throw new ClientException(error_msg);
    }
    writeStatementEvent(statementStartTime, statement.getId(), Status.SUCCESS, /* payload= */ null);
  }

  private String getIdSeparator() {
    String idSeparator;
    if (this.getArguments() == null || this.getArguments().get(CONCURRENT_ID_SEPARATOR) == null) {
      idSeparator = DEFAULT_CONCURRENT_ID_SEPARATOR;
    } else {
      idSeparator = this.getArguments().get(CONCURRENT_ID_SEPARATOR);
    }
    return idSeparator;
  }

  private String getIdConnector() {
    String idConnector;
    if (this.getArguments() == null || this.getArguments().get(CONCURRENT_ID_CONNECTOR) == null) {
      idConnector = DEFAULT_CONCURRENT_ID_CONNECTOR;
    } else {
      idConnector = this.getArguments().get(CONCURRENT_ID_CONNECTOR);
    }
    return idConnector;
  }
}
