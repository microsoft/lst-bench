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

import argparse
from typing import List
import altair as alt
import collections
import duckdb
import logging
import pandas as pd
import os
import streamlit as st
import utils


@st.cache_resource
def get_connection(*, result_dirs: List[str] = None):
    # Either search for results in provided directories
    # or use default assuming that that the CWD is the location of this script
    result_dirs = result_dirs or ["./", "../../run/"]

    connection = duckdb.connect()
    # Get databases and attach them
    databases_list = []

    # Function to recursively find DuckDB files in a directory
    def find_duckdb_files(directory: str) -> collections.abc.Iterator[str]:
        # Warning if the directory does not exist
        if not os.path.exists(directory):
            st.warning(f"Directory '{directory}' does not exist.")
            return
        
        if os.path.isfile(directory) and directory.endswith('.duckdb'):
            yield directory
            return

        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.endswith('.duckdb'):
                    yield os.path.join(root, file)

    # Combine the results from all directories
    for result_dir in result_dirs:
        for database_path in find_duckdb_files(result_dir):
            database = os.path.basename(database_path)[:-3]
            connection.execute(f"ATTACH DATABASE '{database_path}' AS \"{database}\" (READ_ONLY)")
            databases_list.append(database)

    if not databases_list:
        st.error("No DuckDB files found in the provided directories.")
        st.stop()
    # Create view encompassing all experiments
    union_sql = " UNION ".join([f"SELECT * FROM \"{database}\".experiment_telemetry" for database in databases_list])
    connection.execute(f"CREATE VIEW combined_experiment_telemetry AS {union_sql}")
    return connection

@st.cache_data
def get_systems(*, result_dirs: List[str] = None):
    connection = get_connection(result_dirs=result_dirs)
    df = connection.execute(
        f"""
        SELECT DISTINCT concat_ws('-', json(event_data)->>'system', json(event_data)->>'system_version') AS system 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY system ASC;
        """
    ).df()
    # Replace None with Pandas NA
    df.fillna("N/A")
    return df['system']


@st.cache_data
def get_table_formats(*, result_dirs: List[str] = None):
    connection = get_connection(result_dirs=result_dirs)
    df = connection.execute(
        f"""
        SELECT DISTINCT concat_ws('-', json(event_data)->>'table_format', json(event_data)->>'table_format_version') AS table_format 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY table_format ASC;
        """
    ).df()
    # Replace None with Pandas NA
    df.fillna("N/A", inplace=True)
    return df['table_format']


@st.cache_data
def get_modes(*, result_dirs: List[str] = None):
    connection = get_connection(result_dirs=result_dirs)
    df = connection.execute(
        f"""
        SELECT DISTINCT json(event_data)->>'mode' AS mode 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY mode ASC;
        """
    ).df()
    # Replace None with Pandas NA
    df.fillna("N/A", inplace=True)
    return df['mode']


@st.cache_data
def get_cluster_sizes(*, result_dirs: List[str] = None):
    connection = get_connection(result_dirs=result_dirs)
    df = connection.execute(
        f"""
        SELECT DISTINCT json(event_data)->>'cluster_size' AS cluster_size 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY cluster_size ASC;
        """
    ).df()
    # Replace None with Pandas NA
    df.fillna("N/A", inplace=True)
    return df['cluster_size']


@st.cache_data
def get_machines(*, result_dirs: List[str] = None):
    connection = get_connection(result_dirs=result_dirs)
    df = connection.execute(
        f"""
        SELECT DISTINCT json(event_data)->>'machine' AS machine 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY machine ASC;
        """
    ).df()
    # Replace None with Pandas NA
    df.fillna("N/A", inplace=True)
    return df['machine']


@st.cache_data
def get_workloads(*, result_dirs: List[str] = None):
    connection = get_connection(result_dirs=result_dirs)
    df = connection.execute(
        f"""
        SELECT DISTINCT event_id AS workload 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY workload ASC;
        """
    ).df()
    # Replace None with Pandas NA
    df['workload'] = df['workload'].replace('None', "N/A")
    return df['workload']


@st.cache_data
def get_scale_factors(*, result_dirs: List[str] = None):
    connection = get_connection(result_dirs=result_dirs)
    df = connection.execute(
        f"""
        SELECT DISTINCT json(event_data)->>'scale_factor' AS scale_factor 
        FROM combined_experiment_telemetry 
        WHERE event_type = 'EXEC_EXPERIMENT' AND event_status='SUCCESS' AND NOT(event_id LIKE 'setup%')
        ORDER BY scale_factor ASC;
        """
    ).df()
    # Replace None with Pandas NA
    df.fillna("N/A", inplace=True)
    return df['scale_factor']


