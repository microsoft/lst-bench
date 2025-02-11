with ssr as (
       select S_STORE_ID,
              sum(sales_price) as sales,
              sum(profit) as profit,
              sum(return_amt) as returns,
              sum(net_loss) as profit_loss
       from (
                     select SS_STORE_SK as store_sk,
                            SS_SOLD_DATE_SK as date_sk,
                            SS_EXT_SALES_PRICE as sales_price,
                            SS_NET_PROFIT as profit,
                            cast(0 as decimal(7, 2)) as return_amt,
                            cast(0 as decimal(7, 2)) as net_loss
                     from store_sales
                     union all
                     select SR_STORE_SK as store_sk,
                            SR_RETURNED_DATE_SK as date_sk,
                            cast(0 as decimal(7, 2)) as sales_price,
                            cast(0 as decimal(7, 2)) as profit,
                            SR_RETURN_AMT as return_amt,
                            SR_NET_LOSS as net_loss
                     from store_returns
              ) salesreturns,
              date_dim,
              store
       where date_sk = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 14, (cast('2000-08-21' as date)))
              and store_sk = S_STORE_SK
       group by S_STORE_ID
),
csr as (
       select CP_CATALOG_PAGE_ID,
              sum(sales_price) as sales,
              sum(profit) as profit,
              sum(return_amt) as returns,
              sum(net_loss) as profit_loss
       from (
                     select CS_CATALOG_PAGE_SK as page_sk,
                            CS_SOLD_DATE_SK as date_sk,
                            CS_EXT_SALES_PRICE as sales_price,
                            CS_NET_PROFIT as profit,
                            cast(0 as decimal(7, 2)) as return_amt,
                            cast(0 as decimal(7, 2)) as net_loss
                     from catalog_sales
                     union all
                     select CR_CATALOG_PAGE_SK as page_sk,
                            CR_RETURNED_DATE_SK as date_sk,
                            cast(0 as decimal(7, 2)) as sales_price,
                            cast(0 as decimal(7, 2)) as profit,
                            CR_RETURN_AMOUNT as return_amt,
                            CR_NET_LOSS as net_loss
                     from catalog_returns
              ) salesreturns,
              date_dim,
              catalog_page
       where date_sk = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 14, (cast('2000-08-21' as date)))
              and page_sk = CP_CATALOG_PAGE_SK
       group by CP_CATALOG_PAGE_ID
),
wsr as (
       select WEB_SITE_ID,
              sum(sales_price) as sales,
              sum(profit) as profit,
              sum(return_amt) as returns,
              sum(net_loss) as profit_loss
       from (
                     select WS_WEB_SITE_SK as wsr_web_site_sk,
                            WS_SOLD_DATE_SK as date_sk,
                            WS_EXT_SALES_PRICE as sales_price,
                            WS_NET_PROFIT as profit,
                            cast(0 as decimal(7, 2)) as return_amt,
                            cast(0 as decimal(7, 2)) as net_loss
                     from web_sales
                     union all
                     select WS_WEB_SITE_SK as wsr_web_site_sk,
                            WR_RETURNED_DATE_SK as date_sk,
                            cast(0 as decimal(7, 2)) as sales_price,
                            cast(0 as decimal(7, 2)) as profit,
                            WR_RETURN_AMT as return_amt,
                            WR_NET_LOSS as net_loss
                     from web_returns
                            left outer join web_sales on (
                                   WR_ITEM_SK = WS_ITEM_SK
                                   and WR_ORDER_NUMBER = WS_ORDER_NUMBER
                            )
              ) salesreturns,
              date_dim,
              web_site
       where date_sk = D_DATE_SK
              and D_DATE between cast('2000-08-21' as date)
              and dateadd(day, 14, (cast('2000-08-21' as date)))
              and wsr_web_site_sk = WEB_SITE_SK
       group by WEB_SITE_ID
)
select top 100 channel,
       id,
       sum(sales) as sales,
       sum(returns) as returns,
       sum(profit) as profit
from (
              select 'store channel' as channel,
                     'store' + S_STORE_ID as id,
                     sales,
                     returns,
                     (profit - profit_loss) as profit
              from ssr
              union all
              select 'catalog channel' as channel,
                     'catalog_page' + CP_CATALOG_PAGE_ID as id,
                     sales,
                     returns,
                     (profit - profit_loss) as profit
              from csr
              union all
              select 'web channel' as channel,
                     'web_site' + WEB_SITE_ID as id,
                     sales,
                     returns,
                     (profit - profit_loss) as profit
              from wsr
       ) x
group by rollup (channel, id)
order by channel,
       id option (label = 'TPCDS-Q5');