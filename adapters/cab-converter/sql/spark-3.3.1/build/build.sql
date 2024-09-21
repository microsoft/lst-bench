CREATE
    SCHEMA IF NOT EXISTS ${catalog}.${database};

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.customer;
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
INSERT INTO ${catalog}.${database}.customer
SELECT *
FROM   ${external_catalog}.${external_database}.customer;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.lineitem;
CREATE
    TABLE
        ${catalog}.${database}.lineitem(
            l_orderkey BIGINT,
            l_partkey BIGINT,
            l_suppkey BIGINT,
            l_linenumber INT,
            l_quantity DECIMAL,
            l_extendedprice DECIMAL,
            l_discount DECIMAL,
            l_tax DECIMAL,
            l_returnflag CHAR(1),
            l_linestatus CHAR(1),
            l_commitdate DATE,
            l_receiptdate DATE,
            l_shipinstruct CHAR(25),
            l_shipmode CHAR(10),
            l_comment VARCHAR(44),
            l_shipdate DATE
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/lineitem/'
        ) PARTITIONED BY(l_shipdate) TBLPROPERTIES(
            'primaryKey' = 'l_orderkey,l_linenumber' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}.lineitem
SELECT *
FROM   ${external_catalog}.${external_database}.lineitem;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.nation;
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
INSERT INTO ${catalog}.${database}.nation
SELECT *
FROM   ${external_catalog}.${external_database}.nation;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.orders;
CREATE
    TABLE
        ${catalog}.${database}.orders(
            o_orderkey BIGINT,
            o_custkey BIGINT,
            o_orderstatus CHAR(1),
            o_totalprice DECIMAL,
            o_orderpriority CHAR(15),
            o_clerk CHAR(15),
            o_shippriority INT,
            o_comment VARCHAR(79),
            o_orderdate DATE
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/orders/'
        ) PARTITIONED BY(o_orderdate) TBLPROPERTIES(
            'primaryKey' = 'o_orderkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}.orders
SELECT *
FROM   ${external_catalog}.${external_database}.orders;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.part;
CREATE
    TABLE
        ${catalog}.${database}.part(
            p_partkey BIGINT,
            p_name VARCHAR(55),
            p_mfgr CHAR(25),
            p_type VARCHAR(25),
            p_size INT,
            p_container CHAR(10),
            p_retailprice DECIMAL,
            p_comment VARCHAR(23),
            p_brand CHAR(10)
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/part/'
        ) TBLPROPERTIES(
            'primaryKey' = 'p_partkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}.part
SELECT *
FROM   ${external_catalog}.${external_database}.part;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.partsupp;
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
INSERT INTO ${catalog}.${database}.partsupp
SELECT *
FROM   ${external_catalog}.${external_database}.partsupp;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.region;
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
INSERT INTO ${catalog}.${database}.region
SELECT *
FROM   ${external_catalog}.${external_database}.region;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.supplier;
CREATE
    TABLE
        ${catalog}.${database}.supplier(
            s_suppkey BIGINT,
            s_name CHAR(25),
            s_address VARCHAR(40),
            s_nationkey BIGINT,
            s_phone CHAR(15),
            s_acctbal DECIMAL,
            s_comment VARCHAR(101)
        )
        USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/supplier/'
        ) TBLPROPERTIES(
            'primaryKey' = 's_suppkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}.supplier
SELECT *
FROM   ${external_catalog}.${external_database}.supplier;
