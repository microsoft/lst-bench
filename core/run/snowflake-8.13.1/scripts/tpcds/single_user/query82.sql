SELECT
    i_item_id,
    i_item_desc,
    i_current_price
FROM
    ${catalog}.${database}.item,
    ${catalog}.${database}.inventory ${asof_sf},
    ${catalog}.${database}.date_dim,
    ${catalog}.${database}.store_sales ${asof_sf}
WHERE
    i_current_price BETWEEN 69 AND 69 + 30
    AND inv_item_sk = i_item_sk
    AND d_date_sk = inv_date_sk
    AND d_date BETWEEN CAST(
        '1998-06-06' AS DATE
    ) AND DATEADD(DAY, 60, '1998-06-06'::DATE)
    AND i_manufact_id IN(
        105,
        513,
        180,
        137
    )
    AND inv_quantity_on_hand BETWEEN 100 AND 500
    AND ss_item_sk = i_item_sk
GROUP BY
    i_item_id,
    i_item_desc,
    i_current_price
ORDER BY
    i_item_id LIMIT 100;
