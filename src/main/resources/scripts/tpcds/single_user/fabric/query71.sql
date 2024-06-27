select I_BRAND_ID brand_id,
  I_BRAND brand,
  T_HOUR,
  T_MINUTE,
  sum(ext_price) ext_price
from item,
  (
    select WS_EXT_SALES_PRICE as ext_price,
      WS_SOLD_DATE_SK as sold_date_sk,
      WS_ITEM_SK as sold_item_sk,
      WS_SOLD_TIME_SK as time_sk
    from web_sales,
      date_dim
    where D_DATE_SK = WS_SOLD_DATE_SK
      and D_MOY = 11
      and D_YEAR = 1999
    union all
    select CS_EXT_SALES_PRICE as ext_price,
      CS_SOLD_DATE_SK as sold_date_sk,
      CS_ITEM_SK as sold_item_sk,
      CS_SOLD_TIME_SK as time_sk
    from catalog_sales,
      date_dim
    where D_DATE_SK = CS_SOLD_DATE_SK
      and D_MOY = 11
      and D_YEAR = 1999
    union all
    select SS_EXT_SALES_PRICE as ext_price,
      SS_SOLD_DATE_SK as sold_date_sk,
      SS_ITEM_SK as sold_item_sk,
      SS_SOLD_TIME_SK as time_sk
    from store_sales,
      date_dim
    where D_DATE_SK = SS_SOLD_DATE_SK
      and D_MOY = 11
      and D_YEAR = 1999
  ) tmp,
  time_dim
where sold_item_sk = I_ITEM_SK
  and I_MANAGER_ID = 1
  and time_sk = T_TIME_SK
  and (
    T_MEAL_TIME = 'breakfast'
    or T_MEAL_TIME = 'dinner'
  )
group by I_BRAND,
  I_BRAND_ID,
  T_HOUR,
  T_MINUTE
order by ext_price desc,
  I_BRAND_ID option (label = 'TPCDS-Q71');