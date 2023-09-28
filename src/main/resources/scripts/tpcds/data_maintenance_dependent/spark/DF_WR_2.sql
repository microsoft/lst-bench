SELECT
    wr_item_sk, wr_order_number
FROM
    ${catalog}.${database}.web_returns
WHERE
    wr_order_number IN(
        SELECT
            ws_order_number
        FROM
            ${catalog}.${database}.web_sales,
            ${catalog}.${database}.date_dim
        WHERE
            ws_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param3}' AND '${param4}'
    );
