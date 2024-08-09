SELECT
    i_item_id,
    AVG( cs_quantity ) agg1,
    AVG( cs_list_price ) agg2,
    AVG( cs_coupon_amt ) agg3,
    AVG( cs_sales_price ) agg4
FROM
    ${catalog}.${database}.catalog_sales ${asof_sf},
    ${catalog}.${database}.customer_demographics,
    ${catalog}.${database}.date_dim,
    ${catalog}.${database}.item,
    ${catalog}.${database}.promotion
WHERE
    cs_sold_date_sk = d_date_sk
    AND cs_item_sk = i_item_sk
    AND cs_bill_cdemo_sk = cd_demo_sk
    AND cs_promo_sk = p_promo_sk
    AND cd_gender = 'F'
    AND cd_marital_status = 'M'
    AND cd_education_status = '4 yr Degree'
    AND(
        p_channel_email = 'N'
        OR p_channel_event = 'N'
    )
    AND d_year = 2000
GROUP BY
    i_item_id
ORDER BY
    i_item_id LIMIT 100;
