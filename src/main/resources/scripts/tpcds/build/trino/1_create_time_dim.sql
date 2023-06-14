CREATE TABLE ${catalog}.${database}.time_dim(
    t_time_sk                 int                           ,
    t_time_id                 varchar(16)                      ,
    t_time                    int                           ,
    t_hour                    int                           ,
    t_minute                  int                           ,
    t_second                  int                           ,
    t_am_pm                   varchar(2)                       ,
    t_shift                   varchar(20)                      ,
    t_sub_shift               varchar(20)                      ,
    t_meal_time               varchar(20)                       
) WITH (location='${data_path}${experiment_start_time}/${repetition}/time_dim/' ${tblproperties_suffix});
