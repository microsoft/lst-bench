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
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

/**
 * Represents the query result of a query issued against a source. Query result entries should be
 * mapped to column name -> list of column values.
 */
public class QueryResult {

  private final Map<String, List<Object>> valueList;

  public QueryResult() {
    this.valueList = new HashMap<>();
  }

  // TODO: Determine whether this can be done lazily i.e., after the statement has finished
  // executing and the query is not timed anymore.
  public void populate(ResultSet rs) throws SQLException {
    ResultSetMetaData rsmd = rs.getMetaData();

    for (int j = 1; j <= rsmd.getColumnCount(); j++) {
      valueList.put(rsmd.getColumnName(j), new ArrayList<>());
    }

    while (rs.next()) {
      for (int j = 1; j <= rsmd.getColumnCount(); j++) {
        valueList.get(rsmd.getColumnName(j)).add(rs.getObject(j));
      }
    }
  }

  public Integer getValueListSize() {
    Integer size = null;
    for (Entry<String, List<Object>> pair : valueList.entrySet()) {
      size = pair.getValue().size();
      break;
    }
    return size;
  }

  public Map<String, Object> getStringMappings(int listMin, int listMax) {
    Map<String, Object> result = new HashMap<>();
    for (String key : this.valueList.keySet()) {
      List<String> localList =
          this.valueList.get(key).subList(listMin, listMax).stream()
              .map(s -> s.toString())
              .collect(Collectors.toUnmodifiableList());
      result.put(key, "'" + String.join("','", localList) + "'");
    }
    return result;
  }
}
