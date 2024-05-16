WITH ss AS(
    SELECT
        i_item_id,
        SUM( ss_ext_sales_price ) total_sales
    FROM
        ${catalog}.${database}.store_sales ${asof},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.customer_address,
        ${catalog}.${database}.item
    WHERE
        i_item_id IN(
            SELECT
                i_item_id
            FROM
                ${catalog}.${database}.item
            WHERE
                i_color IN(
                    'powder',
                    'goldenrod',
                    'bisque'
                )
        )
        AND ss_item_sk = i_item_sk
        AND ss_sold_date_sk = d_date_sk
        AND d_year = 1998
        AND d_moy = 5
        AND ss_addr_sk = ca_address_sk
        AND ca_gmt_offset =- 5
    GROUP BY
        i_item_id
),
cs AS(
    SELECT
        i_item_id,
        SUM( cs_ext_sales_price ) total_sales
    FROM
        ${catalog}.${database}.catalog_sales ${asof},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.customer_address,
        ${catalog}.${database}.item
    WHERE
        i_item_id IN(
            SELECT
                i_item_id
            FROM
                ${catalog}.${database}.item
            WHERE
                i_color IN(
                    'powder',
                    'goldenrod',
                    'bisque'
                )
        )
        AND cs_item_sk = i_item_sk
        AND cs_sold_date_sk = d_date_sk
        AND d_year = 1998
        AND d_moy = 5
        AND cs_bill_addr_sk = ca_address_sk
        AND ca_gmt_offset =- 5
    GROUP BY
        i_item_id
),
ws AS(
    SELECT
        i_item_id,
        SUM( ws_ext_sales_price ) total_sales
    FROM
        ${catalog}.${database}.web_sales ${asof},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.customer_address,
        ${catalog}.${database}.item
    WHERE
        i_item_id IN(
            SELECT
                i_item_id
            FROM
                ${catalog}.${database}.item
            WHERE
                i_color IN(
                    'powder',
                    'goldenrod',
                    'bisque'
                )
        )
        AND ws_item_sk = i_item_sk
        AND ws_sold_date_sk = d_date_sk
        AND d_year = 1998
        AND d_moy = 5
        AND ws_bill_addr_sk = ca_address_sk
        AND ca_gmt_offset =- 5
    GROUP BY
        i_item_id
) SELECT
    i_item_id,
    SUM( total_sales ) total_sales
FROM
    (
        SELECT
            *
        FROM
            ss
    UNION ALL SELECT
            *
        FROM
            cs
    UNION ALL SELECT
            *
        FROM
            ws
    ) tmp1
GROUP BY
    i_item_id
ORDER BY
    total_sales,
    i_item_id LIMIT 100;
