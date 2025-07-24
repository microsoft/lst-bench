select top 100 *
from (
		select I_MANUFACT_ID,
			sum(SS_SALES_PRICE) sum_sales,
			avg(sum(SS_SALES_PRICE)) over (partition by I_MANUFACT_ID) avg_quarterly_sales
		from item,
			store_sales,
			date_dim,
			store
		where SS_ITEM_SK = I_ITEM_SK
			and SS_SOLD_DATE_SK = D_DATE_SK
			and SS_STORE_SK = S_STORE_SK
			and D_MONTH_SEQ in (
				1176,
				1176 + 1,
				1176 + 2,
				1176 + 3,
				1176 + 4,
				1176 + 5,
				1176 + 6,
				1176 + 7,
				1176 + 8,
				1176 + 9,
				1176 + 10,
				1176 + 11
			)
			and (
				(
					I_CATEGORY in ('Books', 'Children', 'Electronics')
					and I_CLASS in ('personal', 'portable', 'reference', 'self-help')
					and I_BRAND in (
						'scholaramalgamalg #14',
						'scholaramalgamalg #7',
						'exportiunivamalg #9',
						'scholaramalgamalg #9'
					)
				)
				or(
					I_CATEGORY in ('Women', 'Music', 'Men')
					and I_CLASS in ('accessories', 'classical', 'fragrances', 'pants')
					and I_BRAND in (
						'amalgimporto #1',
						'edu packscholar #1',
						'exportiimporto #1',
						'importoamalg #1'
					)
				)
			)
		group by I_MANUFACT_ID,
			D_QOY
	) tmp1
where case
		when avg_quarterly_sales > 0 then abs (sum_sales - avg_quarterly_sales) / avg_quarterly_sales
		else null
	end > 0.1
order by avg_quarterly_sales,
	sum_sales,
	I_MANUFACT_ID option (label = 'TPCDS-Q53');