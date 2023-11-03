SELECT DISTINCT inv_date_sk AS inv_date_sk
FROM ${catalog}.${database}.inventory
WHERE inv_date_sk IS NOT NULL
ORDER BY inv_date_sk ASC;
