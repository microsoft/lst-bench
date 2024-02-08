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

import datetime as dt

import pandas as pd

# -------- DATE MANIPULATIONS -------- #

utc_format = '%Y-%m-%dT%H:%M:%S.%f%z'


def time_diff_in_minutes(time_str1, time_str2):
    d1 = dt.datetime.strptime(time_str1, utc_format)
    d2 = dt.datetime.strptime(time_str2, utc_format)
    return abs((d2 - d1).seconds / 60)


# -------- PERFORMANCE DEGRADATION -------- #
def performance_degradation(values: pd.DataFrame) -> float:
    # Calculate the difference between each value and its previous value
    diffs = values.diff()
    # Remove the first row as it will be NaN
    diffs = diffs.dropna()
    # Divide each difference by the current value
    diffs = diffs.div(values.shift(1))
    # Calculate the average rate of change
    degradation_rate = diffs.mean()
    return degradation_rate
