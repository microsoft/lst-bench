CREATE
    ICEBERG TABLE
        ${catalog}.${database}.call_center(
            cc_call_center_sk INT,
            cc_call_center_id string,
            cc_rec_start_date DATE,
            cc_rec_end_date DATE,
            cc_closed_date_sk INT,
            cc_open_date_sk INT,
            cc_name string,
            cc_class string,
            cc_employees INT,
            cc_sq_ft INT,
            cc_hours string,
            cc_manager string,
            cc_mkt_id INT,
            cc_mkt_class string,
            cc_mkt_desc string,
            cc_market_manager string,
            cc_division INT,
            cc_division_name string,
            cc_company INT,
            cc_company_name string,
            cc_street_number string,
            cc_street_name string,
            cc_street_type string,
            cc_suite_number string,
            cc_city string,
            cc_county string,
            cc_state string,
            cc_zip string,
            cc_country string,
            cc_gmt_offset DECIMAL(
                5,
                2
            ),
            cc_tax_percentage DECIMAL(
                5,
                2
            )
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';