SELECT
    COUNT(*)
FROM
    (
        SELECT
            DISTINCT c_last_name,
            c_first_name,
            d_date
        FROM
            ${catalog}.${database}.store_sales ${asof_sf},
            ${catalog}.${database}.date_dim,
            ${catalog}.${database}.customer
        WHERE
            store_sales.ss_sold_date_sk = date_dim.d_date_sk
            AND store_sales.ss_customer_sk = customer.c_customer_sk
            AND d_month_seq BETWEEN 1190 AND 1190 + 11
    INTERSECT SELECT
            DISTINCT c_last_name,
            c_first_name,
            d_date
        FROM
            ${catalog}.${database}.catalog_sales ${asof_sf},
            ${catalog}.${database}.date_dim,
            ${catalog}.${database}.customer
        WHERE
            catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
            AND catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
            AND d_month_seq BETWEEN 1190 AND 1190 + 11
    INTERSECT SELECT
            DISTINCT c_last_name,
            c_first_name,
            d_date
        FROM
            ${catalog}.${database}.web_sales ${asof_sf},
            ${catalog}.${database}.date_dim,
            ${catalog}.${database}.customer
        WHERE
            web_sales.ws_sold_date_sk = date_dim.d_date_sk
            AND web_sales.ws_bill_customer_sk = customer.c_customer_sk
            AND d_month_seq BETWEEN 1190 AND 1190 + 11
    ) hot_cust LIMIT 100;
