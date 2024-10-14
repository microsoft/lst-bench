select top 100 CA_ZIP,
	CA_CITY,
	sum(WS_SALES_PRICE)
from web_sales,
	customer,
	customer_address,
	date_dim,
	item
where WS_BILL_CUSTOMER_SK = C_CUSTOMER_SK
	and C_CURRENT_ADDR_SK = CA_ADDRESS_SK
	and WS_ITEM_SK = I_ITEM_SK
	and (
		substring(CA_ZIP, 1, 5) in (
			'85669',
			'86197',
			'88274',
			'83405',
			'86475',
			'85392',
			'85460',
			'80348',
			'81792'
		)
		or I_ITEM_ID in (
			select I_ITEM_ID
			from item
			where I_ITEM_SK in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29)
		)
	)
	and WS_SOLD_DATE_SK = D_DATE_SK
	and D_QOY = 1
	and D_YEAR = 1999
group by CA_ZIP,
	CA_CITY
order by CA_ZIP,
	CA_CITY option (label = 'TPCDS-Q45');