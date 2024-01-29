WITH my_customers AS(
    SELECT
        DISTINCT c_customer_sk,
        c_current_addr_sk
    FROM
        (
            SELECT
                cs_sold_date_sk sold_date_sk,
                cs_bill_customer_sk customer_sk,
                cs_item_sk item_sk
            FROM
                ${catalog}.${database}.catalog_sales ${asof}
        UNION ALL SELECT
                ws_sold_date_sk sold_date_sk,
                ws_bill_customer_sk customer_sk,
                ws_item_sk item_sk
            FROM
                ${catalog}.${database}.web_sales ${asof}
        ) cs_or_ws_sales,
        ${catalog}.${database}.item,
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.customer
    WHERE
        sold_date_sk = d_date_sk
        AND item_sk = i_item_sk
        AND i_category = 'Men'
        AND i_class = 'shirts'
        AND c_customer_sk = cs_or_ws_sales.customer_sk
        AND d_moy = 4
        AND d_year = 1998
),
my_revenue AS(
    SELECT
        c_customer_sk,
        SUM( ss_ext_sales_price ) AS revenue
    FROM
        my_customers,
        ${catalog}.${database}.store_sales ${asof},
        ${catalog}.${database}.customer_address,
        ${catalog}.${database}.store,
        ${catalog}.${database}.date_dim
    WHERE
        c_current_addr_sk = ca_address_sk
        AND ca_county = s_county
        AND ca_state = s_state
        AND ss_sold_date_sk = d_date_sk
        AND c_customer_sk = ss_customer_sk
        AND d_month_seq BETWEEN(
            SELECT
                DISTINCT d_month_seq + 1
            FROM
                ${catalog}.${database}.date_dim
            WHERE
                d_year = 1998 AND d_moy = 4
        )
        AND(
            SELECT
                DISTINCT d_month_seq + 3
            FROM
                ${catalog}.${database}.date_dim
            WHERE
                d_year = 1998
                AND d_moy = 4
        )
    GROUP BY
        c_customer_sk
),
segments AS(
    SELECT
        CAST(
            (
                revenue / 50
            ) AS INT
        ) AS segment
    FROM
        my_revenue
) SELECT
    segment,
    COUNT(*) AS num_customers,
    segment*50 AS segment_base
FROM
    segments
GROUP BY
    segment
ORDER BY
    segment,
    num_customers LIMIT 100;
