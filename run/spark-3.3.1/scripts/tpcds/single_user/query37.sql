SELECT
    i_item_id,
    i_item_desc,
    i_current_price
FROM
    ${catalog}.${database}.item,
    ${catalog}.${database}.inventory ${asof},
    ${catalog}.${database}.date_dim,
    ${catalog}.${database}.catalog_sales ${asof}
WHERE
    i_current_price BETWEEN 26 AND 26 + 30
    AND inv_item_sk = i_item_sk
    AND d_date_sk = inv_date_sk
    AND d_date BETWEEN CAST(
        '2001-06-09' AS DATE
    ) AND date_add(
        CAST(
            '2001-06-09' AS DATE
        ),
        60
    )
    AND i_manufact_id IN(
        744,
        884,
        722,
        693
    )
    AND inv_quantity_on_hand BETWEEN 100 AND 500
    AND cs_item_sk = i_item_sk
GROUP BY
    i_item_id,
    i_item_desc,
    i_current_price
ORDER BY
    i_item_id LIMIT 100;
