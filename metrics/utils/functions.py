from datetime import datetime
from dateutil.tz import tzutc
from constant import *
import pandas as pd

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


# -------- TELEMETRY RETRIEVAL FROM AZURE BLOB STORAGE -------- #

def fetch_az_metrics(query, start_time, end_time, logs_client, workspace_id, allow_partial=False):
    try:
        response = logs_client.query_workspace(workspace_id=workspace_id, query=query, timespan=(start_time, end_time))
        if response.status == LogsQueryStatus.PARTIAL:
            error = response.partial_error
            if not allow_partial:
                raise Exception(f"Partial Error: {error.message}")
            data = response.partial_data
            print(error.message)
            # TODO return continuation token
        elif response.status == LogsQueryStatus.SUCCESS:
            data = response.tables

        for table in data:
            return pd.DataFrame(data=table.rows, columns=table.columns)
    except HttpResponseError as err:
        raise(err)

def get_azure_metrics(tf_path, df):
    default_credential = DefaultAzureCredential()
    logs_client = LogsQueryClient(default_credential)

    azure_data = pd.DataFrame()
    for _, row in df.iterrows():
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
        | where Uri contains '{tf_path}'
        | project {project_cols}
        | summarize
            api_call_count = count(),
            io_bytes = sum(RequestBodySize) + sum(ResponseBodySize)
            by event_id, exp_name
        """

        azure_data = pd.concat([azure_data, fetch_az_metrics(query, start_time, end_time, logs_client, AZ_LAW_WORKSPACE)])

    # Consolidate the dataframes.
    azure_data = azure_data.merge(df, on = ['event_id', 'exp_name'])
    # Do conversions for better readability.
    azure_data = calculate_api_calls_in_m(convert_io_bytes_to_gb(azure_data))
    return azure_data


# -------- DATE MANIPULATIONS -------- #

utc_format='%Y-%m-%dT%H:%M:%S.%f'
def time_diff_in_minutes(time_str1, time_str2):
    d1 = datetime.strptime(time_str1[:-4], utc_format)
    d2 = datetime.strptime(time_str2[:-4], utc_format)
    return abs((d2 - d1).seconds/60)

def get_time(time_str):
    time = datetime.strptime(time_str[:-4], utc_format)
    time = time.replace(tzinfo=tzutc())
    return time


# -------- STRING/INTEGER MANIPULATIONS -------- #

def adjust_phase_names(str):
    return str.replace("single_user_", "SU-")

def convert_io_bytes_to_gb(df):
    df["io_gb"] = df["io_bytes"]/1000000000
    return df

def calculate_api_calls_in_m(df):
    df["api_call_count_in_m"] = df["api_call_count"]/1000000
    return df