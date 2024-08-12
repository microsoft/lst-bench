CREATE
    ICEBERG TABLE
        ${catalog}.${database}.catalog_returns(
            cr_returned_date_sk INT,
            cr_returned_time_sk INT,
            cr_item_sk INT,
            cr_refunded_customer_sk INT,
            cr_refunded_cdemo_sk INT,
            cr_refunded_hdemo_sk INT,
            cr_refunded_addr_sk INT,
            cr_returning_customer_sk INT,
            cr_returning_cdemo_sk INT,
            cr_returning_hdemo_sk INT,
            cr_returning_addr_sk INT,
            cr_call_center_sk INT,
            cr_catalog_page_sk INT,
            cr_ship_mode_sk INT,
            cr_warehouse_sk INT,
            cr_reason_sk INT,
            cr_order_number long,
            cr_return_quantity INT,
            cr_return_amount DECIMAL(
                7,
                2
            ),
            cr_return_tax DECIMAL(
                7,
                2
            ),
            cr_return_amt_inc_tax DECIMAL(
                7,
                2
            ),
            cr_fee DECIMAL(
                7,
                2
            ),
            cr_return_ship_cost DECIMAL(
                7,
                2
            ),
            cr_refunded_cash DECIMAL(
                7,
                2
            ),
            cr_reversed_charge DECIMAL(
                7,
                2
            ),
            cr_store_credit DECIMAL(
                7,
                2
            ),
            cr_net_loss DECIMAL(
                7,
                2
            )
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}'
        CLUSTER BY (cr_returned_date_sk);