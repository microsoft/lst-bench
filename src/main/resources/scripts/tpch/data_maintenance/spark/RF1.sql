INSERT
    INTO
        ${catalog}.${database}.orders SELECT
            orde_orderkey,
            orde_custkey,
            orde_orderstatus,
            orde_totalprice,
            orde_orderdate,
            orde_orderpriority,
            orde_clerk,
            orde_shippriority,
            orde_comment
        FROM
            ${external_catalog}.${external_database}.s_orders_${stream_num};

INSERT
    INTO
        ${catalog}.${database}.lineitem SELECT
            liit_orderkey,
            liit_partkey,
            liit_suppkey,
            liit_linenumber,
            liit_quantity,
            liit_extendedprice,
            liit_discount,
            liit_tax,
            liit_returnflag,
            liit_linestatus,
            liit_shipdate,
            liit_commitdate,
            liit_receiptdate,
            liit_shipinstruct,
            liit_shipmode,
            liit_comment
        FROM
            ${external_catalog}.${external_database}.s_lineitem_${stream_num};
