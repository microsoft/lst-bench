with ss as (
       select S_STORE_SK,
              sum(SS_EXT_SALES_PRICE) as sales,
              sum(SS_NET_PROFIT) as profit
       from store_sales,
              date_dim,
              store
       where SS_SOLD_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
              and SS_STORE_SK = S_STORE_SK
       group by S_STORE_SK
),
sr as (
       select S_STORE_SK,
              sum(SR_RETURN_AMT) as returns,
              sum(SR_NET_LOSS) as profit_loss
       from store_returns,
              date_dim,
              store
       where SR_RETURNED_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
              and SR_STORE_SK = S_STORE_SK
       group by S_STORE_SK
),
cs as (
       select CS_CALL_CENTER_SK,
              sum(CS_EXT_SALES_PRICE) as sales,
              sum(CS_NET_PROFIT) as profit
       from catalog_sales,
              date_dim
       where CS_SOLD_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
       group by CS_CALL_CENTER_SK
),
cr as (
       select CR_CALL_CENTER_SK,
              sum(CR_RETURN_AMOUNT) as returns,
              sum(CR_NET_LOSS) as profit_loss
       from catalog_returns,
              date_dim
       where CR_RETURNED_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
       group by CR_CALL_CENTER_SK
),
ws as (
       select WP_WEB_PAGE_SK,
              sum(WS_EXT_SALES_PRICE) as sales,
              sum(WS_NET_PROFIT) as profit
       from web_sales,
              date_dim,
              web_page
       where WS_SOLD_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
              and WS_WEB_PAGE_SK = WP_WEB_PAGE_SK
       group by WP_WEB_PAGE_SK
),
wr as (
       select WP_WEB_PAGE_SK,
              sum(WR_RETURN_AMT) as returns,
              sum(WR_NET_LOSS) as profit_loss
       from web_returns,
              date_dim,
              web_page
       where WR_RETURNED_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
              and WR_WEB_PAGE_SK = WP_WEB_PAGE_SK
       group by WP_WEB_PAGE_SK
)
select top 100 channel,
       id,
       sum(sales) as sales,
       sum(returns) as returns,
       sum(profit) as profit
from (
              select 'store channel' as channel,
                     ss.S_STORE_SK as id,
                     sales,
                     coalesce(returns, 0) as returns,
                     (profit - coalesce(profit_loss, 0)) as profit
              from ss
                     left join sr on ss.S_STORE_SK = sr.S_STORE_SK
              union all
              select 'catalog channel' as channel,
                     CS_CALL_CENTER_SK as id,
                     sales,
                     returns,
                     (profit - profit_loss) as profit
              from cs,
                     cr
              union all
              select 'web channel' as channel,
                     ws.WP_WEB_PAGE_SK as id,
                     sales,
                     coalesce(returns, 0) returns,
                     (profit - coalesce(profit_loss, 0)) as profit
              from ws
                     left join wr on ws.WP_WEB_PAGE_SK = wr.WP_WEB_PAGE_SK
       ) x
group by rollup (channel, id)
order by channel,
       id option (label = 'TPCDS-Q77');