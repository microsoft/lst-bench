# Copyright (c) Microsoft Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from constant import *

import pandas as pd

try:
    from azure.azure_utils import *
    from azure.identity import DefaultAzureCredential
    from azure.monitor.query import LogsQueryClient
    _AZURE_IMPORT_ERROR = None
except ImportError as exc:
    DefaultAzureCredential = None
    LogsQueryClient = None
    _AZURE_IMPORT_ERROR = exc


def _require_azure():
    if _AZURE_IMPORT_ERROR is not None:
        raise RuntimeError(
            "Azure Monitor libraries are not installed. "
            "Install core/metrics/notebooks/requirements.txt to use CLUSTER_TYPE = 'AZURE'."
        ) from _AZURE_IMPORT_ERROR

# Superclass for any type of cluster telemetry extraction. `fetch_metrics`
# should be overwritten by child class. Any child class needs to add columns
# `cpu` (the CPU utilization), `gb_read` (the gb read in GB), and
# `gb_written` (the gb written in GB) to the input dataframe.
class ClusterMetrics:

    def __init__(self, df, cluster_name):
        self.df = df
        self.cluster_name = cluster_name

    def fetch_metrics(self):
        print("This method should be overwritten, it is not implemented for this type of cluster specification.")

    def get_df(self):
        return self.df
    
    # --- Utility functions --- #
    
    def get_label(self, metric):
        if metric == "cpu":
            return "CPU Utilization"
        elif metric == "gb_read":
            return "Bytes Read (in GB)"
        elif metric == "gb_written":
            return "Bytes Written (in GB)"
        else:
            pass


# Implementation of the extraction of Azure cluster telemetry. Connects to a
# log analytics workspace and queries that workspace for cluster utilization as
# well as network bytes read/written.
class AzureClusterMetrics(ClusterMetrics):

    def __init__(self, df, storage_path):
        ClusterMetrics.__init__(self, df, storage_path)

    
    # Overwrites label generation since these bytes read/written are specific to
    # the network.
    def get_label(self, metric):
        if metric == "cpu":
            return "CPU Utilization"
        elif metric == "bytes_read":
            return "Network Bytes Read (in GB)"
        elif metric == "bytes_written":
            return "Network Bytes Written (in GB)"
        else:
            pass


    # Overwrites the parent method. Fetches Azure storage metrics.
    def fetch_metrics(self):
        _require_azure()
        default_credential = DefaultAzureCredential(exclude_shared_token_cache_credential=True)
        logs_client = LogsQueryClient(default_credential)

        azure_data = pd.DataFrame()
        for _, row in self.df.iterrows():
            event_id = row["event_id"]
            start_time = get_time(row['event_start_time'])
            end_time = get_time(row['event_end_time'])
            project_cols = f"""
                event_id = '{event_id}',
                TimeGenerated,"""
            col_cpu = "CPUUtil"
            col_read = "ReadBytesPerSecond"
            col_write = "WriteBytesPerSecond"
            
            query_base = f"""
            InsightsMetrics
            | where _ResourceId contains '{self.cluster_name}'
            | where Origin == 'vm.azm.ms'
            """

            query = f"""
            {query_base}
            | where Namespace == 'Processor'
            | where Name == 'UtilizationPercentage'
            | summarize avg(Val) by bin(TimeGenerated, 30s)
            | project {project_cols} {col_cpu}=avg_Val
            | join 
                ({query_base}
                | where Namespace == 'Network'
                | where Name == '{col_read}'
                | summarize sum(Val) by bin(TimeGenerated, 30s)
                | project {project_cols} {col_read}=sum_Val) 
                on TimeGenerated, event_id
            | join 
                ({query_base}
                | where Namespace == 'Network'
                | where Name == '{col_write}'
                | summarize sum(Val) by bin(TimeGenerated, 30s)
                | project {project_cols} {col_write}=sum_Val) 
                on TimeGenerated, event_id
            | project {project_cols} cpu={col_cpu}, bytes_read_per_sec={col_read}, bytes_written_per_sec={col_write}
            | order by TimeGenerated asc
            """

            azure_data = pd.concat([azure_data, retrieve_az_metrics(query, start_time, end_time, logs_client, AZ_LAW_WORKSPACE)])

        # Consolidate the dataframes.
        self.df = azure_data.merge(self.df, on = ['event_id'])
        # Do conversions for better readability.
        self.convert_bytes_read_to_gb()
        self.convert_bytes_written_to_gb()


    # --- Utility functions --- #
    
    def convert_bytes_read_to_gb(self):
        self.df["gb_read"] = self.df["bytes_read_per_sec"]/1000000000

    def convert_bytes_written_to_gb(self):
        self.df["gb_written"] = self.df["bytes_written_per_sec"]/1000000000


class PrometheusClusterMetrics(ClusterMetrics):
    """Plot adapter. Query text lives in constant.py. HTTP lives in prometheus_utils.py."""

    def fetch_metrics(self):
        from prometheus_utils import collect_prometheus_frame
        if self.cluster_name not in ("spark", "trino", "polaris"):
            raise ValueError(
                "CLUSTER_NAME for PROMETHEUS must be spark, trino, or polaris. "
                "That chooses which component the cluster plot shows. "
                "collect_prometheus_metrics() returns Spark, Trino, Ceph, and Polaris together."
            )
        self.standard_df = collect_prometheus_frame(self.df)
        part = self.standard_df[self.standard_df["component"] == self.cluster_name]
        wide = None
        for metric in ("cpu", "gb_read", "gb_written"):
            metric_rows = part[part["metric"] == metric][["event_id", "time", "value"]].rename(
                columns={"time": "TimeGenerated", "value": metric}
            )
            if metric_rows.empty:
                continue
            wide = metric_rows if wide is None else wide.merge(
                metric_rows, on=["event_id", "TimeGenerated"], how="outer"
            )
        if wide is None:
            self.df = self.df.copy()
            self.df["TimeGenerated"] = pd.NaT
            self.df["cpu"] = float("nan")
            self.df["gb_read"] = float("nan")
            self.df["gb_written"] = float("nan")
            return
        for metric in ("cpu", "gb_read", "gb_written"):
            if metric not in wide.columns:
                wide[metric] = float("nan")
        self.df = wide.merge(self.df, on="event_id", how="left")

    def get_standard_df(self):
        return self.standard_df
