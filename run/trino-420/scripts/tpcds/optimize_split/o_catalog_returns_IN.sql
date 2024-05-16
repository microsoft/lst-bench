ALTER TABLE ${catalog}.${database}.catalog_returns EXECUTE optimize WHERE cr_returned_date_sk IN (${cr_returned_date_sk});
