with my_customers as (
       select distinct C_CUSTOMER_SK,
              C_CURRENT_ADDR_SK
       from (
                     select CS_SOLD_DATE_SK sold_date_sk,
                            CS_BILL_CUSTOMER_SK customer_sk,
                            CS_ITEM_SK item_sk
                     from catalog_sales
                     union all
                     select WS_SOLD_DATE_SK sold_date_sk,
                            WS_BILL_CUSTOMER_SK customer_sk,
                            WS_ITEM_SK item_sk
                     from web_sales
              ) cs_or_ws_sales,
              item,
              date_dim,
              customer
       where sold_date_sk = D_DATE_SK
              and item_sk = I_ITEM_SK
              and I_CATEGORY = 'Children'
              and I_CLASS = 'infants'
              and C_CUSTOMER_SK = cs_or_ws_sales.customer_sk
              and D_MOY = 2
              and D_YEAR = 2001
),
my_revenue as (
       select C_CUSTOMER_SK,
              sum(SS_EXT_SALES_PRICE) as revenue
       from my_customers,
              store_sales,
              customer_address,
              store,
              date_dim
       where C_CURRENT_ADDR_SK = CA_ADDRESS_SK
              and CA_COUNTY = S_COUNTY
              and CA_STATE = S_STATE
              and SS_SOLD_DATE_SK = D_DATE_SK
              and C_CUSTOMER_SK = SS_CUSTOMER_SK
              and D_MONTH_SEQ between (
                     select distinct D_MONTH_SEQ + 1
                     from date_dim
                     where D_YEAR = 2001
                            and D_MOY = 2
              )
              and (
                     select distinct D_MONTH_SEQ + 3
                     from date_dim
                     where D_YEAR = 2001
                            and D_MOY = 2
              )
       group by C_CUSTOMER_SK
),
segments as (
       select cast((revenue / 50) as int) as segment
       from my_revenue
)
select top 100 segment,
       count(*) as num_customers,
       segment * 50 as segment_base
from segments
group by segment
order by segment,
       num_customers option (label = 'TPCDS-Q54');