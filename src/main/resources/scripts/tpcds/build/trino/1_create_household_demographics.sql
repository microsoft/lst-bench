CREATE TABLE ${catalog}.${database}.household_demographics(
    hd_demo_sk                int                           ,
    hd_income_band_sk         int                           ,
    hd_buy_potential          varchar(15)                      ,
    hd_dep_count              int                           ,
    hd_vehicle_count          int                            
) WITH (location='${data_path}${experiment_start_time}/${repetition}/household_demographics/' ${tblproperties_suffix});
