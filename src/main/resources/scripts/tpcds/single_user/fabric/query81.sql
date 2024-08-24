with customer_total_return as (
  select CR_RETURNING_CUSTOMER_SK as ctr_customer_sk,
    CA_STATE as ctr_state,
    sum(CR_RETURN_AMT_INC_TAX) as ctr_total_return
  from catalog_returns,
    date_dim,
    customer_address
  where CR_RETURNED_DATE_SK = D_DATE_SK
    and D_YEAR = 2000
    and CR_RETURNING_ADDR_SK = CA_ADDRESS_SK
  group by CR_RETURNING_CUSTOMER_SK,
    CA_STATE
)
select top 100 C_CUSTOMER_ID,
  C_SALUTATION,
  C_FIRST_NAME,
  C_LAST_NAME,
  CA_STREET_NUMBER,
  CA_STREET_NAME,
  CA_STREET_TYPE,
  CA_SUITE_NUMBER,
  CA_CITY,
  CA_COUNTY,
  CA_STATE,
  CA_ZIP,
  CA_COUNTRY,
  CA_GMT_OFFSET,
  CA_LOCATION_TYPE,
  ctr_total_return
from customer_total_return ctr1,
  customer_address,
  customer
where ctr1.ctr_total_return > (
    select avg(ctr_total_return) * 1.2
    from customer_total_return ctr2
    where ctr1.ctr_state = ctr2.ctr_state
  )
  and CA_ADDRESS_SK = C_CURRENT_ADDR_SK
  and CA_STATE = 'OK'
  and ctr1.ctr_customer_sk = C_CUSTOMER_SK
order by C_CUSTOMER_ID,
  C_SALUTATION,
  C_FIRST_NAME,
  C_LAST_NAME,
  CA_STREET_NUMBER,
  CA_STREET_NAME,
  CA_STREET_TYPE,
  CA_SUITE_NUMBER,
  CA_CITY,
  CA_COUNTY,
  CA_STATE,
  CA_ZIP,
  CA_COUNTRY,
  CA_GMT_OFFSET,
  CA_LOCATION_TYPE,
  ctr_total_return option (label = 'TPCDS-Q81');