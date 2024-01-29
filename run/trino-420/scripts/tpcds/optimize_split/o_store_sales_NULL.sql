ALTER TABLE ${catalog}.${database}.store_sales EXECUTE optimize WHERE ss_sold_date_sk IS NULL;
