SELECT
    sr_item_sk, sr_ticket_number
FROM
    ${catalog}.${database}.store_returns
WHERE
    sr_ticket_number IN(
        SELECT
            ss_ticket_number
        FROM
            ${catalog}.${database}.store_sales,
            ${catalog}.${database}.date_dim
        WHERE
            ss_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param3}' AND '${param4}'
    );
