with wscs as (
      select sold_date_sk,
            sales_price
      from (
                  select WS_SOLD_DATE_SK sold_date_sk,
                        WS_EXT_SALES_PRICE sales_price
                  from web_sales
                  union all
                  select CS_SOLD_DATE_SK sold_date_sk,
                        CS_EXT_SALES_PRICE sales_price
                  from catalog_sales
            ) as x
),
wswscs as (
      select D_WEEK_SEQ,
            sum(
                  case
                        when (D_DAY_NAME = 'Sunday') then sales_price
                        else null
                  end
            ) sun_sales,
            sum(
                  case
                        when (D_DAY_NAME = 'Monday') then sales_price
                        else null
                  end
            ) mon_sales,
            sum(
                  case
                        when (D_DAY_NAME = 'Tuesday') then sales_price
                        else null
                  end
            ) tue_sales,
            sum(
                  case
                        when (D_DAY_NAME = 'Wednesday') then sales_price
                        else null
                  end
            ) wed_sales,
            sum(
                  case
                        when (D_DAY_NAME = 'Thursday') then sales_price
                        else null
                  end
            ) thu_sales,
            sum(
                  case
                        when (D_DAY_NAME = 'Friday') then sales_price
                        else null
                  end
            ) fri_sales,
            sum(
                  case
                        when (D_DAY_NAME = 'Saturday') then sales_price
                        else null
                  end
            ) sat_sales
      from wscs,
            date_dim
      where D_DATE_SK = sold_date_sk
      group by D_WEEK_SEQ
)
select d_week_seq1,
      round(sun_sales1 / sun_sales2, 2),
      round(mon_sales1 / mon_sales2, 2),
      round(tue_sales1 / tue_sales2, 2),
      round(wed_sales1 / wed_sales2, 2),
      round(thu_sales1 / thu_sales2, 2),
      round(fri_sales1 / fri_sales2, 2),
      round(sat_sales1 / sat_sales2, 2)
from (
            select wswscs.D_WEEK_SEQ d_week_seq1,
                  sun_sales sun_sales1,
                  mon_sales mon_sales1,
                  tue_sales tue_sales1,
                  wed_sales wed_sales1,
                  thu_sales thu_sales1,
                  fri_sales fri_sales1,
                  sat_sales sat_sales1
            from wswscs,
                  date_dim
            where date_dim.D_WEEK_SEQ = wswscs.D_WEEK_SEQ
                  and D_YEAR = 2000
      ) y,
      (
            select wswscs.D_WEEK_SEQ d_week_seq2,
                  sun_sales sun_sales2,
                  mon_sales mon_sales2,
                  tue_sales tue_sales2,
                  wed_sales wed_sales2,
                  thu_sales thu_sales2,
                  fri_sales fri_sales2,
                  sat_sales sat_sales2
            from wswscs,
                  date_dim
            where date_dim.D_WEEK_SEQ = wswscs.D_WEEK_SEQ
                  and D_YEAR = 2000 + 1
      ) z
where d_week_seq1 = d_week_seq2 -53
order by d_week_seq1 option (label = 'TPCDS-Q2');