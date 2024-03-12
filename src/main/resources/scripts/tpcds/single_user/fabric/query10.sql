select top 100 CD_GENDER,
      CD_MARITAL_STATUS,
      CD_EDUCATION_STATUS,
      count(*) cnt1,
      CD_PURCHASE_ESTIMATE,
      count(*) cnt2,
      CD_CREDIT_RATING,
      count(*) cnt3,
      CD_DEP_COUNT,
      count(*) cnt4,
      CD_DEP_EMPLOYED_COUNT,
      count(*) cnt5,
      CD_DEP_COLLEGE_COUNT,
      count(*) cnt6
from customer c,
      customer_address ca,
      customer_demographics
where c.C_CURRENT_ADDR_SK = ca.CA_ADDRESS_SK
      and CA_COUNTY in (
            'Nuckolls County',
            'Bullitt County',
            'Franklin County',
            'Las Animas County',
            'Lawrence County'
      )
      and CD_DEMO_SK = c.C_CURRENT_CDEMO_SK
      and exists (
            select *
            from store_sales,
                  date_dim
            where c.C_CUSTOMER_SK = SS_CUSTOMER_SK
                  and SS_SOLD_DATE_SK = D_DATE_SK
                  and D_YEAR = 2001
                  and D_MOY between 2 and 2 + 3
      )
      and (
            exists (
                  select *
                  from web_sales,
                        date_dim
                  where c.C_CUSTOMER_SK = WS_BILL_CUSTOMER_SK
                        and WS_SOLD_DATE_SK = D_DATE_SK
                        and D_YEAR = 2001
                        and D_MOY between 2 ANd 2 + 3
            )
            or exists (
                  select *
                  from catalog_sales,
                        date_dim
                  where c.C_CUSTOMER_SK = CS_SHIP_CUSTOMER_SK
                        and CS_SOLD_DATE_SK = D_DATE_SK
                        and D_YEAR = 2001
                        and D_MOY between 2 and 2 + 3
            )
      )
group by CD_GENDER,
      CD_MARITAL_STATUS,
      CD_EDUCATION_STATUS,
      CD_PURCHASE_ESTIMATE,
      CD_CREDIT_RATING,
      CD_DEP_COUNT,
      CD_DEP_EMPLOYED_COUNT,
      CD_DEP_COLLEGE_COUNT
order by CD_GENDER,
      CD_MARITAL_STATUS,
      CD_EDUCATION_STATUS,
      CD_PURCHASE_ESTIMATE,
      CD_CREDIT_RATING,
      CD_DEP_COUNT,
      CD_DEP_EMPLOYED_COUNT,
      CD_DEP_COLLEGE_COUNT option (label = 'TPCDS-Q10');