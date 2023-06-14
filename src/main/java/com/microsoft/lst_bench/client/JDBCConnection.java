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

/** A JDBC connection. */
public class JDBCConnection implements Connection {

  private final java.sql.Connection connection;

  public JDBCConnection(java.sql.Connection connection) {
    this.connection = connection;
  }

  @Override
  public void execute(String sqlText) throws ClientException {
    try (Statement s = connection.createStatement()) {
      boolean hasResults = s.execute(sqlText);
      if (hasResults) {
        ResultSet rs = s.getResultSet();
        while (rs.next()) {
          // do nothing
        }
      }
    } catch (Exception e) {
      throw new ClientException(e);
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
