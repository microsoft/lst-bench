DROP
    VIEW IF EXISTS ${external_catalog}.${external_database}.crv_${stream_num};

CREATE
    VIEW ${external_catalog}.${external_database}.crv_${stream_num} AS SELECT
        d_date_sk cr_return_date_sk,
        t_time_sk cr_return_time_sk,
        i_item_sk cr_item_sk,
        c1.c_customer_sk cr_refunded_customer_sk,
        c1.c_current_cdemo_sk cr_refunded_cdemo_sk,
        c1.c_current_hdemo_sk cr_refunded_hdemo_sk,
        c1.c_current_addr_sk cr_refunded_addr_sk,
        c2.c_customer_sk cr_returning_customer_sk,
        c2.c_current_cdemo_sk cr_returning_cdemo_sk,
        c2.c_current_hdemo_sk cr_returning_hdemo_sk,
        c2.c_current_addr_sk cr_returning_addr_sk,
        cc_call_center_sk cr_call_center_sk,
        cp_catalog_page_sk CR_CATALOG_PAGE_SK,
        sm_ship_mode_sk CR_SHIP_MODE_SK,
        w_warehouse_sk CR_WAREHOUSE_SK,
        r_reason_sk cr_reason_sk,
        cret_order_id cr_order_number,
        cret_return_qty cr_return_quantity,
        cret_return_amt cr_return_amount,
        cret_return_tax cr_return_tax,
        cret_return_amt + cret_return_tax AS cr_return_amt_inc_tax,
        cret_return_fee cr_fee,
        cret_return_ship_cost cr_return_ship_cost,
        cret_refunded_cash cr_refunded_cash,
        cret_reversed_charge cr_reversed_charge,
        cret_merchant_credit cr_merchant_credit,
        cret_return_amt + cret_return_tax + cret_return_fee - cret_refunded_cash - cret_reversed_charge - cret_merchant_credit cr_net_loss
    FROM
        ${external_catalog}.${external_database}.s_catalog_returns_${stream_num}
    LEFT OUTER JOIN ${catalog}.${database}.date_dim ON
        (
            CAST(
                cret_return_date AS DATE
            )= d_date
        )
    LEFT OUTER JOIN ${catalog}.${database}.time_dim ON
        (
            (
                CAST(
                    substr(
                        cret_return_time,
                        1,
                        2
                    ) AS INTEGER
                )* 3600 + CAST(
                    substr(
                        cret_return_time,
                        4,
                        2
                    ) AS INTEGER
                )* 60 + CAST(
                    substr(
                        cret_return_time,
                        7,
                        2
                    ) AS INTEGER
                )
            )= t_time
        )
    LEFT OUTER JOIN ${catalog}.${database}.item ON
        (
            cret_item_id = i_item_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.customer c1 ON
        (
            cret_return_customer_id = c1.c_customer_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.customer c2 ON
        (
            cret_refund_customer_id = c2.c_customer_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.reason ON
        (
            cret_reason_id = r_reason_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.call_center ON
        (
            cret_call_center_id = cc_call_center_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.catalog_page ON
        (
            cret_catalog_page_id = cp_catalog_page_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.ship_mode ON
        (
            cret_shipmode_id = sm_ship_mode_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.warehouse ON
        (
            cret_warehouse_id = w_warehouse_id
        )
    WHERE
        i_rec_end_date IS NULL
        AND cc_rec_end_date IS NULL;

INSERT
    INTO
        ${catalog}.${database}.catalog_returns SELECT
            cr_return_date_sk,
            cr_return_time_sk,
            cr_item_sk,
            cr_refunded_customer_sk,
            cr_refunded_cdemo_sk,
            cr_refunded_hdemo_sk,
            cr_refunded_addr_sk,
            cr_returning_customer_sk,
            cr_returning_cdemo_sk,
            cr_returning_hdemo_sk,
            cr_returning_addr_sk,
            cr_call_center_sk,
            cr_catalog_page_sk,
            cr_ship_mode_sk,
            cr_warehouse_sk,
            cr_reason_sk,
            cr_order_number,
            cr_return_quantity,
            cr_return_amount,
            cr_return_tax,
            cr_return_amt_inc_tax,
            cr_fee,
            cr_return_ship_cost,
            cr_refunded_cash,
            cr_reversed_charge,
            cr_merchant_credit,
            cr_net_loss
        FROM
            ${external_catalog}.${external_database}.crv_${stream_num};