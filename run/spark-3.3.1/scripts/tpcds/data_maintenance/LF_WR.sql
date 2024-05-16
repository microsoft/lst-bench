DROP
    VIEW IF EXISTS ${external_catalog}.${external_database}.wrv_${stream_num};

CREATE
    VIEW ${external_catalog}.${external_database}.wrv_${stream_num} AS SELECT
        d_date_sk wr_return_date_sk,
        t_time_sk wr_return_time_sk,
        i_item_sk wr_item_sk,
        c1.c_customer_sk wr_refunded_customer_sk,
        c1.c_current_cdemo_sk wr_refunded_cdemo_sk,
        c1.c_current_hdemo_sk wr_refunded_hdemo_sk,
        c1.c_current_addr_sk wr_refunded_addr_sk,
        c2.c_customer_sk wr_returning_customer_sk,
        c2.c_current_cdemo_sk wr_returning_cdemo_sk,
        c2.c_current_hdemo_sk wr_returning_hdemo_sk,
        c2.c_current_addr_sk wr_returning_addr_sk,
        wp_web_page_sk wr_web_page_sk,
        r_reason_sk wr_reason_sk,
        wret_order_id wr_order_number,
        wret_return_qty wr_return_quantity,
        wret_return_amt wr_return_amt,
        wret_return_tax wr_return_tax,
        wret_return_amt + wret_return_tax AS wr_return_amt_inc_tax,
        wret_return_fee wr_fee,
        wret_return_ship_cost wr_return_ship_cost,
        wret_refunded_cash wr_refunded_cash,
        wret_reversed_charge wr_reversed_charge,
        wret_account_credit wr_account_credit,
        wret_return_amt + wret_return_tax + wret_return_fee - wret_refunded_cash - wret_reversed_charge - wret_account_credit wr_net_loss
    FROM
        ${external_catalog}.${external_database}.s_web_returns_${stream_num}
    LEFT OUTER JOIN ${catalog}.${database}.date_dim ON
        (
            CAST(
                wret_return_date AS DATE
            )= d_date
        )
    LEFT OUTER JOIN ${catalog}.${database}.time_dim ON
        (
            (
                CAST(
                    SUBSTR(
                        wret_return_time,
                        1,
                        2
                    ) AS INTEGER
                )* 3600 + CAST(
                    SUBSTR(
                        wret_return_time,
                        4,
                        2
                    ) AS INTEGER
                )* 60 + CAST(
                    SUBSTR(
                        wret_return_time,
                        7,
                        2
                    ) AS INTEGER
                )
            )= t_time
        )
    LEFT OUTER JOIN ${catalog}.${database}.item ON
        (
            wret_item_id = i_item_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.customer c1 ON
        (
            wret_return_customer_id = c1.c_customer_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.customer c2 ON
        (
            wret_refund_customer_id = c2.c_customer_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.reason ON
        (
            wret_reason_id = r_reason_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.web_page ON
        (
            wret_web_site_id = WP_WEB_PAGE_id
        )
    WHERE
        i_rec_end_date IS NULL
        AND wp_rec_end_date IS NULL;

INSERT
    INTO
        ${catalog}.${database}.web_returns SELECT
            wr_return_time_sk,
            wr_item_sk,
            wr_refunded_customer_sk,
            wr_refunded_cdemo_sk,
            wr_refunded_hdemo_sk,
            wr_refunded_addr_sk,
            wr_returning_customer_sk,
            wr_returning_cdemo_sk,
            wr_returning_hdemo_sk,
            wr_returning_addr_sk,
            wr_web_page_sk,
            wr_reason_sk,
            wr_order_number,
            wr_return_quantity,
            wr_return_amt,
            wr_return_tax,
            wr_return_amt_inc_tax,
            wr_fee,
            wr_return_ship_cost,
            wr_refunded_cash,
            wr_reversed_charge,
            wr_account_credit,
            wr_net_loss,
            wr_return_date_sk
        FROM
            ${external_catalog}.${external_database}.wrv_${stream_num};
