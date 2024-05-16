SELECT DISTINCT wr_returned_date_sk AS wr_returned_date_sk
FROM ${catalog}.${database}.web_returns
WHERE wr_returned_date_sk IS NOT NULL
ORDER BY wr_returned_date_sk ASC;
