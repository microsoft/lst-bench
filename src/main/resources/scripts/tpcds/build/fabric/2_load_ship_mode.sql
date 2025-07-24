COPY INTO [ship_mode]
FROM '${external_catalog_base_url}/${external_catalog_size}/ship_mode/*.parquet' WITH (
        FILE_TYPE = 'Parquet',
        CREDENTIAL = (
            IDENTITY = 'Shared Access Signature',
            SECRET = '${external_catalog_secret_token}'
        )
    );