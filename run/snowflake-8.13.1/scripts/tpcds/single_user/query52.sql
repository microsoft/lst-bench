SELECT
    dt.d_year,
    item.i_brand_id brand_id,
    item.i_brand brand,
    SUM( ss_ext_sales_price ) ext_price
FROM
    ${catalog}.${database}.date_dim dt,
    ${catalog}.${database}.store_sales ${asof_sf},
    ${catalog}.${database}.item
WHERE
    dt.d_date_sk = store_sales.ss_sold_date_sk
    AND store_sales.ss_item_sk = item.i_item_sk
    AND item.i_manager_id = 1
    AND dt.d_moy = 11
    AND dt.d_year = 2000
GROUP BY
    dt.d_year,
    item.i_brand,
    item.i_brand_id
ORDER BY
    dt.d_year,
    ext_price DESC,
    brand_id LIMIT 100;
