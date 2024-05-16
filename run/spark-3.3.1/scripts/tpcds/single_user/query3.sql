SELECT
    dt.d_year,
    item.i_brand_id brand_id,
    item.i_brand brand,
    SUM( ss_net_profit ) sum_agg
FROM
    ${catalog}.${database}.date_dim dt,
    ${catalog}.${database}.store_sales ${asof},
    ${catalog}.${database}.item
WHERE
    dt.d_date_sk = store_sales.ss_sold_date_sk
    AND store_sales.ss_item_sk = item.i_item_sk
    AND item.i_manufact_id = 445
    AND dt.d_moy = 12
GROUP BY
    dt.d_year,
    item.i_brand,
    item.i_brand_id
ORDER BY
    dt.d_year,
    sum_agg DESC,
    brand_id LIMIT 100;
