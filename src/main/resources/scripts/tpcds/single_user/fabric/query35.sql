select top 100 CA_STATE,
      CD_GENDER,
      CD_MARITAL_STATUS,
      CD_DEP_COUNT,
      count(*) cnt1,
      sum(CD_DEP_COUNT),
      min(CD_DEP_COUNT),
      max(CD_DEP_COUNT),
      CD_DEP_EMPLOYED_COUNT,
      count(*) cnt2,
      sum(CD_DEP_EMPLOYED_COUNT),
      min(CD_DEP_EMPLOYED_COUNT),
      max(CD_DEP_EMPLOYED_COUNT),
      CD_DEP_COLLEGE_COUNT,
      count(*) cnt3,
      sum(CD_DEP_COLLEGE_COUNT),
      min(CD_DEP_COLLEGE_COUNT),
      max(CD_DEP_COLLEGE_COUNT)
from customer c,
      customer_address ca,
      customer_demographics
where c.C_CURRENT_ADDR_SK = ca.CA_ADDRESS_SK
      and CD_DEMO_SK = c.C_CURRENT_CDEMO_SK
      and exists (
            select *
            from store_sales,
                  date_dim
            where c.C_CUSTOMER_SK = SS_CUSTOMER_SK
                  and SS_SOLD_DATE_SK = D_DATE_SK
                  and D_YEAR = 2002
                  and D_QOY < 4
      )
      and (
            exists (
                  select *
                  from web_sales,
                        date_dim
                  where c.C_CUSTOMER_SK = WS_BILL_CUSTOMER_SK
                        and WS_SOLD_DATE_SK = D_DATE_SK
                        and D_YEAR = 2002
                        and D_QOY < 4
            )
            or exists (
                  select *
                  from catalog_sales,
                        date_dim
                  where c.C_CUSTOMER_SK = CS_SHIP_CUSTOMER_SK
                        and CS_SOLD_DATE_SK = D_DATE_SK
                        and D_YEAR = 2002
                        and D_QOY < 4
            )
      )
group by CA_STATE,
      CD_GENDER,
      CD_MARITAL_STATUS,
      CD_DEP_COUNT,
      CD_DEP_EMPLOYED_COUNT,
      CD_DEP_COLLEGE_COUNT
order by CA_STATE,
      CD_GENDER,
      CD_MARITAL_STATUS,
      CD_DEP_COUNT,
      CD_DEP_EMPLOYED_COUNT,
      CD_DEP_COLLEGE_COUNT option (label = 'TPCDS-Q35');