WITH ssr AS(
    SELECT
        s_store_id AS store_id,
        SUM( ss_ext_sales_price ) AS sales,
        SUM( COALESCE( sr_return_amt, 0 )) AS RETURNS,
        SUM( ss_net_profit - COALESCE( sr_net_loss, 0 )) AS profit
    FROM
        ${catalog}.${database}.store_sales ${asof}
    LEFT OUTER JOIN ${catalog}.${database}.store_returns ${asof} ON
        (
            ss_item_sk = sr_item_sk
            AND ss_ticket_number = sr_ticket_number
        ),
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.store,
        ${catalog}.${database}.item,
        ${catalog}.${database}.promotion
    WHERE
        ss_sold_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2002-08-04' AS DATE
        ) AND date_add(
            CAST(
                '2002-08-04' AS DATE
            ),
            30
        )
        AND ss_store_sk = s_store_sk
        AND ss_item_sk = i_item_sk
        AND i_current_price > 50
        AND ss_promo_sk = p_promo_sk
        AND p_channel_tv = 'N'
    GROUP BY
        s_store_id
),
csr AS(
    SELECT
        cp_catalog_page_id AS catalog_page_id,
        SUM( cs_ext_sales_price ) AS sales,
        SUM( COALESCE( cr_return_amount, 0 )) AS RETURNS,
        SUM( cs_net_profit - COALESCE( cr_net_loss, 0 )) AS profit
    FROM
        ${catalog}.${database}.catalog_sales ${asof}
    LEFT OUTER JOIN ${catalog}.${database}.catalog_returns ${asof} ON
        (
            cs_item_sk = cr_item_sk
            AND cs_order_number = cr_order_number
        ),
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.catalog_page,
        ${catalog}.${database}.item,
        ${catalog}.${database}.promotion
    WHERE
        cs_sold_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2002-08-04' AS DATE
        ) AND date_add(
            CAST(
                '2002-08-04' AS DATE
            ),
            30
        )
        AND cs_catalog_page_sk = cp_catalog_page_sk
        AND cs_item_sk = i_item_sk
        AND i_current_price > 50
        AND cs_promo_sk = p_promo_sk
        AND p_channel_tv = 'N'
    GROUP BY
        cp_catalog_page_id
),
wsr AS(
    SELECT
        web_site_id,
        SUM( ws_ext_sales_price ) AS sales,
        SUM( COALESCE( wr_return_amt, 0 )) AS RETURNS,
        SUM( ws_net_profit - COALESCE( wr_net_loss, 0 )) AS profit
    FROM
        ${catalog}.${database}.web_sales ${asof}
    LEFT OUTER JOIN ${catalog}.${database}.web_returns ${asof} ON
        (
            ws_item_sk = wr_item_sk
            AND ws_order_number = wr_order_number
        ),
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.web_site,
        ${catalog}.${database}.item,
        ${catalog}.${database}.promotion
    WHERE
        ws_sold_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2002-08-04' AS DATE
        ) AND date_add(
            CAST(
                '2002-08-04' AS DATE
            ),
            30
        )
        AND ws_web_site_sk = web_site_sk
        AND ws_item_sk = i_item_sk
        AND i_current_price > 50
        AND ws_promo_sk = p_promo_sk
        AND p_channel_tv = 'N'
    GROUP BY
        web_site_id
) SELECT
    channel,
    id,
    SUM( sales ) AS sales,
    SUM( RETURNS ) AS RETURNS,
    SUM( profit ) AS profit
FROM
    (
        SELECT
            'store channel' AS channel,
            'store' || store_id AS id,
            sales,
            RETURNS,
            profit
        FROM
            ssr
    UNION ALL SELECT
            'catalog channel' AS channel,
            'catalog_page' || catalog_page_id AS id,
            sales,
            RETURNS,
            profit
        FROM
            csr
    UNION ALL SELECT
            'web channel' AS channel,
            'web_site' || web_site_id AS id,
            sales,
            RETURNS,
            profit
        FROM
            wsr
    ) x
GROUP BY
    ROLLUP(
        channel,
        id
    )
ORDER BY
    channel,
    id LIMIT 100;
