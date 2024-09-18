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

from azure.azure_utils import *
from constant import *

import pandas as pd

from azure.identity import DefaultAzureCredential
from azure.monitor.query import LogsQueryClient

# Superclass for any type of storage telemetry extraction. `fetch_metrics`
# should be overwritten by child class. Any child class needs to add columns
# `io_gb` (the I/O volume in GB) and `api_calls` (the number of API calls)
# to the input dataframe.
class StorageMetrics:

    def __init__(self, df, storage_path):
        self.df = df
        self.storage_path = storage_path

    def fetch_metrics(self):
        print("This method should be overwritten, it is not implemented for this type of storage specification.")

    def get_df(self):
        return self.df
    
    # --- Utility functions --- #
    
    def get_label(self, metric):
        if metric == "api_calls":
            return "API Calls (in M)"
        elif metric == "io_gb":
            return "I/O Volume (in GB)"
        else:
            pass


# Implementation of the extraction of Azure storage telemetry. Connects to a
# log analytics workspace and queries that workspace for storage information,
# including I/O and API access information.
class AzureStorageMetrics(StorageMetrics):

    def __init__(self, df, storage_path):
        StorageMetrics.__init__(self, df, storage_path)


    # Overwrites the parent method. Fetches Azure storage metrics.
    def fetch_metrics(self):
        default_credential = DefaultAzureCredential(exclude_shared_token_cache_credential=True)
        logs_client = LogsQueryClient(default_credential)

        azure_data = pd.DataFrame()
        for _, row in self.df.iterrows():
            event_id = row["event_id"]
            exp_name = row["exp_name"]
            start_time = get_time(row['event_start_time'])
            end_time = get_time(row['event_end_time'])
            project_cols = f"""
                event_id = '{event_id}',
                exp_name = '{exp_name}',
                RequestBodySize,
                ResponseBodySize"""

            query = f"""
            StorageBlobLogs
            | where Uri contains '{self.storage_path}'
            | project {project_cols}
            | summarize
                api_call_count = count(),
                io_bytes = sum(RequestBodySize) + sum(ResponseBodySize)
                by event_id, exp_name
            """

            azure_data = pd.concat([azure_data, retrieve_az_metrics(query, start_time, end_time, logs_client, AZ_LAW_WORKSPACE)])

        # Consolidate the dataframes.
        self.df = azure_data.merge(self.df, on = ['event_id', 'exp_name'])
        # Do conversions for better readability.
        self.calculate_api_calls_in_m()
        self.convert_io_bytes_to_gb()


    # --- Utility functions --- #
    
    def convert_io_bytes_to_gb(self):
        self.df["io_gb"] = self.df["io_bytes"]/1000000000


    def calculate_api_calls_in_m(self):
        self.df["api_calls"] = self.df["api_call_count"]/1000000
