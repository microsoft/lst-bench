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

import com.microsoft.lst_bench.input.config.ConnectionsConfig;
import com.microsoft.lst_bench.input.config.ExperimentConfig;
import com.microsoft.lst_bench.input.config.JDBCConnectionConfig;
import com.microsoft.lst_bench.input.config.SparkConnectionConfig;
import com.microsoft.lst_bench.input.config.TelemetryConfig;
import com.microsoft.lst_bench.util.FileParser;
import java.io.File;
import java.io.IOException;
import java.util.List;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;
import org.junitpioneer.jupiter.SetEnvironmentVariable;

/** Tests for YAML parser into POJO representation. */
@DisabledIfSystemProperty(named = "lst-bench.test.db", matches = ".*")
public class ParserTest {

  private static final String CONFIG_PATH =
      "src"
          + File.separator
          + "main"
          + File.separator
          + "resources"
          + File.separator
          + "config"
          + File.separator
          + "spark"
          + File.separator;

  @Test
  public void testParseExperimentConfig() throws IOException {
    ExperimentConfig experimentConfig =
        FileParser.createObject(
            CONFIG_PATH + "sample_experiment_config.yaml", ExperimentConfig.class);
    Assertions.assertEquals(1, experimentConfig.getVersion());
    Assertions.assertEquals("spark_del_sf_10", experimentConfig.getId());
    Assertions.assertNotNull(experimentConfig.getMetadata());
    Assertions.assertEquals("spark", experimentConfig.getMetadata().get("system"));
    Assertions.assertEquals("3.3.1", experimentConfig.getMetadata().get("system_version"));
    Assertions.assertEquals("delta", experimentConfig.getMetadata().get("table_format"));
    Assertions.assertEquals("2.2.0", experimentConfig.getMetadata().get("table_format_version"));
    Assertions.assertEquals("10", experimentConfig.getMetadata().get("scale_factor"));
    Assertions.assertEquals("cow", experimentConfig.getMetadata().get("mode"));
    Assertions.assertNotNull(experimentConfig.getParameterValues());
    Assertions.assertEquals(
        "spark_catalog", experimentConfig.getParameterValues().get("external_catalog"));
    Assertions.assertEquals(
        "external_tpcds", experimentConfig.getParameterValues().get("external_database"));
    Assertions.assertEquals(
        "csv", experimentConfig.getParameterValues().get("external_table_format"));
    Assertions.assertEquals(
        "abfss://mycontainer@myaccount.dfs.core.windows.net/sf_10/",
        experimentConfig.getParameterValues().get("external_data_path"));
    Assertions.assertEquals(
        ",header=\"true\"", experimentConfig.getParameterValues().get("external_options_suffix"));
    Assertions.assertEquals(
        "", experimentConfig.getParameterValues().get("external_tblproperties_suffix"));
    Assertions.assertEquals("spark_catalog", experimentConfig.getParameterValues().get("catalog"));
    Assertions.assertEquals("delta_tpcds", experimentConfig.getParameterValues().get("database"));
    Assertions.assertEquals("delta", experimentConfig.getParameterValues().get("table_format"));
    Assertions.assertEquals(
        "abfss://mycontainer@myaccount.dfs.core.windows.net/delta/sf_10/",
        experimentConfig.getParameterValues().get("data_path"));
    Assertions.assertEquals("", experimentConfig.getParameterValues().get("options_suffix"));
    Assertions.assertEquals("", experimentConfig.getParameterValues().get("tblproperties_suffix"));
  }

