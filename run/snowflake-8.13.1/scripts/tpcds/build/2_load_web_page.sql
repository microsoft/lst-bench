INSERT
    INTO
        ${catalog}.${database}.web_page SELECT
            *
        FROM
            ${external_catalog}.${external_database}.web_page;
