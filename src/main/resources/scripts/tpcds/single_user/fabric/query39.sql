with inv as (
  select W_WAREHOUSE_NAME,
    W_WAREHOUSE_SK,
    I_ITEM_SK,
    D_MOY,
    stdev,
    mean,
    case
      mean
      when 0 then null
      else stdev / mean
    end cov
  from(
      select W_WAREHOUSE_NAME,
        W_WAREHOUSE_SK,
        I_ITEM_SK,
        D_MOY,
        stdev(INV_QUANTITY_ON_HAND) stdev,
        avg(INV_QUANTITY_ON_HAND) mean
      from inventory,
        item,
        warehouse,
        date_dim
      where INV_ITEM_SK = I_ITEM_SK
        and INV_WAREHOUSE_SK = W_WAREHOUSE_SK
        and INV_DATE_SK = D_DATE_SK
        and D_YEAR = 2000
      group by W_WAREHOUSE_NAME,
        W_WAREHOUSE_SK,
        I_ITEM_SK,
        D_MOY
    ) foo
  where case
      mean
      when 0 then 0
      else stdev / mean
    end > 1
)
select inv1.W_WAREHOUSE_SK,
  inv1.I_ITEM_SK,
  inv1.D_MOY,
  inv1.mean,
  inv1.cov,
  inv2.W_WAREHOUSE_SK,
  inv2.I_ITEM_SK,
  inv2.D_MOY,
  inv2.mean,
  inv2.cov
from inv inv1,
  inv inv2
where inv1.I_ITEM_SK = inv2.I_ITEM_SK
  and inv1.W_WAREHOUSE_SK = inv2.W_WAREHOUSE_SK
  and inv1.D_MOY = 2
  and inv2.D_MOY = 2 + 1
order by inv1.W_WAREHOUSE_SK,
  inv1.I_ITEM_SK,
  inv1.D_MOY,
  inv1.mean,
  inv1.cov,
  inv2.D_MOY,
  inv2.mean,
  inv2.cov option (label = 'TPCDS-Q39a');