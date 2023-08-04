INSERT
    INTO
        ${catalog}.${database}.nation SELECT
            *
        FROM
            ${external_catalog}.${external_database}.nation;
