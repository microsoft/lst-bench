SELECT
    substr(
        w_warehouse_name,
        1,
        20
    ),
    sm_type,
    cc_name,
    SUM( CASE WHEN( cs_ship_date_sk - cs_sold_date_sk <= 30 ) THEN 1 ELSE 0 END ) AS " 30 days ",
    SUM( CASE WHEN( cs_ship_date_sk - cs_sold_date_sk > 30 ) AND( cs_ship_date_sk - cs_sold_date_sk <= 60 ) THEN 1 ELSE 0 END ) AS " 31 - 60 days ",
    SUM( CASE WHEN( cs_ship_date_sk - cs_sold_date_sk > 60 ) AND( cs_ship_date_sk - cs_sold_date_sk <= 90 ) THEN 1 ELSE 0 END ) AS " 61 - 90 days ",
    SUM( CASE WHEN( cs_ship_date_sk - cs_sold_date_sk > 90 ) AND( cs_ship_date_sk - cs_sold_date_sk <= 120 ) THEN 1 ELSE 0 END ) AS " 91 - 120 days ",
    SUM( CASE WHEN( cs_ship_date_sk - cs_sold_date_sk > 120 ) THEN 1 ELSE 0 END ) AS "> 120 days "
FROM
    ${catalog}.${database}.catalog_sales ${asof_sf},
    ${catalog}.${database}.warehouse,
    ${catalog}.${database}.ship_mode,
    ${catalog}.${database}.call_center,
    ${catalog}.${database}.date_dim
WHERE
    d_month_seq BETWEEN 1188 AND 1188 + 11
    AND cs_ship_date_sk = d_date_sk
    AND cs_warehouse_sk = w_warehouse_sk
    AND cs_ship_mode_sk = sm_ship_mode_sk
    AND cs_call_center_sk = cc_call_center_sk
GROUP BY
    substr(
        w_warehouse_name,
        1,
        20
    ),
    sm_type,
    cc_name
ORDER BY
    substr(
        w_warehouse_name,
        1,
        20
    ),
    sm_type,
    cc_name LIMIT 100;
