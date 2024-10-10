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

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;
import com.microsoft.lst_bench.input.ImmutableLibrary;
import com.microsoft.lst_bench.input.ImmutablePhase;
import com.microsoft.lst_bench.input.ImmutableSession;
import com.microsoft.lst_bench.input.ImmutableTask;
import com.microsoft.lst_bench.input.ImmutableTaskTemplate;
import com.microsoft.lst_bench.input.ImmutableWorkload;
import com.microsoft.lst_bench.input.Session;
import com.microsoft.lst_bench.input.TaskTemplate;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This class is responsible for converting CAB streams into a library and workload files that can
 * be used by LST-Bench.
 */
public class Converter {

  private static final Logger LOGGER = LoggerFactory.getLogger(Converter.class);
  private static final String QUERY_23_1 = "query_23_1";
  private static final String QUERY_23_2 = "query_23_2";

  private final File streamsDir;
  private final File outputDir;
  private final boolean splitReadWriteStreams;
  private final ConnectionGenMode connectionGenMode;

  public Converter(
      File streamsDir,
      File outputDir,
      boolean splitReadWriteStreams,
      ConnectionGenMode connectionGenMode) {
    this.streamsDir = streamsDir;
    this.outputDir = outputDir;
    this.splitReadWriteStreams = splitReadWriteStreams;
    this.connectionGenMode = connectionGenMode;
  }

  public void execute() throws Exception {
    LOGGER.info("Converting CAB streams from directory: {}", streamsDir);
    LOGGER.info("Output directory: {}", outputDir);
    LOGGER.info("Splitting read/write streams: {}", splitReadWriteStreams);
    LOGGER.info("Connection generation mode: {}", connectionGenMode);

    YAMLMapper yamlMapper = new YAMLMapper();

    // The workload will consist of three phases: setup, build, and run.
    // First we need to create a library that contains all the tasks
    ImmutableLibrary library = getLibrary();
    try {
      yamlMapper.writeValue(Paths.get(outputDir.getPath(), "cab_library.yaml").toFile(), library);
    } catch (IOException e) {
      throw new RuntimeException("Failed to write the library to file", e);
    }

    // Now we are going to create the parameter values file needed for the setup and build tasks
    List<String> content = getParameterValuesFileContent(streamsDir);
    File parameterValuesFile =
        Paths.get(outputDir.getPath(), "auxiliary", "parameter_values.dat").toFile();
    // Ensure that the parent directories exist
    File parentDir = parameterValuesFile.getParentFile();
    if (parentDir != null && !parentDir.exists()) {
      // Create directories if they don't exist
      if (!parentDir.mkdirs()) {
        throw new IOException("Failed to create directories: " + parentDir.getPath());
      }
    }
    // Write content to file
    try (BufferedWriter writer = new BufferedWriter(new FileWriter(parameterValuesFile))) {
      for (String line : content) {
        writer.write(line);
        writer.newLine();
      }
    }

    // Lastly we create the workload itself
    int numStreams = content.size() - 1; // Subtract 1 to exclude the header
    ImmutableWorkload workload = getWorkload(numStreams);
    try {
      yamlMapper.writeValue(Paths.get(outputDir.getPath(), "cab_workload.yaml").toFile(), workload);
    } catch (IOException e) {
      throw new RuntimeException("Failed to write the workload to file", e);
    }
  }

