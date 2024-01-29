DELETE FROM ${catalog}.${database}.store_returns
WHERE sr_item_sk IN (${sr_item_sk}) AND sr_ticket_number IN (${sr_ticket_number});
