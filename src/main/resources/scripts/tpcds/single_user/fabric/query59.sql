with wss as (
       select D_WEEK_SEQ,
              SS_STORE_SK,
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
       from store_sales,
              date_dim
       where D_DATE_SK = SS_SOLD_DATE_SK
       group by D_WEEK_SEQ,
              SS_STORE_SK
)
select top 100 s_store_name1,
       s_store_id1,
       d_week_seq1,
       sun_sales1 / sun_sales2,
       mon_sales1 / mon_sales2,
       tue_sales1 / tue_sales2,
       wed_sales1 / wed_sales2,
       thu_sales1 / thu_sales2,
       fri_sales1 / fri_sales2,
       sat_sales1 / sat_sales2
from (
              select S_STORE_NAME s_store_name1,
                     wss.D_WEEK_SEQ d_week_seq1,
                     S_STORE_ID s_store_id1,
                     sun_sales sun_sales1,
                     mon_sales mon_sales1,
                     tue_sales tue_sales1,
                     wed_sales wed_sales1,
                     thu_sales thu_sales1,
                     fri_sales fri_sales1,
                     sat_sales sat_sales1
              from wss,
                     store,
                     date_dim d
              where d.D_WEEK_SEQ = wss.D_WEEK_SEQ
                     and SS_STORE_SK = S_STORE_SK
                     and D_MONTH_SEQ between 1190 and 1190 + 11
       ) y,
       (
              select S_STORE_NAME s_store_name2,
                     wss.D_WEEK_SEQ d_week_seq2,
                     S_STORE_ID s_store_id2,
                     sun_sales sun_sales2,
                     mon_sales mon_sales2,
                     tue_sales tue_sales2,
                     wed_sales wed_sales2,
                     thu_sales thu_sales2,
                     fri_sales fri_sales2,
                     sat_sales sat_sales2
              from wss,
                     store,
                     date_dim d
              where d.D_WEEK_SEQ = wss.D_WEEK_SEQ
                     and SS_STORE_SK = S_STORE_SK
                     and D_MONTH_SEQ between 1190 + 12 and 1190 + 23
       ) x
where s_store_id1 = s_store_id2
       and d_week_seq1 = d_week_seq2 -52
order by s_store_name1,
       s_store_id1,
       d_week_seq1 option (label = 'TPCDS-Q59');