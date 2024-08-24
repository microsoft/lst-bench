select top 100 dt.D_YEAR,
     item.I_BRAND_ID brand_id,
     item.I_BRAND brand,
     sum(SS_EXT_DISCOUNT_AMT) sum_agg
from date_dim dt,
     store_sales,
     item
where dt.D_DATE_SK = store_sales.SS_SOLD_DATE_SK
     and store_sales.SS_ITEM_SK = item.I_ITEM_SK
     and item.I_MANUFACT_ID = 143
     and dt.D_MOY = 12
group by dt.D_YEAR,
     item.I_BRAND,
     item.I_BRAND_ID
order by dt.D_YEAR,
     sum_agg desc,
     brand_id option (label = 'TPCDS-Q3');