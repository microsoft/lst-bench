with cross_items as (
  select I_ITEM_SK SS_ITEM_SK
  from item,
    (
      select iss.I_BRAND_ID brand_id,
        iss.I_CLASS_ID class_id,
        iss.I_CATEGORY_ID category_id
      from store_sales,
        item iss,
        date_dim d1
      where SS_ITEM_SK = iss.I_ITEM_SK
        and SS_SOLD_DATE_SK = d1.D_DATE_SK
        and d1.D_YEAR between 1999 AND 1999 + 2
      intersect
      select ics.I_BRAND_ID,
        ics.I_CLASS_ID,
        ics.I_CATEGORY_ID
      from catalog_sales,
        item ics,
        date_dim d2
      where CS_ITEM_SK = ics.I_ITEM_SK
        and CS_SOLD_DATE_SK = d2.D_DATE_SK
        and d2.D_YEAR between 1999 AND 1999 + 2
      intersect
      select iws.I_BRAND_ID,
        iws.I_CLASS_ID,
        iws.I_CATEGORY_ID
      from web_sales,
        item iws,
        date_dim d3
      where WS_ITEM_SK = iws.I_ITEM_SK
        and WS_SOLD_DATE_SK = d3.D_DATE_SK
        and d3.D_YEAR between 1999 AND 1999 + 2
    ) as x
  where I_BRAND_ID = brand_id
    and I_CLASS_ID = class_id
    and I_CATEGORY_ID = category_id
),
avg_sales as (
  select avg(quantity * list_price) average_sales
  from (
      select SS_QUANTITY quantity,
        SS_LIST_PRICE list_price
      from store_sales,
        date_dim
      where SS_SOLD_DATE_SK = D_DATE_SK
        and D_YEAR between 1999 and 1999 + 2
      union all
      select CS_QUANTITY quantity,
        CS_LIST_PRICE list_price
      from catalog_sales,
        date_dim
      where CS_SOLD_DATE_SK = D_DATE_SK
        and D_YEAR between 1999 and 1999 + 2
      union all
      select WS_QUANTITY quantity,
        WS_LIST_PRICE list_price
      from web_sales,
        date_dim
      where WS_SOLD_DATE_SK = D_DATE_SK
        and D_YEAR between 1999 and 1999 + 2
    ) x
)
select top 100 channel,
  I_BRAND_ID,
  I_CLASS_ID,
  I_CATEGORY_ID,
  sum(sales),
  sum(number_sales)
from(
    select 'store' channel,
      I_BRAND_ID,
      I_CLASS_ID,
      I_CATEGORY_ID,
      sum(SS_QUANTITY * SS_LIST_PRICE) sales,
      count(*) number_sales
    from store_sales,
      item,
      date_dim
    where SS_ITEM_SK in (
        select SS_ITEM_SK
        from cross_items
      )
      and SS_ITEM_SK = I_ITEM_SK
      and SS_SOLD_DATE_SK = D_DATE_SK
      and D_YEAR = 1999 + 2
      and D_MOY = 11
    group by I_BRAND_ID,
      I_CLASS_ID,
      I_CATEGORY_ID
    having sum(SS_QUANTITY * SS_LIST_PRICE) > (
        select average_sales
        from avg_sales
      )
    union all
    select 'catalog' channel,
      I_BRAND_ID,
      I_CLASS_ID,
      I_CATEGORY_ID,
      sum(CS_QUANTITY * CS_LIST_PRICE) sales,
      count(*) number_sales
    from catalog_sales,
      item,
      date_dim
    where CS_ITEM_SK in (
        select SS_ITEM_SK
        from cross_items
      )
      and CS_ITEM_SK = I_ITEM_SK
      and CS_SOLD_DATE_SK = D_DATE_SK
      and D_YEAR = 1999 + 2
      and D_MOY = 11
    group by I_BRAND_ID,
      I_CLASS_ID,
      I_CATEGORY_ID
    having sum(CS_QUANTITY * CS_LIST_PRICE) > (
        select average_sales
        from avg_sales
      )
    union all
    select 'web' channel,
      I_BRAND_ID,
      I_CLASS_ID,
      I_CATEGORY_ID,
      sum(WS_QUANTITY * WS_LIST_PRICE) sales,
      count(*) number_sales
    from web_sales,
      item,
      date_dim
    where WS_ITEM_SK in (
        select SS_ITEM_SK
        from cross_items
      )
      and WS_ITEM_SK = I_ITEM_SK
      and WS_SOLD_DATE_SK = D_DATE_SK
      and D_YEAR = 1999 + 2
      and D_MOY = 11
    group by I_BRAND_ID,
      I_CLASS_ID,
      I_CATEGORY_ID
    having sum(WS_QUANTITY * WS_LIST_PRICE) > (
        select average_sales
        from avg_sales
      )
  ) y
group by rollup (channel, I_BRAND_ID, I_CLASS_ID, I_CATEGORY_ID)
order by channel,
  I_BRAND_ID,
  I_CLASS_ID,
  I_CATEGORY_ID option (label = 'TPCDS-Q14a');