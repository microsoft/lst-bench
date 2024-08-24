with v1 as(
  select I_CATEGORY,
    I_BRAND,
    CC_NAME,
    D_YEAR,
    D_MOY,
    sum(CS_SALES_PRICE) sum_sales,
    avg(sum(CS_SALES_PRICE)) over (
      partition by I_CATEGORY,
      I_BRAND,
      CC_NAME,
      D_YEAR
    ) avg_monthly_sales,
    rank() over (
      partition by I_CATEGORY,
      I_BRAND,
      CC_NAME
      order by D_YEAR,
        D_MOY
    ) rn
  from item,
    catalog_sales,
    date_dim,
    call_center
  where CS_ITEM_SK = I_ITEM_SK
    and CS_SOLD_DATE_SK = D_DATE_SK
    and CC_CALL_CENTER_SK = CS_CALL_CENTER_SK
    and (
      D_YEAR = 2001
      or (
        D_YEAR = 2001 -1
        and D_MOY = 12
      )
      or (
        D_YEAR = 2001 + 1
        and D_MOY = 1
      )
    )
  group by I_CATEGORY,
    I_BRAND,
    CC_NAME,
    D_YEAR,
    D_MOY
),
v2 as(
  select v1.I_CATEGORY,
    v1.D_YEAR,
    v1.D_MOY,
    v1.avg_monthly_sales,
    v1.sum_sales,
    v1_lag.sum_sales psum,
    v1_lead.sum_sales nsum
  from v1,
    v1 v1_lag,
    v1 v1_lead
  where v1.I_CATEGORY = v1_lag.I_CATEGORY
    and v1.I_CATEGORY = v1_lead.I_CATEGORY
    and v1.I_BRAND = v1_lag.I_BRAND
    and v1.I_BRAND = v1_lead.I_BRAND
    and v1.CC_NAME = v1_lag.CC_NAME
    and v1.CC_NAME = v1_lead.CC_NAME
    and v1.rn = v1_lag.rn + 1
    and v1.rn = v1_lead.rn - 1
)
select top 100 *
from v2
where D_YEAR = 2001
  and avg_monthly_sales > 0
  and case
    when avg_monthly_sales > 0 then abs(sum_sales - avg_monthly_sales) / avg_monthly_sales
    else null
  end > 0.1
order by sum_sales - avg_monthly_sales,
  psum option (label = 'TPCDS-Q57');