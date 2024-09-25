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
package com.microsoft.lst_bench.task.util;

import com.microsoft.lst_bench.util.TaskExecutorArgumentsParser;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class TaskExecutorArguments {

  private final List<String> retryExceptionStrings;
  private final List<String> skipExceptionStrings;
  private final Map<String, Object> arguments;

  public TaskExecutorArguments(Map<String, Object> arguments) {
    this.retryExceptionStrings =
        Collections.unmodifiableList(
            TaskExecutorArgumentsParser.parseRetryExceptionStrings(arguments));
    this.skipExceptionStrings =
        Collections.unmodifiableList(
            TaskExecutorArgumentsParser.parseSkipExceptionStrings(arguments));
    this.arguments = arguments != null ? Collections.unmodifiableMap(arguments) : Map.of();
  }

  public List<String> getRetryExceptionStrings() {
    return this.retryExceptionStrings;
  }

  public List<String> getSkipExceptionStrings() {
    return this.skipExceptionStrings;
  }

  public Map<String, Object> getArguments() {
    return this.arguments;
  }

  // Added arguments are automatically appended if possible.
  public TaskExecutorArguments addArguments(Map<String, Object> arguments) {
    if (arguments == null) {
      return this; // If no new arguments, return the same instance
    }
    // Create a new map with combined arguments (existing + new)
    Map<String, Object> combinedArguments =
        Stream.concat(this.arguments.entrySet().stream(), arguments.entrySet().stream())
            .collect(
                Collectors.toUnmodifiableMap(
                    Map.Entry::getKey,
                    Map.Entry::getValue,
                    (existing, replacement) -> replacement));
    // Return a new instance with the updated state
    return new TaskExecutorArguments(combinedArguments);
  }
}
