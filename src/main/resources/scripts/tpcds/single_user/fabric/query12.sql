select top 100 I_ITEM_ID,
        I_ITEM_DESC,
        I_CATEGORY,
        I_CLASS,
        I_CURRENT_PRICE,
        sum(WS_EXT_SALES_PRICE) as itemrevenue,
        sum(WS_EXT_SALES_PRICE) * 100 / sum(sum(WS_EXT_SALES_PRICE)) over (partition by I_CLASS) as revenueratio
from web_sales,
        item,
        date_dim
where WS_ITEM_SK = I_ITEM_SK
        and I_CATEGORY in ('Jewelry', 'Men', 'Electronics')
        and WS_SOLD_DATE_SK = D_DATE_SK
        and D_DATE between cast('1999-03-09' as date)
        and dateadd(day, 30, (cast('1999-03-09' as date)))
group by I_ITEM_ID,
        I_ITEM_DESC,
        I_CATEGORY,
        I_CLASS,
        I_CURRENT_PRICE
order by I_CATEGORY,
        I_CLASS,
        I_ITEM_ID,
        I_ITEM_DESC,
        revenueratio option (label = 'TPCDS-Q12');