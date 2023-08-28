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
package com.microsoft.lst_bench.client;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** A JDBC connection. */
public class JDBCConnection implements Connection {

  private static final Logger LOGGER = LoggerFactory.getLogger(JDBCConnection.class);

  private final java.sql.Connection connection;
  private final int max_num_retries;

  public JDBCConnection(java.sql.Connection connection, int max_num_retries) {
    this.connection = connection;
    this.max_num_retries = max_num_retries;
  }

  @Override
  public void execute(String sqlText) throws ClientException {
    Exception last_error = null;
    int error_count = 0;

    while (error_count < this.max_num_retries) {
      try (Statement s = connection.createStatement()) {
        boolean hasResults = s.execute(sqlText);
        if (hasResults) {
          ResultSet rs = s.getResultSet();
          while (rs.next()) {
            // do nothing
          }
        }
        return;

      } catch (Exception e) {
        last_error = e;
        error_count++;
      }
    }

    if (last_error != null) {
      String last_error_msg =
          "Query retries ("
              + this.max_num_retries
              + ") unsuccessful. Error occurred while executing the following query: "
              + sqlText;
      LOGGER.info(last_error_msg);
      throw new ClientException(last_error_msg);
    }
  }

  @Override
  public void close() throws ClientException {
    try {
      connection.close();
    } catch (SQLException e) {
      throw new ClientException(e);
    }
  }
}
