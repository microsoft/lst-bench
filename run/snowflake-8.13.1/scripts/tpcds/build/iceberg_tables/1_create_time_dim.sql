CREATE
    ICEBERG TABLE
        ${catalog}.${database}.time_dim(
            t_time_sk INT,
            t_time_id string,
            t_time INT,
            t_hour INT,
            t_minute INT,
            t_second INT,
            t_am_pm string,
            t_shift string,
            t_sub_shift string,
            t_meal_time string
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';