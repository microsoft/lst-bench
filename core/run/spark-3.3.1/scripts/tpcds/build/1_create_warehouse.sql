CREATE
    TABLE
        ${catalog}.${database}.warehouse(
            w_warehouse_sk INT,
            w_warehouse_id VARCHAR(16),
            w_warehouse_name VARCHAR(20),
            w_warehouse_sq_ft INT,
            w_street_number VARCHAR(10),
            w_street_name VARCHAR(60),
            w_street_type VARCHAR(15),
            w_suite_number VARCHAR(10),
            w_city VARCHAR(60),
            w_county VARCHAR(30),
            w_state VARCHAR(2),
            w_zip VARCHAR(10),
            w_country VARCHAR(20),
            w_gmt_offset DECIMAL(
                5,
                2
            )
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/warehouse/'
        ) TBLPROPERTIES(
            'primaryKey' = 'w_warehouse_sk' ${tblproperties_suffix}
        );
