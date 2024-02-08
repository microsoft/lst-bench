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
from textwrap import wrap

import altair as alt
import collections
import duckdb
import logging
import pandas as pd
import os
import streamlit as st
import utils


@st.cache_resource
def get_connection():
    connection = duckdb.connect()
    # Get databases and attach them
    databases_list = []

    # Function to recursively find DuckDB files in a directory
    def find_duckdb_files(directory: str) -> collections.abc.Iterator[str]:
        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.endswith('.duckdb'):
                    yield os.path.join(root, file)

    # Combine the results of the current directory (used when deployed)
    # and find_duckdb_files('../../run/') (used when developing)
    for database_path in list(find_duckdb_files('./')) + list(find_duckdb_files('../../run/')):
        database = os.path.basename(database_path)[:-3]
        connection.execute(f"ATTACH DATABASE '{database_path}' AS \"{database}\" (READ_ONLY)")
        databases_list.append(database)
    # Create view encompassing all experiments
    union_sql = " UNION ".join([f"SELECT * FROM \"{database}\".experiment_telemetry" for database in databases_list])
    connection.execute(f"CREATE VIEW combined_experiment_telemetry AS {union_sql}")
    return connection


@st.cache_data
def get_systems():
    connection = get_connection()
    df = connection.execute(
        f"""
        SELECT DISTINCT concat_ws('-', json(event_data)->>'system', json(event_data)->>'system_version') AS system 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY system ASC;
        """
    ).df()
    return df['system']


@st.cache_data
def get_table_formats():
    connection = get_connection()
    df = connection.execute(
        f"""
        SELECT DISTINCT concat_ws('-', json(event_data)->>'table_format', json(event_data)->>'table_format_version') AS table_format 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY table_format ASC;
        """
    ).df()
    return df['table_format']


@st.cache_data
def get_modes():
    connection = get_connection()
    df = connection.execute(
        f"""
        SELECT DISTINCT json(event_data)->>'mode' AS mode 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY mode ASC;
        """
    ).df()
    return df['mode']


@st.cache_data
def get_cluster_sizes():
    connection = get_connection()
    df = connection.execute(
        f"""
        SELECT DISTINCT json(event_data)->>'cluster_size' AS cluster_size 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY cluster_size ASC;
        """
    ).df()
    return df['cluster_size']


@st.cache_data
def get_machines():
    connection = get_connection()
    df = connection.execute(
        f"""
        SELECT DISTINCT json(event_data)->>'machine' AS machine 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY machine ASC;
        """
    ).df()
    return df['machine']


@st.cache_data
def get_workloads():
    connection = get_connection()
    df = connection.execute(
        f"""
        SELECT DISTINCT event_id AS workload 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY workload ASC;
        """
    ).df()
    return df['workload']


@st.cache_data
def get_scale_factors():
    connection = get_connection()
    df = connection.execute(
        f"""
        SELECT DISTINCT json(event_data)->>'scale_factor' AS scale_factor 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY scale_factor ASC;
        """
    ).df()
    return df['scale_factor']


def get_experiments_selected(
        _workload_selected: str,
        _systems_selected: list[str],
        _table_formats_selected: list[str],
        _modes_selected: list[str],
        _cluster_sizes_selected: list[str],
        _machines_selected: list[str],
        _scale_factors_selected: list[str]) -> pd.DataFrame:
    connection = get_connection()
    df = connection.execute(
        f"""
        SELECT run_id, event_start_time, event_end_time, event_id, 
               concat_ws('-', json(event_data)->>'system', json(event_data)->>'system_version') AS system, 
               concat_ws('-', json(event_data)->>'table_format', json(event_data)->>'table_format_version') AS table_format, 
               cast(json(event_data)->>'mode' AS VARCHAR) AS mode, 
               cast(json(event_data)->>'cluster_size' AS VARCHAR) AS cluster_size, 
               cast(json(event_data)->>'machine' AS VARCHAR) AS machine, 
               cast(json(event_data)->>'scale_factor' AS VARCHAR) AS scale_factor 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND event_id = '{_workload_selected}'
              AND concat_ws('-', json(event_data)->>'system', json(event_data)->>'system_version') IN ({', '.join(["'" + system + "'" for system in _systems_selected])}) 
              AND concat_ws('-', json(event_data)->>'table_format', json(event_data)->>'table_format_version') IN ({', '.join(["'" + table_format + "'" for table_format in _table_formats_selected])}) 
              AND cast(json(event_data)->>'mode' AS VARCHAR) IN ({', '.join(["'" + mode + "'" for mode in _modes_selected])}) 
              AND cast(json(event_data)->>'cluster_size' AS VARCHAR) IN ({', '.join(["'" + cluster_size + "'" for cluster_size in _cluster_sizes_selected])}) 
              AND cast(json(event_data)->>'machine' AS VARCHAR) IN ({', '.join(["'" + machine + "'" for machine in _machines_selected])}) 
              AND cast(json(event_data)->>'scale_factor' AS VARCHAR) IN ({', '.join(["'" + scale_factor + "'" for scale_factor in _scale_factors_selected])}) 
        ORDER BY event_start_time ASC;
        """
    ).df()
    logging.debug(df)
    return df


