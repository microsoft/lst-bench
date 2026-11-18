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

import os

# Telemetry database path. Set by default to "./telemetry" analogous to the
# sample telemetry configuration.
DUCKDB_PATH = "./telemetry"

# Azure Log Analytics Workspace identifier.
AZ_LAW_WORKSPACE = ""

# Prometheus server that scrapes Spark, Trino, Ceph, and Polaris.
# PROMETHEUS_URL and PROMETHEUS_TOKEN can be set in the environment.
PROMETHEUS_URL = os.environ.get("PROMETHEUS_URL", "http://localhost:9090")
PROMETHEUS_TOKEN = os.environ.get("PROMETHEUS_TOKEN", "")
PROMETHEUS_STEP_SECONDS = 30

# How many Prometheus calls collect_prometheus_frame makes.
# batch: one query_range for every selected metric over the whole experiment.
# per_metric: one query_range per metric over the whole experiment.
# per_event: one request per metric per benchmark event.
PROMETHEUS_REQUEST_MODE = "batch"

# Label matchers from your scrape config. These select one component each.
PROMETHEUS_SELECTORS = {
    "spark": 'namespace="spark"',
    "trino": 'namespace="trino"',
    "ceph": 'job="ceph"',
    "polaris": 'job="polaris"',
}

# PromQL for each component. {selector} is replaced with the matcher above.
# {duration} is the event length in per_event mode. In batch and per_metric mode
# it is the step, and increase samples inside each event are summed.
# kind "range" is a value at each step. kind "increase" is one total per event.
PROMETHEUS_METRICS = {
    "spark": {
        "cpu": {
            "kind": "range",
            "unit": "percent",
            "query": (
                "100 * sum(rate(container_cpu_usage_seconds_total"
                "{{selector},container!=\"\",container!=\"POD\"}[1m]))"
                " / sum(kube_pod_container_resource_limits"
                "{{selector},resource=\"cpu\"})"
            ),
        },
        "gb_read": {
            "kind": "range",
            "unit": "GB/s",
            "query": (
                "sum(rate(container_network_receive_bytes_total"
                "{{selector},container!=\"\",container!=\"POD\"}[1m])) / 1000000000"
            ),
        },
        "gb_written": {
            "kind": "range",
            "unit": "GB/s",
            "query": (
                "sum(rate(container_network_transmit_bytes_total"
                "{{selector},container!=\"\",container!=\"POD\"}[1m])) / 1000000000"
            ),
        },
    },
    "trino": {
        "cpu": {
            "kind": "range",
            "unit": "percent",
            "query": (
                "100 * sum(rate(container_cpu_usage_seconds_total"
                "{{selector},container!=\"\",container!=\"POD\"}[1m]))"
                " / sum(kube_pod_container_resource_limits"
                "{{selector},resource=\"cpu\"})"
            ),
        },
        "gb_read": {
            "kind": "range",
            "unit": "GB/s",
            "query": (
                "sum(rate(container_network_receive_bytes_total"
                "{{selector},container!=\"\",container!=\"POD\"}[1m])) / 1000000000"
            ),
        },
        "gb_written": {
            "kind": "range",
            "unit": "GB/s",
            "query": (
                "sum(rate(container_network_transmit_bytes_total"
                "{{selector},container!=\"\",container!=\"POD\"}[1m])) / 1000000000"
            ),
        },
    },
    "ceph": {
        "io_gb": {
            "kind": "increase",
            "unit": "GB",
            "query": (
                "(sum(increase(ceph_pool_rd_bytes{{selector}}[{duration}]))"
                " + sum(increase(ceph_pool_wr_bytes{{selector}}[{duration}])))"
                " / 1000000000"
            ),
        },
        "api_calls": {
            "kind": "increase",
            "unit": "millions",
            "query": (
                "(sum(increase(ceph_osd_op_r{{selector}}[{duration}]))"
                " + sum(increase(ceph_osd_op_w{{selector}}[{duration}])))"
                " / 1000000"
            ),
        },
    },
    "polaris": {
        "cpu": {
            "kind": "range",
            "unit": "percent",
            "query": "avg(process_cpu_usage{{selector}}) * 100",
        },
        "api_calls": {
            "kind": "increase",
            "unit": "millions",
            "query": (
                "sum(increase(http_server_requests_seconds_count"
                "{{selector}}[{duration}])) / 1000000"
            ),
        },
    },
}