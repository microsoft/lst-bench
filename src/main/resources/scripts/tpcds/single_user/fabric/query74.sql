with year_total as (
  select C_CUSTOMER_ID customer_id,
    C_FIRST_NAME customer_first_name,
    C_LAST_NAME customer_last_name,
    D_YEAR as year,
    stdev(SS_NET_PAID) year_total,
    's' sale_type
  from customer,
    store_sales,
    date_dim
  where C_CUSTOMER_SK = SS_CUSTOMER_SK
    and SS_SOLD_DATE_SK = D_DATE_SK
    and D_YEAR in (2000, 2000 + 1)
  group by C_CUSTOMER_ID,
    C_FIRST_NAME,
    C_LAST_NAME,
    D_YEAR
  union all
  select C_CUSTOMER_ID customer_id,
    C_FIRST_NAME customer_first_name,
    C_LAST_NAME customer_last_name,
    D_YEAR as year,
    stdev(WS_NET_PAID) year_total,
    'w' sale_type
  from customer,
    web_sales,
    date_dim
  where C_CUSTOMER_SK = WS_BILL_CUSTOMER_SK
    and WS_SOLD_DATE_SK = D_DATE_SK
    and D_YEAR in (2000, 2000 + 1)
  group by C_CUSTOMER_ID,
    C_FIRST_NAME,
    C_LAST_NAME,
    D_YEAR
)
select top 100 t_s_secyear.customer_id,
  t_s_secyear.customer_first_name,
  t_s_secyear.customer_last_name
from year_total t_s_firstyear,
  year_total t_s_secyear,
  year_total t_w_firstyear,
  year_total t_w_secyear
where t_s_secyear.customer_id = t_s_firstyear.customer_id
  and t_s_firstyear.customer_id = t_w_secyear.customer_id
  and t_s_firstyear.customer_id = t_w_firstyear.customer_id
  and t_s_firstyear.sale_type = 's'
  and t_w_firstyear.sale_type = 'w'
  and t_s_secyear.sale_type = 's'
  and t_w_secyear.sale_type = 'w'
  and t_s_firstyear.year = 2000
  and t_s_secyear.year = 2000 + 1
  and t_w_firstyear.year = 2000
  and t_w_secyear.year = 2000 + 1
  and t_s_firstyear.year_total > 0
  and t_w_firstyear.year_total > 0
  and case
    when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total
    else null
  end > case
    when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total
    else null
  end
order by 1,
  3,
  2 option (label = 'TPCDS-Q74');