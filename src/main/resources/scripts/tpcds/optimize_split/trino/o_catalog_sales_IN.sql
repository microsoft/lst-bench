ALTER TABLE ${catalog}.${database}.catalog_sales EXECUTE optimize WHERE cs_sold_date_sk IN (${cs_sold_date_sk});
