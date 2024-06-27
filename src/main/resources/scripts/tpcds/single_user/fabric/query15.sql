select top 100 CA_ZIP,
	sum(CS_SALES_PRICE)
from catalog_sales,
	customer,
	customer_address,
	date_dim
where CS_BILL_CUSTOMER_SK = C_CUSTOMER_SK
	and C_CURRENT_ADDR_SK = CA_ADDRESS_SK
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
		or CA_STATE in ('CA', 'WA', 'GA')
		or CS_SALES_PRICE > 500
	)
	and CS_SOLD_DATE_SK = D_DATE_SK
	and D_QOY = 1
	and D_YEAR = 1999
group by CA_ZIP
order by CA_ZIP;