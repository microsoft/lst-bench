with customer_total_return as (
  select WR_RETURNING_CUSTOMER_SK as ctr_customer_sk,
    CA_STATE as ctr_state,
    sum(WR_RETURN_AMT) as ctr_total_return
  from web_returns,
    date_dim,
    customer_address
  where WR_RETURNED_DATE_SK = D_DATE_SK
    and D_YEAR = 2001
    and WR_RETURNING_ADDR_SK = CA_ADDRESS_SK
  group by WR_RETURNING_CUSTOMER_SK,
    CA_STATE
)
select top 100 C_CUSTOMER_ID,
  C_SALUTATION,
  C_FIRST_NAME,
  C_LAST_NAME,
  C_PREFERRED_CUST_FLAG,
  C_BIRTH_DAY,
  C_BIRTH_MONTH,
  C_BIRTH_YEAR,
  C_BIRTH_COUNTRY,
  C_LOGIN,
  C_EMAIL_ADDRESS,
  C_LAST_REVIEW_DATE_SK,
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
  C_PREFERRED_CUST_FLAG,
  C_BIRTH_DAY,
  C_BIRTH_MONTH,
  C_BIRTH_YEAR,
  C_BIRTH_COUNTRY,
  C_LOGIN,
  C_EMAIL_ADDRESS,
  C_LAST_REVIEW_DATE_SK,
  ctr_total_return option (label = 'TPCDS-Q30');