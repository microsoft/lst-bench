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
import java.util.Map;
import java.util.stream.Stream;

public class TaskExecutorArguments {

  private String[] retryExceptionStrings;
  private String[] skipExceptionStrings;
  private Map<String, Object> arguments;

  public TaskExecutorArguments(Map<String, Object> arguments) {
    this.retryExceptionStrings = TaskExecutorArgumentsParser.parseRetryExceptionStrings(arguments);
    this.skipExceptionStrings = TaskExecutorArgumentsParser.parseSkipExceptionStrings(arguments);
    this.arguments = arguments;
  }

  public String[] getRetryExceptionStrings() {
    return this.retryExceptionStrings;
  }

  public String[] getSkipExceptionStrings() {
    return this.skipExceptionStrings;
  }

  public Map<String, Object> getArguments() {
    return this.arguments;
  }

  // Added arguments are automatically appended if possible.
  public void addArguments(Map<String, Object> arguments) {
    this.arguments = arguments;

    this.retryExceptionStrings =
        Stream.of(
                this.getRetryExceptionStrings(),
                TaskExecutorArgumentsParser.parseRetryExceptionStrings(arguments))
            .flatMap(Stream::of)
            .toArray(String[]::new);

    this.skipExceptionStrings =
        Stream.of(
                this.getSkipExceptionStrings(),
                TaskExecutorArgumentsParser.parseSkipExceptionStrings(arguments))
            .flatMap(Stream::of)
            .toArray(String[]::new);
  }
}
