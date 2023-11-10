select top 100 CD_GENDER,
      CD_MARITAL_STATUS,
      CD_EDUCATION_STATUS,
      count(*) cnt1,
      CD_PURCHASE_ESTIMATE,
      count(*) cnt2,
      CD_CREDIT_RATING,
      count(*) cnt3
from customer c,
      customer_address ca,
      customer_demographics
where c.C_CURRENT_ADDR_SK = ca.CA_ADDRESS_SK
      and CA_STATE in ('MO', 'WI', 'SC')
      and CD_DEMO_SK = c.C_CURRENT_CDEMO_SK
      and exists (
            select *
            from store_sales,
                  date_dim
            where c.C_CUSTOMER_SK = SS_CUSTOMER_SK
                  and SS_SOLD_DATE_SK = D_DATE_SK
                  and D_YEAR = 2003
                  and D_MOY between 1 and 1 + 2
      )
      and (
            not exists (
                  select *
                  from web_sales,
                        date_dim
                  where c.C_CUSTOMER_SK = WS_BILL_CUSTOMER_SK
                        and WS_SOLD_DATE_SK = D_DATE_SK
                        and D_YEAR = 2003
                        and D_MOY between 1 and 1 + 2
            )
            and not exists (
                  select *
                  from catalog_sales,
                        date_dim
                  where c.C_CUSTOMER_SK = CS_SHIP_CUSTOMER_SK
                        and CS_SOLD_DATE_SK = D_DATE_SK
                        and D_YEAR = 2003
                        and D_MOY between 1 and 1 + 2
            )
      )
group by CD_GENDER,
      CD_MARITAL_STATUS,
      CD_EDUCATION_STATUS,
      CD_PURCHASE_ESTIMATE,
      CD_CREDIT_RATING
order by CD_GENDER,
      CD_MARITAL_STATUS,
      CD_EDUCATION_STATUS,
      CD_PURCHASE_ESTIMATE,
      CD_CREDIT_RATING option (label = 'TPCDS-Q69');