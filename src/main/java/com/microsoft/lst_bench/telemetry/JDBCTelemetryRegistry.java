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
package com.microsoft.lst_bench.telemetry;

import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.sql.ConnectionManager;
import com.microsoft.lst_bench.sql.SQLParser;
import com.microsoft.lst_bench.util.StringUtils;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** A telemetry registry that writes events to a JDBC database. */
public class JDBCTelemetryRegistry {

  private static final Logger LOGGER = LoggerFactory.getLogger(JDBCTelemetryRegistry.class);

  private final ConnectionManager connectionManager;

  private final List<StatementExec> insertFileStatements;

  // TODO: Make writing events thread-safe.
  private List<EventInfo> eventsStream;

  public JDBCTelemetryRegistry(
      ConnectionManager connectionManager,
      boolean executeDdl,
      String ddlFile,
      String insertFile,
      Map<String, Object> parameterValues)
      throws SQLException {
    this.connectionManager = connectionManager;
    this.eventsStream = Collections.synchronizedList(new ArrayList<>());
    this.insertFileStatements =
        Collections.unmodifiableList(
            SQLParser.getStatements(insertFile).getStatements().stream()
                .map(s -> StringUtils.replaceParameters(s, parameterValues))
                .collect(Collectors.toList()));
    // Create the tables if they don't exist.
    if (executeDdl) {
      executeDdl(ddlFile, parameterValues);
    }
  }

  private void executeDdl(String ddlFile, Map<String, Object> parameterValues) throws SQLException {
    LOGGER.info("Creating new logging tables...");
    try (Connection connection = connectionManager.createConnection();
        Statement statement = connection.createStatement()) {
      List<StatementExec> ddlFileStatements = SQLParser.getStatements(ddlFile).getStatements();
      for (StatementExec query : ddlFileStatements) {
        String currentQuery = StringUtils.replaceParameters(query, parameterValues).getStatement();
        statement.execute(currentQuery);
      }
    }
    LOGGER.info("Logging tables created.");
  }

  /** Inserts an event into the stream. */
  public void writeEvent(EventInfo eventInfo) {
    eventsStream.add(eventInfo);
  }

  /** Flushes the events to the database. */
  public void flush() throws EventException {
    if (eventsStream.isEmpty()) return;

    LOGGER.info("Flushing events to database...");
    try (Connection connection = connectionManager.createConnection();
        Statement statement = connection.createStatement()) {
      Map<String, Object> values = new HashMap<>();
      values.put(
          "tuples",
          eventsStream.stream()
              .map(
                  o ->
                      String.join(
                          ",",
                          StringUtils.quote(o.getExperimentRunId().toString()),
                          StringUtils.quote(o.getStartTime().toString()),
                          StringUtils.quote(o.getEndTime().toString()),
                          StringUtils.quote(o.getEventId()),
                          StringUtils.quote(o.getEventType().toString()),
                          StringUtils.quote(o.getStatus().toString()),
                          StringUtils.quote(o.getPayload())))
              .collect(Collectors.joining("),(", "(", ")")));
      for (StatementExec query : insertFileStatements) {
        String currentQuery = StringUtils.replaceParameters(query, values).getStatement();
        statement.execute(currentQuery);
      }

      eventsStream = Collections.synchronizedList(new ArrayList<>());
      LOGGER.info("Events flushed to database.");
    } catch (SQLException e) {
      throw new EventException(e);
    }
  }
}
