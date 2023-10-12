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

import com.microsoft.lst_bench.client.ConnectionManager;
import com.microsoft.lst_bench.client.JDBCConnectionManager;
import com.microsoft.lst_bench.client.SparkConnectionManager;
import com.microsoft.lst_bench.common.BenchmarkConfig;
import com.microsoft.lst_bench.exec.FileExec;
import com.microsoft.lst_bench.exec.ImmutablePhaseExec;
import com.microsoft.lst_bench.exec.ImmutableSessionExec;
import com.microsoft.lst_bench.exec.ImmutableTaskExec;
import com.microsoft.lst_bench.exec.ImmutableWorkloadExec;
import com.microsoft.lst_bench.exec.PhaseExec;
import com.microsoft.lst_bench.exec.SessionExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.input.config.ConnectionConfig;
import com.microsoft.lst_bench.input.config.ExperimentConfig;
import com.microsoft.lst_bench.input.config.JDBCConnectionConfig;
import com.microsoft.lst_bench.input.config.SparkConnectionConfig;
import com.microsoft.lst_bench.sql.SQLParser;
import com.microsoft.lst_bench.util.FileParser;
import com.microsoft.lst_bench.util.StringUtils;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.ObjectUtils;

/** Factory class for creating benchmark objects from the input configuration. */
public class BenchmarkObjectFactory {

  private BenchmarkObjectFactory() {
    // Defeat instantiation
  }

  /**
   * Creates a connection manager from the connection configuration.
   *
   * @param connectionConfig the connection configuration
   */
  public static ConnectionManager connectionManager(ConnectionConfig connectionConfig) {
    if (connectionConfig instanceof JDBCConnectionConfig) {
      return jdbcConnectionManager((JDBCConnectionConfig) connectionConfig);
    } else if (connectionConfig instanceof SparkConnectionConfig) {
      return sparkConnectionManager((SparkConnectionConfig) connectionConfig);
    } else {
      throw new IllegalArgumentException(
          "Unsupported connection config type: " + connectionConfig.getClass().getName());
    }
  }

  private static JDBCConnectionManager jdbcConnectionManager(
      JDBCConnectionConfig connectionConfig) {
    try {
      Class.forName(connectionConfig.getDriver());
    } catch (ClassNotFoundException e) {
      throw new IllegalArgumentException(
          "Unable to load driver class: " + connectionConfig.getDriver(), e);
    }
    return new JDBCConnectionManager(
        connectionConfig.getUrl(),
        connectionConfig.getMaxNumRetries(),
        connectionConfig.getUsername(),
        connectionConfig.getPassword());
  }

  private static SparkConnectionManager sparkConnectionManager(
      SparkConnectionConfig connectionConfig) {
    return new SparkConnectionManager(connectionConfig.getUrl(), connectionConfig.getConfig());
  }

  /**
   * Creates a benchmark configuration from the experiment configuration, task library, and
   * workload.
   *
   * @param experimentConfig the experiment configuration
   * @param taskLibrary the task library
   * @param workload the workload
   * @return a benchmark configuration
   */
  public static BenchmarkConfig benchmarkConfig(
      ExperimentConfig experimentConfig, TaskLibrary taskLibrary, Workload workload) {
    Map<String, TaskTemplate> idToTaskTemplate = parseTaskLibrary(taskLibrary);
    ImmutableWorkloadExec workloadExec =
        createWorkloadExec(workload, idToTaskTemplate, experimentConfig);
    return new BenchmarkConfig(
        experimentConfig.getId(),
        experimentConfig.getRepetitions(),
        experimentConfig.getMetadata(),
        experimentConfig.getArguments(),
        workloadExec);
  }

