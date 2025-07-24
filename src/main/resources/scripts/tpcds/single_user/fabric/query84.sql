select top 100 C_CUSTOMER_ID as customer_id,
  coalesce(C_LAST_NAME, '') + ', ' + coalesce(C_FIRST_NAME, '') as customername
from customer,
  customer_address,
  customer_demographics,
  household_demographics,
  income_band,
  store_returns
where CA_CITY = 'Fairview'
  and C_CURRENT_ADDR_SK = CA_ADDRESS_SK
  and IB_LOWER_BOUND >= 36925
  and IB_UPPER_BOUND <= 36925 + 50000
  and IB_INCOME_BAND_SK = HD_INCOME_BAND_SK
  and CD_DEMO_SK = C_CURRENT_CDEMO_SK
  and HD_DEMO_SK = C_CURRENT_HDEMO_SK
  and SR_CDEMO_SK = CD_DEMO_SK
order by C_CUSTOMER_ID option (label = 'TPCDS-Q84');