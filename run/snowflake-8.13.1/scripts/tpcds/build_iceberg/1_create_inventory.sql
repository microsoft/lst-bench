CREATE
    ICEBERG TABLE
        ${catalog}.${database}.inventory(
            inv_item_sk INT,
            inv_warehouse_sk INT,
            inv_quantity_on_hand INT,
            inv_date_sk INT
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';