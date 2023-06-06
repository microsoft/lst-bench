CREATE
    TABLE
        ${catalog}.${database}.customer_address(
            ca_address_sk INT,
            ca_address_id VARCHAR(16),
            ca_street_number VARCHAR(10),
            ca_street_name VARCHAR(60),
            ca_street_type VARCHAR(15),
            ca_suite_number VARCHAR(10),
            ca_city VARCHAR(60),
            ca_county VARCHAR(30),
            ca_state VARCHAR(2),
            ca_zip VARCHAR(10),
            ca_country VARCHAR(20),
            ca_gmt_offset DECIMAL(
                5,
                2
            ),
            ca_location_type VARCHAR(20)
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/customer_address/'
        ) TBLPROPERTIES(
            'primaryKey' = 'ca_address_sk' ${tblproperties_suffix}
        );
