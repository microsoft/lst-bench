DELETE FROM ${catalog}.${database}.web_sales
WHERE (ws_item_sk, ws_order_number) IN (${multi_values_clause});