  private ImmutableLibrary getLibrary() {
    ImmutableLibrary.Builder libraryBuilder = ImmutableLibrary.builder();
    libraryBuilder.version(1);
    List<TaskTemplate> taskTemplateList = new ArrayList<>();
    // Create a task template for setup
    ImmutableTaskTemplate.Builder setupTaskTemplateBuilder = ImmutableTaskTemplate.builder();
    setupTaskTemplateBuilder.id("setup");
    setupTaskTemplateBuilder.addFiles("setup" + File.separator + "setup.sql");
    setupTaskTemplateBuilder.parameterValuesFile(
        "auxiliary" + File.separator + "parameter_values.dat");
    taskTemplateList.add(setupTaskTemplateBuilder.build());
    // Create a task template for build
    ImmutableTaskTemplate.Builder buildTaskTemplateBuilder = ImmutableTaskTemplate.builder();
    buildTaskTemplateBuilder.id("build");
    buildTaskTemplateBuilder.addFiles("build" + File.separator + "build.sql");
    buildTaskTemplateBuilder.parameterValuesFile(
        "auxiliary" + File.separator + "parameter_values.dat");
    taskTemplateList.add(buildTaskTemplateBuilder.build());
    // Create a task template for each query in run
    for (int i = 1; i <= 22; i++) {
      ImmutableTaskTemplate.Builder queryTaskTemplateBuilder = ImmutableTaskTemplate.builder();
      queryTaskTemplateBuilder.id("query_" + i);
      queryTaskTemplateBuilder.addFiles("run" + File.separator + "query_" + i + ".sql");
      taskTemplateList.add(queryTaskTemplateBuilder.build());
    }
    // Special handling for query_23, which consists of two write queries
    ImmutableTaskTemplate.Builder queryTaskTemplateBuilder = ImmutableTaskTemplate.builder();
    queryTaskTemplateBuilder.id(QUERY_23_1);
    queryTaskTemplateBuilder.addFiles("run" + File.separator + QUERY_23_1 + ".sql");
    taskTemplateList.add(queryTaskTemplateBuilder.build());
    queryTaskTemplateBuilder = ImmutableTaskTemplate.builder();
    queryTaskTemplateBuilder.id(QUERY_23_2);
    queryTaskTemplateBuilder.addFiles("run" + File.separator + QUERY_23_2 + ".sql");
    taskTemplateList.add(queryTaskTemplateBuilder.build());
    libraryBuilder.taskTemplates(taskTemplateList);
    return libraryBuilder.build();
  }

  private List<String> getParameterValuesFileContent(File streamsDir) {
    int numStreams = 0;
    List<String> content = new ArrayList<>();
    // Add header
    content.add("stream_num|");
    // List files in streamsDir
    File[] files = streamsDir.listFiles();
    if (files == null || files.length == 0) {
      throw new IllegalArgumentException("No files found in the streams directory: " + streamsDir);
    }
    // Iterate through files and generate content
    for (File file : files) {
      if (file.isFile() && file.getName().startsWith("query_stream_")) {
        content.add(numStreams++ + "|");
      }
    }
    if (numStreams == 0) {
      throw new IllegalArgumentException(
          "No query streams found in the streams directory: " + streamsDir);
    }
    return content;
  }

  private ImmutableWorkload getWorkload(int numStreams) throws IOException {
    ImmutableWorkload.Builder workloadBuilder = ImmutableWorkload.builder();
    workloadBuilder.version(1);
    workloadBuilder.id("cab_workload");
    final ImmutablePhase setupPhase = getInitialSimpleWorkloadPhase("setup", "setup", numStreams);
    workloadBuilder.addPhases(setupPhase);
    final ImmutablePhase buildPhase = getInitialSimpleWorkloadPhase("build", "build", numStreams);
    workloadBuilder.addPhases(buildPhase);
    final ImmutablePhase runPhase = getRunWorkloadPhase(numStreams);
    workloadBuilder.addPhases(runPhase);
    return workloadBuilder.build();
  }

  private ImmutablePhase getInitialSimpleWorkloadPhase(
      String phaseId, String taskTemplateId, int numStreams) {
    ImmutablePhase.Builder phaseBuilder = ImmutablePhase.builder();
    phaseBuilder.id(phaseId);
    List<Session> phaseSessions = new ArrayList<>();
    for (int i = 0; i < numStreams; i++) {
      ImmutableSession.Builder sessionBuilder = ImmutableSession.builder();
      ImmutableTask.Builder taskBuilder = ImmutableTask.builder();
      taskBuilder.templateId(taskTemplateId);
      sessionBuilder.addTasks(taskBuilder.build());
      if (connectionGenMode != ConnectionGenMode.SINGLE) {
        sessionBuilder.targetEndpoint(i);
      }
      phaseSessions.add(sessionBuilder.build());
    }
    phaseBuilder.sessions(phaseSessions);
    return phaseBuilder.build();
  }

