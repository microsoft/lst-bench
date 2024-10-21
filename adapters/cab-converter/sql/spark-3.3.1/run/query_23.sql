INSERT
    INTO
        ${catalog}.${database}${stream_num}.orders (
        SELECT
           o_orderkey + 8,
           o_custkey,
           o_orderstatus,
           (select sum(L_QUANTITY * P_RETAILPRICE * (1+L_TAX) * (1-L_DISCOUNT)) from ${catalog}.${database}${stream_num}.lineitem, ${catalog}.${database}${stream_num}.part where l_orderkey = o_orderkey and P_PARTKEY = L_PARTKEY),
           o_orderdate,
           o_orderpriority,
           o_clerk,
           o_shippriority,
           o_comment
        FROM
            ${catalog}.${database}${stream_num}.orders
        WHERE
            ${param1} <= o_orderkey and o_orderkey < ${param2});

DELETE
FROM
    ${catalog}.${database}${stream_num}.orders
WHERE
    ${param1} <= o_orderkey and o_orderkey < ${param2} and mod(o_orderkey, 32) between ${param3} and ${param4};

INSERT
    INTO
        ${catalog}.${database}${stream_num}.lineitem (
        SELECT
            l_orderkey + 8,
            l_partkey,
            l_suppkey,
            l_linenumber,
            l_quantity,
            l_extendedprice,
            l_discount,
            l_tax,
            l_returnflag,
            l_linestatus,
            l_shipdate,
            l_commitdate,
            l_receiptdate,
            l_shipinstruct,
            l_shipmode,
            l_comment
        FROM
            ${catalog}.${database}${stream_num}.lineitem
        WHERE
            ${param1} <= l_orderkey and l_orderkey < ${param2});

DELETE
FROM
    ${catalog}.${database}${stream_num}.lineitem
WHERE
    ${param1} <= l_orderkey and l_orderkey < ${param2} and mod(l_orderkey, 32) between ${param3} and ${param4};
