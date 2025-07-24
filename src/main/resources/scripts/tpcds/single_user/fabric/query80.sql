with ssr as (
       select S_STORE_ID as store_id,
              sum(SS_EXT_SALES_PRICE) as sales,
              sum(coalesce(SR_RETURN_AMT, 0)) as returns,
              sum(SS_NET_PROFIT - coalesce(SR_NET_LOSS, 0)) as profit
       from store_sales
              left outer join store_returns on (
                     SS_ITEM_SK = SR_ITEM_SK
                     and SS_TICKET_NUMBER = SR_TICKET_NUMBER
              ),
              date_dim,
              store,
              item,
              promotion
       where SS_SOLD_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
              and SS_STORE_SK = S_STORE_SK
              and SS_ITEM_SK = I_ITEM_SK
              and I_CURRENT_PRICE > 50
              and SS_PROMO_SK = P_PROMO_SK
              and P_CHANNEL_TV = 'N'
       group by S_STORE_ID
),
csr as (
       select CP_CATALOG_PAGE_ID as catalog_page_id,
              sum(CS_EXT_SALES_PRICE) as sales,
              sum(coalesce(CR_RETURN_AMOUNT, 0)) as returns,
              sum(CS_NET_PROFIT - coalesce(CR_NET_LOSS, 0)) as profit
       from catalog_sales
              left outer join catalog_returns on (
                     CS_ITEM_SK = CR_ITEM_SK
                     and CS_ORDER_NUMBER = CR_ORDER_NUMBER
              ),
              date_dim,
              catalog_page,
              item,
              promotion
       where CS_SOLD_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
              and CS_CATALOG_PAGE_SK = CP_CATALOG_PAGE_SK
              and CS_ITEM_SK = I_ITEM_SK
              and I_CURRENT_PRICE > 50
              and CS_PROMO_SK = P_PROMO_SK
              and P_CHANNEL_TV = 'N'
       group by CP_CATALOG_PAGE_ID
),
wsr as (
       select WEB_SITE_ID,
              sum(WS_EXT_SALES_PRICE) as sales,
              sum(coalesce(WR_RETURN_AMT, 0)) as returns,
              sum(WS_NET_PROFIT - coalesce(WR_NET_LOSS, 0)) as profit
       from web_sales
              left outer join web_returns on (
                     WS_ITEM_SK = WR_ITEM_SK
                     and WS_ORDER_NUMBER = WR_ORDER_NUMBER
              ),
              date_dim,
              web_site,
              item,
              promotion
       where WS_SOLD_DATE_SK = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 30, (cast('2000-08-21' as date)))
              and WS_WEB_SITE_SK = WEB_SITE_SK
              and WS_ITEM_SK = I_ITEM_SK
              and I_CURRENT_PRICE > 50
              and WS_PROMO_SK = P_PROMO_SK
              and P_CHANNEL_TV = 'N'
       group by WEB_SITE_ID
)
select top 100 channel,
       id,
       sum(sales) as sales,
       sum(returns) as returns,
       sum(profit) as profit
from (
              select 'store channel' as channel,
                     'store' + store_id as id,
                     sales,
                     returns,
                     profit
              from ssr
              union all
              select 'catalog channel' as channel,
                     'catalog_page' + catalog_page_id as id,
                     sales,
                     returns,
                     profit
              from csr
              union all
              select 'web channel' as channel,
                     'web_site' + WEB_SITE_ID as id,
                     sales,
                     returns,
                     profit
              from wsr
       ) x
group by rollup (channel, id)
order by channel,
       id option (label = 'TPCDS-Q80');