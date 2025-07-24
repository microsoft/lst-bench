COPY INTO [call_center]
FROM '${external_catalog_base_url}/${external_catalog_size}/call_center/*.parquet' WITH (
        FILE_TYPE = 'Parquet',
        CREDENTIAL = (
            IDENTITY = 'Shared Access Signature',
            SECRET = '${external_catalog_secret_token}'
        )
    );