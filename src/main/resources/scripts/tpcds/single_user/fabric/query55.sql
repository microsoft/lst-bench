select top 100 I_BRAND_ID brand_id,
	I_BRAND brand,
	sum(SS_EXT_SALES_PRICE) ext_price
from date_dim,
	store_sales,
	item
where D_DATE_SK = SS_SOLD_DATE_SK
	and SS_ITEM_SK = I_ITEM_SK
	and I_MANAGER_ID = 43
	and D_MOY = 12
	and D_YEAR = 1998
group by I_BRAND,
	I_BRAND_ID
order by ext_price desc,
	I_BRAND_ID option (label = 'TPCDS-Q55');