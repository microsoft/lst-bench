SELECT
    c_custkey,
    c_name,
    sum(l_extendedprice * (1 - l_discount)) as revenue,
    c_acctbal,
    n_name,
    c_address,
    c_phone,
    c_comment
FROM
    ${catalog}.${database}${stream_num}.customer,
    ${catalog}.${database}${stream_num}.orders,
    ${catalog}.${database}${stream_num}.lineitem,
    ${catalog}.${database}${stream_num}.nation
WHERE
    c_custkey = o_custkey
    and l_orderkey = o_orderkey
    and o_orderdate >= date '${param1}'
    and o_orderdate < date '${param1}' + interval '3' month
    and l_returnflag = 'R'
    and c_nationkey = n_nationkey
GROUP BY
    c_custkey,
    c_name,
    c_acctbal,
    c_phone,
    n_name,
    c_address,
    c_comment
ORDER BY
    revenue DESC
LIMIT 20;
