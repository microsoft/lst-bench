CREATE
    ICEBERG TABLE
        ${catalog}.${database}.customer(
            c_customer_sk INT,
            c_customer_id string,
            c_current_cdemo_sk INT,
            c_current_hdemo_sk INT,
            c_current_addr_sk INT,
            c_first_shipto_date_sk INT,
            c_first_sales_date_sk INT,
            c_salutation string,
            c_first_name string,
            c_last_name string,
            c_preferred_cust_flag string,
            c_birth_day INT,
            c_birth_month INT,
            c_birth_year INT,
            c_birth_country string,
            c_login string,
            c_email_address string,
            c_last_review_date_sk string
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';