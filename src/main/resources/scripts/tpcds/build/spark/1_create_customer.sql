CREATE
    TABLE
        ${catalog}.${database}.customer(
            c_customer_sk INT,
            c_customer_id VARCHAR(16),
            c_current_cdemo_sk INT,
            c_current_hdemo_sk INT,
            c_current_addr_sk INT,
            c_first_shipto_date_sk INT,
            c_first_sales_date_sk INT,
            c_salutation VARCHAR(10),
            c_first_name VARCHAR(20),
            c_last_name VARCHAR(30),
            c_preferred_cust_flag VARCHAR(1),
            c_birth_day INT,
            c_birth_month INT,
            c_birth_year INT,
            c_birth_country VARCHAR(20),
            c_login VARCHAR(13),
            c_email_address VARCHAR(50),
            c_last_review_date_sk VARCHAR(10)
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/customer/'
        ) TBLPROPERTIES(
            'primaryKey' = 'c_customer_sk' ${tblproperties_suffix}
        );
