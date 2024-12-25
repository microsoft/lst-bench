INSERT INTO store_sales
    SELECT
        SS_SOLD_DATE_SK,
        SS_SOLD_TIME_SK,
        SS_ITEM_SK,
        SS_CUSTOMER_SK,
        SS_CDEMO_SK,
        SS_HDEMO_SK,
        SS_ADDR_SK,
        SS_STORE_SK,
        SS_PROMO_SK,
        SS_TICKET_NUMBER,
        SS_QUANTITY,
        SS_WHOLESALE_COST,
        SS_LIST_PRICE,
        SS_SALES_PRICE,
        SS_EXT_DISCOUNT_AMT,
        SS_EXT_SALES_PRICE,
        SS_EXT_WHOLESALE_COST,
        SS_EXT_LIST_PRICE,
        SS_EXT_TAX,
        SS_COUPON_AMT,
        SS_NET_PAID,
        SS_NET_PAID_INC_TAX,
        SS_NET_PROFIT
    FROM
        ssv_${stream_num}
    WHERE row_number IN (${row_number});