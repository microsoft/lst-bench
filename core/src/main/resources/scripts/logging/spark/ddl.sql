CREATE
    DATABASE IF NOT EXISTS ${catalog}.${database};

CREATE
    TABLE
        IF NOT EXISTS ${catalog}.${database}.experiment_telemetry(
            event_start_time STRING,
            event_end_time STRING,
            event_id STRING,
            event_type STRING,
            event_status STRING,
            event_data STRING
        )
            USING csv OPTIONS(
            PATH '${path}experiment/'
        );
