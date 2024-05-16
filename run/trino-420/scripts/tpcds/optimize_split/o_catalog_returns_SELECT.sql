SELECT DISTINCT cr_returned_date_sk AS cr_returned_date_sk
FROM ${catalog}.${database}.catalog_returns
WHERE cr_returned_date_sk IS NOT NULL
ORDER BY cr_returned_date_sk ASC;
