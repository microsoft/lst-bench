select C_LAST_NAME,
  C_FIRST_NAME,
  C_SALUTATION,
  C_PREFERRED_CUST_FLAG,
  SS_TICKET_NUMBER,
  cnt
from (
    select SS_TICKET_NUMBER,
      SS_CUSTOMER_SK,
      count(*) cnt
    from store_sales,
      date_dim,
      store,
      household_demographics
    where store_sales.SS_SOLD_DATE_SK = date_dim.D_DATE_SK
      and store_sales.SS_STORE_SK = store.S_STORE_SK
      and store_sales.SS_HDEMO_SK = household_demographics.HD_DEMO_SK
      and (
        date_dim.D_DOM between 1 and 3
        or date_dim.D_DOM between 25 and 28
      )
      and (
        household_demographics.HD_BUY_POTENTIAL = '1001-5000'
        or household_demographics.HD_BUY_POTENTIAL = 'Unknown'
      )
      and household_demographics.HD_VEHICLE_COUNT > 0
      and (
        case
          when household_demographics.HD_VEHICLE_COUNT > 0 then household_demographics.HD_DEP_COUNT / household_demographics.HD_VEHICLE_COUNT
          else null
        end
      ) > 1.2
      and date_dim.D_YEAR in (2000, 2000 + 1, 2000 + 2)
      and store.S_COUNTY in (
        'Williamson County',
        'Walker County',
        'Ziebach County',
        'Ziebach County',
        'Ziebach County',
        'Ziebach County',
        'Walker County',
        'Walker County'
      )
    group by SS_TICKET_NUMBER,
      SS_CUSTOMER_SK
  ) dn,
  customer
where SS_CUSTOMER_SK = C_CUSTOMER_SK
  and cnt between 15 and 20
order by C_LAST_NAME,
  C_FIRST_NAME,
  C_SALUTATION,
  C_PREFERRED_CUST_FLAG desc,
  SS_TICKET_NUMBER option (label = 'TPCDS-Q34');