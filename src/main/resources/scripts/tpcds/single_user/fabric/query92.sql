select top 100 sum(WS_EXT_DISCOUNT_AMT) as "Excess Discount Amount"
from web_sales,
   item,
   date_dim
where I_MANUFACT_ID = 591
   and I_ITEM_SK = WS_ITEM_SK
   and D_DATE between '2000-01-03' and dateadd(day, 90, (cast('2000-01-03' as date)))
   and D_DATE_SK = WS_SOLD_DATE_SK
   and WS_EXT_DISCOUNT_AMT > (
      SELECT 1.3 * avg(WS_EXT_DISCOUNT_AMT)
      FROM web_sales,
         date_dim
      WHERE WS_ITEM_SK = I_ITEM_SK
         and D_DATE between '2000-01-03' and dateadd(day, 90, (cast('2000-01-03' as date)))
         and D_DATE_SK = WS_SOLD_DATE_SK
   )
order by sum(WS_EXT_DISCOUNT_AMT) option (label = 'TPCDS-Q92');