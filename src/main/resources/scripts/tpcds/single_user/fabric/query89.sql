select top 100 *
from(
    select I_CATEGORY,
      I_CLASS,
      I_BRAND,
      S_STORE_NAME,
      S_COMPANY_NAME,
      D_MOY,
      sum(SS_SALES_PRICE) sum_sales,
      avg(sum(SS_SALES_PRICE)) over (
        partition by I_CATEGORY,
        I_BRAND,
        S_STORE_NAME,
        S_COMPANY_NAME
      ) avg_monthly_sales
    from item,
      store_sales,
      date_dim,
      store
    where SS_ITEM_SK = I_ITEM_SK
      and SS_SOLD_DATE_SK = D_DATE_SK
      and SS_STORE_SK = S_STORE_SK
      and D_YEAR in (1999)
      and (
        (
          I_CATEGORY in ('Jewelry', 'Men', 'Women')
          and I_CLASS in ('rings', 'pants', 'swimwear')
        )
        or (
          I_CATEGORY in ('Electronics', 'Sports', 'Jewelry')
          and I_CLASS in ('televisions', 'optics', 'costume')
        )
      )
    group by I_CATEGORY,
      I_CLASS,
      I_BRAND,
      S_STORE_NAME,
      S_COMPANY_NAME,
      D_MOY
  ) tmp1
where case
    when (avg_monthly_sales <> 0) then (
      abs(sum_sales - avg_monthly_sales) / avg_monthly_sales
    )
    else null
  end > 0.1
order by sum_sales - avg_monthly_sales,
  S_STORE_NAME option (label = 'TPCDS-Q89');