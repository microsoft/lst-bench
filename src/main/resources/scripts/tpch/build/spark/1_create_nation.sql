CREATE
    TABLE
        ${catalog}.${database}.nation(
            n_nationkey BIGINT,
            n_name CHAR(25),
            n_regionkey BIGINT,
            n_comment VARCHAR(152)
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/nation/'
        ) TBLPROPERTIES(
            'primaryKey' = 'n_nationkey' ${tblproperties_suffix}
        );
