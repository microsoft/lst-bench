SELECT
    SUM( cs_ext_discount_amt ) AS ` excess discount amount `
FROM
    ${catalog}.${database}.catalog_sales ${asof},
    ${catalog}.${database}.item,
    ${catalog}.${database}.date_dim
WHERE
    i_manufact_id = 283
    AND i_item_sk = cs_item_sk
    AND d_date BETWEEN '1999-02-22' AND date_add(
        CAST(
            '1999-02-22' AS DATE
        ),
        90
    )
    AND d_date_sk = cs_sold_date_sk
    AND cs_ext_discount_amt >(
        SELECT
            1.3 * AVG( cs_ext_discount_amt )
        FROM
            ${catalog}.${database}.catalog_sales ${asof},
            ${catalog}.${database}.date_dim
        WHERE
            cs_item_sk = i_item_sk
            AND d_date BETWEEN '1999-02-22' AND date_add(
                CAST(
                    '1999-02-22' AS DATE
                ),
                90
            )
            AND d_date_sk = cs_sold_date_sk
    ) LIMIT 100;
