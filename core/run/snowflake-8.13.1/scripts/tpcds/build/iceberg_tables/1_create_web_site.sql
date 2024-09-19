CREATE
    ICEBERG TABLE
        ${catalog}.${database}.web_site(
            web_site_sk INT,
            web_site_id string,
            web_rec_start_date DATE,
            web_rec_end_date DATE,
            web_name string,
            web_open_date_sk INT,
            web_close_date_sk INT,
            web_class string,
            web_manager string,
            web_mkt_id INT,
            web_mkt_class string,
            web_mkt_desc string,
            web_market_manager string,
            web_company_id INT,
            web_company_name string,
            web_street_number string,
            web_street_name string,
            web_street_type string,
            web_suite_number string,
            web_city string,
            web_county string,
            web_state string,
            web_zip string,
            web_country string,
            web_gmt_offset DECIMAL(
                5,
                2
            ),
            web_tax_percentage DECIMAL(
                5,
                2
            )
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';