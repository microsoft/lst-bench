CREATE
    ICEBERG TABLE
        ${catalog}.${database}.web_sales(
            ws_sold_date_sk INT,
            ws_sold_time_sk INT,
            ws_ship_date_sk INT,
            ws_item_sk INT,
            ws_bill_customer_sk INT,
            ws_bill_cdemo_sk INT,
            ws_bill_hdemo_sk INT,
            ws_bill_addr_sk INT,
            ws_ship_customer_sk INT,
            ws_ship_cdemo_sk INT,
            ws_ship_hdemo_sk INT,
            ws_ship_addr_sk INT,
            ws_web_page_sk INT,
            ws_web_site_sk INT,
            ws_ship_mode_sk INT,
            ws_warehouse_sk INT,
            ws_promo_sk INT,
            ws_order_number long,
            ws_quantity INT,
            ws_wholesale_cost DECIMAL(
                7,
                2
            ),
            ws_list_price DECIMAL(
                7,
                2
            ),
            ws_sales_price DECIMAL(
                7,
                2
            ),
            ws_ext_discount_amt DECIMAL(
                7,
                2
            ),
            ws_ext_sales_price DECIMAL(
                7,
                2
            ),
            ws_ext_wholesale_cost DECIMAL(
                7,
                2
            ),
            ws_ext_list_price DECIMAL(
                7,
                2
            ),
            ws_ext_tax DECIMAL(
                7,
                2
            ),
            ws_coupon_amt DECIMAL(
                7,
                2
            ),
            ws_ext_ship_cost DECIMAL(
                7,
                2
            ),
            ws_net_paid DECIMAL(
                7,
                2
            ),
            ws_net_paid_inc_tax DECIMAL(
                7,
                2
            ),
            ws_net_paid_inc_ship DECIMAL(
                7,
                2
            ),
            ws_net_paid_inc_ship_tax DECIMAL(
                7,
                2
            ),
            ws_net_profit DECIMAL(
                7,
                2
            )
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}'
        CLUSTER BY (ws_sold_date_sk);