with v1 as(
  select I_CATEGORY,
    I_BRAND,
    S_STORE_NAME,
    S_COMPANY_NAME,
    D_YEAR,
    D_MOY,
    sum(SS_SALES_PRICE) sum_sales,
    avg(sum(SS_SALES_PRICE)) over (
      partition by I_CATEGORY,
      I_BRAND,
      S_STORE_NAME,
      S_COMPANY_NAME,
      D_YEAR
    ) avg_monthly_sales,
    rank() over (
      partition by I_CATEGORY,
      I_BRAND,
      S_STORE_NAME,
      S_COMPANY_NAME
      order by D_YEAR,
        D_MOY
    ) rn
  from item,
    store_sales,
    date_dim,
    store
  where SS_ITEM_SK = I_ITEM_SK
    and SS_SOLD_DATE_SK = D_DATE_SK
    and SS_STORE_SK = S_STORE_SK
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
    S_STORE_NAME,
    S_COMPANY_NAME,
    D_YEAR,
    D_MOY
),
v2 as(
  select v1.I_CATEGORY,
    v1.I_BRAND,
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
    and v1.S_STORE_NAME = v1_lag.S_STORE_NAME
    and v1.S_STORE_NAME = v1_lead.S_STORE_NAME
    and v1.S_COMPANY_NAME = v1_lag.S_COMPANY_NAME
    and v1.S_COMPANY_NAME = v1_lead.S_COMPANY_NAME
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
  psum option (label = 'TPCDS-Q47');