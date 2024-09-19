DELETE FROM ${catalog}.${database}.web_returns
WHERE (wr_item_sk, wr_order_number) IN (${multi_values_clause});
