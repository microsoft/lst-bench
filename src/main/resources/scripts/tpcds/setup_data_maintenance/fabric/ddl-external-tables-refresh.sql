DROP TABLE IF EXISTS s_purchase_lineitem_${stream_num};
CREATE TABLE s_purchase_lineitem_${stream_num}
(
    PLIN_PURCHASE_ID            INTEGER                       ,
    PLIN_LINE_NUMBER            INTEGER                       ,
    PLIN_ITEM_ID                CHAR(16)                      ,
    PLIN_PROMOTION_ID           CHAR(16)                      ,
    PLIN_QUANTITY               BIGINT                        ,
    PLIN_SALE_PRICE             DECIMAL(7,2)                  ,
    PLIN_COUPON_AMT             DECIMAL(7,2)                  ,
    PLIN_COMMENT                VARCHAR(100)                  
);

COPY INTO
s_purchase_lineitem_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_purchase_lineitem/s_purchase_lineitem_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_catalog_order_${stream_num};
CREATE TABLE s_catalog_order_${stream_num}
(
    CORD_ORDER_ID               INTEGER                       ,
    CORD_BILL_CUSTOMER_ID       CHAR(16)                      ,
    CORD_SHIP_CUSTOMER_ID       CHAR(16)                      ,
    CORD_ORDER_DATE             CHAR(10)                      ,
    CORD_ORDER_TIME             INTEGER                       ,
    CORD_SHIP_MODE_ID           CHAR(16)                      ,
    CORD_CALL_CENTER_ID         CHAR(16)                      ,
    CORD_ORDER_COMMENTS         VARCHAR(100)                  
);

COPY INTO
s_catalog_order_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_catalog_order/s_catalog_order_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_catalog_order_lineitem_${stream_num};
CREATE TABLE s_catalog_order_lineitem_${stream_num}
(
    CLIN_ORDER_ID               INTEGER                       ,
    CLIN_LINE_NUMBER            INTEGER                       ,
    CLIN_ITEM_ID                CHAR(16)                      ,
    CLIN_PROMOTION_ID           CHAR(16)                      ,
    CLIN_QUANTITY               BIGINT                        ,
    CLIN_SALES_PRICE            DECIMAL(7,2)                  ,
    CLIN_COUPON_AMT             DECIMAL(7,2)                  ,
    CLIN_WAREHOUSE_ID           CHAR(16)                      ,
    CLIN_SHIP_DATE              CHAR(10)                      ,
    CLIN_CATALOG_NUMBER         INTEGER                       ,
    CLIN_CATALOG_PAGE_NUMBER    INTEGER                       ,
    CLIN_SHIP_COST              DECIMAL(7,2)                  
);

COPY INTO
s_catalog_order_lineitem_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_catalog_order_lineitem/s_catalog_order_lineitem_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_catalog_returns_${stream_num};
CREATE TABLE s_catalog_returns_${stream_num}
(
    CRET_CALL_CENTER_ID         CHAR(16)                      ,
    CRET_ORDER_ID               INTEGER                       ,
    CRET_LINE_NUMBER            INTEGER                       ,
    CRET_ITEM_ID                CHAR(16)                      ,
    CRET_RETURN_CUSTOMER_ID     CHAR(16)                      ,
    CRET_REFUND_CUSTOMER_ID     CHAR(16)                      ,
    CRET_RETURN_DATE            CHAR(10)                      ,
    CRET_RETURN_TIME            CHAR(10)                      ,
    CRET_RETURN_QTY             INTEGER                       ,
    CRET_RETURN_AMT             DECIMAL(7,2)                  ,
    CRET_RETURN_TAX             DECIMAL(7,2)                  ,
    CRET_RETURN_FEE             DECIMAL(7,2)                  ,
    CRET_RETURN_SHIP_COST       DECIMAL(7,2)                  ,
    CRET_REFUNDED_CASH          DECIMAL(7,2)                  ,
    CRET_REVERSED_CHARGE        DECIMAL(7,2)                  ,
    CRET_MERCHANT_CREDIT        DECIMAL(7,2)                  ,
    CRET_REASON_ID              CHAR(16)                      ,
    CRET_SHIPMODE_ID            CHAR(16)                      ,
    CRET_CATALOG_PAGE_ID        CHAR(16)                      ,
    CRET_WAREHOUSE_ID           CHAR(16)                      
);

COPY INTO
s_catalog_returns_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_catalog_returns/s_catalog_returns_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_inventory_${stream_num};
CREATE TABLE s_inventory_${stream_num}
(
    INVN_WAREHOUSE_ID           CHAR(16)                      ,
    INVN_ITEM_ID                CHAR(16)                      ,
    INVN_DATE                   CHAR(10)                      ,
    INVN_QTY_ON_HAND            INTEGER                       
);

