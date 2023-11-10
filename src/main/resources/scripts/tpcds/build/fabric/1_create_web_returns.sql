CREATE TABLE web_returns
(
    WR_RETURNED_DATE_SK             int,
    WR_RETURNED_TIME_SK             int,
    WR_ITEM_SK                      int,
    WR_REFUNDED_CUSTOMER_SK         int,
    WR_REFUNDED_CDEMO_SK            int,
    WR_REFUNDED_HDEMO_SK            int,
    WR_REFUNDED_ADDR_SK             int,
    WR_RETURNING_CUSTOMER_SK        int,
    WR_RETURNING_CDEMO_SK           int,
    WR_RETURNING_HDEMO_SK           int,
    WR_RETURNING_ADDR_SK            int,
    WR_WEB_PAGE_SK                  int,
    WR_REASON_SK                    int,
    WR_ORDER_NUMBER                 int,
    WR_RETURN_QUANTITY              int,
    WR_RETURN_AMT                   decimal(7,2),
    WR_RETURN_TAX                   decimal(7,2),
    WR_RETURN_AMT_INC_TAX           decimal(7,2),
    WR_FEE                          decimal(7,2),
    WR_RETURN_SHIP_COST             decimal(7,2),
    WR_REFUNDED_CASH                decimal(7,2),
    WR_REVERSED_CHARGE              decimal(7,2),
    WR_ACCOUNT_CREDIT               decimal(7,2),
    WR_NET_LOSS                     decimal(7,2)
);