DELETE FROM ${catalog}.${database}.web_returns
WHERE wr_item_sk IN (${wr_item_sk}) AND wr_order_number IN (${wr_order_number});
