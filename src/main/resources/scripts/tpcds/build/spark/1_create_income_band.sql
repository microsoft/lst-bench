CREATE
    TABLE
        ${catalog}.${database}.income_band(
            ib_income_band_sk INT,
            ib_lower_bound INT,
            ib_upper_bound INT
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/income_band/'
        ) TBLPROPERTIES(
            'primaryKey' = 'ib_income_band_sk' ${table_props_suffix}
        );
