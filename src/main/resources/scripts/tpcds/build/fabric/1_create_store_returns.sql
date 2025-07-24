CREATE TABLE store_returns
(
    SR_RETURNED_DATE_SK       int,
    SR_RETURN_TIME_SK         int,
    SR_ITEM_SK                int,
    SR_CUSTOMER_SK            int,
    SR_CDEMO_SK               int,
    SR_HDEMO_SK               int,
    SR_ADDR_SK                int,
    SR_STORE_SK               int,
    SR_REASON_SK              int,
    SR_TICKET_NUMBER          int,
    SR_RETURN_QUANTITY        int,
    SR_RETURN_AMT             decimal(7,2),
    SR_RETURN_TAX             decimal(7,2),
    SR_RETURN_AMT_INC_TAX     decimal(7,2),
    SR_FEE                    decimal(7,2),
    SR_RETURN_SHIP_COST       decimal(7,2),
    SR_REFUNDED_CASH          decimal(7,2),
    SR_REVERSED_CHARGE        decimal(7,2),
    SR_STORE_CREDIT           decimal(7,2),
    SR_NET_LOSS               decimal(7,2)
);