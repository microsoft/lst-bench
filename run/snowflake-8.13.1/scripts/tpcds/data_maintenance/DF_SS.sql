DELETE
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
            AND d_date BETWEEN '${param1}' AND '${param2}'
    );

DELETE
FROM
    ${catalog}.${database}.store_sales
WHERE
    ss_sold_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param1}' AND '${param2}'
    )
    AND ss_sold_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param1}' AND '${param2}'
    );

DELETE
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

DELETE
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

DELETE
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
            AND d_date BETWEEN '${param5}' AND '${param6}'
    );

DELETE
FROM
    ${catalog}.${database}.store_sales
WHERE
    ss_sold_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param5}' AND '${param6}'
    )
    AND ss_sold_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param5}' AND '${param6}'
    );
