select sum (SS_QUANTITY)
from store_sales,
  store,
  customer_demographics,
  customer_address,
  date_dim
where S_STORE_SK = SS_STORE_SK
  and SS_SOLD_DATE_SK = D_DATE_SK
  and D_YEAR = 2000
  and (
    (
      CD_DEMO_SK = SS_CDEMO_SK
      and CD_MARITAL_STATUS = 'U'
      and CD_EDUCATION_STATUS = 'Advanced Degree'
      and SS_SALES_PRICE between 100.00 and 150.00
    )
    or (
      CD_DEMO_SK = SS_CDEMO_SK
      and CD_MARITAL_STATUS = 'D'
      and CD_EDUCATION_STATUS = 'Unknown'
      and SS_SALES_PRICE between 50.00 and 100.00
    )
    or (
      CD_DEMO_SK = SS_CDEMO_SK
      and CD_MARITAL_STATUS = 'M'
      and CD_EDUCATION_STATUS = 'Secondary'
      and SS_SALES_PRICE between 150.00 and 200.00
    )
  )
  and (
    (
      SS_ADDR_SK = CA_ADDRESS_SK
      and CA_COUNTRY = 'United States'
      and CA_STATE in ('OH', 'AR', 'WI')
      and SS_NET_PROFIT between 0 and 2000
    )
    or (
      SS_ADDR_SK = CA_ADDRESS_SK
      and CA_COUNTRY = 'United States'
      and CA_STATE in ('AL', 'CO', 'IA')
      and SS_NET_PROFIT between 150 and 3000
    )
    or (
      SS_ADDR_SK = CA_ADDRESS_SK
      and CA_COUNTRY = 'United States'
      and CA_STATE in ('IN', 'PA', 'KS')
      and SS_NET_PROFIT between 50 and 25000
    )
  ) option (label = 'TPCDS-Q48');