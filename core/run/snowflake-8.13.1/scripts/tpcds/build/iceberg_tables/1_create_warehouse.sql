CREATE
    ICEBERG TABLE
        ${catalog}.${database}.warehouse(
            w_warehouse_sk INT,
            w_warehouse_id string,
            w_warehouse_name string,
            w_warehouse_sq_ft INT,
            w_street_number string,
            w_street_name string,
            w_street_type string,
            w_suite_number string,
            w_city string,
            w_county string,
            w_state string,
            w_zip string,
            w_country string,
            w_gmt_offset DECIMAL(
                5,
                2
            )
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';