def get_experiments_selected(
        _workload_selected: str,
        _systems_selected: list[str],
        _table_formats_selected: list[str],
        _modes_selected: list[str],
        _cluster_sizes_selected: list[str],
        _machines_selected: list[str],
        _scale_factors_selected: list[str],
        *, result_dirs: List[str] = None) -> pd.DataFrame:
    connection = get_connection(result_dirs=result_dirs)
   
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
        AND {utils.generate_sql_in_with_null('system', _systems_selected)}
        AND {utils.generate_sql_in_with_null('table_format', _table_formats_selected)}
        AND {utils.generate_sql_in_with_null('mode', _modes_selected)}
        AND {utils.generate_sql_in_with_null('cluster_size', _cluster_sizes_selected)}
        AND {utils.generate_sql_in_with_null('machine', _machines_selected)}
        AND {utils.generate_sql_in_with_null('scale_factor', _scale_factors_selected)}
        ORDER BY cast(event_start_time AS TIMESTAMP) ASC;
        """
    ).df()
    df.fillna("N/A", inplace=True)
    logging.debug(df)
    if len(df) == 0:
        st.error("No data found for the selected dimensions.")
        st.stop()
    return df
    #return df_unfiltered

@st.cache_data
def get_experiments_data(experiments_df: pd.DataFrame, target_granularity: str,
                         *, result_dirs: List[str] = None) -> pd.DataFrame:
    connection = get_connection(result_dirs=result_dirs)
    df = experiments_df
    if len(df) == 0:
        st.error("Empty experiments data.")
        st.stop()

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
                      AND cast(event_start_time AS TIMESTAMP) >= ? AND cast(event_end_time AS TIMESTAMP) <= ? 
                ORDER BY cast(event_start_time AS TIMESTAMP) ASC;
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
    # Replace None with Pandas NA
    df.fillna("N/A", inplace=True)
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

def run(*, result_dirs: List[str] = None):
    st.set_page_config(
        page_title="LST-Bench - Dashboard",
        page_icon=":bar_chart:",
        layout="wide")
    st.title('LST-Bench - Dashboard')
    st.write("[Project Page](https://github.com/microsoft/lst-bench/) | "
            "[Technical Report](https://arxiv.org/abs/2305.01120) | "
            "[Evaluation](https://github.com/microsoft/lst-bench/tree/main/core/metrics/app#evaluation) | "
            "[Adding a New Result](https://github.com/microsoft/lst-bench/tree/main/core/metrics/app#adding-a-new-result)")

    workloads = get_workloads(result_dirs=result_dirs)
    workload_selected = st.sidebar.selectbox('Workload', workloads, index=0)

    systems = get_systems(result_dirs=result_dirs)
    systems_selected = st.sidebar.multiselect('System', systems, default=systems)

    table_formats = get_table_formats(result_dirs=result_dirs)
    table_formats_selected = st.sidebar.multiselect('Table Format', table_formats, default=table_formats)

    modes = get_modes(result_dirs=result_dirs)
    modes_selected = st.sidebar.multiselect('Mode', modes, default=modes)

    cluster_sizes = get_cluster_sizes(result_dirs=result_dirs)
    cluster_sizes_selected = st.sidebar.multiselect('Cluster Size', cluster_sizes, default=cluster_sizes)

    machines = get_machines(result_dirs=result_dirs)
    machines_selected = st.sidebar.multiselect('Machine', machines, default=machines)

    scale_factors = get_scale_factors(result_dirs=result_dirs)
    scale_factors_selected = st.sidebar.multiselect('Scale Factor', scale_factors, default=scale_factors)

    # Bail out if any of the dimensions if empty
    if any(len(arr) == 0 for arr in [systems_selected, table_formats_selected,
                                    modes_selected, cluster_sizes_selected,
                                    machines_selected, scale_factors_selected]):
        st.error("Please ensure you have selected at least one option for each dimension.")
        st.stop()

    # Create tabs for current selection
    exec_time_tab = None  # This tab shows execution time.
    performance_degradation_tab = None  # This tab shows degradation rate.
    # TODO
    io_tab = None  # This tab will show I/O metrics, such as bytes read/written.
    io_api_calls_tab = None  # This tab will show I/O API call metrics.
    cpu_utilization_tab = None  # This tab will show CPU utilization metrics.

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
                                                        scale_factors_selected,
                                                        result_dirs=result_dirs)
        experiments_data_df = get_experiments_data(experiments_selected_df, granularity_selected, result_dirs=result_dirs)
        experiments_data_df = experiments_data_df[experiments_data_df['event_id'].str.contains(regex, regex=True)]

        if len(experiments_data_df) > 3000:
            st.error(
                "Too many rows in the result. "
                "Please refine your dimension selection or apply a regex filter to narrow down the results.")
            st.stop()

        # --- Plot the data --- #
        chart = (
            alt.Chart(experiments_data_df)
            .mark_bar()
            .encode(
                alt.X("configuration:N", axis=None, title='Configuration', stack=None),
                alt.Y("time_diff_in_mins:Q", title='Latency (mins)', axis=alt.Axis(titleFontWeight='bold')),
                alt.Color("configuration:N", legend=alt.Legend(titleFontWeight='bold', labelLimit=400),
                        title='Configuration'),
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
                                                        scale_factors_selected, result_dirs=result_dirs)
        experiments_data_df = get_experiments_data(experiments_selected_df, 'phase', result_dirs=result_dirs)
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
                alt.Y("configuration:N", title='Configuration',
                    axis=alt.Axis(titleFontWeight='bold', maxExtent=430, labelLimit=400))
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
        performance_degradation_tab.altair_chart(heatmap + text, theme=None)

if __name__ == '__main__':
    # Parse arguments
    parser = argparse.ArgumentParser(description='LST-Bench Dashboard')
    parser.add_argument('--result_dirs', type=str, nargs='+', help='Directories containing the result files')
    args = parser.parse_args()
    run(result_dirs=args.result_dirs)
