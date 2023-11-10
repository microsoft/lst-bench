select top 100 I_ITEM_ID,
  I_ITEM_DESC,
  I_CATEGORY,
  I_CLASS,
  I_CURRENT_PRICE,
  sum(CS_EXT_SALES_PRICE) as itemrevenue,
  sum(CS_EXT_SALES_PRICE) * 100 / sum(sum(CS_EXT_SALES_PRICE)) over (partition by I_CLASS) as revenueratio
from catalog_sales,
  item,
  date_dim
where CS_ITEM_SK = I_ITEM_SK
  and I_CATEGORY in ('Jewelry', 'Men', 'Electronics')
  and CS_SOLD_DATE_SK = D_DATE_SK
  and D_DATE between cast('1999-03-09' as date)
  and dateadd(day, 30, (cast('1999-03-09' as date)))
group by I_ITEM_ID,
  I_ITEM_DESC,
  I_CATEGORY,
  I_CLASS,
  I_CURRENT_PRICE
order by I_CATEGORY,
  I_CLASS,
  I_ITEM_ID,
  I_ITEM_DESC,
  revenueratio option (label = 'TPCDS-Q20');