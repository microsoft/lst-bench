CREATE
    TABLE
        ${catalog}.${database}.partsupp(
            ps_partkey BIGINT,
            ps_suppkey BIGINT,
            ps_availqty INT,
            ps_supplycost DECIMAL,
            ps_comment VARCHAR(199)
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/partsupp/'
        ) TBLPROPERTIES(
            'primaryKey' = 'ps_partkey,ps_suppkey' ${tblproperties_suffix}
        );
