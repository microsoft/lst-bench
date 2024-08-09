DROP
    VIEW IF EXISTS ${external_catalog}.${external_database}.srv_${stream_num};

CREATE
    VIEW ${external_catalog}.${external_database}.srv_${stream_num} AS SELECT
        d_date_sk sr_returned_date_sk,
        t_time_sk sr_return_time_sk,
        i_item_sk sr_item_sk,
        c_customer_sk sr_customer_sk,
        c_current_cdemo_sk sr_cdemo_sk,
        c_current_hdemo_sk sr_hdemo_sk,
        c_current_addr_sk sr_addr_sk,
        s_store_sk sr_store_sk,
        r_reason_sk sr_reason_sk,
        CAST(
            sret_ticket_number AS BIGINT
        ) sr_ticket_number,
        sret_return_qty sr_return_quantity,
        sret_return_amt sr_return_amt,
        sret_return_tax sr_return_tax,
        sret_return_amt + sret_return_tax sr_return_amt_inc_tax,
        sret_return_fee sr_fee,
        sret_return_ship_cost sr_return_ship_cost,
        sret_refunded_cash sr_refunded_cash,
        sret_reversed_charge sr_reversed_charge,
        sret_store_credit sr_store_credit,
        sret_return_amt + sret_return_tax + sret_return_fee - sret_refunded_cash - sret_reversed_charge - sret_store_credit sr_net_loss
    FROM
        ${external_catalog}.${external_database}.s_store_returns_${stream_num}
    LEFT OUTER JOIN ${catalog}.${database}.date_dim ON
        (
            CAST(
                sret_return_date AS DATE
            )= d_date
        )
    LEFT OUTER JOIN ${catalog}.${database}.time_dim ON
        (
            (
                CAST(
                    substr(
                        sret_return_time,
                        1,
                        2
                    ) AS INTEGER
                )* 3600 + CAST(
                    substr(
                        sret_return_time,
                        4,
                        2
                    ) AS INTEGER
                )* 60 + CAST(
                    substr(
                        sret_return_time,
                        7,
                        2
                    ) AS INTEGER
                )
            )= t_time
        )
    LEFT OUTER JOIN ${catalog}.${database}.item ON
        (
            sret_item_id = i_item_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.customer ON
        (
            sret_customer_id = c_customer_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.store ON
        (
            sret_store_id = s_store_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.reason ON
        (
            sret_reason_id = r_reason_id
        )
    WHERE
        i_rec_end_date IS NULL
        AND s_rec_end_date IS NULL;

INSERT
    INTO
        ${catalog}.${database}.store_returns SELECT
            sr_returned_date_sk,
            sr_return_time_sk,
            sr_item_sk,
            sr_customer_sk,
            sr_cdemo_sk,
            sr_hdemo_sk,
            sr_addr_sk,
            sr_store_sk,
            sr_reason_sk,
            sr_ticket_number,
            sr_return_quantity,
            sr_return_amt,
            sr_return_tax,
            sr_return_amt_inc_tax,
            sr_fee,
            sr_return_ship_cost,
            sr_refunded_cash,
            sr_reversed_charge,
            sr_store_credit,
            sr_net_loss
        FROM
            ${external_catalog}.${external_database}.srv_${stream_num};