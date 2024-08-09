SELECT
    i_item_id,
    s_state,
    GROUPING(s_state) g_state,
    AVG( ss_quantity ) agg1,
    AVG( ss_list_price ) agg2,
    AVG( ss_coupon_amt ) agg3,
    AVG( ss_sales_price ) agg4
FROM
    ${catalog}.${database}.store_sales ${asof_sf},
    ${catalog}.${database}.customer_demographics,
    ${catalog}.${database}.date_dim,
    ${catalog}.${database}.store,
    ${catalog}.${database}.item
WHERE
    ss_sold_date_sk = d_date_sk
    AND ss_item_sk = i_item_sk
    AND ss_store_sk = s_store_sk
    AND ss_cdemo_sk = cd_demo_sk
    AND cd_gender = 'M'
    AND cd_marital_status = 'U'
    AND cd_education_status = 'Secondary'
    AND d_year = 2000
    AND s_state IN(
        'TN',
        'TN',
        'TN',
        'TN',
        'TN',
        'TN'
    )
GROUP BY
    ROLLUP(
        i_item_id,
        s_state
    )
ORDER BY
    i_item_id,
    s_state LIMIT 100;
