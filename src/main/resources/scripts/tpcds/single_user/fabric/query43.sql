select top 100 S_STORE_NAME,
      S_STORE_ID,
      sum(
            case
                  when (D_DAY_NAME = 'Sunday') then SS_SALES_PRICE
                  else null
            end
      ) sun_sales,
      sum(
            case
                  when (D_DAY_NAME = 'Monday') then SS_SALES_PRICE
                  else null
            end
      ) mon_sales,
      sum(
            case
                  when (D_DAY_NAME = 'Tuesday') then SS_SALES_PRICE
                  else null
            end
      ) tue_sales,
      sum(
            case
                  when (D_DAY_NAME = 'Wednesday') then SS_SALES_PRICE
                  else null
            end
      ) wed_sales,
      sum(
            case
                  when (D_DAY_NAME = 'Thursday') then SS_SALES_PRICE
                  else null
            end
      ) thu_sales,
      sum(
            case
                  when (D_DAY_NAME = 'Friday') then SS_SALES_PRICE
                  else null
            end
      ) fri_sales,
      sum(
            case
                  when (D_DAY_NAME = 'Saturday') then SS_SALES_PRICE
                  else null
            end
      ) sat_sales
from date_dim,
      store_sales,
      store
where D_DATE_SK = SS_SOLD_DATE_SK
      and S_STORE_SK = SS_STORE_SK
      and S_GMT_OFFSET = -6
      and D_YEAR = 2000
group by S_STORE_NAME,
      S_STORE_ID
order by S_STORE_NAME,
      S_STORE_ID,
      sun_sales,
      mon_sales,
      tue_sales,
      wed_sales,
      thu_sales,
      fri_sales,
      sat_sales option (label = 'TPCDS-Q43');