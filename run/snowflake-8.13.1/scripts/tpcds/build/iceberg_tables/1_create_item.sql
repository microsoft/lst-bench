CREATE
    ICEBERG TABLE
        ${catalog}.${database}.item(
            i_item_sk INT,
            i_item_id string,
            i_rec_start_date DATE,
            i_rec_end_date DATE,
            i_item_desc string,
            i_current_price DECIMAL(
                7,
                2
            ),
            i_wholesale_cost DECIMAL(
                7,
                2
            ),
            i_brand_id INT,
            i_brand string,
            i_class_id INT,
            i_class string,
            i_category_id INT,
            i_category string,
            i_manufact_id INT,
            i_manufact string,
            i_size string,
            i_formulation string,
            i_color string,
            i_units string,
            i_container string,
            i_manager_id INT,
            i_product_name string
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';