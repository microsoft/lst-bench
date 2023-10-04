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
import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.StringUtils;
import java.time.Instant;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Custom task executor implementation that allows users to avoid failing execution by skipping
 * queries which return a specific substring in their error message. For this task executor, we
 * allow users to determine the exception strings as part of the input, by specifying parameter
 * 'skip_failed_query_task_strings'. If multiple strings can lead to a skip action, they need to be
 * separated with delimiter ';' by default.
 */
public class SkipFailedQueryTaskExecutor extends CustomTaskExecutor {

  private static final Logger LOGGER = LoggerFactory.getLogger(DependentTaskExecutor.class);

  private final String SKIP_FAILED_QUERY_TASK_DELIMITER = ";";
  private final String SKIP_FAILED_QUERY_TASK_STRINGS = "skip_failed_query_task_strings";

  public SkipFailedQueryTaskExecutor(
      SQLTelemetryRegistry telemetryRegistry,
      String experimentStartTime,
      Map<String, String> arguments) {
    super(telemetryRegistry, experimentStartTime, arguments);
  }

  @Override
  public void executeTask(Connection connection, TaskExec task, Map<String, Object> values)
      throws ClientException {
    String[] exceptionTaskStrings;
    if (this.getArguments() == null
        || this.getArguments().get(SKIP_FAILED_QUERY_TASK_STRINGS) == null) {
      exceptionTaskStrings = new String[] {""};
    } else {
      exceptionTaskStrings =
          this.getArguments()
              .get(SKIP_FAILED_QUERY_TASK_STRINGS)
              .split(SKIP_FAILED_QUERY_TASK_DELIMITER);
    }

    for (FileExec file : task.getFiles()) {
      Instant fileStartTime = Instant.now();
      try {
        for (StatementExec statement : file.getStatements()) {
          boolean skip = false;
          Instant statementStartTime = Instant.now();
          try {
            connection.execute(StringUtils.replaceParameters(statement, values).getStatement());
          } catch (Exception e) {
            for (String skipException : exceptionTaskStrings) {
              LOGGER.error("Exception executing statement: " + statement.getId());
              writeStatementEvent(
                  statementStartTime,
                  statement.getId(),
                  Status.FAILURE,
                  e.getMessage() + "; " + e.getStackTrace());
              if (e.getMessage().contains(skipException)) {
                skip = true;
                break;
              }
            }
            if (!skip) {
              throw e;
            }
          }
          // Only log success if we have not skipped execution.
          if (!skip) {
            writeStatementEvent(
                statementStartTime, statement.getId(), Status.SUCCESS, /* payload= */ null);
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
}