@st.cache_data
def get_experiments_data(experiments_df: pd.DataFrame, target_granularity: str) -> pd.DataFrame:
    connection = get_connection()
    df = experiments_df
    granularities = {
        'phase': 'EXEC_PHASE',
        'session': 'EXEC_SESSION',
        'task': 'EXEC_TASK',
        'file': 'EXEC_FILE'
    }
    for granularity in granularities:
        new_experiments_data_df = pd.DataFrame()
        for idx, (run_id, event_start_time, event_end_time, event_id, system, table_format, mode, cluster_size, machine,
                  scale_factor) in enumerate(df.itertuples(index=False)):
            new_experiment_data_df = connection.execute(
                f"""
                SELECT run_id, event_start_time, event_end_time, 
                       concat_ws('/', CASE WHEN event_type = 'EXEC_PHASE' THEN NULL ELSE '{event_id}' END, regexp_replace(event_id, '(_delta|_iceberg|_hudi)', '')) AS event_id 
                FROM combined_experiment_telemetry 
                WHERE run_id = ? AND event_type = ? AND event_status='SUCCESS' 
                      AND event_start_time >= ? AND event_end_time <= ? 
                ORDER BY event_start_time ASC;
                """,
                [run_id, granularities.get(granularity), event_start_time, event_end_time]).df()
            new_experiment_data_df["system"] = system
            new_experiment_data_df["table_format"] = table_format
            new_experiment_data_df["mode"] = mode
            new_experiment_data_df["cluster_size"] = cluster_size
            new_experiment_data_df["machine"] = machine
            new_experiment_data_df["scale_factor"] = scale_factor
            new_experiments_data_df = pd.concat([new_experiments_data_df, new_experiment_data_df])
        df = new_experiments_data_df
        if granularity == target_granularity:
            break
    logging.debug(df)
    df['configuration'] = df.apply(
        lambda row: (row['system'] + ", "
                     + row['table_format'] + ", "
                     + row['mode'] + ", "
                     + row['cluster_size'] + "x" + row['machine']),
        axis=1)
    # Calculate latency for each element.
    df['time_diff_in_mins'] = df.apply(
        lambda row: utils.time_diff_in_minutes(row['event_start_time'], row['event_end_time']),
        axis=1)
    return df


st.set_page_config(layout="wide")

systems = get_systems()
systems_selected = st.sidebar.multiselect('System', systems, default=systems)

table_formats = get_table_formats()
table_formats_selected = st.sidebar.multiselect('Table Format', table_formats, default=table_formats)

modes = get_modes()
modes_selected = st.sidebar.multiselect('Mode', modes, default=modes)

cluster_sizes = get_cluster_sizes()
cluster_sizes_selected = st.sidebar.multiselect('Cluster Size', cluster_sizes, default=cluster_sizes)

machines = get_machines()
machines_selected = st.sidebar.multiselect('Machine', machines, default=machines)

workloads = get_workloads()
workload_selected = st.sidebar.selectbox('Workload', workloads, index=0)

scale_factors = get_scale_factors()
scale_factors_selected = st.sidebar.multiselect('Scale Factor', scale_factors, default=scale_factors)


# Create title
st.title('LST-Bench - Dashboard')
st.write("[Project Page](https://github.com/microsoft/lst-bench/) | "
         "[Technical Report](https://arxiv.org/abs/2305.01120) | "
         "Add a System")

