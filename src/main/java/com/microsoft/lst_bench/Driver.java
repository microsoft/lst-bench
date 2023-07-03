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
package com.microsoft.lst_bench;

import com.microsoft.lst_bench.client.ConnectionManager;
import com.microsoft.lst_bench.common.BenchmarkConfig;
import com.microsoft.lst_bench.common.BenchmarkRunnable;
import com.microsoft.lst_bench.common.LSTBenchmarkExecutor;
import com.microsoft.lst_bench.input.BenchmarkObjectFactory;
import com.microsoft.lst_bench.input.TaskLibrary;
import com.microsoft.lst_bench.input.Workload;
import com.microsoft.lst_bench.input.config.ConnectionConfig;
import com.microsoft.lst_bench.input.config.ConnectionsConfig;
import com.microsoft.lst_bench.input.config.ExperimentConfig;
import com.microsoft.lst_bench.input.config.TelemetryConfig;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.telemetry.TelemetryHook;
import com.microsoft.lst_bench.util.FileParser;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.MissingOptionException;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.UnrecognizedOptionException;
import org.apache.commons.lang3.Validate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** This is the main class. */
public class Driver {

  private static final Logger LOGGER = LoggerFactory.getLogger(Driver.class);

  private static final String OPT_INPUT_TASK_LIBRARY_FILE = "task-library";
  private static final String OPT_INPUT_WORKLOAD_FILE = "workload";
  private static final String OPT_INPUT_CONNECTION_CONFIG_FILE = "connections-config";
  private static final String OPT_INPUT_EXPERIMENT_CONFIG_FILE = "experiment-config";
  private static final String OPT_INPUT_TELEMETRY_CONFIG_FILE = "input-log-config";

  /** Defeat instantiation. */
  private Driver() {}

  /** Main method. */
  public static void main(String[] args) throws Exception {
    String inputTaskLibraryFile = null;
    String inputWorkloadFile = null;
    String inputConnectionsConfigFile = null;
    String inputExperimentConfigFile = null;
    String inputTelemetryConfigFile = null;

    // Retrieve program input values
    final Options options = createOptions();
    final CommandLineParser parser = new DefaultParser();
    try {
      final CommandLine cmd = parser.parse(options, args);
      if (cmd.getOptions().length == 0) {
        usageAndHelp();
      } else {
        if (cmd.hasOption(OPT_INPUT_TASK_LIBRARY_FILE)) {
          inputTaskLibraryFile = cmd.getOptionValue(OPT_INPUT_TASK_LIBRARY_FILE);
        }
        if (cmd.hasOption(OPT_INPUT_WORKLOAD_FILE)) {
          inputWorkloadFile = cmd.getOptionValue(OPT_INPUT_WORKLOAD_FILE);
        }
        if (cmd.hasOption(OPT_INPUT_CONNECTION_CONFIG_FILE)) {
          inputConnectionsConfigFile = cmd.getOptionValue(OPT_INPUT_CONNECTION_CONFIG_FILE);
        }
        if (cmd.hasOption(OPT_INPUT_EXPERIMENT_CONFIG_FILE)) {
          inputExperimentConfigFile = cmd.getOptionValue(OPT_INPUT_EXPERIMENT_CONFIG_FILE);
        }
        if (cmd.hasOption(OPT_INPUT_TELEMETRY_CONFIG_FILE)) {
          inputTelemetryConfigFile = cmd.getOptionValue(OPT_INPUT_TELEMETRY_CONFIG_FILE);
        }
      }
    } catch (MissingOptionException | UnrecognizedOptionException e) {
      usageAndHelp();
      return;
    }

    // Validate input values
    Validate.notNull(inputTaskLibraryFile, "TaskExec library file is required.");
    Validate.notNull(inputWorkloadFile, "Workload file is required.");
    Validate.notNull(inputConnectionsConfigFile, "Connections config file is required.");
    Validate.notNull(inputExperimentConfigFile, "Experiment config file is required.");
    Validate.notNull(inputTelemetryConfigFile, "Telemetry config file is required.");

    // Create Java objects from input files
    final TaskLibrary taskLibrary =
        FileParser.createObject(inputTaskLibraryFile, TaskLibrary.class);
    final Workload workload = FileParser.createObject(inputWorkloadFile, Workload.class);
    final ConnectionsConfig connectionsConfig =
        FileParser.createObject(inputConnectionsConfigFile, ConnectionsConfig.class);
    final ExperimentConfig experimentConfig =
        FileParser.createObject(inputExperimentConfigFile, ExperimentConfig.class);
    final TelemetryConfig telemetryConfig =
        FileParser.createObject(inputTelemetryConfigFile, TelemetryConfig.class);

    run(taskLibrary, workload, connectionsConfig, experimentConfig, telemetryConfig);
  }

