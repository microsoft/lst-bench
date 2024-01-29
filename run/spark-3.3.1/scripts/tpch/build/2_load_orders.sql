INSERT INTO ${catalog}.${database}.orders
SELECT *
FROM   ${external_catalog}.${external_database}.orders;
