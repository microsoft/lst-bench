CREATE
    ICEBERG TABLE
        ${catalog}.${database}.store(
            s_store_sk INT,
            s_store_id string,
            s_rec_start_date DATE,
            s_rec_end_date DATE,
            s_closed_date_sk INT,
            s_store_name string,
            s_number_employees INT,
            s_floor_space INT,
            s_hours string,
            s_manager string,
            s_market_id INT,
            s_geography_class string,
            s_market_desc string,
            s_market_manager string,
            s_division_id INT,
            s_division_name string,
            s_company_id INT,
            s_company_name string,
            s_street_number string,
            s_street_name string,
            s_street_type string,
            s_suite_number string,
            s_city string,
            s_county string,
            s_state string,
            s_zip string,
            s_country string,
            s_gmt_offset DECIMAL(
                5,
                2
            ),
            s_tax_precentage DECIMAL(
                5,
                2
            )
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';