COPY INTO
s_inventory_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_inventory/s_inventory_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_store_returns_${stream_num};
CREATE TABLE s_store_returns_${stream_num}
(
    SRET_STORE_ID               CHAR(16)                      ,
    SRET_PURCHASE_ID            CHAR(16)                      ,
    SRET_LINE_NUMBER            INTEGER                       ,
    SRET_ITEM_ID                CHAR(16)                      ,
    SRET_CUSTOMER_ID            CHAR(16)                      ,
    SRET_RETURN_DATE            CHAR(10)                      ,
    SRET_RETURN_TIME            CHAR(10)                      ,
    SRET_TICKET_NUMBER          CHAR(20)                      ,
    SRET_RETURN_QTY             INTEGER                       ,
    SRET_RETURN_AMT             DECIMAL(7,2)                  ,
    SRET_RETURN_TAX             DECIMAL(7,2)                  ,
    SRET_RETURN_FEE             DECIMAL(7,2)                  ,
    SRET_RETURN_SHIP_COST       DECIMAL(7,2)                  ,
    SRET_REFUNDED_CASH          DECIMAL(7,2)                  ,
    SRET_REVERSED_CHARGE        DECIMAL(7,2)                  ,
    SRET_STORE_CREDIT           DECIMAL(7,2)                  ,
    SRET_REASON_ID              CHAR(16)                      
);

COPY INTO
s_store_returns_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_store_returns/s_store_returns_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_purchase_${stream_num};
CREATE TABLE s_purchase_${stream_num}
(
    PURC_PURCHASE_ID            INTEGER                       ,
    PURC_STORE_ID               CHAR(16)                      ,
    PURC_CUSTOMER_ID            CHAR(16)                      ,
    PURC_PURCHASE_DATE          CHAR(10)                      ,
    PURC_PURCHASE_TIME          INTEGER                       ,
    PURC_REGISTER_ID            INTEGER                       ,
    PURC_CLERK_ID               INTEGER                       ,
    PURC_COMMENT                CHAR(100)                     
);


COPY INTO
s_purchase_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_purchase/s_purchase_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_web_returns_${stream_num};
CREATE TABLE s_web_returns_${stream_num}
(
    WRET_WEB_SITE_ID            CHAR(16)                      ,
    WRET_ORDER_ID               INTEGER                       ,
    WRET_LINE_NUMBER            INTEGER                       ,
    WRET_ITEM_ID                CHAR(16)                      ,
    WRET_RETURN_CUSTOMER_ID     CHAR(16)                      ,
    WRET_REFUND_CUSTOMER_ID     CHAR(16)                      ,
    WRET_RETURN_DATE            CHAR(10)                      ,
    WRET_RETURN_TIME            CHAR(10)                      ,
    WRET_RETURN_QTY             INTEGER                       ,
    WRET_RETURN_AMT             DECIMAL(7,2)                  ,
    WRET_RETURN_TAX             DECIMAL(7,2)                  ,
    WRET_RETURN_FEE             DECIMAL(7,2)                  ,
    WRET_RETURN_SHIP_COST       DECIMAL(7,2)                  ,
    WRET_REFUNDED_CASH          DECIMAL(7,2)                  ,
    WRET_REVERSED_CHARGE        DECIMAL(7,2)                  ,
    WRET_ACCOUNT_CREDIT         DECIMAL(7,2)                  ,
    WRET_REASON_ID              CHAR(16)                      
);

COPY INTO
s_web_returns_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_web_returns/s_web_returns_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_web_order_${stream_num};
CREATE TABLE s_web_order_${stream_num}
(
    WORD_ORDER_ID               INTEGER                       ,
    WORD_BILL_CUSTOMER_ID       CHAR(16)                      ,
    WORD_SHIP_CUSTOMER_ID       CHAR(16)                      ,
    WORD_ORDER_DATE             CHAR(10)                      ,
    WORD_ORDER_TIME             INTEGER                       ,
    WORD_SHIP_MODE_ID           CHAR(16)                      ,
    WORD_WEB_SITE_ID            CHAR(16)                      ,
    WORD_ORDER_COMMENTS         CHAR(100)                     
);

COPY INTO
s_web_order_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_web_order/s_web_order_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));

----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS s_web_order_lineitem_${stream_num};
CREATE TABLE s_web_order_lineitem_${stream_num}
(
    WLIN_ORDER_ID               INTEGER                       ,
    WLIN_LINE_NUMBER            INTEGER                       ,
    WLIN_ITEM_ID                CHAR(16)                      ,
    WLIN_PROMOTION_ID           CHAR(16)                      ,
    WLIN_QUANTITY               BIGINT                       ,
    WLIN_SALES_PRICE            DECIMAL(7,2)                  ,
    WLIN_COUPON_AMT             DECIMAL(7,2)                  ,
    WLIN_WAREHOUSE_ID           CHAR(16)                      ,
    WLIN_SHIP_DATE              CHAR(10)                      ,
    WLIN_SHIP_COST              DECIMAL(7,2)                  ,
    WLIN_WEB_PAGE_ID            CHAR(16)                      
);

COPY INTO
s_web_order_lineitem_${stream_num}
FROM '${external_catalog_base_url}/refresh_data/s_web_order_lineitem/s_web_order_lineitem_${stream_num}.csv'
WITH (
FILE_TYPE = 'Csv',
CREDENTIAL = (IDENTITY = 'Shared Access Signature',
SECRET='${external_catalog_secret_token}'));