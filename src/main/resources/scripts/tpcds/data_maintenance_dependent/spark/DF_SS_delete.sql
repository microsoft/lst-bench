DELETE FROM ${catalog}.${database}.store_sales
WHERE ss_item_sk IN (${ss_item_sk}) AND ss_ticket_number IN (${ss_ticket_number});
