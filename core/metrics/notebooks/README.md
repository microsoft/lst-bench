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

We currently support three types of visualizations: Execution time (``execTimePlots.ipynb``), storage information (``storagePlots.ipynb``) such as the I/O volume and API calls, and cluster metrics (``clusterPlots.ipnyb``). For all three, we require the following parameters:
1. The experiment identifier(s) (`EXPERIMENT_ID`).
2. The experiment start time(s). The length of 1. and 2. need to be the same, i.e., every experiment identifier is associated with one start time (`EXPERIMENT_START_TIME`).
3. The path to the DuckDB database (`DUCKDB_PATH`), set in ``utils/constants.py``. 
4. The event identifiers that should be plotted (`EVENT_IDS`). 

The first two parameters should be consistent with identifiers/start times that can be found in the database and have event type `EXEC_EXPERIMENT`. You can determine the available experiment identifiers and start times by using the ``listExperiments.ipynb`` notebook. The event identifiers can point to any event type though we generally recommend visualizing the same event type at a time (for example to compare experiment phases or certain statements).

All parameters are set in the first code block of the respective notebooks. Here is an example for the comparison of three single user phases (phase identifiers taken from WP1 but may vary based on the yaml configuration):
```
EXPERIMENT_ID = ["test_experiment1", "test_experiment2"]
EXPERIMENT_START_TIME = ["2023-04-30T12:12:12.000000000Z", "2023-04-30T14:14:14.000000000Z"]
EVENT_IDS = ["single_user_1", "single_user_2", "single_user_3"]
```

`CLUSTER_TYPE` and `STORAGE_TYPE` accept `AZURE` or `PROMETHEUS`.

For Azure, link the storage account and cluster to an [Azure Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/private-storage#link-storage-accounts-to-your-log-analytics-workspace) and set `AZ_LAW_WORKSPACE` in ``utils/constant.py``. `CLUSTER_NAME` is matched against the Azure resource id, and `STORAGE_PATH` is matched against the blob URI.

For Prometheus, set `PROMETHEUS_URL`, `PROMETHEUS_SELECTORS`, and the PromQL in `PROMETHEUS_METRICS` in ``utils/constant.py``. `PROMETHEUS_REQUEST_MODE` controls the calls: `batch` sends one range query for every metric, `per_metric` sends one range query per metric, and `per_event` sends one request per metric per benchmark event. ``utils/prometheus_utils.py`` sends those queries. `PrometheusClusterMetrics` in ``utils/clusterMetrics.py`` reads Spark, Trino, Ceph, and Polaris on each `fetch_metrics` call. `CLUSTER_NAME` must be `spark`, `trino`, or `polaris` and selects which of those the cluster plot shows. `PrometheusStorageMetrics` in ``utils/storageMetrics.py`` fills Ceph `io_gb` and `api_calls` for the storage plot. Both classes are selected from ``utils/functions.py`` when the type is `PROMETHEUS`.

To take all four components in one table:

```python
standard = collect_prometheus_metrics(EXP_DATA)
```

The columns are `event_id`, `exp_name`, `component`, `metric`, `time`, `value`, and `unit`.


# Adding drivers for storage telemetry extraction

To add a new storage telemetry driver, extend class `StorageMetrics` (``utils/StorageMetrics.py``) and add an elif-clause in method `get_storage_metrics` in ``utils/functions.py``. By default, the notebook plotting the data ((``storagePlots.ipynb``) assumes that there is an `io_gb` as well as a `api_calls` column in the metrics data frame, so the driver needs to be able to extract these metrics or implement appropriate error handling.

# Adding drivers for cluster telemetry extraction

To add a new cluster telemetry driver, extend class `ClusterMetrics` (``utils/ClusterMetrics.py``) and add an elif-clause in method `get_cluster_metrics` in ``utils/functions.py``. By default, the notebook plotting the data ((``clusterPlots.ipynb``) assumes that there are `cpu`, `gb_read`, and `gb_written` columns in the metrics data frame, so the driver needs to be able to extract these metrics or implement appropriate error handling.
