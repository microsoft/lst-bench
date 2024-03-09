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
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.tuple.Pair;

/**
 * Represents the query result of a query issued against a source. Query result entries should be
 * mapped to column name -> list of column values.
 */
public class QueryResult {

  private final List<String> columnNames;
  private final List<Integer> columnTypes;
  private final List<List<Object>> valueList;

  private static final String MULTI_VALUES_KEY = "multi_values_clause";
  private static final String RESULT = "Result";

  public QueryResult() {
    this(new ArrayList<>(), new ArrayList<>(), new ArrayList<>());
  }

  protected QueryResult(
      List<String> columnNames, List<Integer> columnTypes, List<List<Object>> valueList) {
    this.columnNames = columnNames;
    this.columnTypes = columnTypes;
    this.valueList = valueList;
  }

  // TODO: Determine whether this can be done lazily i.e., after the statement has finished
  // executing and the query is not timed anymore.
  public void populate(ResultSet rs) throws SQLException {
    ResultSetMetaData rsmd = rs.getMetaData();

    for (int j = 1; j <= rsmd.getColumnCount(); j++) {
      columnNames.add(rsmd.getColumnName(j));
      columnTypes.add(rsmd.getColumnType(j));
      valueList.add(new ArrayList<>());
    }

    while (rs.next()) {
      for (int j = 1; j <= rsmd.getColumnCount(); j++) {
        valueList.get(j - 1).add(rs.getObject(j));
      }
    }
  }

  public Integer getValueListSize() {
    Integer size = null;
    for (List<Object> values : valueList) {
      size = values.size();
      break;
    }
    return size;
  }

  public boolean containsEmptyResultColumnOnly() {
    return columnNames.size() == 1
        && columnNames.get(0).equals(RESULT)
        && valueList.get(0).isEmpty();
  }

  public Pair<String, Object> getStringMappings(int listMin, int listMax) {
    if (columnNames.size() == 1) {
      List<String> localList =
          valueList.get(0).subList(listMin, listMax).stream()
              .map(Object::toString)
              .map(s -> wrapString(s, columnTypes.get(0)))
              .collect(Collectors.toUnmodifiableList());
      return Pair.of(columnNames.get(0), String.join(",", localList));
    }
    StringBuilder multiValuesClause = new StringBuilder();
    for (int i = listMin; i < listMax; i++) {
      multiValuesClause.append("(");
      for (int j = 0; j < valueList.size(); j++) {
        multiValuesClause
            .append(wrapString(valueList.get(j).get(i).toString(), columnTypes.get(j)))
            .append(",");
      }
      // Remove trailing comma
      multiValuesClause.setLength(multiValuesClause.length() - 1);
      multiValuesClause.append("),");
    }
    // Remove trailing comma
    multiValuesClause.setLength(multiValuesClause.length() - 1);
    return Pair.of(MULTI_VALUES_KEY, multiValuesClause.toString());
  }

  private String wrapString(String value, int type) {
    switch (type) {
      case java.sql.Types.BIGINT:
      case java.sql.Types.INTEGER:
      case java.sql.Types.SMALLINT:
      case java.sql.Types.TINYINT:
        return value;
      default:
        // Currently assumes String for all other types.
        // TODO: Better handling and testing of data types across engines.
        return "'" + value + "'";
    }
  }
}
