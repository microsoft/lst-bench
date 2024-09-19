ALTER TABLE ${catalog}.${database}.web_sales EXECUTE optimize WHERE ws_sold_date_sk IS NULL;
