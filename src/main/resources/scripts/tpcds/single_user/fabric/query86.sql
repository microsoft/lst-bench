select top 100 sum(WS_NET_PAID) as total_sum,
   I_CATEGORY,
   I_CLASS,
   grouping(I_CATEGORY) + grouping(I_CLASS) as lochierarchy,
   rank() over (
      partition by grouping(I_CATEGORY) + grouping(I_CLASS),
      case
         when grouping(I_CLASS) = 0 then I_CATEGORY
      end
      order by sum(WS_NET_PAID) desc
   ) as rank_within_parent
from web_sales,
   date_dim d1,
   item
where d1.D_MONTH_SEQ between 1176 and 1176 + 11
   and d1.D_DATE_SK = WS_SOLD_DATE_SK
   and I_ITEM_SK = WS_ITEM_SK
group by rollup(I_CATEGORY, I_CLASS)
order by lochierarchy desc,
   case
      when grouping(I_CATEGORY) + grouping(I_CLASS) = 0 then I_CATEGORY
   end,
   rank_within_parent option (label = 'TPCDS-Q86');