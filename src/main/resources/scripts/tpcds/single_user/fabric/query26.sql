select top 100 I_ITEM_ID,
      avg(CS_QUANTITY) agg1,
      avg(CS_LIST_PRICE) agg2,
      avg(CS_COUPON_AMT) agg3,
      avg(CS_SALES_PRICE) agg4
from catalog_sales,
      customer_demographics,
      date_dim,
      item,
      promotion
where CS_SOLD_DATE_SK = D_DATE_SK
      and CS_ITEM_SK = I_ITEM_SK
      and CS_BILL_CDEMO_SK = CD_DEMO_SK
      and CS_PROMO_SK = P_PROMO_SK
      and CD_GENDER = 'M'
      and CD_MARITAL_STATUS = 'M'
      and CD_EDUCATION_STATUS = 'Primary'
      and (
            P_CHANNEL_EMAIL = 'N'
            or P_CHANNEL_EVENT = 'N'
      )
      and D_YEAR = 2000
group by I_ITEM_ID
order by I_ITEM_ID option (label = 'TPCDS-Q26');