# Create tabs for current selection
exec_time_tab = None
performance_degradation_tab = None
# TODO
io_tab = None
io_api_calls_tab = None
cpu_utilization_tab = None

if workload_selected == 'wp1_longevity':
    exec_time_tab, performance_degradation_tab = st.tabs(['Execution Time', 'Performance Degradation'])
else:
    exec_time_tab = st.tabs(['Execution Time'])[0]

if exec_time_tab is not None:
    granularity_selected = exec_time_tab.radio(
        'Granularity:',
        ['phase', 'session', 'task', 'file'],
        horizontal=True)
    regex = exec_time_tab.text_input('Filter Results:', placeholder='Regular Expression (Regex)')

    # --- Data manipulations --- #
    experiments_selected_df = get_experiments_selected(workload_selected, systems_selected, table_formats_selected,
                                                       modes_selected, cluster_sizes_selected, machines_selected,
                                                       scale_factors_selected)
    experiments_data_df = get_experiments_data(experiments_selected_df, granularity_selected)
    experiments_data_df = experiments_data_df[experiments_data_df['event_id'].str.contains(regex, regex=True)]

    # --- Plot the data --- #
    chart = (
        alt.Chart(experiments_data_df)
        .mark_bar()
        .encode(
            alt.X("configuration:N", axis=None, title='Configuration', stack=None),
            alt.Y("time_diff_in_mins:Q", title='Latency (mins)', axis=alt.Axis(titleFontWeight='bold')),
            alt.Color("configuration:N", legend=alt.Legend(titleFontWeight='bold', labelLimit=400), title='Configuration'),
            alt.Column("event_id:N", title="",
                       header=alt.Header(orient='bottom', labelFontWeight='bold', labelAlign='right',
                                         labelAngle=-45, labelPadding=20),
                       sort=alt.SortField("event_start_time", order="ascending"))
        )
        .configure_range(
            category={'scheme': 'dark2'}
        )
    )
    exec_time_tab.markdown('#')
    exec_time_tab.altair_chart(chart, theme=None)

if performance_degradation_tab is not None:
    # --- Data manipulations --- #
    experiments_selected_df = get_experiments_selected(workload_selected, systems_selected, table_formats_selected,
                                                       modes_selected, cluster_sizes_selected, machines_selected,
                                                       scale_factors_selected)
    experiments_data_df = get_experiments_data(experiments_selected_df, 'phase')
    # Filter rows with event_id following the format <name>_<numeric>
    experiments_data_df = experiments_data_df[experiments_data_df['event_id'].str.match(r'^.+_\d+$')]
    # Extract name part from event_id
    experiments_data_df['phase_type'] = experiments_data_df['event_id'].str.extract(r'^(.+)_\d+$')
    # Group by each distinct 'configuration' and 'phase_type'
    grouped_df = experiments_data_df.groupby(['configuration', 'phase_type'])
    # Compute performance degradation
    grouped_df = grouped_df['time_diff_in_mins'].agg(performance_degradation_rate=utils.performance_degradation)
    grouped_df = grouped_df.reset_index()

    # --- Plot the data --- #
    # X axis: phase type
    # Y axis: configuration
    # score: degradation rate
    base = (
        alt.Chart(grouped_df)
        .encode(
            alt.X("phase_type:N", title='', axis=alt.Axis(labelFontWeight='bold', labelAngle=-45)),
            alt.Y("configuration:N", title='Configuration', axis=alt.Axis(titleFontWeight='bold', maxExtent=430, labelLimit=400))
        )
    )
    heatmap = (
        base.mark_rect()
        .encode(
            alt.Color('performance_degradation_rate:Q',
                      scale=alt.Scale(scheme='redblue', reverse=True),
                      title='Performance Degradation Rate',
                      legend=alt.Legend(titleFontWeight='bold', titleLimit=400, direction="horizontal"))
        )
        .properties(
            height={"step": 50},
            width={"step": 50}
        )
    )
    text = (
        base.mark_text()
        .encode(
            alt.Text('performance_degradation_rate:Q', format=".2f"),
            color=alt.condition(alt.datum.performance_degradation_rate > 0.8, alt.value("black"), alt.value("white"))
        )
    )
    performance_degradation_tab.markdown('#')
    performance_degradation_tab.altair_chart(heatmap+text, theme=None)
