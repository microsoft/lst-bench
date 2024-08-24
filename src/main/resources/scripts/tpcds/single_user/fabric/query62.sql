select top 100 substring(W_WAREHOUSE_NAME, 1, 20),
  SM_TYPE,
  WEB_NAME,
  sum(
    case
      when (WS_SHIP_DATE_SK - WS_SOLD_DATE_SK <= 30) then 1
      else 0
    end
  ) as "30 days",
  sum(
    case
      when (WS_SHIP_DATE_SK - WS_SOLD_DATE_SK > 30)
      and (WS_SHIP_DATE_SK - WS_SOLD_DATE_SK <= 60) then 1
      else 0
    end
  ) as "31-60 days",
  sum(
    case
      when (WS_SHIP_DATE_SK - WS_SOLD_DATE_SK > 60)
      and (WS_SHIP_DATE_SK - WS_SOLD_DATE_SK <= 90) then 1
      else 0
    end
  ) as "61-90 days",
  sum(
    case
      when (WS_SHIP_DATE_SK - WS_SOLD_DATE_SK > 90)
      and (WS_SHIP_DATE_SK - WS_SOLD_DATE_SK <= 120) then 1
      else 0
    end
  ) as "91-120 days",
  sum(
    case
      when (WS_SHIP_DATE_SK - WS_SOLD_DATE_SK > 120) then 1
      else 0
    end
  ) as ">120 days"
from web_sales,
  warehouse,
  ship_mode,
  web_site,
  date_dim
where D_MONTH_SEQ between 1176 and 1176 + 11
  and WS_SHIP_DATE_SK = D_DATE_SK
  and WS_WAREHOUSE_SK = W_WAREHOUSE_SK
  and WS_SHIP_MODE_SK = SM_SHIP_MODE_SK
  and WS_WEB_SITE_SK = WEB_SITE_SK
group by substring(W_WAREHOUSE_NAME, 1, 20),
  SM_TYPE,
  WEB_NAME
order by substring(W_WAREHOUSE_NAME, 1, 20),
  SM_TYPE,
  WEB_NAME option (label = 'TPCDS-Q62');