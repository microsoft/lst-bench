select top 100 *
from(
    select W_WAREHOUSE_NAME,
      I_ITEM_ID,
      sum(
        case
          when (
            cast(D_DATE as date) < cast ('2000-06-06' as date)
          ) then INV_QUANTITY_ON_HAND
          else 0
        end
      ) as inv_before,
      sum(
        case
          when (
            cast(D_DATE as date) >= cast ('2000-06-06' as date)
          ) then INV_QUANTITY_ON_HAND
          else 0
        end
      ) as inv_after
    from inventory,
      warehouse,
      item,
      date_dim
    where I_CURRENT_PRICE between 0.99 and 1.49
      and I_ITEM_SK = INV_ITEM_SK
      and INV_WAREHOUSE_SK = W_WAREHOUSE_SK
      and INV_DATE_SK = D_DATE_SK
      and D_DATE between dateadd(day, -30, (cast ('2000-06-06' as date)))
      and dateadd(day, 30, (cast ('2000-06-06' as date)))
    group by W_WAREHOUSE_NAME,
      I_ITEM_ID
  ) x
where (
    case
      when inv_before > 0 then inv_after / inv_before
      else null
    end
  ) between 2.0 / 3.0 and 3.0 / 2.0
order by W_WAREHOUSE_NAME,
  I_ITEM_ID option (label = 'TPCDS-Q21');