select avg(SS_QUANTITY),
   avg(SS_EXT_SALES_PRICE),
   avg(SS_EXT_WHOLESALE_COST),
   sum(SS_EXT_WHOLESALE_COST)
from store_sales,
   store,
   customer_demographics,
   household_demographics,
   customer_address,
   date_dim
where S_STORE_SK = SS_STORE_SK
   and SS_SOLD_DATE_SK = D_DATE_SK
   and D_YEAR = 2001
   and(
      (
         SS_HDEMO_SK = HD_DEMO_SK
         and CD_DEMO_SK = SS_CDEMO_SK
         and CD_MARITAL_STATUS = 'S'
         and CD_EDUCATION_STATUS = 'College'
         and SS_SALES_PRICE between 100.00 and 150.00
         and HD_DEP_COUNT = 3
      )
      or (
         SS_HDEMO_SK = HD_DEMO_SK
         and CD_DEMO_SK = SS_CDEMO_SK
         and CD_MARITAL_STATUS = 'D'
         and CD_EDUCATION_STATUS = '4 yr Degree'
         and SS_SALES_PRICE between 50.00 and 100.00
         and HD_DEP_COUNT = 1
      )
      or (
         SS_HDEMO_SK = HD_DEMO_SK
         and CD_DEMO_SK = SS_CDEMO_SK
         and CD_MARITAL_STATUS = 'M'
         and CD_EDUCATION_STATUS = 'Unknown'
         and SS_SALES_PRICE between 150.00 and 200.00
         and HD_DEP_COUNT = 1
      )
   )
   and(
      (
         SS_ADDR_SK = CA_ADDRESS_SK
         and CA_COUNTRY = 'United States'
         and CA_STATE in ('MO', 'WI', 'SC')
         and SS_NET_PROFIT between 100 and 200
      )
      or (
         SS_ADDR_SK = CA_ADDRESS_SK
         and CA_COUNTRY = 'United States'
         and CA_STATE in ('AL', 'CO', 'TX')
         and SS_NET_PROFIT between 150 and 300
      )
      or (
         SS_ADDR_SK = CA_ADDRESS_SK
         and CA_COUNTRY = 'United States'
         and CA_STATE in ('MI', 'LA', 'PA')
         and SS_NET_PROFIT between 50 and 250
      )
   ) option (label = 'TPCDS-Q13');