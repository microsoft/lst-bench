ALTER TABLE ${catalog}.${database}.store_returns EXECUTE optimize WHERE sr_returned_date_sk IN (${sr_returned_date_sk});
