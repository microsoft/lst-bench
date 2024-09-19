<!--
{% comment %}
Copyright (c) Microsoft Corporation.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
{% endcomment %}
-->

# LST-Bench

[![CI Status](https://github.com/microsoft/lst-bench/workflows/Java%20CI/badge.svg?branch=main)](https://github.com/microsoft/lst-bench/actions?query=branch%3Amain)

LST-Bench is a framework that allows users to run benchmarks specifically designed for evaluating the performance, efficiency, and stability of Log-Structured Tables (LSTs), also commonly referred to as table formats, such as [Delta Lake](https://delta.io/), [Apache Hudi](http://hudi.apache.org), and [Apache Iceberg](http://iceberg.apache.org).

## Usage Guide

### How to Build

#### Prerequisites

Install open-source Java Development Kit. As a recommendation, install OpenJDK distribution from [Adoptium]('https://adoptium.net/en-GB/').

#### Build

To build LST-Bench in Linux/macOS, run the following command:

```bash
./mvnw package
```

Or use the following command for Windows:

```bat
mvnw.cmd package
```

To build LST-Bench for a specific database, you can use the profile name (`-P`) option. 
This will include the corresponding JDBC driver in the `./target` directory. 
Currently, the following profiles are supported: `databricks-jdbc`, `snowflake-jdbc`, `spark-jdbc`, `spark-client`, `trino-jdbc` and `microsoft-fabric-jdbc`.
For example, to build LST-Bench for open-source Spark with JDBC drivers in Linux/macOS, you can run the following command:

```bash
./mvnw package -Pspark-jdbc
```

Or use the following command for Windows:

```bat
mvnw.cmd package -Pspark-jdbc
```

### How to Run

After building LST-Bench, if you are on Linux/macOS run `launcher.sh` or open a Powershell `launcher.ps1` if you are on Windows to display the usage options.

```bash
usage: ./launcher.sh -c <arg> -e <arg> -l <arg> -t <arg> -w <arg>
 -c,--connections-config <arg>   [required] Path to input file containing
                                 connections config details
 -e,--experiment-config <arg>    [required] Path to input file containing
                                 the experiment config details
 -l,--library <arg>              [required] Path to input file containing
                                 the library with templates
 -t,--input-log-config <arg>     [required] Path to input file containing
                                 the telemetry gathering config details
 -w,--workload <arg>             [required] Path to input file containing
                                 the workload definition
```

## Configuration Files
The configuration files used in LST-Bench are YAML files. 

You can find their schema, which describes the expected structure and properties, [here](core/src/main/resources/schemas).

NOTE: The spark schemas are configured for Spark 3.3 or earlier. In case you plan to use Spark 3.4, the setup and setup_data_maintenance tasks need to be
modified to handle [SPARK-44025](https://issues.apache.org/jira/browse/SPARK-44025). Columns in CSV tables need to defined as `STRING` instead of `VARCHAR` or `CHAR`.
Append the following regex replacement to the setup and setup_data_maintenance phases in the workload file:
```bash
    replace_regex:
      - pattern: '(?i)varchar\(.*\)|char\(.*\)'
        replacement: 'string'
```

Additionally, you can find sample configurations that can serve as guidelines for creating your configurations [here](core/src/main/resources/config).
The YAML file can also contain references to environment variable along with default values. The parser will handle the same appropriately. 
Example:
```bash
    parameter_name: ${ENVIRONMENT_VARIABLE:-default_value}
```

## Architecture

The core of LST-Bench is organized into two modules:

1. **Java Application.** This module is written entirely in Java and is responsible for executing SQL workloads against a system under test using JDBC.
   It reads input configuration files to determine the tasks, sessions, and phases to be executed.
   The Java application handles the execution of SQL statements and manages the interaction with the system under test.

2. **Python Metrics Module.** The metrics module is written in Python and serves as the post-execution analysis component.
   It consolidates experimental results obtained from the Java application and computes metrics to provide insights into LSTs and cloud data warehouses.
   The Python module performs data processing, analysis, and visualization to facilitate a deeper understanding of the experimental results.

Additionally, the **Adapters** module is designed to handle integration with external tools and systems by converting outputs from third-party benchmarks into formats compatible with LST-Bench.
One example of this is the **CAB to LST-Bench converter**, which transforms results from the Cloud Analytics Benchmark (CAB) into a format that can be used by LST-Bench for further analysis.

### LST-Bench Concepts
In LST-Bench, we utilize specific concepts to define and organize SQL workloads, with a focus on maximizing flexibility and facilitating reusability across various workloads. For detailed information, refer to our [documentation](docs/workloads.md).

### Telemetry and Metrics Processor
LST-Bench captures execution telemetry during workload execution at multiple levels, including per experiment, phase, session, task, file, and statement.
Each telemetry event is recorded with an associated identifier, such as the statement's name or the phase IDs defined in the workload YAML.
The event includes information on whether it succeeded or not, along with any additional associated data.
Specifically, each event includes a _start time_, _end time_, _event ID_, _event type_, _status_, and optional _payload_.

The telemetry registry in LST-Bench is configurable, providing flexibility for different systems and use cases.
By default, LST-Bench includes an implementation for a JDBC-based registry and supports writing telemetry to DuckDB or Spark.
LST-Bench writes these telemetry events into a table within the specified systems, enabling any application to consume and gain insights from the results.

Alternatively, if the LST-Bench [Metrics Processor](core/metrics) is used, you can simply point it to the same database.
The processor will then analyze and visualize the results, providing a streamlined solution for result analysis and visualization.

## Documentation
Interested in learning more about LST-Bench? Explore the following resources:

* **From Paper to Practice: Leveraging LST-Bench to Evaluate Lake-Centric Data Platforms** - Presented at the DBTest'24 Workshop, June 2024. [Slides available here](docs/20240609-LSTBench-DBTest24.pdf).
* **LST-Bench: Benchmarking Log-Structured Tables in the Cloud** - In SIGMOD 2024. [Read the technical report here](https://arxiv.org/pdf/2305.01120).

If you are writing an academic paper, you can cite this work as:

```bibtex
@article{2024lstbench,
    author = {Jes{\'u}s Camacho-Rodr{\'i}guez and Ashvin Agrawal and Anja Gruenheid and
            Ashit Gosalia and Cristian Petculescu and Josep Aguilar-Saborit and
            Avrilia Floratou and Carlo Curino and Raghu Ramakrishnan},
    title = {LST-Bench: Benchmarking Log-Structured Tables in the Cloud},
    journal = {Proc. ACM Manag. Data},
    volume = {2},
    number = {1},
    year = {2024},
    url = {https://doi.org/10.1145/3639314}
}
```

## Contributing

Here are some ways you can contribute to the LST-Bench project:

* Submit PRs to fix bugs or add new features.
* Review currently [open PRs](https://github.com/microsoft/lst-bench/pulls).
* Provide feedback and report bugs related to the software or the documentation.
* Enhance our design documents, examples, tutorials, and overall documentation.

To get started, please take a look at the [issues](https://github.com/microsoft/lst-bench/issues) and leave a comment if any of them interest you.

If you plan to make significant changes, we recommend [discussing](https://github.com/microsoft/lst-bench/discussions) them with the LST-Bench community first.
This helps ensure that your contributions align with the project's goals and avoids duplicating efforts.

## Contributor License Agreement

Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## License

See the [LICENSE](LICENSE) file for more details.
