COPY INTO [web_sales]
FROM '${external_catalog_base_url}/${external_catalog_size}/web_sales/*.parquet' WITH (
        FILE_TYPE = 'Parquet',
        CREDENTIAL = (
            IDENTITY = 'Shared Access Signature',
            SECRET = '${external_catalog_secret_token}'
        )
    );