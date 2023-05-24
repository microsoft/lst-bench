CREATE
    TABLE
        IF NOT EXISTS experiment_telemetry(
            run_id STRING,
            event_start_time STRING,
            event_end_time STRING,
            event_id STRING,
            event_type STRING,
            event_status STRING,
            event_data STRING
        );
