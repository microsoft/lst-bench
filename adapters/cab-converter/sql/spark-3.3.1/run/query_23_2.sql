DELETE
FROM
    ${catalog}.${database}${stream_num}.orders
WHERE
    ${param1} <= o_orderkey and o_orderkey < ${param2} and mod(o_orderkey, 32) between ${param3} and ${param4};
