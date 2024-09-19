INSERT
    INTO
        ${catalog}.${database}.time_dim SELECT
            *
        FROM
            ${external_catalog}.${external_database}.time_dim;
