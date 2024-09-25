SELECT
    nation,
    o_year,
    sum(amount) as sum_profit
FROM (
        SELECT
            n_name as nation,
            extract(year from o_orderdate) as o_year,
            l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount
        FROM
            ${catalog}.${database}${stream_num}.part,
            ${catalog}.${database}${stream_num}.supplier,
            ${catalog}.${database}${stream_num}.lineitem,
            ${catalog}.${database}${stream_num}.partsupp,
            ${catalog}.${database}${stream_num}.orders,
            ${catalog}.${database}${stream_num}.nation
        WHERE
            s_suppkey = l_suppkey
            and ps_suppkey = l_suppkey
            and ps_partkey = l_partkey
            and p_partkey = l_partkey
            and o_orderkey = l_orderkey
            and s_nationkey = n_nationkey
            and p_name like '%${param1}%'
    ) as profit
GROUP BY
    nation,
    o_year
ORDER BY
    nation,
    o_year desc;
