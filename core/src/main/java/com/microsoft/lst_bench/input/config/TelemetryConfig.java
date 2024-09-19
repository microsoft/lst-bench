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
package com.microsoft.lst_bench.input.config;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import java.util.Map;
import javax.annotation.Nullable;
import org.immutables.value.Value;

/** Represents an input experiment configuration. */
@Value.Immutable
@Value.Style(jdkOnly = true)
@JsonSerialize(as = ImmutableTelemetryConfig.class)
@JsonDeserialize(as = ImmutableTelemetryConfig.class)
@JsonInclude(JsonInclude.Include.NON_NULL)
public interface TelemetryConfig {
  int getVersion();

  ConnectionConfig getConnection();

  @JsonProperty("execute_ddl")
  Boolean isExecuteDDL();

  @JsonProperty("ddl_file")
  String getDDLFile();

  @JsonProperty("insert_file")
  String getInsertFile();

  @JsonProperty("parameter_values")
  @Nullable Map<String, Object> getParameterValues();
}
