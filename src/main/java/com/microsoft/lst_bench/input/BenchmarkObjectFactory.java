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
import com.microsoft.lst_bench.task.util.TaskExecutorArguments;
import com.microsoft.lst_bench.util.FileParser;
import com.microsoft.lst_bench.util.StringUtils;
import java.util.ArrayList;
import java.util.Collections;
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
   * @param library the library
   * @param workload the workload
   * @return a benchmark configuration
   */
  public static BenchmarkConfig benchmarkConfig(
      ExperimentConfig experimentConfig, Library library, Workload workload) {
    InternalLibrary internalLibrary = parseLibrary(library);
    ImmutableWorkloadExec workloadExec =
        createWorkloadExec(workload, internalLibrary, experimentConfig);
    return new BenchmarkConfig(
        experimentConfig.getId(),
        experimentConfig.getRepetitions(),
        experimentConfig.getMetadata(),
        workloadExec);
  }

  /**
   * Creates a workload execution from the workload and task library.
   *
   * @param workload the workload to execute
   * @param internalLibrary a library with task, session, and phase templates
   * @param experimentConfig the experiment configuration
   * @return a workload execution
   * @throws IllegalArgumentException if the workload contains an invalid task template ID
   */
  private static ImmutableWorkloadExec createWorkloadExec(
      Workload workload, InternalLibrary internalLibrary, ExperimentConfig experimentConfig) {
    List<Phase> phases = workload.getPhases();
    validatePhases(phases);
    Map<String, Integer> taskTemplateIdToPermuteOrderCounter = new HashMap<>();
    Map<String, Integer> taskTemplateIdToParameterValuesCounter = new HashMap<>();
    List<PhaseExec> phaseExecList = new ArrayList<>();
    for (Phase phase : phases) {
      PhaseExec phaseExec =
          createPhaseExec(
              phase,
              internalLibrary,
              experimentConfig,
              taskTemplateIdToPermuteOrderCounter,
              taskTemplateIdToParameterValuesCounter);
      phaseExecList.add(phaseExec);
    }
    return ImmutableWorkloadExec.of(workload.getId(), phaseExecList);
  }

  /**
   * Validates that the phases have exactly one of template ID, list of sessions, or instance ID
   * defined.
   */
  private static void validatePhases(List<Phase> phases) {
    for (Phase phase : phases) {
      boolean onlyOneTrue = phase.getTemplateId() != null ^ phase.getSessions() != null;
      if (!onlyOneTrue) {
        throw new IllegalArgumentException(
            "Must have exactly one of template id or list of sessions defined");
      }
    }
  }

  private static PhaseExec createPhaseExec(
      Phase phase,
      InternalLibrary internalLibrary,
      ExperimentConfig experimentConfig,
      Map<String, Integer> taskTemplateIdToPermuteOrderCounter,
      Map<String, Integer> taskTemplateIdToParameterValuesCounter) {
    List<Session> sessions;
    if (phase.getSessions() != null) {
      sessions = phase.getSessions();
    } else if (phase.getTemplateId() != null) {
      PhaseTemplate phaseTemplate =
          internalLibrary.getIdToPhaseTemplate().get(phase.getTemplateId());
      if (phaseTemplate == null) {
        throw new IllegalArgumentException("Unknown phase template id: " + phase.getTemplateId());
      }
      sessions = phaseTemplate.getSessions();
    } else {
      throw new IllegalArgumentException("Unknown phase type");
    }
    validateSessions(sessions);
    List<SessionExec> sessionExecList = new ArrayList<>();
    for (int i = 0; i < sessions.size(); i++) {
      Session session = sessions.get(i);
      String sessionId = String.valueOf(i);
      SessionExec sessionExec =
          createSessionExec(
              sessionId,
              session,
              internalLibrary,
              experimentConfig,
              taskTemplateIdToPermuteOrderCounter,
              taskTemplateIdToParameterValuesCounter);
      sessionExecList.add(sessionExec);
    }
    return ImmutablePhaseExec.of(phase.getId(), sessionExecList);
  }

  /**
   * Validates that the sessions have exactly one of template ID, list of tasks, or instance ID
   * defined.
   */
  private static void validateSessions(List<Session> sessions) {
    for (Session session : sessions) {
      boolean onlyOneTrue = session.getTemplateId() != null ^ session.getTasks() != null;
      if (!onlyOneTrue) {
        throw new IllegalArgumentException(
            "Must have exactly one of template id or list of tasks defined");
      }
    }
  }

  private static SessionExec createSessionExec(
      String sessionId,
      Session session,
      InternalLibrary internalLibrary,
      ExperimentConfig experimentConfig,
      Map<String, Integer> taskTemplateIdToPermuteOrderCounter,
      Map<String, Integer> taskTemplateIdToParameterValuesCounter) {
    List<Task> tasks;
    if (session.getTasks() != null) {
      tasks = session.getTasks();
    } else if (session.getTemplateId() != null) {
      SessionTemplate sessionTemplate =
          internalLibrary.getIdToSessionTemplate().get(session.getTemplateId());
      if (sessionTemplate == null) {
        throw new IllegalArgumentException(
            "Unknown session template id: " + session.getTemplateId());
      }
      tasks = sessionTemplate.getTasks();
    } else {
      throw new IllegalArgumentException("Unknown session type");
    }
    validateTasks(tasks);
    tasks = expandTasksSequences(tasks, internalLibrary);
    List<TaskExec> taskExecList = new ArrayList<>();
    for (int j = 0; j < tasks.size(); j++) {
      Task task = tasks.get(j);
      String taskId = task.getTemplateId() + "_" + j;
      TaskExec taskExec =
          createTaskExec(
              taskId,
              task,
              internalLibrary,
              experimentConfig,
              taskTemplateIdToPermuteOrderCounter,
              taskTemplateIdToParameterValuesCounter);
      taskExecList.add(taskExec);
    }
    return ImmutableSessionExec.of(
        sessionId, taskExecList, ObjectUtils.defaultIfNull(session.getTargetEndpoint(), 0));
  }

  /**
   * Validates that the tasks have exactly one of template ID, tasks sequence ID, or instance ID
   * defined.
   */
  private static void validateTasks(List<Task> tasks) {
    for (Task task : tasks) {
      boolean onlyOneTrue =
          (task.getTemplateId() != null ^ task.getTasksSequenceId() != null)
              ^ task.getInstanceId() != null;
      if (!onlyOneTrue) {
        throw new IllegalArgumentException(
            "Must have exactly one of template id, tasks sequence id, or instance id defined");
      }
    }
  }

  /**
   * Expands tasks sequences into a list of tasks. TODO: Nested sequences.
   *
   * @param tasks the tasks to expand
   * @param internalLibrary a library with task, session, and phase templates
   * @return a list of tasks with tasks sequences expanded
   * @throws IllegalArgumentException if a task references an unknown tasks sequence ID
   */
  private static List<Task> expandTasksSequences(
      List<Task> tasks, InternalLibrary internalLibrary) {
    List<Task> expandedTasks = new ArrayList<>();
    for (Task task : tasks) {
      if (task.getTasksSequenceId() != null) {
        TasksSequence tasksSequence =
            internalLibrary.getIdToTasksSequence().get(task.getTasksSequenceId());
        if (tasksSequence == null) {
          throw new IllegalArgumentException(
              "Unknown tasks sequence id: " + task.getTasksSequenceId());
        }
        validateTasks(tasksSequence.getTasks());
        expandedTasks.addAll(tasksSequence.getTasks());
      } else {
        expandedTasks.add(task);
      }
    }
    return Collections.unmodifiableList(expandedTasks);
  }

  private static TaskExec createTaskExec(
      String taskId,
      Task task,
      InternalLibrary internalLibrary,
      ExperimentConfig experimentConfig,
      Map<String, Integer> taskTemplateIdToPermuteOrderCounter,
      Map<String, Integer> taskTemplateIdToParameterValuesCounter) {
    if (task.getInstanceId() != null) {
      Task taskInstance = internalLibrary.getIdToTaskInstance().get(task.getInstanceId());
      if (taskInstance == null) {
        throw new IllegalArgumentException("Unknown task instance id: " + task.getInstanceId());
      }
      return createTaskExec(
          taskId,
          taskInstance,
          internalLibrary,
          experimentConfig,
          taskTemplateIdToPermuteOrderCounter,
          taskTemplateIdToParameterValuesCounter);
    }
    TaskTemplate taskTemplate = internalLibrary.getIdToTaskTemplate().get(task.getTemplateId());
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

    // TODO: Figure out whether we should turn this into a class variable to avoid recomputation.
    // Allow the use of globally (via the experiment config defined) arguments to be parsed into the
    // tasks.
    TaskExecutorArguments taskExecutorArguments =
        new TaskExecutorArguments(experimentConfig.getTaskExecutorArguments());
    taskExecutorArguments.addArguments(task.getTaskExecutorArguments());

    return ImmutableTaskExec.of(taskId, files)
        .withTimeTravelPhaseId(task.getTimeTravelPhaseId())
        .withCustomTaskExecutor(taskTemplate.getCustomTaskExecutor())
        .withTaskExecutorArguments(taskExecutorArguments);
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

  /**
   * Parses the library.
   *
   * @param library the library to parse
   * @return the library internal representation
   * @throws IllegalArgumentException if there are duplicate IDs
   */
  private static InternalLibrary parseLibrary(Library library) {
    Map<String, TaskTemplate> idToTaskTemplate = new HashMap<>();
    for (TaskTemplate taskTemplate : library.getTaskTemplates()) {
      if (idToTaskTemplate.containsKey(taskTemplate.getId())) {
        throw new IllegalArgumentException("Duplicate task template id: " + taskTemplate.getId());
      }
      idToTaskTemplate.put(taskTemplate.getId(), taskTemplate);
    }
    Map<String, SessionTemplate> idToSessionTemplate = new HashMap<>();
    if (library.getSessionTemplates() != null) {
      for (SessionTemplate sessionTemplate : library.getSessionTemplates()) {
        if (idToSessionTemplate.containsKey(sessionTemplate.getId())) {
          throw new IllegalArgumentException(
              "Duplicate session template id: " + sessionTemplate.getId());
        }
        idToSessionTemplate.put(sessionTemplate.getId(), sessionTemplate);
      }
    }
    Map<String, PhaseTemplate> idToPhaseTemplate = new HashMap<>();
    if (library.getPhaseTemplates() != null) {
      for (PhaseTemplate phaseTemplate : library.getPhaseTemplates()) {
        if (idToPhaseTemplate.containsKey(phaseTemplate.getId())) {
          throw new IllegalArgumentException(
              "Duplicate phase template id: " + phaseTemplate.getId());
        }
        idToPhaseTemplate.put(phaseTemplate.getId(), phaseTemplate);
      }
    }
    Map<String, Task> idToTaskInstance = new HashMap<>();
    if (library.getTasks() != null) {
      for (Task task : library.getTasks()) {
        if (idToTaskInstance.containsKey(task.getId())) {
          throw new IllegalArgumentException("Duplicate task id: " + task.getId());
        }
        idToTaskInstance.put(task.getId(), task);
      }
    }
    Map<String, TasksSequence> idToTasksSequence = new HashMap<>();
    if (library.getTasksSequences() != null) {
      for (TasksSequence tasksSequence : library.getTasksSequences()) {
        if (idToTasksSequence.containsKey(tasksSequence.getId())) {
          throw new IllegalArgumentException(
              "Duplicate tasks sequence id: " + tasksSequence.getId());
        }
        idToTasksSequence.put(tasksSequence.getId(), tasksSequence);
      }
    }
    return new InternalLibrary(
        idToTaskTemplate,
        idToSessionTemplate,
        idToPhaseTemplate,
        idToTaskInstance,
        idToTasksSequence);
  }

  private static class InternalLibrary {
    private final Map<String, TaskTemplate> idToTaskTemplate;
    private final Map<String, SessionTemplate> idToSessionTemplate;
    private final Map<String, PhaseTemplate> idToPhaseTemplate;
    private final Map<String, Task> idToTaskInstance;
    private final Map<String, TasksSequence> idToTasksSequence;

    InternalLibrary(
        Map<String, TaskTemplate> idToTaskTemplate,
        Map<String, SessionTemplate> idToSessionTemplate,
        Map<String, PhaseTemplate> idToPhaseTemplate,
        Map<String, Task> idToTaskInstance,
        Map<String, TasksSequence> idToTasksSequence) {
      this.idToTaskTemplate = Collections.unmodifiableMap(idToTaskTemplate);
      this.idToSessionTemplate = Collections.unmodifiableMap(idToSessionTemplate);
      this.idToPhaseTemplate = Collections.unmodifiableMap(idToPhaseTemplate);
      this.idToTaskInstance = Collections.unmodifiableMap(idToTaskInstance);
      this.idToTasksSequence = Collections.unmodifiableMap(idToTasksSequence);
    }

    private Map<String, TaskTemplate> getIdToTaskTemplate() {
      return idToTaskTemplate;
    }

    private Map<String, SessionTemplate> getIdToSessionTemplate() {
      return idToSessionTemplate;
    }

    private Map<String, PhaseTemplate> getIdToPhaseTemplate() {
      return idToPhaseTemplate;
    }

    private Map<String, Task> getIdToTaskInstance() {
      return idToTaskInstance;
    }

    private Map<String, TasksSequence> getIdToTasksSequence() {
      return idToTasksSequence;
    }
  }
}
