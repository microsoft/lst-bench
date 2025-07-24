select top 100 I_ITEM_ID,
      S_STATE,
      grouping(S_STATE) g_state,
      avg(SS_QUANTITY) agg1,
      avg(SS_LIST_PRICE) agg2,
      avg(SS_COUPON_AMT) agg3,
      avg(SS_SALES_PRICE) agg4
from store_sales,
      customer_demographics,
      date_dim,
      store,
      item
where SS_SOLD_DATE_SK = D_DATE_SK
      and SS_ITEM_SK = I_ITEM_SK
      and SS_STORE_SK = S_STORE_SK
      and SS_CDEMO_SK = CD_DEMO_SK
      and CD_GENDER = 'M'
      and CD_MARITAL_STATUS = 'S'
      and CD_EDUCATION_STATUS = 'College'
      and D_YEAR = 1998
      and S_STATE in ('TN', 'AL', 'SD', 'TN', 'SD', 'SD')
group by rollup (I_ITEM_ID, S_STATE)
order by I_ITEM_ID,
      S_STATE option (label = 'TPCDS-Q27');