select
    s_name,
    s_address
from
    ${catalog}.${database}${stream_num}.supplier,
    ${catalog}.${database}${stream_num}.nation
where
    s_suppkey in (
        select
            ps_suppkey
        from
            ${catalog}.${database}${stream_num}.partsupp
        where
            ps_partkey in (
                select
                    p_partkey
                from
                    ${catalog}.${database}${stream_num}.part
                where
                    p_name like '${param1}%'
            )
            and ps_availqty > (
                select
                    0.5 * sum(l_quantity)
                from
                    ${catalog}.${database}${stream_num}.lineitem
                where
                    l_partkey = ps_partkey
                    and l_suppkey = ps_suppkey
                    and l_shipdate >= date '${param2}'
                    and l_shipdate < date '${param2}' + interval '1' year
            )
    )
    and s_nationkey = n_nationkey
    and n_name = '${param3}'
order by
    s_name;
