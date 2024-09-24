INSERT
    INTO
        ${catalog}.${database}.orders (
        SELECT
           o_orderkey + 8,
           o_custkey,
           o_orderstatus,
           (select sum(L_QUANTITY * P_RETAILPRICE * (1+L_TAX) * (1-L_DISCOUNT)) from ${catalog}.${database}.lineitem, ${catalog}.${database}.part where l_orderkey = o_orderkey and P_PARTKEY = L_PARTKEY),
           o_orderpriority,
           o_clerk,
           o_shippriority,
           o_comment,
           o_orderdate
        FROM
            ${catalog}.${database}.orders
        WHERE
            ${param1} <= o_orderkey and o_orderkey < ${param2});

DELETE
FROM
    ${catalog}.${database}.orders
WHERE
    ${param1} <= o_orderkey and o_orderkey < ${param2} and mod(o_orderkey, 32) between ${param3} and ${param4};
