SELECT
    cs_item_sk, cs_order_number
FROM
    ${catalog}.${database}.catalog_sales
WHERE
    cs_sold_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param3}' AND '${param4}'
    )
    AND cs_sold_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param3}' AND '${param4}'
    );
