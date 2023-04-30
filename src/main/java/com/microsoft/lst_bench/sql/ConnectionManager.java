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

import com.microsoft.lst_bench.input.config.ConnectionConfig;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.annotation.Nullable;
import org.apache.commons.lang3.StringUtils;

/** Simple JDBC connection manager. */
public class ConnectionManager {

  private final String url;

  @Nullable private final String username;

  @Nullable private final String password;

  private ConnectionManager(String url, String username, String password) {
    this.url = url;
    this.username = username;
    this.password = password;
  }

  public Connection createConnection() throws SQLException {
    if (StringUtils.isEmpty(username)) {
      return DriverManager.getConnection(url);
    } else {
      return DriverManager.getConnection(url, username, password);
    }
  }

  public static ConnectionManager from(ConnectionConfig connectionConfig) {
    try {
      Class.forName(connectionConfig.getDriver());
    } catch (ClassNotFoundException e) {
      throw new IllegalArgumentException(
          "Unable to load driver class: " + connectionConfig.getDriver(), e);
    }
    return new ConnectionManager(
        connectionConfig.getUrl(), connectionConfig.getUsername(), connectionConfig.getPassword());
  }
}
