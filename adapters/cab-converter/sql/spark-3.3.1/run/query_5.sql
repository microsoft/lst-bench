select
    n_name,
    sum(l_extendedprice * (1 - l_discount)) as revenue
from
    ${catalog}.${database}${stream_num}.customer,
    ${catalog}.${database}${stream_num}.orders,
    ${catalog}.${database}${stream_num}.lineitem,
    ${catalog}.${database}${stream_num}.supplier,
    ${catalog}.${database}${stream_num}.nation,
    ${catalog}.${database}${stream_num}.region
where
    c_custkey = o_custkey
    and l_orderkey = o_orderkey
    and l_suppkey = s_suppkey
    and c_nationkey = s_nationkey
    and s_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = '${param1}'
    and o_orderdate >= date '${param2}'
    and o_orderdate < date '${param2}' + interval '1' year
group by
    n_name
order by
    revenue desc;
