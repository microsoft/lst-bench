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
import org.immutables.value.Value;

/**
 * Represents an input task library containing task templates that can be instantiated to create
 * tasks.
 */
@Value.Immutable
@Value.Style(jdkOnly = true)
@JsonSerialize(as = ImmutableTaskLibrary.class)
@JsonDeserialize(as = ImmutableTaskLibrary.class)
@JsonInclude(JsonInclude.Include.NON_NULL)
public interface TaskLibrary {
  int getVersion();

  @JsonProperty("task_templates")
  List<TaskTemplate> getTaskTemplates();
}
