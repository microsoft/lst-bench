INSERT
    INTO
        ${catalog}.${database}.customer SELECT
            *
        FROM
            ${external_catalog}.${external_database}.customer;
