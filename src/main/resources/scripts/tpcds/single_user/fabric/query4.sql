with year_total as (
  select C_CUSTOMER_ID customer_id,
    C_FIRST_NAME customer_first_name,
    C_LAST_NAME customer_last_name,
    C_PREFERRED_CUST_FLAG customer_preferred_cust_flag,
    C_BIRTH_COUNTRY customer_birth_country,
    C_LOGIN customer_login,
    C_EMAIL_ADDRESS customer_email_address,
    D_YEAR dyear,
    sum(
      (
        (
          SS_EXT_LIST_PRICE - SS_EXT_WHOLESALE_COST - SS_EXT_DISCOUNT_AMT
        ) + SS_EXT_SALES_PRICE
      ) / 2
    ) year_total,
    's' sale_type
  from customer,
    store_sales,
    date_dim
  where C_CUSTOMER_SK = SS_CUSTOMER_SK
    and SS_SOLD_DATE_SK = D_DATE_SK
  group by C_CUSTOMER_ID,
    C_FIRST_NAME,
    C_LAST_NAME,
    C_PREFERRED_CUST_FLAG,
    C_BIRTH_COUNTRY,
    C_LOGIN,
    C_EMAIL_ADDRESS,
    D_YEAR
  union all
  select C_CUSTOMER_ID customer_id,
    C_FIRST_NAME customer_first_name,
    C_LAST_NAME customer_last_name,
    C_PREFERRED_CUST_FLAG customer_preferred_cust_flag,
    C_BIRTH_COUNTRY customer_birth_country,
    C_LOGIN customer_login,
    C_EMAIL_ADDRESS customer_email_address,
    D_YEAR dyear,
    sum(
      (
        (
          (
            CS_EXT_LIST_PRICE - CS_EXT_WHOLESALE_COST - CS_EXT_DISCOUNT_AMT
          ) + CS_EXT_SALES_PRICE
        ) / 2
      )
    ) year_total,
    'c' sale_type
  from customer,
    catalog_sales,
    date_dim
  where C_CUSTOMER_SK = CS_BILL_CUSTOMER_SK
    and CS_SOLD_DATE_SK = D_DATE_SK
  group by C_CUSTOMER_ID,
    C_FIRST_NAME,
    C_LAST_NAME,
    C_PREFERRED_CUST_FLAG,
    C_BIRTH_COUNTRY,
    C_LOGIN,
    C_EMAIL_ADDRESS,
    D_YEAR
  union all
  select C_CUSTOMER_ID customer_id,
    C_FIRST_NAME customer_first_name,
    C_LAST_NAME customer_last_name,
    C_PREFERRED_CUST_FLAG customer_preferred_cust_flag,
    C_BIRTH_COUNTRY customer_birth_country,
    C_LOGIN customer_login,
    C_EMAIL_ADDRESS customer_email_address,
    D_YEAR dyear,
    sum(
      (
        (
          (
            WS_EXT_LIST_PRICE - WS_EXT_WHOLESALE_COST - WS_EXT_DISCOUNT_AMT
          ) + WS_EXT_SALES_PRICE
        ) / 2
      )
    ) year_total,
    'w' sale_type
  from customer,
    web_sales,
    date_dim
  where C_CUSTOMER_SK = WS_BILL_CUSTOMER_SK
    and WS_SOLD_DATE_SK = D_DATE_SK
  group by C_CUSTOMER_ID,
    C_FIRST_NAME,
    C_LAST_NAME,
    C_PREFERRED_CUST_FLAG,
    C_BIRTH_COUNTRY,
    C_LOGIN,
    C_EMAIL_ADDRESS,
    D_YEAR
)
select top 100 t_s_secyear.customer_id,
  t_s_secyear.customer_first_name,
  t_s_secyear.customer_last_name,
  t_s_secyear.customer_login
from year_total t_s_firstyear,
  year_total t_s_secyear,
  year_total t_c_firstyear,
  year_total t_c_secyear,
  year_total t_w_firstyear,
  year_total t_w_secyear
where t_s_secyear.customer_id = t_s_firstyear.customer_id
  and t_s_firstyear.customer_id = t_c_secyear.customer_id
  and t_s_firstyear.customer_id = t_c_firstyear.customer_id
  and t_s_firstyear.customer_id = t_w_firstyear.customer_id
  and t_s_firstyear.customer_id = t_w_secyear.customer_id
  and t_s_firstyear.sale_type = 's'
  and t_c_firstyear.sale_type = 'c'
  and t_w_firstyear.sale_type = 'w'
  and t_s_secyear.sale_type = 's'
  and t_c_secyear.sale_type = 'c'
  and t_w_secyear.sale_type = 'w'
  and t_s_firstyear.dyear = 1999
  and t_s_secyear.dyear = 1999 + 1
  and t_c_firstyear.dyear = 1999
  and t_c_secyear.dyear = 1999 + 1
  and t_w_firstyear.dyear = 1999
  and t_w_secyear.dyear = 1999 + 1
  and t_s_firstyear.year_total > 0
  and t_c_firstyear.year_total > 0
  and t_w_firstyear.year_total > 0
  and case
    when t_c_firstyear.year_total > 0 then t_c_secyear.year_total / t_c_firstyear.year_total
    else null
  end > case
    when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total
    else null
  end
  and case
    when t_c_firstyear.year_total > 0 then t_c_secyear.year_total / t_c_firstyear.year_total
    else null
  end > case
    when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total
    else null
  end
order by t_s_secyear.customer_id,
  t_s_secyear.customer_first_name,
  t_s_secyear.customer_last_name,
  t_s_secyear.customer_login option (label = 'TPCDS-Q4');