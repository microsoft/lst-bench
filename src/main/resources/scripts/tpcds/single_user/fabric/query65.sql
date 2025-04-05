select top 100 S_STORE_NAME,
	I_ITEM_DESC,
	sc.revenue,
	I_CURRENT_PRICE,
	I_WHOLESALE_COST,
	I_BRAND
from store,
	item,
	(
		select SS_STORE_SK,
			avg(revenue) as ave
		from (
				select SS_STORE_SK,
					SS_ITEM_SK,
					sum(SS_SALES_PRICE) as revenue
				from store_sales,
					date_dim
				where SS_SOLD_DATE_SK = D_DATE_SK
					and D_MONTH_SEQ between 1176 and 1176 + 11
				group by SS_STORE_SK,
					SS_ITEM_SK
			) sa
		group by SS_STORE_SK
	) sb,
	(
		select SS_STORE_SK,
			SS_ITEM_SK,
			sum(SS_SALES_PRICE) as revenue
		from store_sales,
			date_dim
		where SS_SOLD_DATE_SK = D_DATE_SK
			and D_MONTH_SEQ between 1176 and 1176 + 11
		group by SS_STORE_SK,
			SS_ITEM_SK
	) sc
where sb.SS_STORE_SK = sc.SS_STORE_SK
	and sc.revenue <= 0.1 * sb.ave
	and S_STORE_SK = sc.SS_STORE_SK
	and I_ITEM_SK = sc.SS_ITEM_SK
order by S_STORE_NAME,
	I_ITEM_DESC option (label = 'TPCDS-Q65');