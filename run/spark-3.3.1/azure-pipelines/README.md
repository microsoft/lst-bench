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

# Azure Pipelines Deployment for LST-Bench on Apache Spark 3.3.1
This directory comprises the necessary tooling for executing LST-Bench on Apache Spark 3.3.1 with different LSTs using Azure Pipelines. The included tooling consists of:
- `run-lst-bench.yml`:
  An Azure Pipelines script designed to deploy Apache Spark with various LSTs and execute LST-Bench.
- `sh/`:
  A directory containing shell scripts and engine configuration files supporting the deployment of Spark with different LSTs and the execution of experiments.
- `config/`:
  A directory with LST-Bench configuration files necessary for executing the experiments that are part of the results.

## Prerequisites
- Automation for deploying the infrastructure in Azure to run LST-Bench is not implemented. As a result, the Azure Pipeline script expects the following setup:
  - A VM named 'lst-bench-client' connected to the pipeline environment to run the LST-Bench client.
  - A VM named 'lst-bench-head' to run the head node of the Spark cluster, also connected to the pipeline environment.
  - A VMSS cluster, that will serve as the Spark worker nodes, within the same VNet as the head node.
  - An Azure Storage Account accessible by both the VMSS and head node.
  - An Azure SQL Database (or SQL Server flavored RDBMS) that will be running Hive Metastore.
    The Hive Metastore schema for version 2.3.0 should already be installed in the instance.
- Prior to running the pipeline, several variables need definition in your Azure Pipeline:
  - `data_storage_account`: Name of the Azure Blob Storage account where the source data for the experiment is stored.
  - `data_storage_account_shared_key` (secret): Shared key for the Azure Blob Storage account where the source data for the experiment is stored.
  - `hms_jdbc_driver`: JDBC driver for the Hive Metastore.
  - `hms_jdbc_url`: JDBC URL for the Hive Metastore.
  - `hms_jdbc_user`: Username for the Hive Metastore.
  - `hms_jdbc_password` (secret): Password for the Hive Metastore.
  - `hms_storage_account`: Name of the Azure Blob Storage account where the Hive Metastore will store data associated with the catalog (can be the same as the data_storage_account).
  - `hms_storage_account_shared_key` (secret): Shared key for the Azure Blob Storage account where the Hive Metastore will store data associated with the catalog.
  - `hms_storage_account_container`: Name of the container in the Azure Blob Storage account where the Hive Metastore will store data associated with the catalog.
- The versions and configurations of LSTs to run can be modified via input parameters for the pipelines in the Azure Pipelines YAML file or from the Web UI.
  Default values are assigned to these parameters. 
  Parameters also include experiment scale factor, machine type, and cluster size. 
  Note that these parameters are not used to deploy the data or the infrastructure, as this process is not automated in the pipeline. 
  Instead, they are recorded in the experiment telemetry for proper categorization and visualization of results later on.
