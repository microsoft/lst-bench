select top 100 I_ITEM_ID,
   I_ITEM_DESC,
   S_STORE_ID,
   S_STORE_NAME,
   max(SS_QUANTITY) as store_sales_quantity,
   max(SR_RETURN_QUANTITY) as store_returns_quantity,
   max(CS_QUANTITY) as catalog_sales_quantity
from store_sales,
   store_returns,
   catalog_sales,
   date_dim d1,
   date_dim d2,
   date_dim d3,
   store,
   item
where d1.D_MOY = 4
   and d1.D_YEAR = 1998
   and d1.D_DATE_SK = SS_SOLD_DATE_SK
   and I_ITEM_SK = SS_ITEM_SK
   and S_STORE_SK = SS_STORE_SK
   and SS_CUSTOMER_SK = SR_CUSTOMER_SK
   and SS_ITEM_SK = SR_ITEM_SK
   and SS_TICKET_NUMBER = SR_TICKET_NUMBER
   and SR_RETURNED_DATE_SK = d2.D_DATE_SK
   and d2.D_MOY between 4 and 4 + 3
   and d2.D_YEAR = 1998
   and SR_CUSTOMER_SK = CS_BILL_CUSTOMER_SK
   and SR_ITEM_SK = CS_ITEM_SK
   and CS_SOLD_DATE_SK = d3.D_DATE_SK
   and d3.D_YEAR in (1998, 1998 + 1, 1998 + 2)
group by I_ITEM_ID,
   I_ITEM_DESC,
   S_STORE_ID,
   S_STORE_NAME
order by I_ITEM_ID,
   I_ITEM_DESC,
   S_STORE_ID,
   S_STORE_NAME option (label = 'TPCDS-Q29');