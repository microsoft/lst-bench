select top 100 channel,
	item,
	return_ratio,
	return_rank,
	currency_rank
from (
		select 'web' as channel,
			web.item,
			web.return_ratio,
			web.return_rank,
			web.currency_rank
		from (
				select item,
					return_ratio,
					currency_ratio,
					rank() over (
						order by return_ratio
					) as return_rank,
					rank() over (
						order by currency_ratio
					) as currency_rank
				from (
						select ws.WS_ITEM_SK as item,
(
								cast(
									sum(coalesce(wr.WR_RETURN_QUANTITY, 0)) as decimal(15, 4)
								) / cast(
									sum(coalesce(ws.WS_QUANTITY, 0)) as decimal(15, 4)
								)
							) as return_ratio,
(
								cast(
									sum(coalesce(wr.WR_RETURN_AMT, 0)) as decimal(15, 4)
								) / cast(
									sum(coalesce(ws.WS_NET_PAID, 0)) as decimal(15, 4)
								)
							) as currency_ratio
						from web_sales ws
							left outer join web_returns wr on (
								ws.WS_ORDER_NUMBER = wr.WR_ORDER_NUMBER
								and ws.WS_ITEM_SK = wr.WR_ITEM_SK
							),
							date_dim
						where wr.WR_RETURN_AMT > 10000
							and ws.WS_NET_PROFIT > 1
							and ws.WS_NET_PAID > 0
							and ws.WS_QUANTITY > 0
							and WS_SOLD_DATE_SK = D_DATE_SK
							and D_YEAR = 1999
							and D_MOY = 11
						group by ws.WS_ITEM_SK
					) in_web
			) web
		where (
				web.return_rank <= 10
				or web.currency_rank <= 10
			)
		union
		select 'catalog' as channel,
			catalog.item,
			catalog.return_ratio,
			catalog.return_rank,
			catalog.currency_rank
		from (
				select item,
					return_ratio,
					currency_ratio,
					rank() over (
						order by return_ratio
					) as return_rank,
					rank() over (
						order by currency_ratio
					) as currency_rank
				from (
						select cs.CS_ITEM_SK as item,
(
								cast(
									sum(coalesce(cr.CR_RETURN_QUANTITY, 0)) as decimal(15, 4)
								) / cast(
									sum(coalesce(cs.CS_QUANTITY, 0)) as decimal(15, 4)
								)
							) as return_ratio,
(
								cast(
									sum(coalesce(cr.CR_RETURN_AMOUNT, 0)) as decimal(15, 4)
								) / cast(
									sum(coalesce(cs.CS_NET_PAID, 0)) as decimal(15, 4)
								)
							) as currency_ratio
						from catalog_sales cs
							left outer join catalog_returns cr on (
								cs.CS_ORDER_NUMBER = cr.CR_ORDER_NUMBER
								and cs.CS_ITEM_SK = cr.CR_ITEM_SK
							),
							date_dim
						where cr.CR_RETURN_AMOUNT > 10000
							and cs.CS_NET_PROFIT > 1
							and cs.CS_NET_PAID > 0
							and cs.CS_QUANTITY > 0
							and CS_SOLD_DATE_SK = D_DATE_SK
							and D_YEAR = 1999
							and D_MOY = 11
						group by cs.CS_ITEM_SK
					) in_cat
			) catalog
		where (
				catalog.return_rank <= 10
				or catalog.currency_rank <= 10
			)
		union
		select 'store' as channel,
			store.item,
			store.return_ratio,
			store.return_rank,
			store.currency_rank
		from (
				select item,
					return_ratio,
					currency_ratio,
					rank() over (
						order by return_ratio
					) as return_rank,
					rank() over (
						order by currency_ratio
					) as currency_rank
				from (
						select sts.SS_ITEM_SK as item,
(
								cast(
									sum(coalesce(sr.SR_RETURN_QUANTITY, 0)) as decimal(15, 4)
								) / cast(
									sum(coalesce(sts.SS_QUANTITY, 0)) as decimal(15, 4)
								)
							) as return_ratio,
(
								cast(
									sum(coalesce(sr.SR_RETURN_AMT, 0)) as decimal(15, 4)
								) / cast(
									sum(coalesce(sts.SS_NET_PAID, 0)) as decimal(15, 4)
								)
							) as currency_ratio
						from store_sales sts
							left outer join store_returns sr on (
								sts.SS_TICKET_NUMBER = sr.SR_TICKET_NUMBER
								and sts.SS_ITEM_SK = sr.SR_ITEM_SK
							),
							date_dim
						where sr.SR_RETURN_AMT > 10000
							and sts.SS_NET_PROFIT > 1
							and sts.SS_NET_PAID > 0
							and sts.SS_QUANTITY > 0
							and SS_SOLD_DATE_SK = D_DATE_SK
							and D_YEAR = 1999
							and D_MOY = 11
						group by sts.SS_ITEM_SK
					) in_store
			) store
		where (
				store.return_rank <= 10
				or store.currency_rank <= 10
			)
	) as x
order by 1,
	4,
	5,
	2 option (label = 'TPCDS-Q49');