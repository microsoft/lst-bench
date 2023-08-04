INSERT
    INTO
        ${catalog}.${database}.part SELECT
            *
        FROM
            ${external_catalog}.${external_database}.part;
