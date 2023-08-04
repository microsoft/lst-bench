select
    sum(l_extendedprice) / 7.0 as avg_yearly
from
    ${catalog}.${database}.lineitem,
    ${catalog}.${database}.part
where
    p_partkey = l_partkey
    and p_brand = 'Brand#23'
    and p_container = 'MED BOX'
    and l_quantity < (
      select
          0.2 * avg(l_quantity)
      from
          ${catalog}.${database}.lineitem
      where
          l_partkey = p_partkey
    );
