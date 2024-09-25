SELECT
    supp_nation,
    cust_nation,
    l_year,
    sum(volume) as revenue
FROM (
    SELECT
        n1.n_name as supp_nation,
        n2.n_name as cust_nation,
        extract(year from l_shipdate) as l_year,
        l_extendedprice * (1 - l_discount) as volume
    FROM
        ${catalog}.${database}${stream_num}.supplier,
        ${catalog}.${database}${stream_num}.lineitem,
        ${catalog}.${database}${stream_num}.orders,
        ${catalog}.${database}${stream_num}.customer,
        ${catalog}.${database}${stream_num}.nation n1,
        ${catalog}.${database}${stream_num}.nation n2
    WHERE
        s_suppkey = l_suppkey
        and o_orderkey = l_orderkey
        and c_custkey = o_custkey
        and s_nationkey = n1.n_nationkey
        and c_nationkey = n2.n_nationkey
        and (
        (n1.n_name = '${param1}' and n2.n_name = '${param2}')
        or (n1.n_name = '${param2}' and n2.n_name = '${param1}')
        )
        and l_shipdate between date '1995-01-01' and date '1996-12-31'
    ) as shipping
GROUP BY
    supp_nation,
    cust_nation,
    l_year
ORDER BY
    supp_nation,
    cust_nation,
    l_year;
