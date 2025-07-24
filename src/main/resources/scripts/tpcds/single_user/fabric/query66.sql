select top 100 W_WAREHOUSE_NAME,
	W_WAREHOUSE_SQ_FT,
	W_CITY,
	W_COUNTY,
	W_STATE,
	W_COUNTRY,
	ship_carriers,
	year,
	sum(jan_sales) as jan_sales,
	sum(feb_sales) as feb_sales,
	sum(mar_sales) as mar_sales,
	sum(apr_sales) as apr_sales,
	sum(may_sales) as may_sales,
	sum(jun_sales) as jun_sales,
	sum(jul_sales) as jul_sales,
	sum(aug_sales) as aug_sales,
	sum(sep_sales) as sep_sales,
	sum(oct_sales) as oct_sales,
	sum(nov_sales) as nov_sales,
	sum(dec_sales) as dec_sales,
	sum(jan_sales / W_WAREHOUSE_SQ_FT) as jan_sales_per_sq_foot,
	sum(feb_sales / W_WAREHOUSE_SQ_FT) as feb_sales_per_sq_foot,
	sum(mar_sales / W_WAREHOUSE_SQ_FT) as mar_sales_per_sq_foot,
	sum(apr_sales / W_WAREHOUSE_SQ_FT) as apr_sales_per_sq_foot,
	sum(may_sales / W_WAREHOUSE_SQ_FT) as may_sales_per_sq_foot,
	sum(jun_sales / W_WAREHOUSE_SQ_FT) as jun_sales_per_sq_foot,
	sum(jul_sales / W_WAREHOUSE_SQ_FT) as jul_sales_per_sq_foot,
	sum(aug_sales / W_WAREHOUSE_SQ_FT) as aug_sales_per_sq_foot,
	sum(sep_sales / W_WAREHOUSE_SQ_FT) as sep_sales_per_sq_foot,
	sum(oct_sales / W_WAREHOUSE_SQ_FT) as oct_sales_per_sq_foot,
	sum(nov_sales / W_WAREHOUSE_SQ_FT) as nov_sales_per_sq_foot,
	sum(dec_sales / W_WAREHOUSE_SQ_FT) as dec_sales_per_sq_foot,
	sum(jan_net) as jan_net,
	sum(feb_net) as feb_net,
	sum(mar_net) as mar_net,
	sum(apr_net) as apr_net,
	sum(may_net) as may_net,
	sum(jun_net) as jun_net,
	sum(jul_net) as jul_net,
	sum(aug_net) as aug_net,
	sum(sep_net) as sep_net,
	sum(oct_net) as oct_net,
	sum(nov_net) as nov_net,
	sum(dec_net) as dec_net
