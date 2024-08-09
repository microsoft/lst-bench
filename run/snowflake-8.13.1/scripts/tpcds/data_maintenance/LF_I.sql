DROP
    VIEW IF EXISTS ${external_catalog}.${external_database}.iv_${stream_num};

CREATE
    VIEW ${external_catalog}.${external_database}.iv_${stream_num} AS SELECT
        d_date_sk inv_date_sk,
        i_item_sk inv_item_sk,
        w_warehouse_sk inv_warehouse_sk,
        invn_qty_on_hand inv_quantity_on_hand
    FROM
        ${external_catalog}.${external_database}.s_inventory_${stream_num}
    LEFT OUTER JOIN ${catalog}.${database}.warehouse ON
        (
            invn_warehouse_id = w_warehouse_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.item ON
        (
            invn_item_id = i_item_id
            AND i_rec_end_date IS NULL
        )
    LEFT OUTER JOIN ${catalog}.${database}.date_dim ON
        (
            d_date = CAST(
                invn_date AS DATE
            )
        );

INSERT
    INTO
        ${catalog}.${database}.inventory SELECT
            INV_ITEM_SK,
            INV_WAREHOUSE_SK,
            INV_QUANTITY_ON_HAND,
            INV_DATE_SK
        FROM
            ${external_catalog}.${external_database}.iv_${stream_num};
