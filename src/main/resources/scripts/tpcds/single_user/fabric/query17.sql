select top 100 I_ITEM_ID,
        I_ITEM_DESC,
        S_STATE,
        count(SS_QUANTITY) as store_sales_quantitycount,
        avg(SS_QUANTITY) as store_sales_quantityave,
        stdev(SS_QUANTITY) as store_sales_quantitystdev,
        stdev(SS_QUANTITY) / avg(SS_QUANTITY) as store_sales_quantitycov,
        count(SR_RETURN_QUANTITY) as store_returns_quantitycount,
        avg(SR_RETURN_QUANTITY) as store_returns_quantityave,
        stdev(SR_RETURN_QUANTITY) as store_returns_quantitystdev,
        stdev(SR_RETURN_QUANTITY) / avg(SR_RETURN_QUANTITY) as store_returns_quantitycov,
        count(CS_QUANTITY) as catalog_sales_quantitycount,
        avg(CS_QUANTITY) as catalog_sales_quantityave,
        stdev(CS_QUANTITY) as catalog_sales_quantitystdev,
        stdev(CS_QUANTITY) / avg(CS_QUANTITY) as catalog_sales_quantitycov
from store_sales,
        store_returns,
        catalog_sales,
        date_dim d1,
        date_dim d2,
        date_dim d3,
        store,
        item
where d1.D_QUARTER_NAME = '2000Q1'
        and d1.D_DATE_SK = SS_SOLD_DATE_SK
        and I_ITEM_SK = SS_ITEM_SK
        and S_STORE_SK = SS_STORE_SK
        and SS_CUSTOMER_SK = SR_CUSTOMER_SK
        and SS_ITEM_SK = SR_ITEM_SK
        and SS_TICKET_NUMBER = SR_TICKET_NUMBER
        and SR_RETURNED_DATE_SK = d2.D_DATE_SK
        and d2.D_QUARTER_NAME in ('2000Q1', '2000Q2', '2000Q3')
        and SR_CUSTOMER_SK = CS_BILL_CUSTOMER_SK
        and SR_ITEM_SK = CS_ITEM_SK
        and CS_SOLD_DATE_SK = d3.D_DATE_SK
        and d3.D_QUARTER_NAME in ('2000Q1', '2000Q2', '2000Q3')
group by I_ITEM_ID,
        I_ITEM_DESC,
        S_STATE
order by I_ITEM_ID,
        I_ITEM_DESC,
        S_STATE option (label = 'TPCDS-Q17');