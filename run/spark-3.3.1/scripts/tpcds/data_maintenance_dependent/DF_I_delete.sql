DELETE FROM ${catalog}.${database}.inventory
WHERE inv_date_sk IN (${inv_date_sk}) AND inv_item_sk IN (${inv_item_sk}) AND inv_warehouse_sk IN (${inv_warehouse_sk});
