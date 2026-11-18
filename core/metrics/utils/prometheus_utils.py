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

import json
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timezone

import pandas as pd

from constant import (
    PROMETHEUS_METRICS,
    PROMETHEUS_SELECTORS,
    PROMETHEUS_STEP_SECONDS,
    PROMETHEUS_TOKEN,
    PROMETHEUS_URL,
)

STANDARD_COLUMNS = ["event_id", "exp_name", "component", "metric", "time", "value", "unit"]


def to_utc(value):
    if isinstance(value, datetime):
        if value.tzinfo is None:
            return value.replace(tzinfo=timezone.utc)
        return value.astimezone(timezone.utc)
    text = str(value).strip()
    if text.endswith("Z"):
        text = text[:-1]
    if "+" in text[10:]:
        text = text.split("+", 1)[0]
    if "." in text:
        head, frac = text.split(".", 1)
        digits = "".join(ch for ch in frac if ch.isdigit())[:6]
        text = head + "." + digits if digits else head
        fmt = "%Y-%m-%dT%H:%M:%S.%f" if "T" in text else "%Y-%m-%d %H:%M:%S.%f"
    else:
        fmt = "%Y-%m-%dT%H:%M:%S" if "T" in text else "%Y-%m-%d %H:%M:%S"
    return datetime.strptime(text, fmt).replace(tzinfo=timezone.utc)


def duration_literal(start, end):
    seconds = int((end - start).total_seconds())
    if seconds < PROMETHEUS_STEP_SECONDS:
        seconds = PROMETHEUS_STEP_SECONDS
    return str(seconds) + "s"


def render_query(template, selector, duration):
    if selector is None or str(selector).strip() == "":
        raise ValueError(
            "Prometheus selector is empty. Set PROMETHEUS_SELECTORS in constant.py."
        )
    return template.replace("{selector}", selector).replace("{duration}", duration)


def _request(path, params):
    url = PROMETHEUS_URL.rstrip("/") + path
    data = urllib.parse.urlencode(params).encode("utf-8")
    request = urllib.request.Request(url, data=data, method="POST")
    request.add_header("Content-Type", "application/x-www-form-urlencoded")
    if PROMETHEUS_TOKEN:
        request.add_header("Authorization", "Bearer " + PROMETHEUS_TOKEN)
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            body = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as err:
        detail = err.read().decode("utf-8", errors="replace")
        raise RuntimeError(
            "Prometheus returned HTTP " + str(err.code) + " for [" + params.get("query", "") + "]: " + detail
        ) from err
    except urllib.error.URLError as err:
        raise RuntimeError("Cannot reach Prometheus at " + url + ": " + str(err.reason)) from err
    if body.get("status") != "success":
        raise RuntimeError("Prometheus query failed: " + body.get("error", str(body)))
    return body["data"]


def query_range_series(query, start, end):
    """One range request. Each series keeps its labels and timestamp map."""
    data = _request("/api/v1/query_range", {
        "query": query,
        "start": start.timestamp(),
        "end": end.timestamp(),
        "step": PROMETHEUS_STEP_SECONDS,
    })
    series = []
    for item in data.get("result", []):
        points = {}
        for sample in item.get("values", []):
            timestamp = float(sample[0])
            points[timestamp] = points.get(timestamp, 0.0) + float(sample[1])
        series.append((item.get("metric", {}), points))
    return series


def query_range(query, start, end):
    points = {}
    for _, series_points in query_range_series(query, start, end):
        for timestamp, value in series_points.items():
            points[timestamp] = points.get(timestamp, 0.0) + value
    return points


def query_instant(query, at):
    data = _request("/api/v1/query", {"query": query, "time": at.timestamp()})
    result = data.get("result", [])
    if not result:
        return float("nan")
    return sum(float(series["value"][1]) for series in result)


def _selected_metrics(components):
    if components is None:
        components = list(PROMETHEUS_METRICS.keys())
    unknown = [name for name in components if name not in PROMETHEUS_METRICS]
    if unknown:
        raise ValueError(
            "Unknown Prometheus component " + ", ".join(unknown)
            + ". Known components: " + ", ".join(PROMETHEUS_METRICS.keys())
        )
    selected = []
    for component in components:
        selector = PROMETHEUS_SELECTORS.get(component, "")
        for metric, spec in PROMETHEUS_METRICS[component].items():
            selected.append((component, metric, spec, selector))
    return selected


def _events(df):
    events = []
    for _, event in df.iterrows():
        events.append({
            "event_id": event["event_id"],
            "exp_name": event["exp_name"] if "exp_name" in event.index else "",
            "start": to_utc(event["event_start_time"]),
            "end": to_utc(event["event_end_time"]),
        })
    return events


