select top 100 count(*)
from (
        select distinct C_LAST_NAME,
            C_FIRST_NAME,
            D_DATE
        from store_sales,
            date_dim,
            customer
        where store_sales.SS_SOLD_DATE_SK = date_dim.D_DATE_SK
            and store_sales.SS_CUSTOMER_SK = customer.C_CUSTOMER_SK
            and D_MONTH_SEQ between 1176 and 1176 + 11
        intersect
        select distinct C_LAST_NAME,
            C_FIRST_NAME,
            D_DATE
        from catalog_sales,
            date_dim,
            customer
        where catalog_sales.CS_SOLD_DATE_SK = date_dim.D_DATE_SK
            and catalog_sales.CS_BILL_CUSTOMER_SK = customer.C_CUSTOMER_SK
            and D_MONTH_SEQ between 1176 and 1176 + 11
        intersect
        select distinct C_LAST_NAME,
            C_FIRST_NAME,
            D_DATE
        from web_sales,
            date_dim,
            customer
        where web_sales.WS_SOLD_DATE_SK = date_dim.D_DATE_SK
            and web_sales.WS_BILL_CUSTOMER_SK = customer.C_CUSTOMER_SK
            and D_MONTH_SEQ between 1176 and 1176 + 11
    ) hot_cust option (label = 'TPCDS-Q38');