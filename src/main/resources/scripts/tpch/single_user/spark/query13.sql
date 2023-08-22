select
        c_count,
        count(*) as custdist
    from (
        select
            c_custkey,
            count(o_orderkey)
        from
            ${catalog}.${database}.customer left outer join ${catalog}.${database}.orders
                on c_custkey = o_custkey
                and o_comment not like '%special%requests%'
        group by
            c_custkey
        ) as c_orders (c_custkey, c_count)
    group by
        c_count
    order by
        custdist desc,
        c_count desc;
