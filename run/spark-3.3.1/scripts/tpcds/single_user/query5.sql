WITH ssr AS(
    SELECT
        s_store_id,
        SUM( sales_price ) AS sales,
        SUM( profit ) AS profit,
        SUM( return_amt ) AS RETURNS,
        SUM( net_loss ) AS profit_loss
    FROM
        (
            SELECT
                ss_store_sk AS store_sk,
                ss_sold_date_sk AS date_sk,
                ss_ext_sales_price AS sales_price,
                ss_net_profit AS profit,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS return_amt,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS net_loss
            FROM
                ${catalog}.${database}.store_sales ${asof}
        UNION ALL SELECT
                sr_store_sk AS store_sk,
                sr_returned_date_sk AS date_sk,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS sales_price,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS profit,
                sr_return_amt AS return_amt,
                sr_net_loss AS net_loss
            FROM
                ${catalog}.${database}.store_returns ${asof}
        ) salesreturns,
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.store
    WHERE
        date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-04' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-04' AS DATE
            ),
            14
        )
        AND store_sk = s_store_sk
    GROUP BY
        s_store_id
),
csr AS(
    SELECT
        cp_catalog_page_id,
        SUM( sales_price ) AS sales,
        SUM( profit ) AS profit,
        SUM( return_amt ) AS RETURNS,
        SUM( net_loss ) AS profit_loss
    FROM
        (
            SELECT
                cs_catalog_page_sk AS page_sk,
                cs_sold_date_sk AS date_sk,
                cs_ext_sales_price AS sales_price,
                cs_net_profit AS profit,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS return_amt,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS net_loss
            FROM
                ${catalog}.${database}.catalog_sales ${asof}
        UNION ALL SELECT
                cr_catalog_page_sk AS page_sk,
                cr_returned_date_sk AS date_sk,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS sales_price,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS profit,
                cr_return_amount AS return_amt,
                cr_net_loss AS net_loss
            FROM
                ${catalog}.${database}.catalog_returns ${asof}
        ) salesreturns,
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.catalog_page
    WHERE
        date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-04' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-04' AS DATE
            ),
            14
        )
        AND page_sk = cp_catalog_page_sk
    GROUP BY
        cp_catalog_page_id
),
wsr AS(
    SELECT
        web_site_id,
        SUM( sales_price ) AS sales,
        SUM( profit ) AS profit,
        SUM( return_amt ) AS RETURNS,
        SUM( net_loss ) AS profit_loss
    FROM
        (
            SELECT
                ws_web_site_sk AS wsr_web_site_sk,
                ws_sold_date_sk AS date_sk,
                ws_ext_sales_price AS sales_price,
                ws_net_profit AS profit,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS return_amt,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS net_loss
            FROM
                ${catalog}.${database}.web_sales ${asof}
        UNION ALL SELECT
                ws_web_site_sk AS wsr_web_site_sk,
                wr_returned_date_sk AS date_sk,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS sales_price,
                CAST(
                    0 AS DECIMAL(
                        7,
                        2
                    )
                ) AS profit,
                wr_return_amt AS return_amt,
                wr_net_loss AS net_loss
            FROM
                ${catalog}.${database}.web_returns ${asof}
            LEFT OUTER JOIN ${catalog}.${database}.web_sales ${asof} ON
                (
                    wr_item_sk = ws_item_sk
                    AND wr_order_number = ws_order_number
                )
        ) salesreturns,
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.web_site
    WHERE
        date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-04' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-04' AS DATE
            ),
            14
        )
        AND wsr_web_site_sk = web_site_sk
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
            'store' || s_store_id AS id,
            sales,
            RETURNS,
            (
                profit - profit_loss
            ) AS profit
        FROM
            ssr
    UNION ALL SELECT
            'catalog channel' AS channel,
            'catalog_page' || cp_catalog_page_id AS id,
            sales,
            RETURNS,
            (
                profit - profit_loss
            ) AS profit
        FROM
            csr
    UNION ALL SELECT
            'web channel' AS channel,
            'web_site' || web_site_id AS id,
            sales,
            RETURNS,
            (
                profit - profit_loss
            ) AS profit
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
