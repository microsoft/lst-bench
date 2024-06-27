select top 100 W_STATE,
    I_ITEM_ID,
    sum(
        case
            when (
                cast(D_DATE as date) < cast ('2000-06-06' as date)
            ) then CS_SALES_PRICE - coalesce(CR_REFUNDED_CASH, 0)
            else 0
        end
    ) as sales_before,
    sum(
        case
            when (
                cast(D_DATE as date) >= cast ('2000-06-06' as date)
            ) then CS_SALES_PRICE - coalesce(CR_REFUNDED_CASH, 0)
            else 0
        end
    ) as sales_after
from catalog_sales
    left outer join catalog_returns on (
        CS_ORDER_NUMBER = CR_ORDER_NUMBER
        and CS_ITEM_SK = CR_ITEM_SK
    ),
    warehouse,
    item,
    date_dim
where I_CURRENT_PRICE between 0.99 and 1.49
    and I_ITEM_SK = CS_ITEM_SK
    and CS_WAREHOUSE_SK = W_WAREHOUSE_SK
    and CS_SOLD_DATE_SK = D_DATE_SK
    and D_DATE between dateadd(day, -30, (cast ('2000-06-06' as date)))
    and dateadd(day, 30, (cast ('2000-06-06' as date)))
group by W_STATE,
    I_ITEM_ID
order by W_STATE,
    I_ITEM_ID option (label = 'TPCDS-Q40');