  /** Run benchmark. */
  public static void run(
      TaskLibrary taskLibrary,
      Workload workload,
      ConnectionsConfig connectionsConfig,
      ExperimentConfig experimentConfig,
      TelemetryConfig telemetryConfig)
      throws Exception {
    // Create connections managers
    Set<String> connectionManagerIds = new HashSet<>();
    List<ConnectionManager> connectionManagers = new ArrayList<>();
    for (ConnectionConfig connectionConfig : connectionsConfig.getConnections()) {
      ConnectionManager connectionManager =
          BenchmarkObjectFactory.connectionManager(connectionConfig);
      if (!connectionManagerIds.add(connectionConfig.getId())) {
        throw new IllegalArgumentException("Duplicate connection id: " + connectionConfig.getId());
      }
      connectionManagers.add(connectionManager);
    }

    // Create log utility
    final ConnectionManager telemetryConnectionManager =
        BenchmarkObjectFactory.connectionManager(telemetryConfig.getConnection());
    final SQLTelemetryRegistry telemetryRegistry =
        new SQLTelemetryRegistry(
            telemetryConnectionManager,
            telemetryConfig.isExecuteDDL(),
            telemetryConfig.getDDLFile(),
            telemetryConfig.getInsertFile(),
            telemetryConfig.getParameterValues());
    Thread telemetryHook = new TelemetryHook(telemetryRegistry);
    Runtime.getRuntime().addShutdownHook(telemetryHook);

    // Create experiment configuration
    final BenchmarkConfig benchmarkConfig =
        BenchmarkObjectFactory.benchmarkConfig(experimentConfig, taskLibrary, workload);

    // Run experiment
    final BenchmarkRunnable experiment =
        new LSTBenchmarkExecutor(connectionManagers, benchmarkConfig, telemetryRegistry);
    experiment.execute();
  }

  private static Options createOptions() {
    final Options options = new Options();

    final Option inputTaskLibraryFile =
        Option.builder()
            .required()
            .option("l")
            .longOpt(OPT_INPUT_TASK_LIBRARY_FILE)
            .hasArg()
            .argName("arg")
            .desc("Path to input file containing the library with task templates")
            .build();
    options.addOption(inputTaskLibraryFile);

    final Option inputWorkloadFile =
        Option.builder()
            .required()
            .option("w")
            .longOpt(OPT_INPUT_WORKLOAD_FILE)
            .hasArg()
            .argName("arg")
            .desc("Path to input file containing the workload definition")
            .build();
    options.addOption(inputWorkloadFile);

    final Option inputConnectionConfigFile =
        Option.builder()
            .required()
            .option("c")
            .longOpt(OPT_INPUT_CONNECTION_CONFIG_FILE)
            .hasArg()
            .argName("arg")
            .desc("Path to input file containing connections config details")
            .build();
    options.addOption(inputConnectionConfigFile);

    final Option inputExperimentConfigFile =
        Option.builder()
            .required()
            .option("e")
            .longOpt(OPT_INPUT_EXPERIMENT_CONFIG_FILE)
            .hasArg()
            .argName("arg")
            .desc("Path to input file containing the experiment config details")
            .build();
    options.addOption(inputExperimentConfigFile);

    final Option inputTelemetryConfigFile =
        Option.builder()
            .required()
            .option("t")
            .longOpt(OPT_INPUT_TELEMETRY_CONFIG_FILE)
            .hasArg()
            .argName("arg")
            .desc("Path to input file containing the telemetry gathering config details")
            .build();
    options.addOption(inputTelemetryConfigFile);

    return options;
  }

  private static void usageAndHelp() {
    // Print usage and help
    final HelpFormatter formatter = new HelpFormatter();
    formatter.setWidth(120);
    formatter.printHelp("./launcher.sh", createOptions(), true);
  }
}
