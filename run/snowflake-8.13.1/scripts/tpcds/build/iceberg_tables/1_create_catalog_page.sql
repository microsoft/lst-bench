CREATE
    ICEBERG TABLE
        ${catalog}.${database}.catalog_page(
            cp_catalog_page_sk INT,
            cp_catalog_page_id string,
            cp_start_date_sk INT,
            cp_end_date_sk INT,
            cp_department string,
            cp_catalog_number INT,
            cp_catalog_page_number INT,
            cp_description string,
            cp_type string
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';