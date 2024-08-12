CREATE
    ICEBERG TABLE
        ${catalog}.${database}.income_band(
            ib_income_band_sk INT,
            ib_lower_bound INT,
            ib_upper_bound INT
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';