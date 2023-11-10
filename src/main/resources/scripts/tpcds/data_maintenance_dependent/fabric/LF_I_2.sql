CREATE VIEW iv_${stream_num} AS
    SELECT
        D_DATE_SK INV_DATE_SK,
        I_ITEM_SK INV_ITEM_SK,
        W_WAREHOUSE_SK INV_WAREHOUSE_SK,
        INVN_QTY_ON_HAND INV_QUANTITY_ON_HAND,
        row_number() over (order by D_DATE_SK, I_ITEM_SK, W_WAREHOUSE_SK) row_number
    FROM
        s_inventory_${stream_num}
    LEFT OUTER JOIN warehouse ON
        (
            INVN_WAREHOUSE_ID = W_WAREHOUSE_ID
        )
    LEFT OUTER JOIN item ON
        (
            INVN_ITEM_ID = I_ITEM_ID
            AND I_REC_END_DATE IS NULL
        )
    LEFT OUTER JOIN date_dim ON
        (
            D_DATE = CAST(INVN_DATE AS DATE)
        );
