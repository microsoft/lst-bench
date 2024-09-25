SELECT
    l_orderkey, sum(l_extendedprice*(1-l_discount)) as revenue, o_orderdate, o_shippriority
FROM
    ${catalog}.${database}${stream_num}.customer,
    ${catalog}.${database}${stream_num}.orders,
    ${catalog}.${database}${stream_num}.lineitem
WHERE
    c_mktsegment = '${param1}'
    and c_custkey = o_custkey
    and l_orderkey = o_orderkey
    and o_orderdate < date '${param2}'
    and l_shipdate > date '${param2}'
GROUP BY
    l_orderkey,
    o_orderdate,
    o_shippriority
ORDER BY
    revenue DESC,
    o_orderdate
LIMIT 10;
