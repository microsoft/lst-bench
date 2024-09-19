CREATE
    TABLE
        ${catalog}.${database}.store_returns(
            sr_return_time_sk INT,
            sr_item_sk INT,
            sr_customer_sk INT,
            sr_cdemo_sk INT,
            sr_hdemo_sk INT,
            sr_addr_sk INT,
            sr_store_sk INT,
            sr_reason_sk INT,
            sr_ticket_number BIGINT,
            sr_return_quantity INT,
            sr_return_amt DECIMAL(
                7,
                2
            ),
            sr_return_tax DECIMAL(
                7,
                2
            ),
            sr_return_amt_inc_tax DECIMAL(
                7,
                2
            ),
            sr_fee DECIMAL(
                7,
                2
            ),
            sr_return_ship_cost DECIMAL(
                7,
                2
            ),
            sr_refunded_cash DECIMAL(
                7,
                2
            ),
            sr_reversed_charge DECIMAL(
                7,
                2
            ),
            sr_store_credit DECIMAL(
                7,
                2
            ),
            sr_net_loss DECIMAL(
                7,
                2
            ),
            sr_returned_date_sk INT
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/store_returns/'
        ) PARTITIONED BY(sr_returned_date_sk) TBLPROPERTIES(
            'primaryKey' = 'sr_item_sk,sr_ticket_number' ${tblproperties_suffix}
        );
