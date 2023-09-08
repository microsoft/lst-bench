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
package com.microsoft.lst_bench.task.custom;

import com.microsoft.lst_bench.client.ClientException;
import com.microsoft.lst_bench.client.Connection;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.input.Task.CustomTaskExecutorArguments;
import com.microsoft.lst_bench.task.TaskExecutor;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import java.util.Map;

/**
 * Custom task executor implementation that allows users to execute dependent tasks. We call a
 * dependent task a task that iteratively executes a) a statement that is expected to return a
 * result; and b) a statement repeatedly that is expected to use that result. The result of the
 * first statement is stored in an intermediate object that can be specific to the connection. The
 * expected object for a JDBC connection is of type List<Map<String, Object>>, handling of other
 * objects would need to be added to the if-clause that checks the instance of the object.
 */
public class CustomTaskExecutor extends TaskExecutor {

  protected final CustomTaskExecutorArguments arguments;

  public CustomTaskExecutor(
      SQLTelemetryRegistry telemetryRegistry,
      String experimentStartTime,
      CustomTaskExecutorArguments arguments) {
    super(telemetryRegistry, experimentStartTime);
    this.arguments = arguments;
  }

  @Override
  public void executeTask(Connection connection, TaskExec task, Map<String, Object> values)
      throws ClientException {
    super.executeTask(connection, task, values);
  }

  protected CustomTaskExecutorArguments getArguments() {
    return this.arguments;
  }
}
