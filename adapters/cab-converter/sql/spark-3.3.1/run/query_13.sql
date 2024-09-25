select
        c_count,
        count(*) as custdist
    from (
        select
            c_custkey,
            count(o_orderkey)
        from
            ${catalog}.${database}${stream_num}.customer left outer join ${catalog}.${database}${stream_num}.orders
                on c_custkey = o_custkey
                and o_comment not like '%${param1}%${param2}%'
        group by
            c_custkey
        ) as c_orders (c_custkey, c_count)
    group by
        c_count
    order by
        custdist desc,
        c_count desc;
