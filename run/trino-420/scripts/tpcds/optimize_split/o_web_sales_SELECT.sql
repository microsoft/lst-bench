SELECT DISTINCT ws_sold_date_sk AS ws_sold_date_sk
FROM ${catalog}.${database}.web_sales
WHERE ws_sold_date_sk IS NOT NULL
ORDER BY ws_sold_date_sk ASC;
