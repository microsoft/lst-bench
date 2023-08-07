SELECT
    cs_order_number
FROM
    ${catalog}.${database}.catalog_sales,
    ${catalog}.${database}.date_dim
WHERE
    cs_sold_date_sk = d_date_sk
    AND d_date BETWEEN '${param3}' AND '${param4}';
