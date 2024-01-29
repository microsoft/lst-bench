SELECT DISTINCT ss_sold_date_sk AS ss_sold_date_sk
FROM ${catalog}.${database}.store_sales
WHERE ss_sold_date_sk IS NOT NULL
ORDER BY ss_sold_date_sk ASC;
