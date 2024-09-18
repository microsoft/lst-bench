CREATE
    TABLE
        ${catalog}.${database}.call_center(
            cc_call_center_sk INT,
            cc_call_center_id VARCHAR(16),
            cc_rec_start_date DATE,
            cc_rec_end_date DATE,
            cc_closed_date_sk INT,
            cc_open_date_sk INT,
            cc_name VARCHAR(50),
            cc_class VARCHAR(50),
            cc_employees INT,
            cc_sq_ft INT,
            cc_hours VARCHAR(20),
            cc_manager VARCHAR(40),
            cc_mkt_id INT,
            cc_mkt_class VARCHAR(50),
            cc_mkt_desc VARCHAR(100),
            cc_market_manager VARCHAR(40),
            cc_division INT,
            cc_division_name VARCHAR(50),
            cc_company INT,
            cc_company_name VARCHAR(50),
            cc_street_number VARCHAR(10),
            cc_street_name VARCHAR(60),
            cc_street_type VARCHAR(15),
            cc_suite_number VARCHAR(10),
            cc_city VARCHAR(60),
            cc_county VARCHAR(30),
            cc_state VARCHAR(2),
            cc_zip VARCHAR(10),
            cc_country VARCHAR(20),
            cc_gmt_offset DECIMAL(
                5,
                2
            ),
            cc_tax_percentage DECIMAL(
                5,
                2
            )
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/call_center/'
        ) TBLPROPERTIES(
            'primaryKey' = 'cc_call_center_sk' ${tblproperties_suffix}
        );
