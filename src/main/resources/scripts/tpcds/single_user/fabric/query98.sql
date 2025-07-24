select I_ITEM_ID,
        I_ITEM_DESC,
        I_CATEGORY,
        I_CLASS,
        I_CURRENT_PRICE,
        sum(SS_EXT_SALES_PRICE) as itemrevenue,
        sum(SS_EXT_SALES_PRICE) * 100 / sum(sum(SS_EXT_SALES_PRICE)) over (partition by I_CLASS) as revenueratio
from store_sales,
        item,
        date_dim
where SS_ITEM_SK = I_ITEM_SK
        and I_CATEGORY in ('Jewelry', 'Men', 'Electronics')
        and SS_SOLD_DATE_SK = D_DATE_SK
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
        revenueratio option (label = 'TPCDS-Q98');