CREATE
    ICEBERG TABLE
        ${catalog}.${database}.date_dim(
            d_date_sk INT,
            d_date_id string,
            d_date DATE,
            d_month_seq INT,
            d_week_seq INT,
            d_quarter_seq INT,
            d_year INT,
            d_dow INT,
            d_moy INT,
            d_dom INT,
            d_qoy INT,
            d_fy_year INT,
            d_fy_quarter_seq INT,
            d_fy_week_seq INT,
            d_day_name string,
            d_quarter_name string,
            d_holiday string,
            d_weekend string,
            d_following_holiday string,
            d_first_dom INT,
            d_last_dom INT,
            d_same_day_ly INT,
            d_same_day_lq INT,
            d_current_day string,
            d_current_week string,
            d_current_month string,
            d_current_quarter string,
            d_current_year string
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';