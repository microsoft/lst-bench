CREATE
    TABLE
        ${catalog}.${database}.promotion(
            p_promo_sk INT,
            p_promo_id VARCHAR(16),
            p_start_date_sk INT,
            p_end_date_sk INT,
            p_item_sk INT,
            p_cost DECIMAL(
                15,
                2
            ),
            p_response_target INT,
            p_promo_name VARCHAR(50),
            p_channel_dmail VARCHAR(1),
            p_channel_email VARCHAR(1),
            p_channel_catalog VARCHAR(1),
            p_channel_tv VARCHAR(1),
            p_channel_radio VARCHAR(1),
            p_channel_press VARCHAR(1),
            p_channel_event VARCHAR(1),
            p_channel_demo VARCHAR(1),
            p_channel_details VARCHAR(100),
            p_purpose VARCHAR(15),
            p_discount_active VARCHAR(1)
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/promotion/'
        ) TBLPROPERTIES(
            'primaryKey' = 'p_promo_sk' ${table_props_suffix}
        );
