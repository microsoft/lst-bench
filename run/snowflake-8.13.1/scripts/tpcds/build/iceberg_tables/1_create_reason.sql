CREATE
    ICEBERG TABLE
        ${catalog}.${database}.reason(
            r_reason_sk INT,
            r_reason_id string,
            r_reason_desc string
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';