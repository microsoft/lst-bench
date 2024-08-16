INSERT
    INTO
        ${catalog}.${database}.inventory SELECT
            *
        FROM
            ${external_catalog}.${external_database}.inventory;
