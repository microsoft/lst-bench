SELECT
    COUNT( DISTINCT ws_order_number ) AS " ORDER COUNT ",
    SUM( ws_ext_ship_cost ) AS " total shipping cost ",
    SUM( ws_net_profit ) AS " total net profit "
FROM
    ${catalog}.${database}.web_sales ${asof_sf} ws1,
    ${catalog}.${database}.date_dim,
    ${catalog}.${database}.customer_address,
    ${catalog}.${database}.web_site
WHERE
    d_date BETWEEN '1999-4-01' AND DATEADD(DAY, 60, '1999-4-01'::DATE)
    AND ws1.ws_ship_date_sk = d_date_sk
    AND ws1.ws_ship_addr_sk = ca_address_sk
    AND ca_state = 'WI'
    AND ws1.ws_web_site_sk = web_site_sk
    AND web_company_name = 'pri'
    AND EXISTS(
        SELECT
            *
        FROM
            ${catalog}.${database}.web_sales ${asof_sf} ws2
        WHERE
            ws1.ws_order_number = ws2.ws_order_number
            AND ws1.ws_warehouse_sk <> ws2.ws_warehouse_sk
    )
    AND NOT EXISTS(
        SELECT
            *
        FROM
            ${catalog}.${database}.web_returns ${asof_sf} wr1
        WHERE
            ws1.ws_order_number = wr1.wr_order_number
    )
ORDER BY
    COUNT( DISTINCT ws_order_number ) LIMIT 100;
