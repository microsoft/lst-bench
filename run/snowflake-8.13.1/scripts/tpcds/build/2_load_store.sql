INSERT
    INTO
        ${catalog}.${database}.store SELECT
            *
        FROM
            ${external_catalog}.${external_database}.store;
