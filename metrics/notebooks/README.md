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

## LST-Bench: Visualization of Telemetry

LST-Bench captures execution statistics while executing the workload on multiple levels: per experiment, phase, session, task, file, and statement. Each of these events is logged with an associated identifier (for example the statement's name, the phase ids that were defined in the experiment yaml etc.), whether it succeeded or not, and any additional, associated data. These events are stored by default in DuckDB. For visualization, we rely on this dataset to determine the experiment parameters and associated metrics.

We currently support two types of visualizations: Execution time (``execTimePlots.ipynb``) and Azure storage information (``storagePlots.ipynb``) such as the I/O volume and API calls. For both, we require the following parameters:
1. The experiment identifier(s) in a list (`EXPERIMENT_ID`).
2. The experiment start time(s) in a list. The length of 1. and 2. need to be the same, i.e., every experiment identifier is associated with one start time. (`EXPERIMENT_START_TIME`).
3. The path to the DuckDB database (`DUCKDB_PATH`), set in ``utils/constants.py``. 
4. The event identifiers that should be plotted (`EVENT_IDS`). 

The first two parameters should be consistent with identifiers/start times that can be found in the database and have event type `EXEC_EXPERIMENT`. The event identifiers can point to any event type though we generally recommend to visualize the same event type at a time (for example to compare experiment phases or certain statements).
For storage visualizations, the user first needs to ensure that the Azure storage account is linked to an [Azure Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/private-storage#link-storage-accounts-to-your-log-analytics-workspace) prior to running the experiments. The workspace identifier needs to be stored in variable `AZ_LAW_WORKSPACE` as part of the constants to be used for visualization (``utils/constants.py``). Additionally, the user needs to define the path of the table formats folder for the experiment (`TF_PATH`) and the chosen metric (`METRIC`, either "io" or "api_calls") as variable in the notebook.

All parameters are set in the first code block of the respective notebooks.

Example for the comparison of three single user phases (phase identifiers taken from WP1 but may vary based on the yaml configuration):
```
EXPERIMENT_ID = ["test_experiment1", "test_experiment2"]
EXPERIMENT_START_TIME = ["2023-04-30T12:12:12.000000000Z", "2023-04-30T14:14:14.000000000Z"]
EVENT_IDS = ["single_user_1", "single_user_2", "single_user_3"]
```

You can determine the available experiment identifiers and start times by running the following query against the database:
```
SELECT distinct event_id, event_start_time FROM experiment_telemetry WHERE event_type='EXEC_EXPERIMENT'
```


