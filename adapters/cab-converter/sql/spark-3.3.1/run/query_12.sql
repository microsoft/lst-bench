SELECT
    l_shipmode,
    sum(case
        when o_orderpriority ='1-URGENT'
        or o_orderpriority ='2-HIGH'
        then 1
        else 0
    end) as high_line_count,
    sum(case
        when o_orderpriority <> '1-URGENT'
        and o_orderpriority <> '2-HIGH'
        then 1
        else 0
    end) as low_line_count
FROM
    ${catalog}.${database}${stream_num}.orders,
    ${catalog}.${database}${stream_num}.lineitem
WHERE
    o_orderkey = l_orderkey
    and l_shipmode in ('${param1}', '${param2}')
    and l_commitdate < l_receiptdate
    and l_shipdate < l_commitdate
    and l_receiptdate >= date '${param3}'
    and l_receiptdate < date '${param3}' + interval '1' year
GROUP BY
    l_shipmode
ORDER BY
    l_shipmode;
