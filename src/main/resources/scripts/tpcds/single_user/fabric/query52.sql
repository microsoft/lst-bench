select top 100 dt.D_YEAR,
	item.I_BRAND_ID brand_id,
	item.I_BRAND brand,
	sum(SS_EXT_SALES_PRICE) ext_price
from date_dim dt,
	store_sales,
	item
where dt.D_DATE_SK = store_sales.SS_SOLD_DATE_SK
	and store_sales.SS_ITEM_SK = item.I_ITEM_SK
	and item.I_MANAGER_ID = 1
	and dt.D_MOY = 12
	and dt.D_YEAR = 2000
group by dt.D_YEAR,
	item.I_BRAND,
	item.I_BRAND_ID
order by dt.D_YEAR,
	ext_price desc,
	brand_id option (label = 'TPCDS-Q52');