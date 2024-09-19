CREATE TABLE ${catalog}.${database}.ship_mode(
    sm_ship_mode_sk           int                           ,
    sm_ship_mode_id           varchar(16)                      ,
    sm_type                   varchar(30)                      ,
    sm_code                   varchar(10)                      ,
    sm_carrier                varchar(20)                      ,
    sm_contract               varchar(20)                       
) WITH (location='${data_path}${experiment_start_time}/${repetition}/ship_mode/' ${tblproperties_suffix});
