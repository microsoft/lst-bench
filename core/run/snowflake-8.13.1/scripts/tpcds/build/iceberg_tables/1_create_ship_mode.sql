CREATE
    ICEBERG TABLE
        ${catalog}.${database}.ship_mode(
            sm_ship_mode_sk INT,
            sm_ship_mode_id string,
            sm_type string,
            sm_code string,
            sm_carrier string,
            sm_contract string
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';