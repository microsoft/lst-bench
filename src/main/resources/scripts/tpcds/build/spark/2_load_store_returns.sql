INSERT
    INTO
        ${catalog}.${database}.store_returns SELECT
            *
        FROM
            ${external_catalog}.${external_database}.store_returns;
