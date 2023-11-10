select top 100 S_STORE_NAME,
  S_COMPANY_ID,
  S_STREET_NUMBER,
  S_STREET_NAME,
  S_STREET_TYPE,
  S_SUITE_NUMBER,
  S_CITY,
  S_COUNTY,
  S_STATE,
  S_ZIP,
  sum(
    case
      when (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK <= 30) then 1
      else 0
    end
  ) as "30 days",
  sum(
    case
      when (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK > 30)
      and (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK <= 60) then 1
      else 0
    end
  ) as "31-60 days",
  sum(
    case
      when (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK > 60)
      and (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK <= 90) then 1
      else 0
    end
  ) as "61-90 days",
  sum(
    case
      when (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK > 90)
      and (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK <= 120) then 1
      else 0
    end
  ) as "91-120 days",
  sum(
    case
      when (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK > 120) then 1
      else 0
    end
  ) as ">120 days"
from store_sales,
  store_returns,
  store,
  date_dim d1,
  date_dim d2
where d2.D_YEAR = 1999
  and d2.D_MOY = 8
  and SS_TICKET_NUMBER = SR_TICKET_NUMBER
  and SS_ITEM_SK = SR_ITEM_SK
  and SS_SOLD_DATE_SK = d1.D_DATE_SK
  and SR_RETURNED_DATE_SK = d2.D_DATE_SK
  and SS_CUSTOMER_SK = SR_CUSTOMER_SK
  and SS_STORE_SK = S_STORE_SK
group by S_STORE_NAME,
  S_COMPANY_ID,
  S_STREET_NUMBER,
  S_STREET_NAME,
  S_STREET_TYPE,
  S_SUITE_NUMBER,
  S_CITY,
  S_COUNTY,
  S_STATE,
  S_ZIP
order by S_STORE_NAME,
  S_COMPANY_ID,
  S_STREET_NUMBER,
  S_STREET_NAME,
  S_STREET_TYPE,
  S_SUITE_NUMBER,
  S_CITY,
  S_COUNTY,
  S_STATE,
  S_ZIP option (label = 'TPCDS-Q50');