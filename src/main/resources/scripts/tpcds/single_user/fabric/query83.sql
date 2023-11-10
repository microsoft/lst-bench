with sr_items as (
     select I_ITEM_ID item_id,
          sum(SR_RETURN_QUANTITY) sr_item_qty
     from store_returns,
          item,
          date_dim
     where SR_ITEM_SK = I_ITEM_SK
          and D_DATE in (
               select D_DATE
               from date_dim
               where D_WEEK_SEQ in (
                         select D_WEEK_SEQ
                         from date_dim
                         where D_DATE in ('2000-06-28', '2000-10-23', '2000-11-23')
                    )
          )
          and SR_RETURNED_DATE_SK = D_DATE_SK
     group by I_ITEM_ID
),
cr_items as (
     select I_ITEM_ID item_id,
          sum(CR_RETURN_QUANTITY) cr_item_qty
     from catalog_returns,
          item,
          date_dim
     where CR_ITEM_SK = I_ITEM_SK
          and D_DATE in (
               select D_DATE
               from date_dim
               where D_WEEK_SEQ in (
                         select D_WEEK_SEQ
                         from date_dim
                         where D_DATE in ('2000-06-28', '2000-10-23', '2000-11-23')
                    )
          )
          and CR_RETURNED_DATE_SK = D_DATE_SK
     group by I_ITEM_ID
),
wr_items as (
     select I_ITEM_ID item_id,
          sum(WR_RETURN_QUANTITY) wr_item_qty
     from web_returns,
          item,
          date_dim
     where WR_ITEM_SK = I_ITEM_SK
          and D_DATE in (
               select D_DATE
               from date_dim
               where D_WEEK_SEQ in (
                         select D_WEEK_SEQ
                         from date_dim
                         where D_DATE in ('2000-06-28', '2000-10-23', '2000-11-23')
                    )
          )
          and WR_RETURNED_DATE_SK = D_DATE_SK
     group by I_ITEM_ID
)
select top 100 sr_items.item_id,
     sr_item_qty,
     sr_item_qty /(sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 sr_dev,
     cr_item_qty,
     cr_item_qty /(sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 cr_dev,
     wr_item_qty,
     wr_item_qty /(sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 * 100 wr_dev,
(sr_item_qty + cr_item_qty + wr_item_qty) / 3.0 average
from sr_items,
     cr_items,
     wr_items
where sr_items.item_id = cr_items.item_id
     and sr_items.item_id = wr_items.item_id
order by sr_items.item_id,
     sr_item_qty option (label = 'TPCDS-Q83');