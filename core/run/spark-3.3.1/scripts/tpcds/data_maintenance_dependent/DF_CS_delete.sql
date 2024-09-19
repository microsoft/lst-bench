DELETE FROM ${catalog}.${database}.catalog_sales
WHERE (cs_item_sk, cs_order_number) IN (${multi_values_clause});
