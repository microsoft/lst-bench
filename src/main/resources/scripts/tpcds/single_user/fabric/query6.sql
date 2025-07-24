select top 100 a.CA_STATE state,
	count(*) cnt
from customer_address a,
	customer c,
	store_sales s,
	date_dim d,
	item i
where a.CA_ADDRESS_SK = c.C_CURRENT_ADDR_SK
	and c.C_CUSTOMER_SK = s.SS_CUSTOMER_SK
	and s.SS_SOLD_DATE_SK = d.D_DATE_SK
	and s.SS_ITEM_SK = i.I_ITEM_SK
	and d.D_MONTH_SEQ = (
		select distinct (D_MONTH_SEQ)
		from date_dim
		where D_YEAR = 1999
			and D_MOY = 1
	)
	and i.I_CURRENT_PRICE > 1.2 * (
		select avg(j.I_CURRENT_PRICE)
		from item j
		where j.I_CATEGORY = i.I_CATEGORY
	)
group by a.CA_STATE
having count(*) >= 10
order by cnt,
	a.CA_STATE option (label = 'TPCDS-Q6');