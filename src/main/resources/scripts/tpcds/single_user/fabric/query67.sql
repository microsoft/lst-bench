select top 100 *
from (
            select I_CATEGORY,
                  I_CLASS,
                  I_BRAND,
                  I_PRODUCT_NAME,
                  D_YEAR,
                  D_QOY,
                  D_MOY,
                  S_STORE_ID,
                  sumsales,
                  rank() over (
                        partition by I_CATEGORY
                        order by sumsales desc
                  ) rk
            from (
                        select I_CATEGORY,
                              I_CLASS,
                              I_BRAND,
                              I_PRODUCT_NAME,
                              D_YEAR,
                              D_QOY,
                              D_MOY,
                              S_STORE_ID,
                              sum(coalesce(SS_SALES_PRICE * SS_QUANTITY, 0)) sumsales
                        from store_sales,
                              date_dim,
                              store,
                              item
                        where SS_SOLD_DATE_SK = D_DATE_SK
                              and SS_ITEM_SK = I_ITEM_SK
                              and SS_STORE_SK = S_STORE_SK
                              and D_MONTH_SEQ between 1176 and 1176 + 11
                        group by rollup(
                                    I_CATEGORY,
                                    I_CLASS,
                                    I_BRAND,
                                    I_PRODUCT_NAME,
                                    D_YEAR,
                                    D_QOY,
                                    D_MOY,
                                    S_STORE_ID
                              )
                  ) dw1
      ) dw2
where rk <= 100
order by I_CATEGORY,
      I_CLASS,
      I_BRAND,
      I_PRODUCT_NAME,
      D_YEAR,
      D_QOY,
      D_MOY,
      S_STORE_ID,
      sumsales,
      rk option (label = 'TPCDS-Q67');