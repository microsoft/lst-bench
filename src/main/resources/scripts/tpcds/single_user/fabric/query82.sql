select top 100 I_ITEM_ID,
      I_ITEM_DESC,
      I_CURRENT_PRICE
from item,
      inventory,
      date_dim,
      store_sales
where I_CURRENT_PRICE between 18 and 18 + 30
      and INV_ITEM_SK = I_ITEM_SK
      and D_DATE_SK = INV_DATE_SK
      and D_DATE between cast('2000-04-20' as date)
      and dateadd(day, 60, (cast('2000-04-20' as date)))
      and I_MANUFACT_ID in (860, 362, 42, 644)
      and INV_QUANTITY_ON_HAND between 100 and 500
      and SS_ITEM_SK = I_ITEM_SK
group by I_ITEM_ID,
      I_ITEM_DESC,
      I_CURRENT_PRICE
order by I_ITEM_ID option (label = 'TPCDS-Q82');