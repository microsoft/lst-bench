INSERT
    INTO
        ${catalog}.${database}.lineitem SELECT
            *
        FROM
            ${external_catalog}.${external_database}.lineitem;
