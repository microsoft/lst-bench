SELECT
    o_orderpriority,
    count(*) as order_count
FROM
    ${catalog}.${database}.orders
WHERE
    o_orderdate >= date '${param1}'
    AND o_orderdate < date '${param1}' + interval '3' month
    AND EXISTS (
        SELECT *
        FROM
            ${catalog}.${database}.lineitem
        WHERE
            l_orderkey = o_orderkey
            AND l_commitdate < l_receiptdate
        )
    GROUP BY
        o_orderpriority
    ORDER BY
        o_orderpriority;
