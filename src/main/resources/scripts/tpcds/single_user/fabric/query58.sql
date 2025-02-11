with ss_items as (
  select I_ITEM_ID item_id,
    sum(SS_EXT_SALES_PRICE) ss_item_rev
  from store_sales,
    item,
    date_dim
  where SS_ITEM_SK = I_ITEM_SK
    and D_DATE in (
      select D_DATE
      from date_dim
      where D_WEEK_SEQ = (
          select D_WEEK_SEQ
          from date_dim
          where D_DATE = '2000-07-19'
        )
    )
    and SS_SOLD_DATE_SK = D_DATE_SK
  group by I_ITEM_ID
),
cs_items as (
  select I_ITEM_ID item_id,
    sum(CS_EXT_SALES_PRICE) cs_item_rev
  from catalog_sales,
    item,
    date_dim
  where CS_ITEM_SK = I_ITEM_SK
    and D_DATE in (
      select D_DATE
      from date_dim
      where D_WEEK_SEQ = (
          select D_WEEK_SEQ
          from date_dim
          where D_DATE = '2000-07-19'
        )
    )
    and CS_SOLD_DATE_SK = D_DATE_SK
  group by I_ITEM_ID
),
ws_items as (
  select I_ITEM_ID item_id,
    sum(WS_EXT_SALES_PRICE) ws_item_rev
  from web_sales,
    item,
    date_dim
  where WS_ITEM_SK = I_ITEM_SK
    and D_DATE in (
      select D_DATE
      from date_dim
      where D_WEEK_SEQ =(
          select D_WEEK_SEQ
          from date_dim
          where D_DATE = '2000-07-19'
        )
    )
    and WS_SOLD_DATE_SK = D_DATE_SK
  group by I_ITEM_ID
)
select top 100 ss_items.item_id,
  ss_item_rev,
  ss_item_rev /((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 ss_dev,
  cs_item_rev,
  cs_item_rev /((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 cs_dev,
  ws_item_rev,
  ws_item_rev /((ss_item_rev + cs_item_rev + ws_item_rev) / 3) * 100 ws_dev,
(ss_item_rev + cs_item_rev + ws_item_rev) / 3 average
from ss_items,
  cs_items,
  ws_items
where ss_items.item_id = cs_items.item_id
  and ss_items.item_id = ws_items.item_id
  and ss_item_rev between 0.9 * cs_item_rev and 1.1 * cs_item_rev
  and ss_item_rev between 0.9 * ws_item_rev and 1.1 * ws_item_rev
  and cs_item_rev between 0.9 * ss_item_rev and 1.1 * ss_item_rev
  and cs_item_rev between 0.9 * ws_item_rev and 1.1 * ws_item_rev
  and ws_item_rev between 0.9 * ss_item_rev and 1.1 * ss_item_rev
  and ws_item_rev between 0.9 * cs_item_rev and 1.1 * cs_item_rev
order by item_id,
  ss_item_rev option (label = 'TPCDS-Q58');