def _span(events):
    start = min(event["start"] for event in events)
    end = max(event["end"] for event in events)
    if end <= start:
        end = datetime.fromtimestamp(start.timestamp() + PROMETHEUS_STEP_SECONDS, tz=timezone.utc)
    return start, end


def _in_event(event, timestamp):
    return event["start"].timestamp() <= timestamp <= event["end"].timestamp()


def _rows_for_points(events, component, metric, spec, points):
    rows = []
    if spec["kind"] == "range":
        for event in events:
            for timestamp, value in sorted(points.items()):
                if not _in_event(event, timestamp):
                    continue
                rows.append({
                    "event_id": event["event_id"],
                    "exp_name": event["exp_name"],
                    "component": component,
                    "metric": metric,
                    "time": datetime.fromtimestamp(timestamp, tz=timezone.utc),
                    "value": value,
                    "unit": spec["unit"],
                })
        return rows
    if spec["kind"] != "increase":
        raise ValueError(
            "Unsupported Prometheus query kind '" + spec["kind"] + "' for "
            + component + "." + metric
        )
    for event in events:
        values = [value for timestamp, value in points.items() if _in_event(event, timestamp)]
        rows.append({
            "event_id": event["event_id"],
            "exp_name": event["exp_name"],
            "component": component,
            "metric": metric,
            "time": event["end"],
            "value": sum(values) if values else float("nan"),
            "unit": spec["unit"],
        })
    return rows


def _tag_query(query, component, metric):
    # Two constant labels so one range response can carry every metric.
    labeled = (
        'label_replace((' + query + '), "lst_component", "' + component
        + '", "lst_component", ".*")'
    )
    return (
        'label_replace(' + labeled + ', "lst_metric", "' + metric
        + '", "lst_component", ".*")'
    )


def _collect_per_event(events, selected):
    rows = []
    for event in events:
        duration = duration_literal(event["start"], event["end"])
        for component, metric, spec, selector in selected:
            query = render_query(spec["query"], selector, duration)
            if spec["kind"] == "range":
                points = query_range(query, event["start"], event["end"])
            elif spec["kind"] == "increase":
                points = {event["end"].timestamp(): query_instant(query, event["end"])}
            else:
                raise ValueError(
                    "Unsupported Prometheus query kind '" + spec["kind"] + "' for "
                    + component + "." + metric
                )
            rows.extend(_rows_for_points([event], component, metric, spec, points))
    return rows


def _collect_over_span(events, selected, group_queries):
    start, end = _span(events)
    step = str(PROMETHEUS_STEP_SECONDS) + "s"
    rendered = []
    for component, metric, spec, selector in selected:
        query = render_query(spec["query"], selector, step)
        rendered.append((component, metric, spec, query))
    grouped = {}
    if group_queries:
        union = " or ".join(
            _tag_query(query, component, metric) for component, metric, spec, query in rendered
        )
        for labels, points in query_range_series(union, start, end):
            key = (labels.get("lst_component", ""), labels.get("lst_metric", ""))
            bucket = grouped.setdefault(key, {})
            for timestamp, value in points.items():
                bucket[timestamp] = bucket.get(timestamp, 0.0) + value
    else:
        for component, metric, spec, query in rendered:
            points = {}
            for _, series_points in query_range_series(query, start, end):
                for timestamp, value in series_points.items():
                    points[timestamp] = points.get(timestamp, 0.0) + value
            grouped[(component, metric)] = points
    rows = []
    for component, metric, spec, query in rendered:
        rows.extend(_rows_for_points(
            events, component, metric, spec, grouped.get((component, metric), {})
        ))
    return rows


def collect_prometheus_frame(df, components=None):
    """Read Spark, Trino, Ceph, and Polaris into one table using PROMETHEUS_METRICS.

    PROMETHEUS_REQUEST_MODE in constant.py chooses the number of HTTP calls.
    """
    import constant
    selected = _selected_metrics(components)
    events = _events(df)
    if not events or not selected:
        return pd.DataFrame(columns=STANDARD_COLUMNS)
    mode = constant.PROMETHEUS_REQUEST_MODE
    if mode == "per_event":
        rows = _collect_per_event(events, selected)
    elif mode == "per_metric":
        rows = _collect_over_span(events, selected, group_queries=False)
    elif mode == "batch":
        rows = _collect_over_span(events, selected, group_queries=True)
    else:
        raise ValueError(
            "PROMETHEUS_REQUEST_MODE must be batch, per_metric, or per_event."
        )
    return pd.DataFrame(rows, columns=STANDARD_COLUMNS)
