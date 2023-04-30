SELECT
    COUNT( DISTINCT cs_order_number ) AS ` ORDER COUNT `,
    SUM( cs_ext_ship_cost ) AS ` total shipping cost `,
    SUM( cs_net_profit ) AS ` total net profit `
FROM
    ${catalog}.${database}.catalog_sales ${asof} cs1,
    ${catalog}.${database}.date_dim,
    ${catalog}.${database}.customer_address,
    ${catalog}.${database}.call_center
WHERE
    d_date BETWEEN '1999-5-01' AND date_add(
        CAST(
            '1999-5-01' AS DATE
        ),
        60
    )
    AND cs1.cs_ship_date_sk = d_date_sk
    AND cs1.cs_ship_addr_sk = ca_address_sk
    AND ca_state = 'ID'
    AND cs1.cs_call_center_sk = cc_call_center_sk
    AND cc_county IN(
        'Williamson County',
        'Williamson County',
        'Williamson County',
        'Williamson County',
        'Williamson County'
    )
    AND EXISTS(
        SELECT
            *
        FROM
            ${catalog}.${database}.catalog_sales ${asof} cs2
        WHERE
            cs1.cs_order_number = cs2.cs_order_number
            AND cs1.cs_warehouse_sk <> cs2.cs_warehouse_sk
    )
    AND NOT EXISTS(
        SELECT
            *
        FROM
            ${catalog}.${database}.catalog_returns ${asof} cr1
        WHERE
            cs1.cs_order_number = cr1.cr_order_number
    )
ORDER BY
    COUNT( DISTINCT cs_order_number ) LIMIT 100;
