CREATE
    TABLE
        ${catalog}.${database}.web_site(
            web_site_sk INT,
            web_site_id VARCHAR(16),
            web_rec_start_date DATE,
            web_rec_end_date DATE,
            web_name VARCHAR(50),
            web_open_date_sk INT,
            web_close_date_sk INT,
            web_class VARCHAR(50),
            web_manager VARCHAR(40),
            web_mkt_id INT,
            web_mkt_class VARCHAR(50),
            web_mkt_desc VARCHAR(100),
            web_market_manager VARCHAR(40),
            web_company_id INT,
            web_company_name VARCHAR(50),
            web_street_number VARCHAR(10),
            web_street_name VARCHAR(60),
            web_street_type VARCHAR(15),
            web_suite_number VARCHAR(10),
            web_city VARCHAR(60),
            web_county VARCHAR(30),
            web_state VARCHAR(2),
            web_zip VARCHAR(10),
            web_country VARCHAR(20),
            web_gmt_offset DECIMAL(
                5,
                2
            ),
            web_tax_percentage DECIMAL(
                5,
                2
            )
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/web_site/'
        ) TBLPROPERTIES(
            'primaryKey' = 'web_site_sk' ${table_props_suffix}
        );
