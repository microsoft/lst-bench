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
package com.microsoft.lst_bench.telemetry;

import java.time.Instant;
import javax.annotation.Nullable;
import org.immutables.value.Value;

/** Captures information about an event. */
@Value.Immutable
@Value.Style(jdkOnly = true, allParameters = true, defaults = @Value.Immutable(builder = false))
public interface EventInfo {
  /**
   * Returns the unique identifier for the experiment run. This identifier helps in distinguishing
   * events of one experiment run from another. Currently, the experiment run start timestamp is
   * used as the unique identifier.
   */
  String getExperimentId();

  Instant getStartTime();

  Instant getEndTime();

  String getEventId();

  EventType getEventType();

  Status getStatus();

  @Value.Parameter(false)
  @Nullable String getPayload();

  /** Enumerates the different types of events that can be captured. */
  enum EventType {
    EXEC_EXPERIMENT,
    EXEC_PHASE,
    EXEC_SESSION,
    EXEC_TASK,
    EXEC_FILE,
    EXEC_STATEMENT;
  }

  /** Enumerates the different types of status that can be captured. */
  enum Status {
    SUCCESS,
    FAILURE,
    WARN,
    UNKNOWN;
  }
}
