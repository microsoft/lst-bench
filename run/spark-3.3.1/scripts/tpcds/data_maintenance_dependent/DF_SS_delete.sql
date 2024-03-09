DELETE FROM ${catalog}.${database}.store_sales
WHERE (ss_item_sk, ss_ticket_number) IN (${multi_values_clause});
