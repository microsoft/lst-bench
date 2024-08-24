INSERT INTO inventory
    SELECT
        INV_DATE_SK,
        INV_ITEM_SK,
        INV_WAREHOUSE_SK,
        INV_QUANTITY_ON_HAND
    FROM
        iv_${stream_num}
    WHERE row_number IN (${row_number});