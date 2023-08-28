CREATE VIEW ${external_catalog}.${external_database}.iv_${stream_num} AS
    SELECT
        d_date_sk inv_date_sk,
        i_item_sk inv_item_sk,
        w_warehouse_sk inv_warehouse_sk,
        invn_qty_on_hand inv_quantity_on_hand,
        row_number() over (order by d_date_sk, i_item_sk, w_warehouse_sk) row_number
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
