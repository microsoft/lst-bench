INSERT
    INTO
        ${catalog}.${database}.promotion SELECT
            *
        FROM
            ${external_catalog}.${external_database}.promotion;
