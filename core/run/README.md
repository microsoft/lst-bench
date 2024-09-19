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

# LST-Bench: Configurations and Results
This folder contains configurations for running LST-Bench on various systems as depicted in the [LST-Bench dashboard](/core/metrics/app), along with details about the setups used to generate those results.

## Systems Included
- [x] Apache Spark 3.3.1
  - [x] Delta Lake 2.2.0
  - [x] Apache Hudi 0.12.2
  - [x] Apache Iceberg 1.1.0
- [x] Trino 420
  - [x] Delta Lake
  - [x] Apache Iceberg
- [x] Snowflake 8.13.1
  - [x] Native tables
  - [x] Apache Iceberg   

## Folder Structure
While the folder for each engine may have a slightly different structure, they generally contain the following:

- `scripts/`: 
  This directory contains SQL files used to execute LST-Bench workloads on the respective engine. 
  Typically, these SQL files may vary slightly across engines and LSTs based on the supported SQL dialect.
- `config/`: 
  This directory houses LST-Bench configuration files required to execute the workload. 
  It includes LST-Bench phase/session/task libraries that reference the aforementioned SQL scripts.
- _(Optional)_ Additional infrastructure and configuration automation folders, e.g., `azure-pipelines/`: 
  These folders contain scripts or files facilitating automation for running the benchmark on a specific infrastructure/engine.
  For instance, Azure Pipelines scripts to deploy an engine with different LSTs and executing LST-Bench. 
  Generally, these folders should include an additional README.md file offering further details.
- _(Optional)_ `results/`: 
  This folder stores the results of the LST-Bench runs as captured by LST-Bench telemetry using DuckDB.
  These results are processed and visualized in the [LST-Bench dashboard](/core/metrics/app).
