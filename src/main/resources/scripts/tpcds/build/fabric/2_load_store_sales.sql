COPY INTO [store_sales]
FROM '${external_catalog_base_url}/${external_catalog_size}/store_sales/*.parquet' WITH (
        FILE_TYPE = 'Parquet',
        CREDENTIAL = (
            IDENTITY = 'Shared Access Signature',
            SECRET = '${external_catalog_secret_token}'
        )
    );