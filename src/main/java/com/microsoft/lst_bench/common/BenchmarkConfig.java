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
package com.microsoft.lst_bench.common;

import com.microsoft.lst_bench.exec.WorkloadExec;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/** A benchmark configuration. */
public class BenchmarkConfig {

  private final String id;
  private final int repetitions;
  private final Map<String, String> metadata;
  private final Map<String, Object> arguments;
  private final WorkloadExec workload;

  public BenchmarkConfig(
      String id,
      int repetitions,
      Map<String, String> metadata,
      Map<String, Object> arguments,
      WorkloadExec workload) {
    this.id = id;
    this.repetitions = repetitions;
    this.metadata = Collections.unmodifiableMap(metadata == null ? new HashMap<>() : metadata);
    this.arguments = Collections.unmodifiableMap(arguments == null ? new HashMap<>() : arguments);
    this.workload = workload;
  }

  public String getId() {
    return id;
  }

  public int getRepetitions() {
    return repetitions;
  }

  public Map<String, String> getMetadata() {
    return metadata;
  }

  public Map<String, Object> getArguments() {
    return arguments;
  }

  public WorkloadExec getWorkload() {
    return workload;
  }
}
