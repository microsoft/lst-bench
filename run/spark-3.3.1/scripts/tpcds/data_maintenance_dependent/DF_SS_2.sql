SELECT
    ss_item_sk, ss_ticket_number
FROM
    ${catalog}.${database}.store_sales
WHERE
    ss_sold_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param3}' AND '${param4}'
    )
    AND ss_sold_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param3}' AND '${param4}'
    );
