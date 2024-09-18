CREATE
    TABLE
        ${catalog}.${database}.household_demographics(
            hd_demo_sk INT,
            hd_income_band_sk INT,
            hd_buy_potential VARCHAR(15),
            hd_dep_count INT,
            hd_vehicle_count INT
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/household_demographics/'
        ) TBLPROPERTIES(
            'primaryKey' = 'hd_demo_sk' ${tblproperties_suffix}
        );
