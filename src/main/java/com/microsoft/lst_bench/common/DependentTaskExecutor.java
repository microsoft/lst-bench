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
import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.StringUtils;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Custom task executor implementation that allows users to execute dependent tasks. We call a
 * dependent task a task that iteratively executes a) a statement that is expected to return a
 * result; and b) a statement that is expected to use that result.
 */
public class DependentTaskExecutor extends TaskExecutor {

  private static final Logger LOGGER = LoggerFactory.getLogger(DependentTaskExecutor.class);

  public DependentTaskExecutor(SQLTelemetryRegistry telemetryRegistry, String experimentStartTime) {
    super(telemetryRegistry, experimentStartTime);
  }

  public void executeTask(Connection connection, TaskExec task, Map<String, Object> values)
      throws ClientException {
    for (FileExec file : task.getFiles()) {
      Instant fileStartTime = Instant.now();
      try {
        Map<String, Object> local_values;
        for (int i = 0; i < file.getStatements().size(); i += 2) {
          StatementExec statement = file.getStatements().get(i);
          Instant statementStartTime = Instant.now();
          try {
            ResultSet rs =
                (ResultSet)
                    connection.executeQuery(
                        StringUtils.replaceParameters(statement, values).getStatement());
            writeStatementEvent(statementStartTime, statement.getId(), Status.SUCCESS);

            if (rs != null) {
              ResultSetMetaData metaData = rs.getMetaData();
              while (rs.next()) {
                local_values = new HashMap<>(values);
                for (int j = 1; j <= metaData.getColumnCount(); j++) {
                  local_values.put(metaData.getColumnName(j), rs.getObject(j));
                }
                statementStartTime = Instant.now();
                connection.execute(
                    StringUtils.replaceParameters(statement, local_values).getStatement());
                writeStatementEvent(statementStartTime, statement.getId(), Status.SUCCESS);
              }
            }
          } catch (Exception e) {
            LOGGER.error("Exception executing statement: " + statement.getId());
            writeStatementEvent(statementStartTime, statement.getId(), Status.FAILURE);
            // TODO: Figure out whether there's a better way to avoid SQLExceptions.
            throw new ClientException(e.getMessage());
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
