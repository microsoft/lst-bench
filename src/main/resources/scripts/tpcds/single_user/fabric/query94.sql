select top 100 count(distinct WS_ORDER_NUMBER) as "order count",
  sum(WS_EXT_SHIP_COST) as "total shipping cost",
  sum(WS_NET_PROFIT) as "total net profit"
from web_sales ws1,
  date_dim,
  customer_address,
  web_site
where D_DATE between '2001-3-01' and dateadd(day, 60, (cast('2001-3-01' as date)))
  and ws1.WS_SHIP_DATE_SK = D_DATE_SK
  and ws1.WS_SHIP_ADDR_SK = CA_ADDRESS_SK
  and CA_STATE = 'KS'
  and ws1.WS_WEB_SITE_SK = WEB_SITE_SK
  and WEB_COMPANY_NAME = 'pri'
  and exists (
    select *
    from web_sales ws2
    where ws1.WS_ORDER_NUMBER = ws2.WS_ORDER_NUMBER
      and ws1.WS_WAREHOUSE_SK <> ws2.WS_WAREHOUSE_SK
  )
  and not exists(
    select *
    from web_returns wr1
    where ws1.WS_ORDER_NUMBER = wr1.WR_ORDER_NUMBER
  )
order by count(distinct WS_ORDER_NUMBER) option (label = 'TPCDS-Q94');