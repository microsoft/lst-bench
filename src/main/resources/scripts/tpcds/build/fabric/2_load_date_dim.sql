COPY INTO [date_dim]
FROM '${external_catalog_base_url}/${external_catalog_size}/date_dim/*.parquet' WITH (
        FILE_TYPE = 'Parquet',
        CREDENTIAL = (
            IDENTITY = 'Shared Access Signature',
            SECRET = '${external_catalog_secret_token}'
        )
    );