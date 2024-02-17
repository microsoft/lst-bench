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

# Azure Pipelines Deployment for LST-Bench on Trino 420
This directory comprises the necessary tooling for executing LST-Bench on Trino 420 with different LSTs using Azure Pipelines. The included tooling consists of:
- `run-lst-bench.yml`:
  An Azure Pipelines script designed to deploy Apache Spark with various LSTs and execute LST-Bench.
- `sh/`:
  A directory containing shell scripts and engine configuration files supporting the deployment of Spark with different LSTs and the execution of experiments.
- `config/`:
  A directory with LST-Bench configuration files necessary for executing the experiments that are part of the results.

## Prerequisites
TODO