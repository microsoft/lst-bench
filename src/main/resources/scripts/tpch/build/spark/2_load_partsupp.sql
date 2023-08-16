INSERT INTO ${catalog}.${database}.partsupp
SELECT *
FROM   ${external_catalog}.${external_database}.partsupp;
