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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Nullable;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** A JDBC connection. */
public class JDBCConnection implements Connection {

  private static final Logger LOGGER = LoggerFactory.getLogger(JDBCConnection.class);

  private final String url;
  private final int maxNumRetries;
  private final boolean showWarnings;
  @Nullable private final String username;
  @Nullable private final String password;

  @Nullable private java.sql.Connection connection;

  public JDBCConnection(
      String url, int maxNumRetries, boolean showWarnings, String username, String password) {
    this.url = url;
    this.username = username;
    this.password = password;
    this.maxNumRetries = maxNumRetries;
    this.showWarnings = showWarnings;
    this.connection = null;
  }

  @Override
  public void execute(String sqlText) throws ClientException {
    execute(sqlText, true);
  }

  @Override
  public QueryResult executeQuery(String sqlText) throws ClientException {
    return execute(sqlText, false);
  }

  private QueryResult execute(String sqlText, boolean ignoreResults) throws ClientException {
    refreshConnection();

    QueryResult queryResult = null;
    int errorCount = 0;

    // Infinite retries if number of retries is set to '-1', otherwise retry count is in addition to
    // the 1 default try, thus '<='.
    while (this.maxNumRetries == -1 || errorCount <= this.maxNumRetries) {
      Statement s = null;
      try {
        s = connection.createStatement();
        boolean hasResults = s.execute(sqlText);
        if (hasResults) {
          ResultSet rs = s.getResultSet();
          if (ignoreResults) {
            while (rs.next()) {
              // do nothing
            }
          } else {
            queryResult = new QueryResult();
            queryResult.populate(rs);
          }
        }
        // Log verbosely, if enabled.
        if (this.showWarnings && LOGGER.isWarnEnabled()) {
          LOGGER.warn(
              createWarningString(
                  s,
                  /* prefix= */ errorCount > 0
                      ? ("Retried query, error count: " + errorCount)
                      : ""));
        }
        // Return here if successful.
        return queryResult;
      } catch (Exception e) {
        queryResult = null;
        String lastErrorMsg =
            "Query execution attempt "
                + (errorCount + 1)
                + " unsuccessful, will retry "
                + (this.maxNumRetries - errorCount)
                + " more times; "
                + createWarningString(s, /* prefix= */ "")
                + "stack trace: "
                + ExceptionUtils.getStackTrace(e);

        // Log execution error and any pending warnings associated with this statement, useful for
        // debugging.
        if (errorCount == this.maxNumRetries) {
          LOGGER.error(lastErrorMsg);
          throw new ClientException(lastErrorMsg);
        } else {
          LOGGER.warn(lastErrorMsg);
        }
        errorCount++;
      } finally {
        if (s != null) {
          try {
            s.close();
          } catch (Exception e) {
            String closingError = "Error when closing statement.";
            // Only throw error if it has not been thrown in the try block to avoid overwriting the
            // error.
            if (errorCount != this.maxNumRetries) {
              LOGGER.error(closingError);
              throw new ClientException("Error when closing statement.");
            } else {
              LOGGER.warn(closingError);
            }
          }
        }
      }
    }
    // Return here if max retries reached without success
    return queryResult;
  }

  @Override
  public void close() throws ClientException {
    try {
      if (connection != null && !connection.isClosed()) {
        connection.close();
      }
    } catch (SQLException e) {
      throw new ClientException(e);
    }
  }

  private synchronized void refreshConnection() throws ClientException {
    try {
      if (connection == null || connection.isClosed()) {
        if (StringUtils.isEmpty(username)) {
          connection = DriverManager.getConnection(url);
        } else {
          connection = DriverManager.getConnection(url, username, password);
        }
      }
    } catch (SQLException e) {
      throw new ClientException(e);
    }
  }

  private String createWarningString(Statement s, String prefix) throws ClientException {
    List<String> warningList = new ArrayList<>();

    if (s != null) {
      SQLWarning warning;
      try {
        warning = s.getWarnings();
        while (warning != null) {
          warningList.add(warning.getMessage());
          warning = warning.getNextWarning();
        }
      } catch (SQLException e) {
        throw new ClientException(e.getMessage());
      }
    }

    return prefix + ";" + String.join("; ", warningList);
  }
}
