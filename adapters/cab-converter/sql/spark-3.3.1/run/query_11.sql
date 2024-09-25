SELECT
    ps_partkey,
    sum(ps_supplycost * ps_availqty) as value
from
    ${catalog}.${database}${stream_num}.partsupp, ${catalog}.${database}${stream_num}.supplier, ${catalog}.${database}${stream_num}.nation
where
    ps_suppkey = s_suppkey
    and s_nationkey = n_nationkey
    and n_name = '${param1}'
group by
    ps_partkey
having
    sum(ps_supplycost * ps_availqty) > (
        select
            sum(ps_supplycost * ps_availqty) *  0.0001 / ${param2}
        from
            ${catalog}.${database}${stream_num}.partsupp,
            ${catalog}.${database}${stream_num}.supplier,
            ${catalog}.${database}${stream_num}.nation
        where
            ps_suppkey = s_suppkey
            and s_nationkey = n_nationkey
            and n_name = '${param1}'
    )
order by
value desc;
