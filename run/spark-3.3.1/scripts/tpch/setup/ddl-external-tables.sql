CREATE
    SCHEMA IF NOT EXISTS ${external_catalog}.${external_database};

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.customer;

CREATE
    TABLE
        ${external_catalog}.${external_database}.customer(
            c_custkey BIGINT,
            c_name VARCHAR(25),
            c_address VARCHAR(40),
            c_nationkey BIGINT,
            c_phone CHAR(15),
            c_acctbal DECIMAL,
            c_comment VARCHAR(117),
            c_mktsegment CHAR(10)
        )
        USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}customer/" ${external_options_suffix}
        )
        PARTITIONED BY(c_mktsegment);

ALTER TABLE 
    ${external_catalog}.${external_database}.customer RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.lineitem;

CREATE
    TABLE
        ${external_catalog}.${external_database}.lineitem(
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
        USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}lineitem/" ${external_options_suffix}
        )
        PARTITIONED BY(l_shipdate);

ALTER TABLE 
    ${external_catalog}.${external_database}.lineitem RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.orders;

CREATE
    TABLE
        ${external_catalog}.${external_database}.orders(
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
        USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}orders/" ${external_options_suffix}
        )
        PARTITIONED BY(o_orderdate);

ALTER TABLE 
    ${external_catalog}.${external_database}.orders RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.nation;

CREATE
    TABLE
        ${external_catalog}.${external_database}.nation(
            n_nationkey BIGINT,
            n_name CHAR(25),
            n_regionkey BIGINT,
            n_comment VARCHAR(152)
        )
        USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}nation/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.region;

CREATE
    TABLE
        ${external_catalog}.${external_database}.region(
            r_regionkey BIGINT,
            r_name CHAR(25),
            r_comment VARCHAR(152)
        )
        USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}region/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.part;

CREATE
    TABLE
        ${external_catalog}.${external_database}.part(
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
        USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}part/" ${external_options_suffix}
        )
        PARTITIONED BY(p_brand);

ALTER TABLE 
    ${external_catalog}.${external_database}.part RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.supplier;

CREATE
    TABLE
        ${external_catalog}.${external_database}.supplier(
            s_suppkey BIGINT,
            s_name CHAR(25),
            s_address VARCHAR(40),
            s_nationkey BIGINT,
            s_phone CHAR(15),
            s_acctbal DECIMAL,
            s_comment VARCHAR(101)
        )
        USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}supplier/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.partsupp;

CREATE
    TABLE
        ${external_catalog}.${external_database}.partsupp(
            ps_partkey BIGINT,
            ps_suppkey BIGINT,
            ps_availqty INT,
            ps_supplycost DECIMAL,
            ps_comment VARCHAR(199)
        )
        USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}partsupp/" ${external_options_suffix}
        );
