select
    o_year,
    sum(case
        when nation = 'BRAZIL'
        then volume
        else 0
    end) / sum(volume) as mkt_share
FROM (
    SELECT
        extract(year from o_orderdate) as o_year,
        l_extendedprice * (1-l_discount) as volume,
        n2.n_name as nation
    FROM
        ${catalog}.${database}.part,
        ${catalog}.${database}.supplier,
        ${catalog}.${database}.lineitem,
        ${catalog}.${database}.orders,
        ${catalog}.${database}.customer,
        ${catalog}.${database}.nation n1,
        ${catalog}.${database}.nation n2,
        ${catalog}.${database}.region
    WHERE
        p_partkey = l_partkey
        and s_suppkey = l_suppkey
        and l_orderkey = o_orderkey
        and o_custkey = c_custkey
        and c_nationkey = n1.n_nationkey
        and n1.n_regionkey = r_regionkey
        and r_name = 'AMERICA'
        and s_nationkey = n2.n_nationkey
        and o_orderdate between date '1995-01-01' and date '1996-12-31'
        and p_type = 'ECONOMY ANODIZED STEEL'
    ) as all_nations
GROUP BY
    o_year
ORDER BY
    o_year;
