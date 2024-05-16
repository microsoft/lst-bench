SELECT DISTINCT sr_returned_date_sk AS sr_returned_date_sk
FROM ${catalog}.${database}.store_returns
WHERE sr_returned_date_sk IS NOT NULL
ORDER BY sr_returned_date_sk ASC;
