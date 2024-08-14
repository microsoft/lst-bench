CREATE
    TABLE
        ${catalog}.${database}.catalog_page(
            cp_catalog_page_sk INT,
            cp_catalog_page_id VARCHAR(16),
            cp_start_date_sk INT,
            cp_end_date_sk INT,
            cp_department VARCHAR(50),
            cp_catalog_number INT,
            cp_catalog_page_number INT,
            cp_description VARCHAR(100),
            cp_type VARCHAR(100)
        );