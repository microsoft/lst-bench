INSERT
    INTO
        ${catalog}.${database}.store_sales SELECT
            *
        FROM
            ${external_catalog}.${external_database}.store_sales;
