CREATE
    TABLE
        ${catalog}.${database}.inventory(
            inv_item_sk INT,
            inv_warehouse_sk INT,
            inv_quantity_on_hand INT,
            inv_date_sk INT
        );