  private ImmutablePhase getRunWorkloadPhase(int numStreams) throws IOException {
    ImmutablePhase.Builder runPhaseBuilder = ImmutablePhase.builder();
    runPhaseBuilder.id("run");
    JsonMapper jsonMapper = new JsonMapper(); // ObjectMapper for parsing JSON files
    List<Session> runPhaseSessions = new ArrayList<>();
    for (int i = 0; i < numStreams; i++) {
      File queryStreamFile =
          Paths.get(streamsDir.getPath(), "query_stream_" + i + ".json").toFile();
      if (!queryStreamFile.exists()) {
        throw new IllegalArgumentException("Query stream file not found: " + queryStreamFile);
      }
      JsonNode rootNode = jsonMapper.readTree(queryStreamFile); // Parse JSON
      JsonNode queriesNode = rootNode.get("queries");
      if (queriesNode == null || !queriesNode.isArray()) {
        throw new IllegalArgumentException(
            "Invalid query stream format: 'queries' field is missing or not an array for stream: "
                + i);
      }
      // Create sessions for the stream (either split or mixed)
      createSessionsForStream(runPhaseSessions, queriesNode, i);
    }
    runPhaseBuilder.sessions(runPhaseSessions);
    return runPhaseBuilder.build();
  }

  private void createSessionsForStream(
      List<Session> runPhaseSessions, JsonNode queriesNode, int streamIndex) {
    if (splitReadWriteStreams) {
      createSplitReadWriteSessionsForStream(runPhaseSessions, queriesNode, streamIndex);
    } else {
      createMixedSessionsForStream(runPhaseSessions, queriesNode, streamIndex);
    }
  }

  private void createSplitReadWriteSessionsForStream(
      List<Session> runPhaseSessions, JsonNode queriesNode, int streamIndex) {
    ImmutableSession.Builder writeSessionBuilder = ImmutableSession.builder();
    writeSessionBuilder.maxConcurrency(10); // Value used by CAB
    ImmutableSession.Builder readSessionBuilder = ImmutableSession.builder();
    readSessionBuilder.maxConcurrency(10); // Value used by CAB

    // Create tasks for each query in the stream
    boolean hasWriteQuery = false;
    boolean hasReadQuery = false;
    for (JsonNode queryNode : queriesNode) {
      ImmutableTask[] tasks = createTasksForQuery(queryNode, streamIndex);
      if (tasks.length == 2) {
        // Only conversion producing two tasks is for query 23
        writeSessionBuilder.addTasks(tasks); // query_23 is the only write query
        hasWriteQuery = true;
      } else {
        readSessionBuilder.addTasks(tasks);
        hasReadQuery = true;
      }
    }

    if (hasWriteQuery || hasReadQuery) {
      // Assign the correct target endpoints
      assignSplitReadWriteTargetEndpoint(writeSessionBuilder, readSessionBuilder, streamIndex);
      if (hasWriteQuery) {
        runPhaseSessions.add(writeSessionBuilder.build());
      }
      if (hasReadQuery) {
        runPhaseSessions.add(readSessionBuilder.build());
      }
    }
  }

  private void createMixedSessionsForStream(
      List<Session> runPhaseSessions, JsonNode queriesNode, int streamIndex) {
    ImmutableSession.Builder sessionBuilder = ImmutableSession.builder();
    sessionBuilder.maxConcurrency(10); // Value used by CAB

    // Create tasks for each query in the stream
    boolean hasQuery = false;
    for (JsonNode queryNode : queriesNode) {
      ImmutableTask[] tasks = createTasksForQuery(queryNode, streamIndex);
      sessionBuilder.addTasks(tasks);
      hasQuery = true;
    }

    // Add session to the run phase
    if (hasQuery) {
      // Assign the correct target endpoint
      assignMixedTargetEndpoint(sessionBuilder, streamIndex);
      runPhaseSessions.add(sessionBuilder.build());
    }
  }

