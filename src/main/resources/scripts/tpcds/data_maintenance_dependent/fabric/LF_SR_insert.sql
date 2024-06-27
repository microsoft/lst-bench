INSERT INTO store_returns
    SELECT
        SR_RETURNED_DATE_SK,
        SR_RETURN_TIME_SK,
        SR_ITEM_SK,
        SR_CUSTOMER_SK,
        SR_CDEMO_SK,
        SR_HDEMO_SK,
        SR_ADDR_SK,
        SR_STORE_SK,
        SR_REASON_SK,
        SR_TICKET_NUMBER,
        SR_RETURN_QUANTITY,
        SR_RETURN_AMT,
        SR_RETURN_TAX,
        SR_RETURN_AMT_INC_TAX,
        SR_FEE,
        SR_RETURN_SHIP_COST,
        SR_REFUNDED_CASH,
        SR_REVERSED_CHARGE,
        SR_STORE_CREDIT,
        SR_NET_LOSS
    FROM
        srv_${stream_num}
    WHERE row_number IN (${row_number});