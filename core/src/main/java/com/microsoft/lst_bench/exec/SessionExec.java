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
package com.microsoft.lst_bench.exec;

import java.util.List;
import org.immutables.value.Value;

/** Represents a session in a phase. */
@Value.Immutable
@Value.Style(jdkOnly = true, allParameters = true, defaults = @Value.Immutable(builder = false))
public interface SessionExec {

  String getId();

  List<TaskExec> getTasks();

  /** Connection manager for this session (positional index). */
  int getTargetEndpoint();

  /** Max concurrency level for this session. */
  int getMaxConcurrency();

  @Value.Check
  default void check() {
    // This check can only be done when all the entities in the workload (templates, prepared)
    // have been resolved.
    boolean hasStartTime = false;
    boolean hasNoStartTime = false;
    long lastStart = -1;

    for (TaskExec task : getTasks()) {
      Long taskStart = task.getStart();

      if (taskStart != null) {
        hasStartTime = true;

        // Ensure tasks are ordered by start time
        if (taskStart < lastStart) {
          throw new IllegalStateException("Tasks in a session must be in order of start time");
        }
        lastStart = taskStart;
      } else {
        hasNoStartTime = true;
      }

      // If both tasks with and without start times are detected, throw an exception
      if (hasStartTime && hasNoStartTime) {
        throw new IllegalStateException(
            "Either all tasks in a session must have a start time, or none should have one.");
      }
    }
  }
}
