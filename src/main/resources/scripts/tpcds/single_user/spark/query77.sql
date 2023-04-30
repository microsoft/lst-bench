WITH ss AS(
    SELECT
        s_store_sk,
        SUM( ss_ext_sales_price ) AS sales,
        SUM( ss_net_profit ) AS profit
    FROM
        ${catalog}.${database}.store_sales ${asof},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.store
    WHERE
        ss_sold_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-11' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-11' AS DATE
            ),
            30
        )
        AND ss_store_sk = s_store_sk
    GROUP BY
        s_store_sk
),
sr AS(
    SELECT
        s_store_sk,
        SUM( sr_return_amt ) AS RETURNS,
        SUM( sr_net_loss ) AS profit_loss
    FROM
        ${catalog}.${database}.store_returns ${asof},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.store
    WHERE
        sr_returned_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-11' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-11' AS DATE
            ),
            30
        )
        AND sr_store_sk = s_store_sk
    GROUP BY
        s_store_sk
),
cs AS(
    SELECT
        cs_call_center_sk,
        SUM( cs_ext_sales_price ) AS sales,
        SUM( cs_net_profit ) AS profit
    FROM
        ${catalog}.${database}.catalog_sales ${asof},
        ${catalog}.${database}.date_dim
    WHERE
        cs_sold_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-11' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-11' AS DATE
            ),
            30
        )
    GROUP BY
        cs_call_center_sk
),
cr AS(
    SELECT
        cr_call_center_sk,
        SUM( cr_return_amount ) AS RETURNS,
        SUM( cr_net_loss ) AS profit_loss
    FROM
        ${catalog}.${database}.catalog_returns ${asof},
        ${catalog}.${database}.date_dim
    WHERE
        cr_returned_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-11' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-11' AS DATE
            ),
            30
        )
    GROUP BY
        cr_call_center_sk
),
ws AS(
    SELECT
        wp_web_page_sk,
        SUM( ws_ext_sales_price ) AS sales,
        SUM( ws_net_profit ) AS profit
    FROM
        ${catalog}.${database}.web_sales ${asof},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.web_page
    WHERE
        ws_sold_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-11' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-11' AS DATE
            ),
            30
        )
        AND ws_web_page_sk = wp_web_page_sk
    GROUP BY
        wp_web_page_sk
),
wr AS(
    SELECT
        wp_web_page_sk,
        SUM( wr_return_amt ) AS RETURNS,
        SUM( wr_net_loss ) AS profit_loss
    FROM
        ${catalog}.${database}.web_returns ${asof},
        ${catalog}.${database}.date_dim,
        ${catalog}.${database}.web_page
    WHERE
        wr_returned_date_sk = d_date_sk
        AND d_date BETWEEN CAST(
            '2001-08-11' AS DATE
        ) AND date_add(
            CAST(
                '2001-08-11' AS DATE
            ),
            30
        )
        AND wr_web_page_sk = wp_web_page_sk
    GROUP BY
        wp_web_page_sk
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
            ss.s_store_sk AS id,
            sales,
            COALESCE(
                RETURNS,
                0
            ) AS RETURNS,
            (
                profit - COALESCE(
                    profit_loss,
                    0
                )
            ) AS profit
        FROM
            ss
        LEFT JOIN sr ON
            ss.s_store_sk = sr.s_store_sk
    UNION ALL SELECT
            'catalog channel' AS channel,
            cs_call_center_sk AS id,
            sales,
            RETURNS,
            (
                profit - profit_loss
            ) AS profit
        FROM
            cs,
            cr
    UNION ALL SELECT
            'web channel' AS channel,
            ws.wp_web_page_sk AS id,
            sales,
            COALESCE(
                RETURNS,
                0
            ) RETURNS,
            (
                profit - COALESCE(
                    profit_loss,
                    0
                )
            ) AS profit
        FROM
            ws
        LEFT JOIN wr ON
            ws.wp_web_page_sk = wr.wp_web_page_sk
    ) x
GROUP BY
    ROLLUP(
        channel,
        id
    )
ORDER BY
    channel,
    id LIMIT 100;
