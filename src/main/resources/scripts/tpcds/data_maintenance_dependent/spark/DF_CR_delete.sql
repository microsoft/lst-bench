DELETE FROM ${catalog}.${database}.catalog_returns
WHERE cr_order_number IN (${cr_order_number});
