CREATE
    SCHEMA IF NOT EXISTS ${catalog}.${database}${stream_num};

DROP
    TABLE
        IF EXISTS ${catalog}.${database}${stream_num}.customer;
CREATE
    TABLE
        ${catalog}.${database}${stream_num}.customer(
            c_custkey BIGINT,
            c_name STRING,
            c_address STRING,
            c_nationkey BIGINT,
            c_phone STRING,
            c_acctbal DECIMAL(12,2),
            c_mktsegment STRING,
            c_comment STRING
        )
        TBLPROPERTIES(
            'primaryKey' = 'c_custkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}${stream_num}.customer
SELECT *
FROM   ${external_catalog}.${external_database}${stream_num}.customer;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}${stream_num}.lineitem;
CREATE
    TABLE
        ${catalog}.${database}${stream_num}.lineitem(
            l_orderkey BIGINT,
            l_partkey BIGINT,
            l_suppkey BIGINT,
            l_linenumber BIGINT,
            l_quantity DECIMAL(12,2),
            l_extendedprice DECIMAL(12,2),
            l_discount DECIMAL(12,2),
            l_tax DECIMAL(12,2),
            l_returnflag STRING,
            l_linestatus STRING,
            l_shipdate DATE,
            l_commitdate DATE,
            l_receiptdate DATE,
            l_shipinstruct STRING,
            l_shipmode STRING,
            l_comment STRING
        )
        PARTITIONED BY(months(l_shipdate)) TBLPROPERTIES(
            'primaryKey' = 'l_orderkey,l_linenumber' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}${stream_num}.lineitem
SELECT *
FROM   ${external_catalog}.${external_database}${stream_num}.lineitem
SORT BY l_shipdate;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}${stream_num}.nation;
CREATE
    TABLE
        ${catalog}.${database}${stream_num}.nation(
            n_nationkey BIGINT,
            n_name STRING,
            n_regionkey BIGINT,
            n_comment STRING
        )
        TBLPROPERTIES(
            'primaryKey' = 'n_nationkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}${stream_num}.nation
SELECT *
FROM   ${external_catalog}.${external_database}${stream_num}.nation;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}${stream_num}.orders;
CREATE
    TABLE
        ${catalog}.${database}${stream_num}.orders(
            o_orderkey BIGINT,
            o_custkey BIGINT,
            o_orderstatus STRING,
            o_totalprice DECIMAL(12,2),
            o_orderdate DATE,
            o_orderpriority STRING,
            o_clerk STRING,
            o_shippriority BIGINT,
            o_comment STRING
        )
        TBLPROPERTIES(
            'primaryKey' = 'o_orderkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}${stream_num}.orders
SELECT *
FROM   ${external_catalog}.${external_database}${stream_num}.orders;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}${stream_num}.part;
CREATE
    TABLE
        ${catalog}.${database}${stream_num}.part(
            p_partkey BIGINT,
            p_name STRING,
            p_mfgr STRING,
            p_brand STRING,
            p_type STRING,
            p_size BIGINT,
            p_container STRING,
            p_retailprice DECIMAL(12,2),
            p_comment STRING
        )
        TBLPROPERTIES(
            'primaryKey' = 'p_partkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}${stream_num}.part
SELECT *
FROM   ${external_catalog}.${external_database}${stream_num}.part;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}${stream_num}.partsupp;
CREATE
    TABLE
        ${catalog}.${database}${stream_num}.partsupp(
            ps_partkey BIGINT,
            ps_suppkey BIGINT,
            ps_availqty BIGINT,
            ps_supplycost DECIMAL(12,2),
            ps_comment STRING
        )
        TBLPROPERTIES(
            'primaryKey' = 'ps_partkey,ps_suppkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}${stream_num}.partsupp
SELECT *
FROM   ${external_catalog}.${external_database}${stream_num}.partsupp;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}${stream_num}.region;
CREATE
    TABLE
        ${catalog}.${database}${stream_num}.region(
            r_regionkey BIGINT,
            r_name STRING,
            r_comment STRING
        )
        TBLPROPERTIES(
            'primaryKey' = 'r_regionkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}${stream_num}.region
SELECT *
FROM   ${external_catalog}.${external_database}${stream_num}.region;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}${stream_num}.supplier;
CREATE
    TABLE
        ${catalog}.${database}${stream_num}.supplier(
            s_suppkey BIGINT,
            s_name STRING,
            s_address STRING,
            s_nationkey BIGINT,
            s_phone STRING,
            s_acctbal DECIMAL(12,2),
            s_comment STRING
        )
        TBLPROPERTIES(
            'primaryKey' = 's_suppkey' ${tblproperties_suffix}
        );
INSERT INTO ${catalog}.${database}${stream_num}.supplier
SELECT *
FROM   ${external_catalog}.${external_database}${stream_num}.supplier;
