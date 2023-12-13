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
package com.microsoft.lst_bench.input;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import java.util.List;
import javax.annotation.Nullable;
import org.immutables.value.Value;

/** Represents a sequence of tasks to be executed in order. */
@Value.Immutable
@Value.Style(jdkOnly = true)
@JsonSerialize(as = ImmutableTasksSequence.class)
@JsonDeserialize(as = ImmutableTasksSequence.class)
@JsonInclude(JsonInclude.Include.NON_NULL)
public interface TasksSequence {
  @JsonProperty("id")
  @Nullable String getId();

  @JsonProperty("prepared_tasks_sequence_id")
  @Nullable String getPreparedTasksSequenceId();

  @Nullable List<Task> getTasks();

  @Value.Check
  default void check() {
    boolean onlyOneTrue = getPreparedTasksSequenceId() != null ^ getTasks() != null;
    if (!onlyOneTrue) {
      throw new IllegalStateException(
          "Must have exactly one of prepared tasks sequence id or list of tasks defined");
    }
  }
}
