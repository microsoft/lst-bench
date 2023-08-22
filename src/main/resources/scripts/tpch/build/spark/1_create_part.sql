CREATE
    TABLE
        ${catalog}.${database}.part(
            p_partkey BIGINT,
            p_name VARCHAR(55),
            p_mfgr CHAR(25),
            p_brand CHAR(10),
            p_type VARCHAR(25),
            p_size INT,
            p_container CHAR(10),
            p_retailprice DECIMAL,
            p_comment VARCHAR(23)
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/part/'
        ) TBLPROPERTIES(
            'primaryKey' = 'p_partkey' ${tblproperties_suffix}
        );
