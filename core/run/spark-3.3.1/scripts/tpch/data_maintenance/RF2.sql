DELETE
FROM
    ${catalog}.${database}.orders
WHERE
    o_orderkey IN(
        SELECT
            dele_key
        FROM
            ${external_catalog}.${external_database}.s_delete_${stream_num}
    );

DELETE
FROM
    ${catalog}.${database}.lineitem
WHERE
    l_orderkey IN(
        SELECT
            dele_key
        FROM
            ${external_catalog}.${external_database}.s_delete_${stream_num}
    );
