ALTER TABLE ${catalog}.${database}.web_returns EXECUTE optimize WHERE wr_returned_date_sk IS NULL;
