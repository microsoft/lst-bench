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
package com.microsoft.lst_bench.cab_converter;

import com.microsoft.lst_bench.input.Library;
import com.microsoft.lst_bench.input.Phase;
import com.microsoft.lst_bench.input.Session;
import com.microsoft.lst_bench.input.Task;
import com.microsoft.lst_bench.input.Workload;
import com.microsoft.lst_bench.util.FileParser;
import java.io.File;
import java.nio.file.Path;
import java.util.BitSet;
import java.util.List;
import org.apache.commons.lang3.ObjectUtils;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;
import org.junit.jupiter.api.io.TempDir;

@DisabledIfSystemProperty(named = "lst-bench.test.db", matches = ".*")
public class DriverConverterTest {

  private static final String TESTS_STREAMS_PATH =
      "src"
          + File.separator
          + "test"
          + File.separator
          + "resources"
          + File.separator
          + "small_1tb_10cpu"
          + File.separator;

  @Test
  public void testNoSplitSingleConnection(@TempDir Path tempDir) throws Exception {
    final Converter converter =
        new Converter(
            Path.of(TESTS_STREAMS_PATH).toFile(),
            tempDir.toFile(),
            false,
            ConnectionGenMode.SINGLE);
    converter.execute();

    File cabLibraryFile = new File(tempDir.toFile(), "cab_library.yaml");
    Assertions.assertTrue(cabLibraryFile.exists());
    Library cabLibrary = FileParser.loadLibrary(cabLibraryFile.toString());
    validateCABLibrary(cabLibrary);

    File cabWorkloadFile = new File(tempDir.toFile(), "cab_workload.yaml");
    Assertions.assertTrue(cabWorkloadFile.exists());
    Workload cabWorkload = FileParser.loadWorkload(cabWorkloadFile.toString());
    validateCABWorkload(cabWorkload, 20, 1);
  }

  @Test
  public void testSplitSingleConnection(@TempDir Path tempDir) throws Exception {
    final Converter converter =
        new Converter(
            Path.of(TESTS_STREAMS_PATH).toFile(), tempDir.toFile(), true, ConnectionGenMode.SINGLE);
    converter.execute();

    File cabLibraryFile = new File(tempDir.toFile(), "cab_library.yaml");
    Assertions.assertTrue(cabLibraryFile.exists());
    Library cabLibrary = FileParser.loadLibrary(cabLibraryFile.toString());
    validateCABLibrary(cabLibrary);

    File cabWorkloadFile = new File(tempDir.toFile(), "cab_workload.yaml");
    Assertions.assertTrue(cabWorkloadFile.exists());
    Workload cabWorkload = FileParser.loadWorkload(cabWorkloadFile.toString());
    validateCABWorkload(cabWorkload, 36, 1);
  }

  @Test
  public void testNoSplitPerDBConnection(@TempDir Path tempDir) throws Exception {
    final Converter converter =
        new Converter(
            Path.of(TESTS_STREAMS_PATH).toFile(),
            tempDir.toFile(),
            false,
            ConnectionGenMode.PER_DB);
    converter.execute();

    File cabLibraryFile = new File(tempDir.toFile(), "cab_library.yaml");
    Assertions.assertTrue(cabLibraryFile.exists());
    Library cabLibrary = FileParser.loadLibrary(cabLibraryFile.toString());
    validateCABLibrary(cabLibrary);

    File cabWorkloadFile = new File(tempDir.toFile(), "cab_workload.yaml");
    Assertions.assertTrue(cabWorkloadFile.exists());
    Workload cabWorkload = FileParser.loadWorkload(cabWorkloadFile.toString());
    validateCABWorkload(cabWorkload, 20, 20);
  }

  @Test
  public void testSplitPerDBConnection(@TempDir Path tempDir) throws Exception {
    final Converter converter =
        new Converter(
            Path.of(TESTS_STREAMS_PATH).toFile(), tempDir.toFile(), true, ConnectionGenMode.PER_DB);
    converter.execute();

    File cabLibraryFile = new File(tempDir.toFile(), "cab_library.yaml");
    Assertions.assertTrue(cabLibraryFile.exists());
    Library cabLibrary = FileParser.loadLibrary(cabLibraryFile.toString());
    validateCABLibrary(cabLibrary);

    File cabWorkloadFile = new File(tempDir.toFile(), "cab_workload.yaml");
    Assertions.assertTrue(cabWorkloadFile.exists());
    Workload cabWorkload = FileParser.loadWorkload(cabWorkloadFile.toString());
    validateCABWorkload(cabWorkload, 36, 20);
  }

  @Test
  public void testNoSplitPerStreamConnection(@TempDir Path tempDir) throws Exception {
    final Converter converter =
        new Converter(
            Path.of(TESTS_STREAMS_PATH).toFile(),
            tempDir.toFile(),
            false,
            ConnectionGenMode.PER_STREAM);
    converter.execute();

    File cabLibraryFile = new File(tempDir.toFile(), "cab_library.yaml");
    Assertions.assertTrue(cabLibraryFile.exists());
    Library cabLibrary = FileParser.loadLibrary(cabLibraryFile.toString());
    validateCABLibrary(cabLibrary);

    File cabWorkloadFile = new File(tempDir.toFile(), "cab_workload.yaml");
    Assertions.assertTrue(cabWorkloadFile.exists());
    Workload cabWorkload = FileParser.loadWorkload(cabWorkloadFile.toString());
    validateCABWorkload(cabWorkload, 20, 20);
  }

