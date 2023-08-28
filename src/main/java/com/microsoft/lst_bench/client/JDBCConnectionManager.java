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

import java.sql.DriverManager;
import java.sql.SQLException;
import javax.annotation.Nullable;
import org.apache.commons.lang3.StringUtils;

/** Simple JDBC connection manager. */
public class JDBCConnectionManager implements ConnectionManager {

  private final String url;
  private final int max_num_retries;

  @Nullable private final String username;

  @Nullable private final String password;

  public JDBCConnectionManager(String url, int max_num_retries, String username, String password) {
    this.url = url;
    this.max_num_retries = max_num_retries;
    this.username = username;
    this.password = password;
  }

  @Override
  public Connection createConnection() throws ClientException {
    try {
      if (StringUtils.isEmpty(username)) {
        return new JDBCConnection(DriverManager.getConnection(url), this.max_num_retries);
      } else {
        return new JDBCConnection(
            DriverManager.getConnection(url, username, password), this.max_num_retries);
      }
    } catch (SQLException e) {
      throw new ClientException(e);
    }
  }
}
