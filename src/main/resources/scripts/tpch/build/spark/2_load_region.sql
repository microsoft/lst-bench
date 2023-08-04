INSERT
    INTO
        ${catalog}.${database}.region SELECT
            *
        FROM
            ${external_catalog}.${external_database}.region;
