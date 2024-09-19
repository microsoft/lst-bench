MERGE INTO
    ${catalog}.${database}.orders
USING(
    SELECT
        dele_key
    FROM
        ${external_catalog}.${external_database}.s_delete_${stream_num}
) SOURCE ON
o_orderkey = dele_key
WHEN MATCHED THEN DELETE;

MERGE INTO
    ${catalog}.${database}.lineitem
USING(
    SELECT
        dele_key
    FROM
        ${external_catalog}.${external_database}.s_delete_${stream_num}
) SOURCE ON
l_orderkey = dele_key
WHEN MATCHED THEN DELETE;
