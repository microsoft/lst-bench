DELETE FROM ${catalog}.${database}.catalog_returns
WHERE cr_order_number IN (${dependent_replace});
