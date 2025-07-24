select top 100 C_LAST_NAME,
  C_FIRST_NAME,
  CA_CITY,
  bought_city,
  SS_TICKET_NUMBER,
  extended_price,
  extended_tax,
  list_price
from (
    select SS_TICKET_NUMBER,
      SS_CUSTOMER_SK,
      CA_CITY bought_city,
      sum(SS_EXT_SALES_PRICE) extended_price,
      sum(SS_EXT_LIST_PRICE) list_price,
      sum(SS_EXT_TAX) extended_tax
    from store_sales,
      date_dim,
      store,
      household_demographics,
      customer_address
    where store_sales.SS_SOLD_DATE_SK = date_dim.D_DATE_SK
      and store_sales.SS_STORE_SK = store.S_STORE_SK
      and store_sales.SS_HDEMO_SK = household_demographics.HD_DEMO_SK
      and store_sales.SS_ADDR_SK = customer_address.CA_ADDRESS_SK
      and date_dim.D_DOM between 1 and 2
      and (
        household_demographics.HD_DEP_COUNT = 3
        or household_demographics.HD_VEHICLE_COUNT = -1
      )
      and date_dim.D_YEAR in (1998, 1998 + 1, 1998 + 2)
      and store.S_CITY in ('Five Points', 'Fairview')
    group by SS_TICKET_NUMBER,
      SS_CUSTOMER_SK,
      SS_ADDR_SK,
      CA_CITY
  ) dn,
  customer,
  customer_address current_addr
where SS_CUSTOMER_SK = C_CUSTOMER_SK
  and customer.C_CURRENT_ADDR_SK = current_addr.CA_ADDRESS_SK
  and current_addr.CA_CITY <> bought_city
order by C_LAST_NAME,
  SS_TICKET_NUMBER option (label = 'TPCDS-Q68');