SELECT DISTINCT cs_sold_date_sk AS cs_sold_date_sk
FROM ${catalog}.${database}.catalog_sales
WHERE cs_sold_date_sk IS NOT NULL
ORDER BY cs_sold_date_sk ASC;
