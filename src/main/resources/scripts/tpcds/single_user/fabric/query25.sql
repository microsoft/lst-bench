select top 100 I_ITEM_ID,
    I_ITEM_DESC,
    S_STORE_ID,
    S_STORE_NAME,
    max(SS_NET_PROFIT) as store_sales_profit,
    max(SR_NET_LOSS) as store_returns_loss,
    max(CS_NET_PROFIT) as catalog_sales_profit
from store_sales,
    store_returns,
    catalog_sales,
    date_dim d1,
    date_dim d2,
    date_dim d3,
    store,
    item
where d1.D_MOY = 4
    and d1.D_YEAR = 1999
    and d1.D_DATE_SK = SS_SOLD_DATE_SK
    and I_ITEM_SK = SS_ITEM_SK
    and S_STORE_SK = SS_STORE_SK
    and SS_CUSTOMER_SK = SR_CUSTOMER_SK
    and SS_ITEM_SK = SR_ITEM_SK
    and SS_TICKET_NUMBER = SR_TICKET_NUMBER
    and SR_RETURNED_DATE_SK = d2.D_DATE_SK
    and d2.D_MOY between 4 and 10
    and d2.D_YEAR = 1999
    and SR_CUSTOMER_SK = CS_BILL_CUSTOMER_SK
    and SR_ITEM_SK = CS_ITEM_SK
    and CS_SOLD_DATE_SK = d3.D_DATE_SK
    and d3.D_MOY between 4 and 10
    and d3.D_YEAR = 1999
group by I_ITEM_ID,
    I_ITEM_DESC,
    S_STORE_ID,
    S_STORE_NAME
order by I_ITEM_ID,
    I_ITEM_DESC,
    S_STORE_ID,
    S_STORE_NAME option (label = 'TPCDS-Q25');