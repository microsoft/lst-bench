CREATE
    TABLE
        ${catalog}.${database}.date_dim(
            d_date_sk INT,
            d_date_id VARCHAR(16),
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
            d_day_name VARCHAR(9),
            d_quarter_name VARCHAR(6),
            d_holiday VARCHAR(1),
            d_weekend VARCHAR(1),
            d_following_holiday VARCHAR(1),
            d_first_dom INT,
            d_last_dom INT,
            d_same_day_ly INT,
            d_same_day_lq INT,
            d_current_day VARCHAR(1),
            d_current_week VARCHAR(1),
            d_current_month VARCHAR(1),
            d_current_quarter VARCHAR(1),
            d_current_year VARCHAR(1)
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/date_dim/'
        ) TBLPROPERTIES(
            'primaryKey' = 'd_date_sk' ${table_props_suffix}
        );
