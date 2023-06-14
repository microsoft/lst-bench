CREATE TABLE ${catalog}.${database}.inventory(
    inv_item_sk               int                           ,
    inv_warehouse_sk          int                           ,
    inv_quantity_on_hand      int                           ,
    inv_date_sk               int                           
) WITH (location='${data_path}${experiment_start_time}/${repetition}/inventory/', ${partition_spec_keyword}=ARRAY['inv_date_sk'] ${tblproperties_suffix});