  @Test
  @SetEnvironmentVariable(key = "DATABASE_PASSWORD", value = "p@ssw0rd0")
  public void testParseConnectionConfig() throws IOException {
    ConnectionsConfig connectionsConfig =
        FileParser.createObject(
            CONFIG_PATH + "sample_connections_config.yaml", ConnectionsConfig.class);
    Assertions.assertEquals(1, connectionsConfig.getVersion());
    Assertions.assertEquals(3, connectionsConfig.getConnections().size());
    JDBCConnectionConfig connection0 =
        (JDBCConnectionConfig) connectionsConfig.getConnections().get(0);
    Assertions.assertEquals("spark_0", connection0.getId());
    Assertions.assertEquals("org.apache.hive.jdbc.HiveDriver", connection0.getDriver());
    Assertions.assertEquals("jdbc:hive2://127.0.0.1:10000", connection0.getUrl());
    Assertions.assertEquals("spark_admin", connection0.getUsername()); // Default value.
    Assertions.assertEquals(
        "p@ssw0rd0", connection0.getPassword()); // Set via DATABASE_PASSWORD environment variable.
    JDBCConnectionConfig connection1 =
        (JDBCConnectionConfig) connectionsConfig.getConnections().get(1);
    Assertions.assertEquals("spark_1", connection1.getId());
    Assertions.assertEquals("org.apache.hive.jdbc.HiveDriver", connection1.getDriver());
    Assertions.assertEquals("jdbc:hive2://127.0.0.1:10001", connection1.getUrl());
    Assertions.assertEquals("admin", connection1.getUsername());
    Assertions.assertEquals("p@ssw0rd1", connection1.getPassword());
    SparkConnectionConfig connection2 =
        (SparkConnectionConfig) connectionsConfig.getConnections().get(2);
    Assertions.assertEquals("spark_2", connection2.getId());
    Assertions.assertEquals("spark://127.0.0.1:7077", connection2.getUrl());
    // TODO
  }

