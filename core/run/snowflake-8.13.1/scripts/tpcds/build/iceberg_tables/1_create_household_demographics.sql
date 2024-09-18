CREATE
    ICEBERG TABLE
        ${catalog}.${database}.household_demographics(
            hd_demo_sk INT,
            hd_income_band_sk INT,
            hd_buy_potential string,
            hd_dep_count INT,
            hd_vehicle_count INT
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';