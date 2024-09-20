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

import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;

@DisabledIfSystemProperty(named = "lst-bench.test.db", matches = ".*")
public class SessionExecTest {

  @Test
  public void testValidSessionExec() {
    TaskExec task1 = ImmutableTaskExec.of("task1", List.of()).withStart(1000L);
    TaskExec task2 = ImmutableTaskExec.of("task2", List.of()).withStart(2000L);
    SessionExec sessionExec =
        ImmutableSessionExec.of("session1", Arrays.asList(task1, task2), 0, 1);

    Assertions.assertEquals("session1", sessionExec.getId());
    Assertions.assertEquals(0, sessionExec.getTargetEndpoint());
    Assertions.assertEquals(1, sessionExec.getMaxConcurrency());
    Assertions.assertEquals(2, sessionExec.getTasks().size());
  }

  @Test
  public void testInvalidSessionExecWithUnorderedTasks() {
    TaskExec task1 = ImmutableTaskExec.of("task1", List.of()).withStart(2000L);
    TaskExec task2 = ImmutableTaskExec.of("task2", List.of()).withStart(1000L);

    IllegalStateException exception =
        Assertions.assertThrows(
            IllegalStateException.class,
            () -> ImmutableSessionExec.of("session1", Arrays.asList(task1, task2), 0, 1));

    Assertions.assertEquals(
        "Tasks in a session must be in order of start time", exception.getMessage());
  }

  @Test
  public void testInvalidSessionExecWithMixedStartTimes() {
    TaskExec task1 = ImmutableTaskExec.of("task1", List.of()).withStart(1000L);
    TaskExec task2 = ImmutableTaskExec.of("task2", List.of()).withStart(null);

    IllegalStateException exception =
        Assertions.assertThrows(
            IllegalStateException.class,
            () -> ImmutableSessionExec.of("session1", Arrays.asList(task1, task2), 0, 1));

    Assertions.assertEquals(
        "Either all tasks in a session must have a start time, or none should have one.",
        exception.getMessage());
  }

  @Test
  public void testValidSessionExecWithoutStartTimes() {
    TaskExec task1 = ImmutableTaskExec.of("task1", List.of()).withStart(null);
    TaskExec task2 = ImmutableTaskExec.of("task2", List.of()).withStart(null);
    SessionExec sessionExec =
        ImmutableSessionExec.of("session1", Arrays.asList(task1, task2), 0, 1);

    Assertions.assertEquals("session1", sessionExec.getId());
    Assertions.assertEquals(0, sessionExec.getTargetEndpoint());
    Assertions.assertEquals(1, sessionExec.getMaxConcurrency());
    Assertions.assertEquals(2, sessionExec.getTasks().size());
  }
}
