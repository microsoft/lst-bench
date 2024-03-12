select top 100 I_ITEM_ID,
      avg(SS_QUANTITY) agg1,
      avg(SS_LIST_PRICE) agg2,
      avg(SS_COUPON_AMT) agg3,
      avg(SS_SALES_PRICE) agg4
from store_sales,
      customer_demographics,
      date_dim,
      item,
      promotion
where SS_SOLD_DATE_SK = D_DATE_SK
      and SS_ITEM_SK = I_ITEM_SK
      and SS_CDEMO_SK = CD_DEMO_SK
      and SS_PROMO_SK = P_PROMO_SK
      and CD_GENDER = 'M'
      and CD_MARITAL_STATUS = 'M'
      and CD_EDUCATION_STATUS = 'Primary'
      and (
            P_CHANNEL_EMAIL = 'N'
            or P_CHANNEL_EVENT = 'N'
      )
      and D_YEAR = 2000
group by I_ITEM_ID
order by I_ITEM_ID option (label = 'TPCDS-Q7');