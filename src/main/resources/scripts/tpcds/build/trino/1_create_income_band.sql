CREATE TABLE ${catalog}.${database}.income_band(
    ib_income_band_sk         int                           ,
    ib_lower_bound            int                           ,
    ib_upper_bound            int        
) WITH (location='${data_path}${experiment_start_time}/${repetition}/income_band/' ${tblproperties_suffix});
