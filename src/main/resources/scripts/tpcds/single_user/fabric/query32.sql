select top 100 sum(CS_EXT_DISCOUNT_AMT) as "excess discount amount"
from catalog_sales,
   item,
   date_dim
where I_MANUFACT_ID = 591
   and I_ITEM_SK = CS_ITEM_SK
   and D_DATE between '2000-01-03' and dateadd(day, 90, (cast('2000-01-03' as date)))
   and D_DATE_SK = CS_SOLD_DATE_SK
   and CS_EXT_DISCOUNT_AMT > (
      select 1.3 * avg(CS_EXT_DISCOUNT_AMT)
      from catalog_sales,
         date_dim
      where CS_ITEM_SK = I_ITEM_SK
         and D_DATE between '2000-01-03' and dateadd(day, 90, (cast('2000-01-03' as date)))
         and D_DATE_SK = CS_SOLD_DATE_SK
   ) option (label = 'TPCDS-Q32');