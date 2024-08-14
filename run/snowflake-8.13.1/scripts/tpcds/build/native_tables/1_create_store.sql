CREATE
    TABLE
        ${catalog}.${database}.store(
            s_store_sk INT,
            s_store_id VARCHAR(16),
            s_rec_start_date DATE,
            s_rec_end_date DATE,
            s_closed_date_sk INT,
            s_store_name VARCHAR(50),
            s_number_employees INT,
            s_floor_space INT,
            s_hours VARCHAR(20),
            s_manager VARCHAR(40),
            s_market_id INT,
            s_geography_class VARCHAR(100),
            s_market_desc VARCHAR(100),
            s_market_manager VARCHAR(40),
            s_division_id INT,
            s_division_name VARCHAR(50),
            s_company_id INT,
            s_company_name VARCHAR(50),
            s_street_number VARCHAR(10),
            s_street_name VARCHAR(60),
            s_street_type VARCHAR(15),
            s_suite_number VARCHAR(10),
            s_city VARCHAR(60),
            s_county VARCHAR(30),
            s_state VARCHAR(2),
            s_zip VARCHAR(10),
            s_country VARCHAR(20),
            s_gmt_offset DECIMAL(
                5,
                2
            ),
            s_tax_precentage DECIMAL(
                5,
                2
            )
        );