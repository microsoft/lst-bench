INSERT INTO ${catalog}.${database}.supplier
SELECT *
FROM   ${external_catalog}.${external_database}.supplier;
