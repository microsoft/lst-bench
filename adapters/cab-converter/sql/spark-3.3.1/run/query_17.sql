select
    sum(l_extendedprice) / 7.0 as avg_yearly
from
    ${catalog}.${database}${stream_num}.lineitem,
    ${catalog}.${database}${stream_num}.part
where
    p_partkey = l_partkey
    and p_brand = '${param1}'
    and p_container = '${param2}'
    and l_quantity < (
      select
          0.2 * avg(l_quantity)
      from
          ${catalog}.${database}${stream_num}.lineitem
      where
          l_partkey = p_partkey
    );
