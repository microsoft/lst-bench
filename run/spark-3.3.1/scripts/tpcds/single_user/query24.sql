WITH ssales AS(
    SELECT
        c_last_name,
        c_first_name,
        s_store_name,
        ca_state,
        s_state,
        i_color,
        i_current_price,
        i_manager_id,
        i_units,
        i_size,
        SUM( ss_net_profit ) netpaid
    FROM
        ${catalog}.${database}.store_sales ${asof},
        ${catalog}.${database}.store_returns ${asof},
        ${catalog}.${database}.store,
        ${catalog}.${database}.item,
        ${catalog}.${database}.customer,
        ${catalog}.${database}.customer_address
    WHERE
        ss_ticket_number = sr_ticket_number
        AND ss_item_sk = sr_item_sk
        AND ss_customer_sk = c_customer_sk
        AND ss_item_sk = i_item_sk
        AND ss_store_sk = s_store_sk
        AND c_current_addr_sk = ca_address_sk
        AND c_birth_country <> UPPER( ca_country )
        AND s_zip = ca_zip
        AND s_market_id = 10
    GROUP BY
        c_last_name,
        c_first_name,
        s_store_name,
        ca_state,
        s_state,
        i_color,
        i_current_price,
        i_manager_id,
        i_units,
        i_size
) SELECT
    c_last_name,
    c_first_name,
    s_store_name,
    SUM( netpaid ) paid
FROM
    ssales
WHERE
    i_color = 'orchid'
GROUP BY
    c_last_name,
    c_first_name,
    s_store_name
HAVING
    SUM( netpaid )>(
        SELECT
            0.05 * AVG( netpaid )
        FROM
            ssales
    )
ORDER BY
    c_last_name,
    c_first_name,
    s_store_name;

WITH ssales AS(
    SELECT
        c_last_name,
        c_first_name,
        s_store_name,
        ca_state,
        s_state,
        i_color,
        i_current_price,
        i_manager_id,
        i_units,
        i_size,
        SUM( ss_net_profit ) netpaid
    FROM
        ${catalog}.${database}.store_sales ${asof},
        ${catalog}.${database}.store_returns ${asof},
        ${catalog}.${database}.store,
        ${catalog}.${database}.item,
        ${catalog}.${database}.customer,
        ${catalog}.${database}.customer_address
    WHERE
        ss_ticket_number = sr_ticket_number
        AND ss_item_sk = sr_item_sk
        AND ss_customer_sk = c_customer_sk
        AND ss_item_sk = i_item_sk
        AND ss_store_sk = s_store_sk
        AND c_current_addr_sk = ca_address_sk
        AND c_birth_country <> UPPER( ca_country )
        AND s_zip = ca_zip
        AND s_market_id = 10
    GROUP BY
        c_last_name,
        c_first_name,
        s_store_name,
        ca_state,
        s_state,
        i_color,
        i_current_price,
        i_manager_id,
        i_units,
        i_size
) SELECT
    c_last_name,
    c_first_name,
    s_store_name,
    SUM( netpaid ) paid
FROM
    ssales
WHERE
    i_color = 'green'
GROUP BY
    c_last_name,
    c_first_name,
    s_store_name
HAVING
    SUM( netpaid )>(
        SELECT
            0.05 * AVG( netpaid )
        FROM
            ssales
    )
ORDER BY
    c_last_name,
    c_first_name,
    s_store_name;
