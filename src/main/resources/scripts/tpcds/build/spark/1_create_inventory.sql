CREATE
    TABLE
        ${catalog}.${database}.inventory(
            inv_item_sk INT,
            inv_warehouse_sk INT,
            inv_quantity_on_hand INT,
            inv_date_sk INT
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/inventory/'
        ) PARTITIONED BY(inv_date_sk) TBLPROPERTIES(
            'primaryKey' = 'inv_date_sk,inv_item_sk,inv_warehouse_sk' ${table_props_suffix}
        );