  /**
   * Parses the task library to create a map of task templates with unique IDs.
   *
   * @param taskLibrary the task library to parse
   * @return a map of task templates with unique IDs
   * @throws IllegalArgumentException if there are duplicate task template IDs
   */
  private static Map<String, TaskTemplate> parseTaskLibrary(TaskLibrary taskLibrary) {
    Map<String, TaskTemplate> idToTaskTemplate = new HashMap<>();
    for (TaskTemplate taskTemplate : taskLibrary.getTaskTemplates()) {
      if (idToTaskTemplate.containsKey(taskTemplate.getId())) {
        throw new IllegalArgumentException("Duplicate task template id: " + taskTemplate.getId());
      }
      idToTaskTemplate.put(taskTemplate.getId(), taskTemplate);
    }
    return idToTaskTemplate;
  }

  /**
   * Creates a workload execution from the workload and task library.
   *
   * @param workload the workload to execute
   * @param idToTaskTemplate a map of task templates with unique IDs
   * @param experimentConfig the experiment configuration
   * @return a workload execution
   * @throws IllegalArgumentException if the workload contains an invalid task template ID
   */
  private static ImmutableWorkloadExec createWorkloadExec(
      Workload workload,
      Map<String, TaskTemplate> idToTaskTemplate,
      ExperimentConfig experimentConfig) {
    Map<String, Integer> taskTemplateIdToPermuteOrderCounter = new HashMap<>();
    Map<String, Integer> taskTemplateIdToParameterValuesCounter = new HashMap<>();
    List<PhaseExec> phases = new ArrayList<>();
    for (Phase phase : workload.getPhases()) {
      PhaseExec phaseExec =
          createPhaseExec(
              phase,
              idToTaskTemplate,
              experimentConfig,
              taskTemplateIdToPermuteOrderCounter,
              taskTemplateIdToParameterValuesCounter);
      phases.add(phaseExec);
    }
    return ImmutableWorkloadExec.of(workload.getId(), phases);
  }

  private static PhaseExec createPhaseExec(
      Phase phase,
      Map<String, TaskTemplate> idToTaskTemplate,
      ExperimentConfig experimentConfig,
      Map<String, Integer> taskTemplateIdToPermuteOrderCounter,
      Map<String, Integer> taskTemplateIdToParameterValuesCounter) {
    List<SessionExec> sessions = new ArrayList<>();
    for (int i = 0; i < phase.getSessions().size(); i++) {
      Session session = phase.getSessions().get(i);
      String sessionId = String.valueOf(i);
      SessionExec sessionExec =
          createSessionExec(
              sessionId,
              session,
              idToTaskTemplate,
              experimentConfig,
              taskTemplateIdToPermuteOrderCounter,
              taskTemplateIdToParameterValuesCounter);
      sessions.add(sessionExec);
    }
    return ImmutablePhaseExec.of(phase.getId(), sessions);
  }

  private static SessionExec createSessionExec(
      String sessionId,
      Session session,
      Map<String, TaskTemplate> idToTaskTemplate,
      ExperimentConfig experimentConfig,
      Map<String, Integer> taskTemplateIdToPermuteOrderCounter,
      Map<String, Integer> taskTemplateIdToParameterValuesCounter) {
    List<TaskExec> tasks = new ArrayList<>();
    for (int j = 0; j < session.getTasks().size(); j++) {
      Task task = session.getTasks().get(j);
      String taskId = task.getTemplateId() + "_" + j;
      TaskExec taskExec =
          createTaskExec(
              taskId,
              task,
              idToTaskTemplate,
              experimentConfig,
              taskTemplateIdToPermuteOrderCounter,
              taskTemplateIdToParameterValuesCounter);
      tasks.add(taskExec);
    }
    return ImmutableSessionExec.of(
        sessionId, tasks, ObjectUtils.defaultIfNull(session.getTargetEndpoint(), 0));
  }

