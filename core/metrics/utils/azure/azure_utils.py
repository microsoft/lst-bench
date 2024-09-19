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

import pandas as pd

from datetime import datetime
from dateutil.tz import tzutc

from azure.core.exceptions import HttpResponseError
from azure.monitor.query import LogsQueryStatus

# --- Azure utilities --- #

def retrieve_az_metrics(query, start_time, end_time, logs_client, workspace_id, allow_partial=False):
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

# --- Data manipulation utilities specific to Azure data --- #

def get_time(time_str):
    utc_format = '%Y-%m-%dT%H:%M:%S.%f'
    time = datetime.strptime(time_str[:-4], utc_format)
    time = time.replace(tzinfo=tzutc())
    return time