  private static ImmutableTask[] createTasksForQuery(JsonNode queryNode, int streamIndex) {
    // Extract necessary fields from each query
    int queryId = queryNode.get("query_id").asInt();
    long startTime = queryNode.get("start").asLong();
    JsonNode argsNode = queryNode.get("arguments");
    if (queryId == 23) {
      // Special handling for query 23, which consists of two write queries
      ImmutableTask[] tasks = new ImmutableTask[2];
      tasks[0] = createTask(QUERY_23_1, startTime, argsNode, streamIndex);
      tasks[1] = createTask(QUERY_23_2, startTime, argsNode, streamIndex);
      return tasks;
    }
    // Create a task for this query
    return new ImmutableTask[] {createTask("query_" + queryId, startTime, argsNode, streamIndex)};
  }

  private static ImmutableTask createTask(
      String queryIdText, long startTime, JsonNode argsNode, int streamIndex) {
    ImmutableTask.Builder taskBuilder = ImmutableTask.builder();
    taskBuilder.templateId(queryIdText);
    taskBuilder.start(startTime);
    // Ensure 'arguments' is an array and handle its values
    if (argsNode != null && argsNode.isArray()) {
      for (int j = 0; j < argsNode.size(); j++) {
        JsonNode arg = argsNode.get(j);
        if (arg.isTextual()) {
          taskBuilder.putTaskExecutorArguments("param" + (j + 1), arg.asText());
        } else if (arg.isInt()) {
          taskBuilder.putTaskExecutorArguments("param" + (j + 1), arg.asInt());
        } else if (arg.isBoolean()) {
          taskBuilder.putTaskExecutorArguments("param" + (j + 1), arg.asBoolean());
        } else if (arg.isDouble()) {
          taskBuilder.putTaskExecutorArguments("param" + (j + 1), arg.asDouble());
        } else {
          throw new IllegalArgumentException(
              "Unsupported argument type for query ID: "
                  + queryIdText
                  + " in stream: "
                  + streamIndex);
        }
      }
    } else {
      throw new IllegalArgumentException(
          "Arguments field missing or not an array for query ID: "
              + queryIdText
              + " in stream: "
              + streamIndex);
    }
    taskBuilder.putTaskExecutorArguments("stream_num", streamIndex);
    return taskBuilder.build();
  }

  private void assignSplitReadWriteTargetEndpoint(
      ImmutableSession.Builder writeSessionBuilder,
      ImmutableSession.Builder readSessionBuilder,
      int streamIndex) {
    if (!splitReadWriteStreams) {
      throw new IllegalArgumentException("Cannot assign target endpoints for mixed streams");
    }
    if (connectionGenMode != ConnectionGenMode.SINGLE) {
      switch (connectionGenMode) {
        case PER_DB:
          writeSessionBuilder.targetEndpoint(streamIndex);
          readSessionBuilder.targetEndpoint(streamIndex);
          break;
        case PER_STREAM:
          writeSessionBuilder.targetEndpoint(streamIndex * 2);
          readSessionBuilder.targetEndpoint(streamIndex * 2 + 1);
          break;
        case PER_STREAM_TYPE:
          writeSessionBuilder.targetEndpoint(0);
          readSessionBuilder.targetEndpoint(1);
          break;
        default:
          throw new IllegalArgumentException("Unsupported connection generation mode");
      }
    }
  }

  private void assignMixedTargetEndpoint(
      ImmutableSession.Builder mixedSessionBuilder, int streamIndex) {
    if (connectionGenMode != ConnectionGenMode.SINGLE) {
      switch (connectionGenMode) {
        case PER_DB:
        case PER_STREAM:
          mixedSessionBuilder.targetEndpoint(streamIndex);
          break;
        case PER_STREAM_TYPE:
          mixedSessionBuilder.targetEndpoint(0);
          break;
        default:
          throw new IllegalArgumentException("Unsupported connection generation mode");
      }
    }
  }
}
