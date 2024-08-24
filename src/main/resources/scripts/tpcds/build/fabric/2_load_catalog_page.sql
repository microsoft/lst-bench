COPY INTO [catalog_page]
FROM '${external_catalog_base_url}/${external_catalog_size}/catalog_page/*.parquet' WITH (
        FILE_TYPE = 'Parquet',
        CREDENTIAL = (
            IDENTITY = 'Shared Access Signature',
            SECRET = '${external_catalog_secret_token}'
        )
    );