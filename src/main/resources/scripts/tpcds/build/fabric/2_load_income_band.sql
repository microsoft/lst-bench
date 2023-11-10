COPY INTO [income_band]
FROM '${external_catalog_base_url}/${external_catalog_size}/income_band/*.parquet' WITH (
        FILE_TYPE = 'Parquet',
        CREDENTIAL = (
            IDENTITY = 'Shared Access Signature',
            SECRET = '${external_catalog_secret_token}'
        )
    );