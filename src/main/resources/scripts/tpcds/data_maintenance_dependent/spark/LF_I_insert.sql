INSERT INTO ${catalog}.${database}.inventory
    SELECT
        INV_ITEM_SK,
        INV_WAREHOUSE_SK,
        INV_QUANTITY_ON_HAND,
        INV_DATE_SK
    FROM
        ${external_catalog}.${external_database}.iv_${stream_num}
    WHERE row_number IN (${row_number});