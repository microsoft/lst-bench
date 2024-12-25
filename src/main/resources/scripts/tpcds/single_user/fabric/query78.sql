with ws as (
  select D_YEAR AS ws_sold_year,
    WS_ITEM_SK,
    WS_BILL_CUSTOMER_SK ws_customer_sk,
    sum(WS_QUANTITY) ws_qty,
    sum(WS_WHOLESALE_COST) ws_wc,
    sum(WS_SALES_PRICE) ws_sp
  from web_sales
    left join web_returns on WR_ORDER_NUMBER = WS_ORDER_NUMBER
    and WS_ITEM_SK = WR_ITEM_SK
    join date_dim on WS_SOLD_DATE_SK = D_DATE_SK
  where WR_ORDER_NUMBER is null
  group by D_YEAR,
    WS_ITEM_SK,
    WS_BILL_CUSTOMER_SK
),
cs as (
  select D_YEAR AS cs_sold_year,
    CS_ITEM_SK,
    CS_BILL_CUSTOMER_SK cs_customer_sk,
    sum(CS_QUANTITY) cs_qty,
    sum(CS_WHOLESALE_COST) cs_wc,
    sum(CS_SALES_PRICE) cs_sp
  from catalog_sales
    left join catalog_returns on CR_ORDER_NUMBER = CS_ORDER_NUMBER
    and CS_ITEM_SK = CR_ITEM_SK
    join date_dim on CS_SOLD_DATE_SK = D_DATE_SK
  where CR_ORDER_NUMBER is null
  group by D_YEAR,
    CS_ITEM_SK,
    CS_BILL_CUSTOMER_SK
),
ss as (
  select D_YEAR AS ss_sold_year,
    SS_ITEM_SK,
    SS_CUSTOMER_SK,
    sum(SS_QUANTITY) ss_qty,
    sum(SS_WHOLESALE_COST) ss_wc,
    sum(SS_SALES_PRICE) ss_sp
  from store_sales
    left join store_returns on SR_TICKET_NUMBER = SS_TICKET_NUMBER
    and SS_ITEM_SK = SR_ITEM_SK
    join date_dim on SS_SOLD_DATE_SK = D_DATE_SK
  where SR_TICKET_NUMBER is null
  group by D_YEAR,
    SS_ITEM_SK,
    SS_CUSTOMER_SK
)
select top 100 SS_CUSTOMER_SK,
  round(ss_qty /(coalesce(ws_qty, 0) + coalesce(cs_qty, 0)), 2) ratio,
  ss_qty store_qty,
  ss_wc store_wholesale_cost,
  ss_sp store_sales_price,
  coalesce(ws_qty, 0) + coalesce(cs_qty, 0) other_chan_qty,
  coalesce(ws_wc, 0) + coalesce(cs_wc, 0) other_chan_wholesale_cost,
  coalesce(ws_sp, 0) + coalesce(cs_sp, 0) other_chan_sales_price
from ss
  left join ws on (
    ws_sold_year = ss_sold_year
    and WS_ITEM_SK = SS_ITEM_SK
    and ws_customer_sk = SS_CUSTOMER_SK
  )
  left join cs on (
    cs_sold_year = ss_sold_year
    and CS_ITEM_SK = SS_ITEM_SK
    and cs_customer_sk = SS_CUSTOMER_SK
  )
where (
    coalesce(ws_qty, 0) > 0
    or coalesce(cs_qty, 0) > 0
  )
  and ss_sold_year = 1999
order by SS_CUSTOMER_SK,
  ss_qty desc,
  ss_wc desc,
  ss_sp desc,
  other_chan_qty,
  other_chan_wholesale_cost,
  other_chan_sales_price,
  ratio option (label = 'TPCDS-Q78');