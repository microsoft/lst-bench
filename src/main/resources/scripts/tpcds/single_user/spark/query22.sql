SELECT
    i_product_name,
    i_brand,
    i_class,
    i_category,
    AVG( inv_quantity_on_hand ) qoh
FROM
    ${catalog}.${database}.inventory ${asof},
    ${catalog}.${database}.date_dim,
    ${catalog}.${database}.item
WHERE
    inv_date_sk = d_date_sk
    AND inv_item_sk = i_item_sk
    AND d_month_seq BETWEEN 1201 AND 1201 + 11
GROUP BY
    ROLLUP(
        i_product_name,
        i_brand,
        i_class,
        i_category
    )
ORDER BY
    qoh,
    i_product_name,
    i_brand,
    i_class,
    i_category LIMIT 100;
