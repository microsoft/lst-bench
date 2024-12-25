WITH web_v1 as (
  select WS_ITEM_SK item_sk,
    D_DATE,
    sum(sum(WS_SALES_PRICE)) over (
      partition by WS_ITEM_SK
      order by D_DATE rows between unbounded preceding and current row
    ) cume_sales
  from web_sales,
    date_dim
  where WS_SOLD_DATE_SK = D_DATE_SK
    and D_MONTH_SEQ between 1176 and 1176 + 11
    and WS_ITEM_SK is not NULL
  group by WS_ITEM_SK,
    D_DATE
),
store_v1 as (
  select SS_ITEM_SK item_sk,
    D_DATE,
    sum(sum(SS_SALES_PRICE)) over (
      partition by SS_ITEM_SK
      order by D_DATE rows between unbounded preceding and current row
    ) cume_sales
  from store_sales,
    date_dim
  where SS_SOLD_DATE_SK = D_DATE_SK
    and D_MONTH_SEQ between 1176 and 1176 + 11
    and SS_ITEM_SK is not NULL
  group by SS_ITEM_SK,
    D_DATE
)
select top 100 *
from (
    select item_sk,
      D_DATE,
      web_sales,
      store_sales,
      max(web_sales) over (
        partition by item_sk
        order by D_DATE rows between unbounded preceding and current row
      ) web_cumulative,
      max(store_sales) over (
        partition by item_sk
        order by D_DATE rows between unbounded preceding and current row
      ) store_cumulative
    from (
        select case
            when web.item_sk is not null then web.item_sk
            else store.item_sk
          end item_sk,
case
            when web.D_DATE is not null then web.D_DATE
            else store.D_DATE
          end D_DATE,
          web.cume_sales web_sales,
          store.cume_sales store_sales
        from web_v1 web
          full outer join store_v1 store on (
            web.item_sk = store.item_sk
            and web.D_DATE = store.D_DATE
          )
      ) x
  ) y
where web_cumulative > store_cumulative
order by item_sk,
  D_DATE option (label = 'TPCDS-Q51');