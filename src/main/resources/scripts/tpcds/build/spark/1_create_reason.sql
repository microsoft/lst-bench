CREATE
    TABLE
        ${catalog}.${database}.reason(
            r_reason_sk INT,
            r_reason_id VARCHAR(16),
            r_reason_desc VARCHAR(100)
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/reason/'
        ) TBLPROPERTIES(
            'primaryKey' = 'r_reason_sk' ${tblproperties_suffix}
        );
