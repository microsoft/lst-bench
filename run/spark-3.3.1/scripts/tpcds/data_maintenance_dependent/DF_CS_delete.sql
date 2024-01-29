DELETE FROM ${catalog}.${database}.catalog_sales
WHERE cs_item_sk IN (${cs_item_sk}) AND cs_order_number IN (${cs_order_number});
