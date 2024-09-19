DELETE FROM ${catalog}.${database}.inventory
WHERE (inv_date_sk, inv_item_sk, inv_warehouse_sk) IN (${multi_values_clause});
