WITH frequent_ss_items AS(
    SELECT
        substr(
            i_item_desc,
            1,
            30
        ) itemdesc,
        i_item_sk item_sk,
        d_date solddate,
        COUNT(*) cnt
    FROM
        ${catalog}.${database}.store_sales ${asof_sf},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.item
    WHERE
        ss_sold_date_sk = d_date_sk
        AND ss_item_sk = i_item_sk
        AND d_year IN(
            2000,
            2000 + 1,
            2000 + 2,
            2000 + 3
        )
    GROUP BY
        substr(
            i_item_desc,
            1,
            30
        ),
        i_item_sk,
        d_date
    HAVING
        COUNT(*)> 4
),
max_store_sales AS(
    SELECT
        MAX( csales ) tpcds_cmax
    FROM
        (
            SELECT
                c_customer_sk,
                SUM( ss_quantity*ss_sales_price ) csales
            FROM
                ${catalog}.${database}.store_sales ${asof_sf},
                ${catalog}.${database}.customer,
                ${catalog}.${database}.date_dim
            WHERE
                ss_customer_sk = c_customer_sk
                AND ss_sold_date_sk = d_date_sk
                AND d_year IN(
                    2000,
                    2000 + 1,
                    2000 + 2,
                    2000 + 3
                )
            GROUP BY
                c_customer_sk
        )
),
best_ss_customer AS(
    SELECT
        c_customer_sk,
        SUM( ss_quantity*ss_sales_price ) ssales
    FROM
        ${catalog}.${database}.store_sales ${asof_sf},
        ${catalog}.${database}.customer
    WHERE
        ss_customer_sk = c_customer_sk
    GROUP BY
        c_customer_sk
    HAVING
        SUM( ss_quantity*ss_sales_price )>(
            95 / 100.0
        )*(
            SELECT
                *
            FROM
                max_store_sales
        )
) SELECT
    SUM( sales )
FROM
    (
        SELECT
            cs_quantity*cs_list_price sales
        FROM
            ${catalog}.${database}.catalog_sales ${asof_sf},
            ${catalog}.${database}.date_dim
        WHERE
            d_year = 2000
            AND d_moy = 3
            AND cs_sold_date_sk = d_date_sk
            AND cs_item_sk IN(
                SELECT
                    item_sk
                FROM
                    frequent_ss_items
            )
            AND cs_bill_customer_sk IN(
                SELECT
                    c_customer_sk
                FROM
                    best_ss_customer
            )
    UNION ALL SELECT
            ws_quantity*ws_list_price sales
        FROM
            ${catalog}.${database}.web_sales ${asof_sf},
            ${catalog}.${database}.date_dim
        WHERE
            d_year = 2000
            AND d_moy = 3
            AND ws_sold_date_sk = d_date_sk
            AND ws_item_sk IN(
                SELECT
                    item_sk
                FROM
                    frequent_ss_items
            )
            AND ws_bill_customer_sk IN(
                SELECT
                    c_customer_sk
                FROM
                    best_ss_customer
            )
    ) LIMIT 100;

WITH frequent_ss_items AS(
    SELECT
        substr(
            i_item_desc,
            1,
            30
        ) itemdesc,
        i_item_sk item_sk,
        d_date solddate,
        COUNT(*) cnt
    FROM
        ${catalog}.${database}.store_sales ${asof_sf},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.item
    WHERE
        ss_sold_date_sk = d_date_sk
        AND ss_item_sk = i_item_sk
        AND d_year IN(
            2000,
            2000 + 1,
            2000 + 2,
            2000 + 3
        )
    GROUP BY
        substr(
            i_item_desc,
            1,
            30
        ),
        i_item_sk,
        d_date
    HAVING
        COUNT(*)> 4
),
max_store_sales AS(
    SELECT
        MAX( csales ) tpcds_cmax
    FROM
        (
            SELECT
                c_customer_sk,
                SUM( ss_quantity*ss_sales_price ) csales
            FROM
                ${catalog}.${database}.store_sales ${asof_sf},
                ${catalog}.${database}.customer,
                ${catalog}.${database}.date_dim
            WHERE
                ss_customer_sk = c_customer_sk
                AND ss_sold_date_sk = d_date_sk
                AND d_year IN(
                    2000,
                    2000 + 1,
                    2000 + 2,
                    2000 + 3
                )
            GROUP BY
                c_customer_sk
        )
),
best_ss_customer AS(
    SELECT
        c_customer_sk,
        SUM( ss_quantity*ss_sales_price ) ssales
    FROM
        ${catalog}.${database}.store_sales ${asof_sf},
        ${catalog}.${database}.customer
    WHERE
        ss_customer_sk = c_customer_sk
    GROUP BY
        c_customer_sk
    HAVING
        SUM( ss_quantity*ss_sales_price )>(
            95 / 100.0
        )*(
            SELECT
                *
            FROM
                max_store_sales
        )
) SELECT
    c_last_name,
    c_first_name,
    sales
FROM
    (
        SELECT
            c_last_name,
            c_first_name,
            SUM( cs_quantity*cs_list_price ) sales
        FROM
            ${catalog}.${database}.catalog_sales ${asof_sf},
            ${catalog}.${database}.customer,
            ${catalog}.${database}.date_dim
        WHERE
            d_year = 2000
            AND d_moy = 3
            AND cs_sold_date_sk = d_date_sk
            AND cs_item_sk IN(
                SELECT
                    item_sk
                FROM
                    frequent_ss_items
            )
            AND cs_bill_customer_sk IN(
                SELECT
                    c_customer_sk
                FROM
                    best_ss_customer
            )
            AND cs_bill_customer_sk = c_customer_sk
        GROUP BY
            c_last_name,
            c_first_name
    UNION ALL SELECT
            c_last_name,
            c_first_name,
            SUM( ws_quantity*ws_list_price ) sales
        FROM
            ${catalog}.${database}.web_sales ${asof_sf},
            ${catalog}.${database}.customer,
            ${catalog}.${database}.date_dim
        WHERE
            d_year = 2000
            AND d_moy = 3
            AND ws_sold_date_sk = d_date_sk
            AND ws_item_sk IN(
                SELECT
                    item_sk
                FROM
                    frequent_ss_items
            )
            AND ws_bill_customer_sk IN(
                SELECT
                    c_customer_sk
                FROM
                    best_ss_customer
            )
            AND ws_bill_customer_sk = c_customer_sk
        GROUP BY
            c_last_name,
            c_first_name
    )
ORDER BY
    c_last_name,
    c_first_name,
    sales LIMIT 100;