  @Test
  public void testSplitPerStreamConnection(@TempDir Path tempDir) throws Exception {
    final Converter converter =
        new Converter(
            Path.of(TESTS_STREAMS_PATH).toFile(),
            tempDir.toFile(),
            true,
            ConnectionGenMode.PER_STREAM);
    converter.execute();

    File cabLibraryFile = new File(tempDir.toFile(), "cab_library.yaml");
    Assertions.assertTrue(cabLibraryFile.exists());
    Library cabLibrary = FileParser.loadLibrary(cabLibraryFile.toString());
    validateCABLibrary(cabLibrary);

    File cabWorkloadFile = new File(tempDir.toFile(), "cab_workload.yaml");
    Assertions.assertTrue(cabWorkloadFile.exists());
    Workload cabWorkload = FileParser.loadWorkload(cabWorkloadFile.toString());
    validateCABWorkload(cabWorkload, 36, 36);
  }

  @Test
  public void testNoSplitPerStreamTypeConnection(@TempDir Path tempDir) throws Exception {
    final Converter converter =
        new Converter(
            Path.of(TESTS_STREAMS_PATH).toFile(),
            tempDir.toFile(),
            false,
            ConnectionGenMode.PER_STREAM_TYPE);
    converter.execute();

    File cabLibraryFile = new File(tempDir.toFile(), "cab_library.yaml");
    Assertions.assertTrue(cabLibraryFile.exists());
    Library cabLibrary = FileParser.loadLibrary(cabLibraryFile.toString());
    validateCABLibrary(cabLibrary);

    File cabWorkloadFile = new File(tempDir.toFile(), "cab_workload.yaml");
    Assertions.assertTrue(cabWorkloadFile.exists());
    Workload cabWorkload = FileParser.loadWorkload(cabWorkloadFile.toString());
    validateCABWorkload(cabWorkload, 20, 1);
  }

  @Test
  public void testSplitPerStreamTypeConnection(@TempDir Path tempDir) throws Exception {
    final Converter converter =
        new Converter(
            Path.of(TESTS_STREAMS_PATH).toFile(),
            tempDir.toFile(),
            true,
            ConnectionGenMode.PER_STREAM_TYPE);
    converter.execute();

    File cabLibraryFile = new File(tempDir.toFile(), "cab_library.yaml");
    Assertions.assertTrue(cabLibraryFile.exists());
    Library cabLibrary = FileParser.loadLibrary(cabLibraryFile.toString());
    validateCABLibrary(cabLibrary);

    File cabWorkloadFile = new File(tempDir.toFile(), "cab_workload.yaml");
    Assertions.assertTrue(cabWorkloadFile.exists());
    Workload cabWorkload = FileParser.loadWorkload(cabWorkloadFile.toString());
    validateCABWorkload(cabWorkload, 36, 2);
  }

  private void validateCABLibrary(Library library) {
    Assertions.assertNotNull(library);
    Assertions.assertEquals(
        25, library.getTaskTemplates().size(), "Library task templates size mismatch");
    Assertions.assertTrue(
        ObjectUtils.isEmpty(library.getPreparedTasks()), "No prepared tasks expected");
    Assertions.assertTrue(
        ObjectUtils.isEmpty(library.getPreparedTasksSequences()),
        "No prepared tasks sequences expected");
    Assertions.assertTrue(
        ObjectUtils.isEmpty(library.getSessionTemplates()), "No session templates expected");
    Assertions.assertTrue(
        ObjectUtils.isEmpty(library.getPhaseTemplates()), "No phase templates expected");
  }

  private void validateCABWorkload(
      Workload workload, int expectedSessions, int expectedDistinctConnections) {
    Assertions.assertNotNull(workload);
    Assertions.assertEquals(3, workload.getPhases().size(), "Workload phases size mismatch");
    Assertions.assertEquals(
        "setup", workload.getPhases().get(0).getId(), "First phase should be 'setup'");
    Assertions.assertEquals(
        "build", workload.getPhases().get(1).getId(), "Second phase should be 'build'");
    Assertions.assertEquals(
        "run", workload.getPhases().get(2).getId(), "Third phase should be 'run'");
    Phase runPhase = workload.getPhases().get(2);
    List<Session> sessions = runPhase.getSessions();
    Assertions.assertNotNull(sessions);
    Assertions.assertEquals(
        expectedSessions, sessions.size(), "Workload run phase sessions size mismatch");
    BitSet distinctConnections = new BitSet();
    for (Session session : sessions) {
      distinctConnections.set(
          session.getTargetEndpoint() != null ? session.getTargetEndpoint() : 0);
      Assertions.assertNotNull(session.getTasks());
      for (Task task : session.getTasks()) {
        Assertions.assertNotNull(task.getStart(), "Property 'start' should be set in run task");
        Assertions.assertNotNull(
            task.getTaskExecutorArguments(),
            "Key 'stream_num' in run task arguments should be set");
        Assertions.assertTrue(
            task.getTaskExecutorArguments().containsKey("stream_num"),
            "Key 'stream_num' in run task arguments should be set");
      }
    }
    Assertions.assertEquals(
        expectedDistinctConnections,
        distinctConnections.cardinality(),
        "Distinct connections count mismatch");
  }
}
