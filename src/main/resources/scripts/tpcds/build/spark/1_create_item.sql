CREATE
    TABLE
        ${catalog}.${database}.item(
            i_item_sk INT,
            i_item_id VARCHAR(16),
            i_rec_start_date DATE,
            i_rec_end_date DATE,
            i_item_desc VARCHAR(200),
            i_current_price DECIMAL(
                7,
                2
            ),
            i_wholesale_cost DECIMAL(
                7,
                2
            ),
            i_brand_id INT,
            i_brand VARCHAR(50),
            i_class_id INT,
            i_class VARCHAR(50),
            i_category_id INT,
            i_category VARCHAR(50),
            i_manufact_id INT,
            i_manufact VARCHAR(50),
            i_size VARCHAR(20),
            i_formulation VARCHAR(20),
            i_color VARCHAR(20),
            i_units VARCHAR(10),
            i_container VARCHAR(10),
            i_manager_id INT,
            i_product_name VARCHAR(50)
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/item/'
        ) TBLPROPERTIES(
            'primaryKey' = 'i_item_sk' ${tblproperties_suffix}
        );
