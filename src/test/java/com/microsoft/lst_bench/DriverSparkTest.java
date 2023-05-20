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

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;

/** Unit test for LST-Bench driver running on Spark. */
@EnabledIfSystemProperty(named = "lst-bench.test.db", matches = "spark")
public class DriverSparkTest {

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "delta")
  public void testTPCDSW0Delta() throws Exception {
    Driver.main(
        new String[] {
          "-c",
          "src/test/resources/config/spark/connections_config.yaml",
          "-e",
          "src/test/resources/config/spark/experiment_config_delta.yaml",
          "-t",
          "src/test/resources/config/spark/telemetry_config.yaml",
          "-l",
          "src/main/resources/config/tpcds/task_library.yaml",
          "-w",
          "src/test/resources/config/spark/w_all_tpcds_delta.yaml"
        });
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "hudi")
  public void testTPCDSW0Hudi() throws Exception {
    Driver.main(
        new String[] {
          "-c",
          "src/test/resources/config/spark/connections_config.yaml",
          "-e",
          "src/test/resources/config/spark/experiment_config_hudi.yaml",
          "-t",
          "src/test/resources/config/spark/telemetry_config.yaml",
          "-l",
          "src/main/resources/config/tpcds/task_library.yaml",
          "-w",
          "src/test/resources/config/spark/w_all_tpcds_hudi.yaml"
        });
  }

  @Test
  @EnabledIfSystemProperty(named = "lst-bench.test.lst", matches = "iceberg")
  public void testTPCDSW0Iceberg() throws Exception {
    Driver.main(
        new String[] {
          "-c",
          "src/test/resources/config/spark/connections_config.yaml",
          "-e",
          "src/test/resources/config/spark/experiment_config_iceberg.yaml",
          "-t",
          "src/test/resources/config/spark/telemetry_config.yaml",
          "-l",
          "src/main/resources/config/tpcds/task_library.yaml",
          "-w",
          "src/test/resources/config/spark/w_all_tpcds_iceberg.yaml"
        });
  }
}
