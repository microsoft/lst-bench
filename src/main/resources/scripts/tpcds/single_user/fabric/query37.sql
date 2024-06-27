select top 100 I_ITEM_ID,
      I_ITEM_DESC,
      I_CURRENT_PRICE
from item,
      inventory,
      date_dim,
      catalog_sales
where I_CURRENT_PRICE between 27 and 27 + 30
      and INV_ITEM_SK = I_ITEM_SK
      and D_DATE_SK = INV_DATE_SK
      and D_DATE between cast('2001-07-14' as date)
      and dateadd(day, 60, (cast('2001-07-14' as date)))
      and I_MANUFACT_ID in (682, 914, 746, 766)
      and INV_QUANTITY_ON_HAND between 100 and 500
      and CS_ITEM_SK = I_ITEM_SK
group by I_ITEM_ID,
      I_ITEM_DESC,
      I_CURRENT_PRICE
order by I_ITEM_ID option (label = 'TPCDS-Q37');