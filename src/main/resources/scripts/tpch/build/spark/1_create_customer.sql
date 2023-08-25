CREATE
    TABLE
        ${catalog}.${database}.customer(
            c_custkey BIGINT,
            c_name VARCHAR(25),
            c_address VARCHAR(40),
            c_nationkey BIGINT,
            c_phone CHAR(15),
            c_acctbal DECIMAL,
            c_comment VARCHAR(117),
            c_mktsegment CHAR(10)
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/customer/'
        ) TBLPROPERTIES(
            'primaryKey' = 'c_custkey' ${tblproperties_suffix}
        );
