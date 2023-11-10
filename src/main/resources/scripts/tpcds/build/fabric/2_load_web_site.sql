COPY INTO [web_site]
FROM '${external_catalog_base_url}/${external_catalog_size}/web_site/*.parquet' WITH (
        FILE_TYPE = 'Parquet',
        CREDENTIAL = (
            IDENTITY = 'Shared Access Signature',
            SECRET = '${external_catalog_secret_token}'
        )
    );