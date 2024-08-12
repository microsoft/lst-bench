CREATE
    ICEBERG TABLE
        ${catalog}.${database}.customer_address(
            ca_address_sk INT,
            ca_address_id string,
            ca_street_number string,
            ca_street_name string,
            ca_street_type string,
            ca_suite_number string,
            ca_city string,
            ca_county string,
            ca_state string,
            ca_zip string,
            ca_country string,
            ca_gmt_offset DECIMAL(
                5,
                2
            ),
            ca_location_type string
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';