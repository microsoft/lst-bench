CREATE
    TABLE
        ${catalog}.${database}.region(
            r_regionkey BIGINT,
            r_name CHAR(25),
            r_comment VARCHAR(152)
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/region/'
        ) TBLPROPERTIES(
            'primaryKey' = 'r_regionkey' ${tblproperties_suffix}
        );