  private static TaskExec createTaskExec(
      String taskId,
      Task task,
      Map<String, TaskTemplate> idToTaskTemplate,
      ExperimentConfig experimentConfig,
      Map<String, Integer> taskTemplateIdToPermuteOrderCounter,
      Map<String, Integer> taskTemplateIdToParameterValuesCounter) {
    TaskTemplate taskTemplate = idToTaskTemplate.get(task.getTemplateId());
    if (taskTemplate == null) {
      throw new IllegalArgumentException("Unknown task template id: " + task.getTemplateId());
    }
    List<FileExec> files =
        createFileExecList(
            taskTemplate,
            task,
            experimentConfig,
            taskTemplateIdToPermuteOrderCounter,
            taskTemplateIdToParameterValuesCounter);
    return ImmutableTaskExec.of(taskId, files)
        .withTimeTravelPhaseId(task.getTimeTravelPhaseId())
        .withTaskExecutorArguments(task.getTaskExecutorArguments())
        .withCustomTaskExecutor(task.getCustomTaskExecutor());
  }

  private static List<FileExec> createFileExecList(
      TaskTemplate taskTemplate,
      Task task,
      ExperimentConfig experimentConfig,
      Map<String, Integer> taskTemplateIdToPermuteOrderCounter,
      Map<String, Integer> taskTemplateIdToParameterValuesCounter) {
    List<FileExec> files = new ArrayList<>();
    for (String file : taskTemplate.getFiles()) {
      files.add(SQLParser.getStatements(file));
    }
    files = applyPermutationOrder(taskTemplate, task, taskTemplateIdToPermuteOrderCounter, files);
    files = applyReplaceRegex(task, files);
    files =
        applyParameterValues(
            taskTemplate, experimentConfig, taskTemplateIdToParameterValuesCounter, files);
    return files;
  }

  private static List<FileExec> applyPermutationOrder(
      TaskTemplate taskTemplate,
      Task task,
      Map<String, Integer> taskTemplateIdToPermuteOrderCounter,
      List<FileExec> files) {
    if (taskTemplate.getPermutationOrdersDirectory() == null) {
      // Create statements with certain order
      return files;
    }
    Map<String, FileExec> idToFile = new HashMap<>();
    for (FileExec file : files) {
      idToFile.put(file.getId(), file);
    }
    int counter;
    if (Boolean.TRUE.equals(task.isPermuteOrder())) {
      counter =
          taskTemplateIdToPermuteOrderCounter.compute(
              taskTemplate.getId(), (k, v) -> v == null ? 1 : v + 1);
    } else {
      counter = 0;
    }
    List<String> permutationOrder =
        FileParser.getPermutationOrder(taskTemplate.getPermutationOrdersDirectory(), counter);
    List<FileExec> sortedFiles = new ArrayList<>();
    for (String fileId : permutationOrder) {
      sortedFiles.add(idToFile.get(fileId));
    }
    return sortedFiles;
  }

  private static List<FileExec> applyReplaceRegex(Task task, List<FileExec> files) {
    if (task.getReplaceRegex() == null) {
      return files;
    }
    return files.stream()
        .map(
            file -> {
              for (Task.ReplaceRegex regex : task.getReplaceRegex()) {
                file = StringUtils.replaceRegex(file, regex.getPattern(), regex.getReplacement());
              }
              return file;
            })
        .collect(Collectors.toList());
  }

  private static List<FileExec> applyParameterValues(
      TaskTemplate taskTemplate,
      ExperimentConfig experimentConfig,
      Map<String, Integer> taskTemplateIdToParameterValuesCounter,
      List<FileExec> files) {
    Map<String, Object> parameterValues = new HashMap<>();
    if (taskTemplate.getParameterValuesFile() != null) {
      // Include parameter values defined in the task template
      parameterValues.putAll(
          FileParser.getParameterValues(
              taskTemplate.getParameterValuesFile(),
              taskTemplateIdToParameterValuesCounter.compute(
                  taskTemplate.getId(), (k, v) -> v == null ? 1 : v + 1)));
    }
    if (experimentConfig.getParameterValues() != null) {
      // Include experiment-specific parameter values (they can override the ones defined in
      // the task template)
      parameterValues.putAll(experimentConfig.getParameterValues());
    }
    return files.stream()
        .map(f -> StringUtils.replaceParameters(f, parameterValues))
        .collect(Collectors.toList());
  }
}
