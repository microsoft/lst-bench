CREATE TABLE ${catalog}.${database}.warehouse(
    w_warehouse_sk            int                           ,
    w_warehouse_id            varchar(16)                      ,
    w_warehouse_name          varchar(20)                   ,
    w_warehouse_sq_ft         int                           ,
    w_street_number           varchar(10)                      ,
    w_street_name             varchar(60)                   ,
    w_street_type             varchar(15)                      ,
    w_suite_number            varchar(10)                      ,
    w_city                    varchar(60)                   ,
    w_county                  varchar(30)                   ,
    w_state                   varchar(2)                       ,
    w_zip                     varchar(10)                      ,
    w_country                 varchar(20)                   ,
    w_gmt_offset              decimal(5,2)                   
) WITH (location='${data_path}${experiment_start_time}/${repetition}/warehouse/' ${tblproperties_suffix});
