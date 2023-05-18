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

from datetime import datetime
from clusterMetrics import *
from constant import *
from storageMetrics import *


# -------- TELEMETRY RETRIEVAL FROM DUCKDB -------- #

# Fetches all experiment data from a duckdb connection. Adds a column 'exp_name'
# with the experiment identifier as value.
def retrieve_experiment_df(con, id, start_time):
    end_time = con.execute(
        "SELECT event_end_time FROM experiment_telemetry WHERE event_id=? and event_start_time=?;",
        [id, start_time]).df()['event_end_time'].item()
    df = con.execute(
        "SELECT * FROM experiment_telemetry WHERE event_start_time >= ? AND event_end_time <= ? order by event_start_time asc;",
        [start_time, end_time]).df()
    df["exp_name"] = id
    return df


# -------- TELEMETRY RETRIEVAL FROM DF -------- #

def filterByEventType(df, type):
    return df[df['event_type'] == type]

def filterByEventIds(df, ids):
    return df[df['event_id'].isin(ids)]


# -------- TELEMETRY EXTRACTION -------- #

def get_storage_metrics(type, df, storage_path):
    if type=="AZURE":
        return AzureStorageMetrics(df, storage_path)
    else:
        return StorageMetrics(df, storage_path)
    
def get_cluster_metrics(type, df, cluster_name):
    if type=="AZURE":
        return AzureClusterMetrics(df, cluster_name)
    else:
        return ClusterMetrics(df, cluster_name)


# -------- DATE MANIPULATIONS -------- #

utc_format='%Y-%m-%dT%H:%M:%S.%f'
def time_diff_in_minutes(time_str1, time_str2):
    d1 = datetime.strptime(time_str1[:-4], utc_format)
    d2 = datetime.strptime(time_str2[:-4], utc_format)
    return abs((d2 - d1).seconds/60)


# -------- STRING/INTEGER MANIPULATIONS -------- #

def adjust_phase_names(str):
    return str.replace("single_user_", "SU-")
