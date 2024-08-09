SELECT
    substr(
        w_warehouse_name,
        1,
        20
    ),
    sm_type,
    web_name,
    SUM( CASE WHEN( ws_ship_date_sk - ws_sold_date_sk <= 30 ) THEN 1 ELSE 0 END ) AS " 30 days ",
    SUM( CASE WHEN( ws_ship_date_sk - ws_sold_date_sk > 30 ) AND( ws_ship_date_sk - ws_sold_date_sk <= 60 ) THEN 1 ELSE 0 END ) AS " 31 - 60 days ",
    SUM( CASE WHEN( ws_ship_date_sk - ws_sold_date_sk > 60 ) AND( ws_ship_date_sk - ws_sold_date_sk <= 90 ) THEN 1 ELSE 0 END ) AS " 61 - 90 days ",
    SUM( CASE WHEN( ws_ship_date_sk - ws_sold_date_sk > 90 ) AND( ws_ship_date_sk - ws_sold_date_sk <= 120 ) THEN 1 ELSE 0 END ) AS " 91 - 120 days ",
    SUM( CASE WHEN( ws_ship_date_sk - ws_sold_date_sk > 120 ) THEN 1 ELSE 0 END ) AS "> 120 days "
FROM
    ${catalog}.${database}.web_sales ${asof_sf},
    ${catalog}.${database}.warehouse,
    ${catalog}.${database}.ship_mode,
    ${catalog}.${database}.web_site,
    ${catalog}.${database}.date_dim
WHERE
    d_month_seq BETWEEN 1217 AND 1217 + 11
    AND ws_ship_date_sk = d_date_sk
    AND ws_warehouse_sk = w_warehouse_sk
    AND ws_ship_mode_sk = sm_ship_mode_sk
    AND ws_web_site_sk = web_site_sk
GROUP BY
    substr(
        w_warehouse_name,
        1,
        20
    ),
    sm_type,
    web_name
ORDER BY
    substr(
        w_warehouse_name,
        1,
        20
    ),
    sm_type,
    web_name LIMIT 100;