  @Test
  public void testParseTaskLibrary() throws IOException {
    TaskLibrary taskLibrary =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "task_library.yaml", TaskLibrary.class);
    Assertions.assertEquals(1, taskLibrary.getVersion());
    Assertions.assertEquals(12, taskLibrary.getTaskTemplates().size());
    for (TaskTemplate taskTemplate : taskLibrary.getTaskTemplates()) {
      switch (taskTemplate.getId()) {
        case "setup":
          Assertions.assertEquals(
              "src/main/resources/scripts/tpcds/setup/spark/ddl-external-tables.sql",
              taskTemplate.getFiles().get(0));
          Assertions.assertNull(taskTemplate.getParameterValuesFile());
          Assertions.assertNull(taskTemplate.getPermutationOrdersDirectory());
          Assertions.assertNull(taskTemplate.supportsTimeTravel());
          break;
        case "setup_data_maintenance":
          Assertions.assertEquals(
              "src/main/resources/auxiliary/tpcds/setup_data_maintenance/parameter_values.dat",
              taskTemplate.getParameterValuesFile());
          break;
        case "single_user":
          Assertions.assertEquals(
              "src/main/resources/auxiliary/tpcds/single_user/permutation_orders/",
              taskTemplate.getPermutationOrdersDirectory());
          Assertions.assertEquals(Boolean.TRUE, taskTemplate.supportsTimeTravel());
          break;
        case "init":
        case "build":
        case "analyze":
        case "optimize_delta":
        case "optimize_hudi":
        case "optimize_iceberg":
          Assertions.assertNull(taskTemplate.getParameterValuesFile());
          Assertions.assertNull(taskTemplate.getPermutationOrdersDirectory());
          Assertions.assertNull(taskTemplate.supportsTimeTravel());
          break;
        case "data_maintenance_delta":
        case "data_maintenance_hudi":
        case "data_maintenance_iceberg":
          Assertions.assertNotNull(taskTemplate.getParameterValuesFile());
          Assertions.assertNull(taskTemplate.getPermutationOrdersDirectory());
          Assertions.assertNull(taskTemplate.supportsTimeTravel());
          break;
        default:
          Assertions.fail("Unexpected task template id: " + taskTemplate.getId());
      }
    }
  }

  @Test
  public void testParseW0Delta() throws IOException {
    Workload workload =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "w0_tpcds-delta.yaml", Workload.class);
    Assertions.assertEquals(1, workload.getVersion());
    Assertions.assertEquals("w0_tpcds", workload.getId());
    Assertions.assertEquals(9, workload.getPhases().size());
    for (Phase phase : workload.getPhases()) {
      switch (phase.getId()) {
        case "setup":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            Assertions.assertEquals(1, tasks.size());
            Task task = tasks.get(0);
            Assertions.assertEquals("setup", task.getTemplateId());
            Assertions.assertNull(task.isPermuteOrder());
            Assertions.assertNull(task.getReplaceRegex());
          }
          break;
        case "throughput_1":
        case "throughput_2":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(4, sessions.size());
            for (Session session : sessions) {
              Assertions.assertEquals(1, session.getTasks().size());
              Task task = session.getTasks().get(0);
              Assertions.assertEquals("single_user", task.getTemplateId());
              Assertions.assertEquals(Boolean.TRUE, task.isPermuteOrder());
              Assertions.assertNull(task.getReplaceRegex());
              Assertions.assertNull(task.getTimeTravelPhaseId());
            }
          }
          break;
        case "data_maintenance_1":
        case "data_maintenance_2":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            for (Task task : tasks) {
              Assertions.assertEquals("data_maintenance_delta", task.getTemplateId());
              Assertions.assertNull(task.isPermuteOrder());
              Assertions.assertNull(task.getReplaceRegex());
            }
          }
          break;
        case "setup_data_maintenance":
        case "init":
        case "build":
        case "single_user":
          // Nothing checked
          break;
        default:
          Assertions.fail("Unexpected phase id: " + phase.getId());
      }
    }
  }

  @Test
  public void testParseW0Hudi() throws IOException {
    Workload workload =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "w0_tpcds-hudi.yaml", Workload.class);
    Assertions.assertEquals(1, workload.getVersion());
    Assertions.assertEquals("w0_tpcds", workload.getId());
    Assertions.assertEquals(9, workload.getPhases().size());
    for (Phase phase : workload.getPhases()) {
      switch (phase.getId()) {
        case "setup":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            Assertions.assertEquals(1, tasks.size());
            Task task = tasks.get(0);
            Assertions.assertEquals("setup", task.getTemplateId());
            Assertions.assertNull(task.isPermuteOrder());
            Assertions.assertNull(task.getReplaceRegex());
          }
          break;
        case "throughput_1":
        case "throughput_2":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(4, sessions.size());
            for (Session session : sessions) {
              Assertions.assertEquals(1, session.getTasks().size());
              Task task = session.getTasks().get(0);
              Assertions.assertEquals("single_user", task.getTemplateId());
              Assertions.assertEquals(Boolean.TRUE, task.isPermuteOrder());
              Assertions.assertNull(task.getReplaceRegex());
              Assertions.assertNull(task.getTimeTravelPhaseId());
            }
          }
          break;
        case "data_maintenance_1":
        case "data_maintenance_2":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            for (Task task : tasks) {
              Assertions.assertEquals("data_maintenance_hudi", task.getTemplateId());
              Assertions.assertNull(task.isPermuteOrder());
              Assertions.assertNull(task.getReplaceRegex());
            }
          }
          break;
        case "build":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            Task task = tasks.get(0);
            Assertions.assertEquals("build", task.getTemplateId());
            Assertions.assertNull(task.isPermuteOrder());
            Assertions.assertNotNull(task.getReplaceRegex());
            List<Task.ReplaceRegex> replaceRegex = task.getReplaceRegex();
            Assertions.assertEquals(1, replaceRegex.size());
            Assertions.assertEquals(
                "(?i)varchar\\(.*\\)|char\\(.*\\)", replaceRegex.get(0).getPattern());
            Assertions.assertEquals("string", replaceRegex.get(0).getReplacement());
          }
          break;
        case "setup_data_maintenance":
        case "init":
        case "single_user":
          // Nothing checked
          break;
        default:
          Assertions.fail("Unexpected phase id: " + phase.getId());
      }
    }
  }

  @Test
  public void testParseW0Iceberg() throws IOException {
    Workload workload =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "w0_tpcds-iceberg.yaml", Workload.class);
    Assertions.assertEquals(1, workload.getVersion());
    Assertions.assertEquals("w0_tpcds", workload.getId());
    Assertions.assertEquals(9, workload.getPhases().size());
    for (Phase phase : workload.getPhases()) {
      switch (phase.getId()) {
        case "setup":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            Assertions.assertEquals(1, tasks.size());
            Task task = tasks.get(0);
            Assertions.assertEquals("setup", task.getTemplateId());
            Assertions.assertNull(task.isPermuteOrder());
            Assertions.assertNull(task.getReplaceRegex());
          }
          break;
        case "throughput_1":
        case "throughput_2":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(4, sessions.size());
            for (Session session : sessions) {
              Assertions.assertEquals(1, session.getTasks().size());
              Task task = session.getTasks().get(0);
              Assertions.assertEquals("single_user", task.getTemplateId());
              Assertions.assertEquals(Boolean.TRUE, task.isPermuteOrder());
              Assertions.assertNull(task.getReplaceRegex());
              Assertions.assertNull(task.getTimeTravelPhaseId());
            }
          }
          break;
        case "data_maintenance_1":
        case "data_maintenance_2":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            for (Task task : tasks) {
              Assertions.assertEquals("data_maintenance_iceberg", task.getTemplateId());
              Assertions.assertNull(task.isPermuteOrder());
              Assertions.assertNull(task.getReplaceRegex());
            }
          }
          break;
        case "setup_data_maintenance":
        case "init":
        case "build":
        case "single_user":
          // Nothing checked
          break;
        default:
          Assertions.fail("Unexpected phase id: " + phase.getId());
      }
    }
  }

  @Test
  public void testParseWP1Longevity() throws IOException {
    Workload workload =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "wp1_longevity.yaml", Workload.class);
    Assertions.assertEquals(1, workload.getVersion());
    Assertions.assertEquals("wp1_longevity", workload.getId());
    Assertions.assertEquals(15, workload.getPhases().size());
  }

  @Test
  public void testParseWP2Resilience() throws IOException {
    Workload workload =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "wp2_resilience.yaml", Workload.class);
    Assertions.assertEquals(1, workload.getVersion());
    Assertions.assertEquals("wp2_resilience", workload.getId());
    Assertions.assertEquals(17, workload.getPhases().size());
    for (Phase phase : workload.getPhases()) {
      switch (phase.getId()) {
        case "setup":
        case "setup_data_maintenance":
        case "init":
        case "build":
        case "single_user_1":
        case "data_maintenance_1":
        case "single_user_2":
        case "optimize_1":
        case "single_user_2o":
        case "data_maintenance_2":
        case "single_user_3":
        case "optimize_2":
        case "single_user_3o":
        case "data_maintenance_3":
        case "single_user_4":
        case "optimize_3":
        case "single_user_4o":
          // Nothing checked
          break;
        default:
          Assertions.fail("Unexpected phase id: " + phase.getId());
      }
    }
  }

  @Test
  public void testParseWP3RWConcurrency() throws IOException {
    Workload workload =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "wp3_rw_concurrency.yaml", Workload.class);
    Assertions.assertEquals(1, workload.getVersion());
    Assertions.assertEquals("wp3_rw_concurrency", workload.getId());
    Assertions.assertEquals(10, workload.getPhases().size());
    for (Phase phase : workload.getPhases()) {
      switch (phase.getId()) {
        case "single_user_1_data_maintenance_1":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(2, sessions.size());
            List<Task> tasksSU = sessions.get(0).getTasks();
            Assertions.assertEquals(1, tasksSU.size());
            Task taskSU = tasksSU.get(0);
            Assertions.assertEquals("single_user", taskSU.getTemplateId());
            Assertions.assertNull(taskSU.isPermuteOrder());
            Assertions.assertNull(taskSU.getReplaceRegex());
            Assertions.assertNull(taskSU.getTimeTravelPhaseId());
            List<Task> tasksDM = sessions.get(1).getTasks();
            Assertions.assertEquals(2, tasksDM.size());
            for (Task task : tasksDM) {
              Assertions.assertEquals("data_maintenance_delta", task.getTemplateId());
              Assertions.assertNull(task.isPermuteOrder());
              Assertions.assertNull(task.getReplaceRegex());
              Assertions.assertNull(task.getTimeTravelPhaseId());
            }
          }
          break;
        case "single_user_2_optimize_1":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(2, sessions.size());
            List<Task> tasksSU = sessions.get(0).getTasks();
            Assertions.assertEquals(1, tasksSU.size());
            Task taskSU = tasksSU.get(0);
            Assertions.assertEquals("single_user", taskSU.getTemplateId());
            Assertions.assertNull(taskSU.isPermuteOrder());
            Assertions.assertNull(taskSU.getReplaceRegex());
            Assertions.assertNull(taskSU.getTimeTravelPhaseId());
            List<Task> tasksO = sessions.get(1).getTasks();
            Assertions.assertEquals(1, tasksO.size());
            Task taskO = tasksO.get(0);
            Assertions.assertEquals("optimize_delta", taskO.getTemplateId());
            Assertions.assertNull(taskO.isPermuteOrder());
            Assertions.assertNull(taskO.getReplaceRegex());
            Assertions.assertNull(taskO.getTimeTravelPhaseId());
          }
          break;
        case "setup":
        case "setup_data_maintenance":
        case "init":
        case "build":
        case "single_user_2o_data_maintenance_2":
        case "single_user_3_optimize_2":
        case "single_user_3o_data_maintenance_3":
        case "single_user_4_optimize_3":
          // Nothing checked
          break;
        default:
          Assertions.fail("Unexpected phase id: " + phase.getId());
      }
    }
  }

  @Test
  public void testParseWP3RWConcurrencyMulti() throws IOException {
    Workload workload =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "wp3_rw_concurrency_multi.yaml",
            Workload.class);
    Assertions.assertEquals(1, workload.getVersion());
    Assertions.assertEquals("wp3_rw_concurrency_multi", workload.getId());
    Assertions.assertEquals(10, workload.getPhases().size());
    for (Phase phase : workload.getPhases()) {
      switch (phase.getId()) {
        case "single_user_1_data_maintenance_1":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(2, sessions.size());
            List<Task> tasksDM = sessions.get(1).getTasks();
            Assertions.assertEquals(2, tasksDM.size());
            Assertions.assertEquals(1, sessions.get(1).getTargetEndpoint());
          }
          break;
        case "single_user_2_optimize_1":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(2, sessions.size());
            List<Task> tasksO = sessions.get(1).getTasks();
            Assertions.assertEquals(1, tasksO.size());
            Assertions.assertEquals(1, sessions.get(1).getTargetEndpoint());
          }
          break;
        case "setup":
        case "setup_data_maintenance":
        case "init":
        case "build":
        case "single_user_2o_data_maintenance_2":
        case "single_user_3_optimize_2":
        case "single_user_3o_data_maintenance_3":
        case "single_user_4_optimize_3":
          // Nothing checked
          break;
        default:
          Assertions.fail("Unexpected phase id: " + phase.getId());
      }
    }
  }

  @Test
  public void testParseWP4TimeTravel() throws IOException {
    Workload workload =
        FileParser.createObject(
            CONFIG_PATH + "tpcds" + File.separator + "wp4_time_travel.yaml", Workload.class);
    Assertions.assertEquals(1, workload.getVersion());
    Assertions.assertEquals("wp4_time_travel", workload.getId());
    Assertions.assertEquals(18, workload.getPhases().size());
    for (Phase phase : workload.getPhases()) {
      switch (phase.getId()) {
        case "single_user_2_0":
        case "single_user_3_0":
        case "single_user_3_1":
        case "single_user_4_0":
        case "single_user_4_1":
        case "single_user_4_2":
        case "single_user_5_0":
        case "single_user_5_1":
        case "single_user_5_2":
        case "single_user_5_3":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            Assertions.assertEquals(1, tasks.size());
            Task task = tasks.get(0);
            Assertions.assertEquals("single_user", task.getTemplateId());
            Assertions.assertNull(task.isPermuteOrder());
            Assertions.assertNull(task.getReplaceRegex());
            Assertions.assertNotNull(task.getTimeTravelPhaseId());
          }
          break;
        case "setup_data_maintenance":
          {
            List<Session> sessions = phase.getSessions();
            Assertions.assertEquals(1, sessions.size());
            List<Task> tasks = sessions.get(0).getTasks();
            Assertions.assertEquals(8, tasks.size());
          }
          break;
        case "setup":
        case "init":
        case "build":
        case "data_maintenance_1":
        case "data_maintenance_2":
        case "data_maintenance_3":
        case "data_maintenance_4":
          // Nothing checked
          break;
        default:
          Assertions.fail("Unexpected phase id: " + phase.getId());
      }
    }
  }

  @Test
  public void testParseTelemetryConfig() throws IOException {
    TelemetryConfig telemetryConfig =
        FileParser.createObject(
            CONFIG_PATH + "sample_telemetry_config.yaml", TelemetryConfig.class);
    Assertions.assertEquals(1, telemetryConfig.getVersion());
    Assertions.assertNotNull(telemetryConfig.getConnection());
    JDBCConnectionConfig connectionConfig = (JDBCConnectionConfig) telemetryConfig.getConnection();
    Assertions.assertEquals("duckdb_0", connectionConfig.getId());
    Assertions.assertEquals("org.duckdb.DuckDBDriver", connectionConfig.getDriver());
    Assertions.assertEquals("jdbc:duckdb:./telemetry", connectionConfig.getUrl());
    Assertions.assertNull(connectionConfig.getUsername());
    Assertions.assertNull(connectionConfig.getPassword());
    Assertions.assertEquals(Boolean.TRUE, telemetryConfig.isExecuteDDL());
    Assertions.assertEquals(
        "src/main/resources/scripts/logging/duckdb/ddl.sql", telemetryConfig.getDDLFile());
    Assertions.assertEquals(
        "src/main/resources/scripts/logging/duckdb/insert.sql", telemetryConfig.getInsertFile());
    Assertions.assertNotNull(telemetryConfig.getParameterValues());
    Assertions.assertEquals("", telemetryConfig.getParameterValues().get("data_path"));
  }
}
