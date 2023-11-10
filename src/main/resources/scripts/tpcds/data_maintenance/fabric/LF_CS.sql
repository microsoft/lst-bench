DROP VIEW IF EXISTS csv_${stream_num};

CREATE VIEW csv_${stream_num}
AS SELECT d1.D_DATE_SK CS_SOLD_DATE_SK
,T_TIME_SK CS_SOLD_TIME_SK
,d2.D_DATE_SK CS_SHIP_DATE_SK
,c1.C_CUSTOMER_SK CS_BILL_CUSTOMER_SK
,c1.C_CURRENT_CDEMO_SK CS_BILL_CDEMO_SK
,c1.C_CURRENT_HDEMO_SK CS_BILL_HDEMO_SK
,c1.C_CURRENT_ADDR_SK CS_BILL_ADDR_SK
,c2.C_CUSTOMER_SK CS_SHIP_CUSTOMER_SK
,c2.C_CURRENT_CDEMO_SK CS_SHIP_CDEMO_SK
,c2.C_CURRENT_HDEMO_SK CS_SHIP_HDEMO_SK
,c2.C_CURRENT_ADDR_SK CS_SHIP_ADDR_SK
,CC_CALL_CENTER_SK CS_CALL_CENTER_SK
,CP_CATALOG_PAGE_SK CS_CATALOG_PAGE_SK
,SM_SHIP_MODE_SK CS_SHIP_MODE_SK
,W_WAREHOUSE_SK CS_WAREHOUSE_SK
,I_ITEM_SK CS_ITEM_SK
,P_PROMO_SK CS_PROMO_SK
,CORD_ORDER_ID CS_ORDER_NUMBER
,CLIN_QUANTITY CS_QUANTITY
,I_WHOLESALE_COST CS_WHOLESALE_COST
,I_CURRENT_PRICE CS_LIST_PRICE
,CLIN_SALES_PRICE CS_SALES_PRICE
,(I_CURRENT_PRICE-CLIN_SALES_PRICE)*CLIN_QUANTITY CS_EXT_DISCOUNT_AMT
,(CLIN_SALES_PRICE * CLIN_QUANTITY) CS_EXT_SALES_PRICE
,(I_WHOLESALE_COST * CLIN_QUANTITY) CS_EXT_WHOLESALE_COST
,(I_CURRENT_PRICE * CLIN_QUANTITY) CS_EXT_LIST_PRICE
,(I_CURRENT_PRICE * CC_TAX_PERCENTAGE) CS_EXT_TAX
,CLIN_COUPON_AMT CS_COUPON_AMT
,(CLIN_SHIP_COST * CLIN_QUANTITY) CS_EXT_SHIP_COST
,(CLIN_SALES_PRICE * CLIN_QUANTITY)-CLIN_COUPON_AMT CS_NET_PAID
,(((CLIN_SALES_PRICE * CLIN_QUANTITY)-CLIN_COUPON_AMT)*(1+CC_TAX_PERCENTAGE)) CS_NET_PAID_INC_TAX
,((CLIN_SALES_PRICE * CLIN_QUANTITY)-CLIN_COUPON_AMT + (CLIN_SHIP_COST * CLIN_QUANTITY)) CS_NET_PAID_INC_SHIP
,((CLIN_SALES_PRICE * CLIN_QUANTITY)-CLIN_COUPON_AMT + (CLIN_SHIP_COST * CLIN_QUANTITY) + I_CURRENT_PRICE * CC_TAX_PERCENTAGE) CS_NET_PAID_INC_SHIP_TAX
,(((CLIN_SALES_PRICE * CLIN_QUANTITY)-CLIN_COUPON_AMT)-(CLIN_QUANTITY*I_WHOLESALE_COST)) CS_NET_PROFIT
FROM
s_catalog_order_${stream_num}
LEFT OUTER JOIN date_dim d1 ON
(CAST(CORD_ORDER_DATE AS DATE) = d1.D_DATE)
LEFT OUTER JOIN time_dim ON (CORD_ORDER_TIME = T_TIME)
LEFT OUTER JOIN customer c1 ON (CORD_BILL_CUSTOMER_ID = c1.C_CUSTOMER_ID)
LEFT OUTER JOIN customer c2 ON (CORD_SHIP_CUSTOMER_ID = c2.C_CUSTOMER_ID)
LEFT OUTER JOIN call_center ON (CORD_CALL_CENTER_ID = CC_CALL_CENTER_ID AND CC_REC_END_DATE IS NULL)
LEFT OUTER JOIN ship_mode ON (CORD_SHIP_MODE_ID = SM_SHIP_MODE_ID)
JOIN s_catalog_order_lineitem_${stream_num} ON (CORD_ORDER_ID = CLIN_ORDER_ID)
LEFT OUTER JOIN date_dim d2 ON
(CAST(CLIN_SHIP_DATE AS DATE) = d2.D_DATE)
LEFT OUTER JOIN catalog_page ON
(CLIN_CATALOG_PAGE_NUMBER = CP_CATALOG_PAGE_NUMBER AND CLIN_CATALOG_NUMBER = CP_CATALOG_NUMBER)
LEFT OUTER JOIN warehouse ON (CLIN_WAREHOUSE_ID = W_WAREHOUSE_ID)
LEFT OUTER JOIN item ON (CLIN_ITEM_ID = I_ITEM_ID AND I_REC_END_DATE IS NULL)
LEFT OUTER JOIN promotion ON (CLIN_PROMOTION_ID = P_PROMO_ID);

INSERT INTO catalog_sales SELECT
CS_SOLD_DATE_SK,CS_SOLD_TIME_SK,CS_SHIP_DATE_SK,CS_BILL_CUSTOMER_SK,CS_BILL_CDEMO_SK,CS_BILL_HDEMO_SK,CS_BILL_ADDR_SK,CS_SHIP_CUSTOMER_SK,CS_SHIP_CDEMO_SK,CS_SHIP_HDEMO_SK,CS_SHIP_ADDR_SK,CS_CALL_CENTER_SK,CS_CATALOG_PAGE_SK,CS_SHIP_MODE_SK,CS_WAREHOUSE_SK,CS_ITEM_SK,CS_PROMO_SK,CS_ORDER_NUMBER,CS_QUANTITY,CS_WHOLESALE_COST,CS_LIST_PRICE,CS_SALES_PRICE,CS_EXT_DISCOUNT_AMT,CS_EXT_SALES_PRICE,CS_EXT_WHOLESALE_COST,CS_EXT_LIST_PRICE,CS_EXT_TAX,CS_COUPON_AMT,CS_EXT_SHIP_COST,CS_NET_PAID,CS_NET_PAID_INC_TAX,CS_NET_PAID_INC_SHIP,CS_NET_PAID_INC_SHIP_TAX,CS_NET_PROFIT
FROM csv_${stream_num};