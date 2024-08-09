DELETE
FROM
    ${catalog}.${database}.catalog_returns
WHERE
    cr_order_number IN(
        SELECT
            cs_order_number
        FROM
            ${catalog}.${database}.catalog_sales,
            ${catalog}.${database}.date_dim
        WHERE
            cs_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param1}' AND '${param2}'
    );

DELETE
FROM
    ${catalog}.${database}.catalog_sales
WHERE
    cs_sold_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param1}' AND '${param2}'
    )
    AND cs_sold_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param1}' AND '${param2}'
    );

DELETE
FROM
    ${catalog}.${database}.catalog_returns
WHERE
    cr_order_number IN(
        SELECT
            cs_order_number
        FROM
            ${catalog}.${database}.catalog_sales,
            ${catalog}.${database}.date_dim
        WHERE
            cs_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param3}' AND '${param4}'
    );

DELETE
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

DELETE
FROM
    ${catalog}.${database}.catalog_returns
WHERE
    cr_order_number IN(
        SELECT
            cs_order_number
        FROM
            ${catalog}.${database}.catalog_sales,
            ${catalog}.${database}.date_dim
        WHERE
            cs_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param5}' AND '${param6}'
    );

DELETE
FROM
    ${catalog}.${database}.catalog_sales
WHERE
    cs_sold_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param5}' AND '${param6}'
    )
    AND cs_sold_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param5}' AND '${param6}'
    );
