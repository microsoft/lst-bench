SELECT
    SUM( ws_ext_discount_amt ) AS ` Excess Discount Amount `
FROM
    ${catalog}.${database}.web_sales ${asof},
    ${catalog}.${database}.item,
    ${catalog}.${database}.date_dim
WHERE
    i_manufact_id = 914
    AND i_item_sk = ws_item_sk
    AND d_date BETWEEN '2001-01-25' AND date_add(
        CAST(
            '2001-01-25' AS DATE
        ),
        90
    )
    AND d_date_sk = ws_sold_date_sk
    AND ws_ext_discount_amt >(
        SELECT
            1.3 * AVG( ws_ext_discount_amt )
        FROM
            ${catalog}.${database}.web_sales ${asof},
            ${catalog}.${database}.date_dim
        WHERE
            ws_item_sk = i_item_sk
            AND d_date BETWEEN '2001-01-25' AND date_add(
                CAST(
                    '2001-01-25' AS DATE
                ),
                90
            )
            AND d_date_sk = ws_sold_date_sk
    )
ORDER BY
    SUM( ws_ext_discount_amt ) LIMIT 100;
