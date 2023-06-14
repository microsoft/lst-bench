CREATE TABLE ${catalog}.${database}.reason(
    r_reason_sk               int                           ,
    r_reason_id               varchar(16)                      ,
    r_reason_desc             varchar(100)           
) WITH (location='${data_path}${experiment_start_time}/${repetition}/reason/' ${tblproperties_suffix});
