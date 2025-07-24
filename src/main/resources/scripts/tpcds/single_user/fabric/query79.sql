select top 100 C_LAST_NAME,
  C_FIRST_NAME,
  substring(S_CITY, 1, 30),
  SS_TICKET_NUMBER,
  amt,
  profit
from (
    select SS_TICKET_NUMBER,
      SS_CUSTOMER_SK,
      store.S_CITY,
      sum(SS_COUPON_AMT) amt,
      sum(SS_NET_PROFIT) profit
    from store_sales,
      date_dim,
      store,
      household_demographics
    where store_sales.SS_SOLD_DATE_SK = date_dim.D_DATE_SK
      and store_sales.SS_STORE_SK = store.S_STORE_SK
      and store_sales.SS_HDEMO_SK = household_demographics.HD_DEMO_SK
      and (
        household_demographics.HD_DEP_COUNT = 0
        or household_demographics.HD_VEHICLE_COUNT > -1
      )
      and date_dim.D_DOW = 1
      and date_dim.D_YEAR in (1999, 1999 + 1, 1999 + 2)
      and store.S_NUMBER_EMPLOYEES between 200 and 295
    group by SS_TICKET_NUMBER,
      SS_CUSTOMER_SK,
      SS_ADDR_SK,
      store.S_CITY
  ) ms,
  customer
where SS_CUSTOMER_SK = C_CUSTOMER_SK
order by C_LAST_NAME,
  C_FIRST_NAME,
  substring(S_CITY, 1, 30),
  profit option (label = 'TPCDS-Q79');