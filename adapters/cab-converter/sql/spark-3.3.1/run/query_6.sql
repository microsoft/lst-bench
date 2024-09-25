select
    sum(l_extendedprice * l_discount) as revenue
from ${catalog}.${database}${stream_num}.lineitem
where
    l_shipdate >= date '${param1}'
    and l_shipdate < date '${param1}' + interval '1' year
    and l_discount between (cast(${param2} as decimal(12,2)) / 100) - 0.01 and (cast(${param2} as decimal(12,2)) / 100) + 0.01
    and l_quantity < ${param3};
