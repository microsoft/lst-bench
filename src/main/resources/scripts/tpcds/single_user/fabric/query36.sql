select top 100 sum(SS_NET_PROFIT) / sum(SS_EXT_SALES_PRICE) as gross_margin,
  I_CATEGORY,
  I_CLASS,
  grouping(I_CATEGORY) + grouping(I_CLASS) as lochierarchy,
  rank() over (
    partition by grouping(I_CATEGORY) + grouping(I_CLASS),
    case
      when grouping(I_CLASS) = 0 then I_CATEGORY
    end
    order by sum(SS_NET_PROFIT) / sum(SS_EXT_SALES_PRICE) asc
  ) as rank_within_parent
from store_sales,
  date_dim d1,
  item,
  store
where d1.D_YEAR = 2001
  and d1.D_DATE_SK = SS_SOLD_DATE_SK
  and I_ITEM_SK = SS_ITEM_SK
  and S_STORE_SK = SS_STORE_SK
  and S_STATE in (
    'TN',
    'AL',
    'SD',
    'TN',
    'SD',
    'SD',
    'SD',
    'TN'
  )
group by rollup(I_CATEGORY, I_CLASS)
order by lochierarchy desc,
case
    when grouping(I_CATEGORY) + grouping(I_CLASS) = 0 then I_CATEGORY
  end,
  rank_within_parent option (label = 'TPCDS-Q36');