from datetime import datetime
from constant import *
from storageMetrics import *

from azure.core.exceptions import HttpResponseError
from azure.identity import DefaultAzureCredential
from azure.monitor.query import LogsQueryClient, LogsQueryStatus
from azure.storage.blob import BlobServiceClient


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


# -------- STORAGE TELEMETRY EXTRACTION -------- #

def get_storage_metrics(type, df, storage_path):
    if type=="AZURE":
        return AzureStorageMetrics(df, storage_path)
    else:
        return StorageMetrics(df, storage_path)


# -------- DATE MANIPULATIONS -------- #

utc_format='%Y-%m-%dT%H:%M:%S.%f'
def time_diff_in_minutes(time_str1, time_str2):
    d1 = datetime.strptime(time_str1[:-4], utc_format)
    d2 = datetime.strptime(time_str2[:-4], utc_format)
    return abs((d2 - d1).seconds/60)


# -------- STRING/INTEGER MANIPULATIONS -------- #

def adjust_phase_names(str):
    return str.replace("single_user_", "SU-")
