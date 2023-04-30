SELECT
    promotions,
    total,
    CAST(
        promotions AS DECIMAL(
            15,
            4
        )
    )/ CAST(
        total AS DECIMAL(
            15,
            4
        )
    )* 100
FROM
    (
        SELECT
            SUM( ss_ext_sales_price ) promotions
        FROM
            ${catalog}.${database}.store_sales ${asof},
            ${catalog}.${database}.store,
            ${catalog}.${database}.promotion,
            ${catalog}.${database}.date_dim,
            ${catalog}.${database}.customer,
            ${catalog}.${database}.customer_address,
            ${catalog}.${database}.item
        WHERE
            ss_sold_date_sk = d_date_sk
            AND ss_store_sk = s_store_sk
            AND ss_promo_sk = p_promo_sk
            AND ss_customer_sk = c_customer_sk
            AND ca_address_sk = c_current_addr_sk
            AND ss_item_sk = i_item_sk
            AND ca_gmt_offset =- 6
            AND i_category = 'Sports'
            AND(
                p_channel_dmail = 'Y'
                OR p_channel_email = 'Y'
                OR p_channel_tv = 'Y'
            )
            AND s_gmt_offset =- 6
            AND d_year = 2002
            AND d_moy = 11
    ) promotional_sales,
    (
        SELECT
            SUM( ss_ext_sales_price ) total
        FROM
            ${catalog}.${database}.store_sales ${asof},
            ${catalog}.${database}.store,
            ${catalog}.${database}.date_dim,
            ${catalog}.${database}.customer,
            ${catalog}.${database}.customer_address,
            ${catalog}.${database}.item
        WHERE
            ss_sold_date_sk = d_date_sk
            AND ss_store_sk = s_store_sk
            AND ss_customer_sk = c_customer_sk
            AND ca_address_sk = c_current_addr_sk
            AND ss_item_sk = i_item_sk
            AND ca_gmt_offset =- 6
            AND i_category = 'Sports'
            AND s_gmt_offset =- 6
            AND d_year = 2002
            AND d_moy = 11
    ) all_sales
ORDER BY
    promotions,
    total LIMIT 100;
