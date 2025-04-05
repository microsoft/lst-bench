select top 100 count(distinct CS_ORDER_NUMBER) as "order count",
  sum(CS_EXT_SHIP_COST) as "total shipping cost",
  sum(CS_NET_PROFIT) as "total net profit"
from catalog_sales cs1,
  date_dim,
  customer_address,
  call_center
where D_DATE between '2001-4-01' and dateadd(day, 60, (cast('2001-4-01' as date)))
  and cs1.CS_SHIP_DATE_SK = D_DATE_SK
  and cs1.CS_SHIP_ADDR_SK = CA_ADDRESS_SK
  and CA_STATE = 'WI'
  and cs1.CS_CALL_CENTER_SK = CC_CALL_CENTER_SK
  and CC_COUNTY in (
    'Williamson County',
    'Walker County',
    'Ziebach County',
    'Williamson County',
    'Ziebach County'
  )
  and exists (
    select *
    from catalog_sales cs2
    where cs1.CS_ORDER_NUMBER = cs2.CS_ORDER_NUMBER
      and cs1.CS_WAREHOUSE_SK <> cs2.CS_WAREHOUSE_SK
  )
  and not exists(
    select *
    from catalog_returns cr1
    where cs1.CS_ORDER_NUMBER = cr1.CR_ORDER_NUMBER
  )
order by count(distinct CS_ORDER_NUMBER) option (label = 'TPCDS-Q16');