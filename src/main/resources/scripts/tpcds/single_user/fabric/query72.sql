select top 100 I_ITEM_DESC,
  W_WAREHOUSE_NAME,
  d1.D_WEEK_SEQ,
  sum(
    case
      when P_PROMO_SK is null then 1
      else 0
    end
  ) no_promo,
  sum(
    case
      when P_PROMO_SK is not null then 1
      else 0
    end
  ) promo,
  count(*) total_cnt
from catalog_sales
  join inventory on (CS_ITEM_SK = INV_ITEM_SK)
  join warehouse on (W_WAREHOUSE_SK = INV_WAREHOUSE_SK)
  join item on (I_ITEM_SK = CS_ITEM_SK)
  join customer_demographics on (CS_BILL_CDEMO_SK = CD_DEMO_SK)
  join household_demographics on (CS_BILL_HDEMO_SK = HD_DEMO_SK)
  join date_dim d1 on (CS_SOLD_DATE_SK = d1.D_DATE_SK)
  join date_dim d2 on (INV_DATE_SK = d2.D_DATE_SK)
  join date_dim d3 on (CS_SHIP_DATE_SK = d3.D_DATE_SK)
  left outer join promotion on (CS_PROMO_SK = P_PROMO_SK)
  left outer join catalog_returns on (
    CR_ITEM_SK = CS_ITEM_SK
    and CR_ORDER_NUMBER = CS_ORDER_NUMBER
  )
where d1.D_WEEK_SEQ = d2.D_WEEK_SEQ
  and INV_QUANTITY_ON_HAND < CS_QUANTITY
  and d3.D_DATE > dateadd(day, 5, d1.D_DATE)
  and HD_BUY_POTENTIAL = '>10000'
  and d1.D_YEAR = 1998
  and CD_MARITAL_STATUS = 'D'
group by I_ITEM_DESC,
  W_WAREHOUSE_NAME,
  d1.D_WEEK_SEQ
order by total_cnt desc,
  I_ITEM_DESC,
  W_WAREHOUSE_NAME,
  D_WEEK_SEQ option (label = 'TPCDS-Q72');