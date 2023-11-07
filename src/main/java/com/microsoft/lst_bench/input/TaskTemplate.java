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

/**
 * A task template is a template for a task. Importantly, it references the files that are required
 * to run the task. It also contains additional parameters that are required to instantiate the
 * task.
 */
@Value.Immutable
@Value.Style(jdkOnly = true)
@JsonSerialize(as = ImmutableTaskTemplate.class)
@JsonDeserialize(as = ImmutableTaskTemplate.class)
@JsonInclude(JsonInclude.Include.NON_NULL)
public interface TaskTemplate {
  String getId();

  List<String> getFiles();

  @JsonProperty("parameter_values_file")
  @Nullable String getParameterValuesFile();

  @JsonProperty("permutation_orders_path")
  @Nullable String getPermutationOrdersDirectory();

  @JsonProperty("supports_time_travel")
  @Nullable Boolean supportsTimeTravel();

  @JsonProperty("custom_task_executor")
  @Nullable String getCustomTaskExecutor();
}
