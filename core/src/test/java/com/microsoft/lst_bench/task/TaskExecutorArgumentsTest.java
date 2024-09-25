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
package com.microsoft.lst_bench.task;

import com.microsoft.lst_bench.task.util.TaskExecutorArguments;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;

@DisabledIfSystemProperty(named = "lst-bench.test.db", matches = ".*")
public class TaskExecutorArgumentsTest {

  @Test
  void getRetryExceptionStrings_returnsParsedRetryExceptionStrings() {
    Map<String, Object> arguments =
        Map.of("retry_erroneous_query_strings", "Exception1;Exception2");
    TaskExecutorArguments taskExecutorArguments = new TaskExecutorArguments(arguments);
    Assertions.assertEquals(
        List.of("Exception1", "Exception2"), taskExecutorArguments.getRetryExceptionStrings());
  }

  @Test
  void getSkipExceptionStrings_returnsParsedSkipExceptionStrings() {
    Map<String, Object> arguments = Map.of("skip_erroneous_query_strings", "Exception3;Exception4");
    TaskExecutorArguments taskExecutorArguments = new TaskExecutorArguments(arguments);
    Assertions.assertEquals(
        List.of("Exception3", "Exception4"), taskExecutorArguments.getSkipExceptionStrings());
  }

  @Test
  void getArguments_returnsUnmodifiableMap() {
    Map<String, Object> arguments = Map.of("key1", "value1", "key2", "value2");
    TaskExecutorArguments taskExecutorArguments = new TaskExecutorArguments(arguments);
    Assertions.assertEquals(arguments, taskExecutorArguments.getArguments());
  }

  @Test
  void addArguments_combinesExistingAndNewArguments() {
    Map<String, Object> initialArguments = Map.of("key1", "value1");
    TaskExecutorArguments taskExecutorArguments = new TaskExecutorArguments(initialArguments);
    Map<String, Object> newArguments = Map.of("key2", "value2");
    TaskExecutorArguments updatedTaskExecutorArguments =
        taskExecutorArguments.addArguments(newArguments);
    Assertions.assertEquals(
        Map.of("key1", "value1", "key2", "value2"), updatedTaskExecutorArguments.getArguments());
  }

  @Test
  void addArguments_replacesExistingArgumentsWithNewOnes() {
    Map<String, Object> initialArguments = Map.of("key1", "value1");
    TaskExecutorArguments taskExecutorArguments = new TaskExecutorArguments(initialArguments);
    Map<String, Object> newArguments = Map.of("key1", "newValue1");
    TaskExecutorArguments updatedTaskExecutorArguments =
        taskExecutorArguments.addArguments(newArguments);
    Assertions.assertEquals(
        Map.of("key1", "newValue1"), updatedTaskExecutorArguments.getArguments());
  }

  @Test
  void addArguments_withNullArguments_returnsSameInstance() {
    Map<String, Object> initialArguments = Map.of("key1", "value1");
    TaskExecutorArguments taskExecutorArguments = new TaskExecutorArguments(initialArguments);
    TaskExecutorArguments updatedTaskExecutorArguments = taskExecutorArguments.addArguments(null);
    Assertions.assertSame(taskExecutorArguments, updatedTaskExecutorArguments);
  }

  @Test
  void constructor_withNullArguments_createsEmptyArguments() {
    TaskExecutorArguments taskExecutorArguments = new TaskExecutorArguments(null);
    Assertions.assertTrue(taskExecutorArguments.getArguments().isEmpty());
  }
}