from (
		select W_WAREHOUSE_NAME,
			W_WAREHOUSE_SQ_FT,
			W_CITY,
			W_COUNTY,
			W_STATE,
			W_COUNTRY,
			'GERMA' + ',' + 'UPS' as ship_carriers,
			D_YEAR as year,
			sum(
				case
					when D_MOY = 1 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as jan_sales,
			sum(
				case
					when D_MOY = 2 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as feb_sales,
			sum(
				case
					when D_MOY = 3 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as mar_sales,
			sum(
				case
					when D_MOY = 4 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as apr_sales,
			sum(
				case
					when D_MOY = 5 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as may_sales,
			sum(
				case
					when D_MOY = 6 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as jun_sales,
			sum(
				case
					when D_MOY = 7 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as jul_sales,
			sum(
				case
					when D_MOY = 8 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as aug_sales,
			sum(
				case
					when D_MOY = 9 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as sep_sales,
			sum(
				case
					when D_MOY = 10 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as oct_sales,
			sum(
				case
					when D_MOY = 11 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as nov_sales,
			sum(
				case
					when D_MOY = 12 then WS_EXT_SALES_PRICE * WS_QUANTITY
					else 0
				end
			) as dec_sales,
			sum(
				case
					when D_MOY = 1 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as jan_net,
			sum(
				case
					when D_MOY = 2 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as feb_net,
			sum(
				case
					when D_MOY = 3 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as mar_net,
			sum(
				case
					when D_MOY = 4 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as apr_net,
			sum(
				case
					when D_MOY = 5 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as may_net,
			sum(
				case
					when D_MOY = 6 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as jun_net,
			sum(
				case
					when D_MOY = 7 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as jul_net,
			sum(
				case
					when D_MOY = 8 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as aug_net,
			sum(
				case
					when D_MOY = 9 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as sep_net,
			sum(
				case
					when D_MOY = 10 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as oct_net,
			sum(
				case
					when D_MOY = 11 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as nov_net,
			sum(
				case
					when D_MOY = 12 then WS_NET_PAID_INC_SHIP_TAX * WS_QUANTITY
					else 0
				end
			) as dec_net
		from web_sales,
			warehouse,
			date_dim,
			time_dim,
			ship_mode
		where WS_WAREHOUSE_SK = W_WAREHOUSE_SK
			and WS_SOLD_DATE_SK = D_DATE_SK
			and WS_SOLD_TIME_SK = T_TIME_SK
			and WS_SHIP_MODE_SK = SM_SHIP_MODE_SK
			and D_YEAR = 2002
			and T_TIME between 1914 and 1914 + 28800
			and SM_CARRIER in ('GERMA', 'UPS')
		group by W_WAREHOUSE_NAME,
			W_WAREHOUSE_SQ_FT,
			W_CITY,
			W_COUNTY,
			W_STATE,
			W_COUNTRY,
			D_YEAR
		union all
		select W_WAREHOUSE_NAME,
			W_WAREHOUSE_SQ_FT,
			W_CITY,
			W_COUNTY,
			W_STATE,
			W_COUNTRY,
			'GERMA' + ',' + 'UPS' as ship_carriers,
			D_YEAR as year,
			sum(
				case
					when D_MOY = 1 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as jan_sales,
			sum(
				case
					when D_MOY = 2 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as feb_sales,
			sum(
				case
					when D_MOY = 3 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as mar_sales,
			sum(
				case
					when D_MOY = 4 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as apr_sales,
			sum(
				case
					when D_MOY = 5 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as may_sales,
			sum(
				case
					when D_MOY = 6 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as jun_sales,
			sum(
				case
					when D_MOY = 7 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as jul_sales,
			sum(
				case
					when D_MOY = 8 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as aug_sales,
			sum(
				case
					when D_MOY = 9 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as sep_sales,
			sum(
				case
					when D_MOY = 10 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as oct_sales,
			sum(
				case
					when D_MOY = 11 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as nov_sales,
			sum(
				case
					when D_MOY = 12 then CS_SALES_PRICE * CS_QUANTITY
					else 0
				end
			) as dec_sales,
			sum(
				case
					when D_MOY = 1 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as jan_net,
			sum(
				case
					when D_MOY = 2 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as feb_net,
			sum(
				case
					when D_MOY = 3 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as mar_net,
			sum(
				case
					when D_MOY = 4 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as apr_net,
			sum(
				case
					when D_MOY = 5 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as may_net,
			sum(
				case
					when D_MOY = 6 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as jun_net,
			sum(
				case
					when D_MOY = 7 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as jul_net,
			sum(
				case
					when D_MOY = 8 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as aug_net,
			sum(
				case
					when D_MOY = 9 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as sep_net,
			sum(
				case
					when D_MOY = 10 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as oct_net,
			sum(
				case
					when D_MOY = 11 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as nov_net,
			sum(
				case
					when D_MOY = 12 then CS_NET_PAID * CS_QUANTITY
					else 0
				end
			) as dec_net
		from catalog_sales,
			warehouse,
			date_dim,
			time_dim,
			ship_mode
		where CS_WAREHOUSE_SK = W_WAREHOUSE_SK
			and CS_SOLD_DATE_SK = D_DATE_SK
			and CS_SOLD_TIME_SK = T_TIME_SK
			and CS_SHIP_MODE_SK = SM_SHIP_MODE_SK
			and D_YEAR = 2002
			and T_TIME between 1914 AND 1914 + 28800
			and SM_CARRIER in ('GERMA', 'UPS')
		group by W_WAREHOUSE_NAME,
			W_WAREHOUSE_SQ_FT,
			W_CITY,
			W_COUNTY,
			W_STATE,
			W_COUNTRY,
			D_YEAR
	) x
group by W_WAREHOUSE_NAME,
	W_WAREHOUSE_SQ_FT,
	W_CITY,
	W_COUNTY,
	W_STATE,
	W_COUNTRY,
	ship_carriers,
	year
order by W_WAREHOUSE_NAME option (label = 'TPCDS-Q66');