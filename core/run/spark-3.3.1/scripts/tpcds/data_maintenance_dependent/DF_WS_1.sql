SELECT
    ws_item_sk, ws_order_number
FROM
    ${catalog}.${database}.web_sales
WHERE
    ws_sold_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param1}' AND '${param2}'
    )
    AND ws_sold_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param1}' AND '${param2}'
    );
