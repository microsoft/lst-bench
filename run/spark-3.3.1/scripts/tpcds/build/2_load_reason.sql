INSERT
    INTO
        ${catalog}.${database}.reason SELECT
            *
        FROM
            ${external_catalog}.${external_database}.reason;
