DELETE FROM ${catalog}.${database}.web_sales
WHERE ws_item_sk IN (${ws_item_sk}) AND ws_order_number IN (${ws_order_number});
