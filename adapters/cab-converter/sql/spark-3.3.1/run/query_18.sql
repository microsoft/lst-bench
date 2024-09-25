select
    c_name,
    c_custkey,
    o_orderkey,
    o_orderdate,
    o_totalprice,
    sum(l_quantity)
from
    ${catalog}.${database}${stream_num}.customer,
    ${catalog}.${database}${stream_num}.orders,
    ${catalog}.${database}${stream_num}.lineitem
where
    o_orderkey in (
        select
            l_orderkey
        from
            ${catalog}.${database}${stream_num}.lineitem
        group by
            l_orderkey having
                sum(l_quantity) > ${param1}
    )
    and c_custkey = o_custkey
    and o_orderkey = l_orderkey
group by
    c_name,
    c_custkey,
    o_orderkey,
    o_orderdate,
    o_totalprice
order by
    o_totalprice desc,
    o_orderdate
limit 100;
