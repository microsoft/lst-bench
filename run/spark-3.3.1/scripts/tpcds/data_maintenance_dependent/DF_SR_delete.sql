DELETE FROM ${catalog}.${database}.store_returns
WHERE (sr_item_sk, sr_ticket_number) IN (${multi_values_clause});
