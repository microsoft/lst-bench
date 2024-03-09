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

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.apache.commons.lang3.tuple.Pair;
import org.junit.jupiter.api.Test;

public class QueryResultTest {

  @Test
  public void testGetStringMappingsSingleColumn() {
    // Given
    List<String> columnNames = Collections.singletonList("ColumnName");
    List<Integer> columnTypes = Collections.singletonList(java.sql.Types.VARCHAR);
    List<List<Object>> valueList =
        Arrays.asList(
            Arrays.asList("Value1", "Value2", "Value3"),
            Arrays.asList("Value4", "Value5", "Value6"),
            Arrays.asList("Value7", "Value8", "Value9"));
    QueryResult queryResult = new QueryResult(columnNames, columnTypes, valueList);

    // When
    Pair<String, Object> result = queryResult.getStringMappings(0, 3);

    // Then
    assertEquals("ColumnName", result.getKey());
    assertEquals("'Value1','Value2','Value3'", result.getValue());
  }

  @Test
  public void testGetStringMappingsMultiColumn() {
    // Given
    List<String> columnNames = Arrays.asList("Column1", "Column2");
    List<Integer> columnTypes = Arrays.asList(java.sql.Types.VARCHAR, java.sql.Types.INTEGER);
    List<List<Object>> valueList =
        Arrays.asList(Arrays.asList("Value1", "Value2", "Value3"), Arrays.asList(1, 2, 3));
    QueryResult queryResult = new QueryResult(columnNames, columnTypes, valueList);

    // When
    Pair<String, Object> result = queryResult.getStringMappings(0, 3);

    // Then
    assertEquals("multi_values_clause", result.getKey());
    assertEquals("('Value1',1),('Value2',2),('Value3',3)", result.getValue());
  }
}
