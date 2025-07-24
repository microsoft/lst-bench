with frequent_ss_items as (
  select substring(I_ITEM_DESC, 1, 30) itemdesc,
    I_ITEM_SK item_sk,
    D_DATE solddate,
    count(*) cnt
  from store_sales,
    date_dim,
    item
  where SS_SOLD_DATE_SK = D_DATE_SK
    and SS_ITEM_SK = I_ITEM_SK
    and D_YEAR in (1998, 1998 + 1, 1998 + 2, 1998 + 3)
  group by substring(I_ITEM_DESC, 1, 30),
    I_ITEM_SK,
    D_DATE
  having count(*) > 4
),
max_store_sales as (
  select max(csales) tpcds_cmax
  from (
      select C_CUSTOMER_SK,
        sum(SS_QUANTITY * SS_SALES_PRICE) csales
      from store_sales,
        customer,
        date_dim
      where SS_CUSTOMER_SK = C_CUSTOMER_SK
        and SS_SOLD_DATE_SK = D_DATE_SK
        and D_YEAR in (1998, 1998 + 1, 1998 + 2, 1998 + 3)
      group by C_CUSTOMER_SK
    ) as x
),
best_ss_customer as (
  select C_CUSTOMER_SK,
    sum(SS_QUANTITY * SS_SALES_PRICE) ssales
  from store_sales,
    customer
  where SS_CUSTOMER_SK = C_CUSTOMER_SK
  group by C_CUSTOMER_SK
  having sum(SS_QUANTITY * SS_SALES_PRICE) > (95 / 100.0) * (
      select *
      from max_store_sales
    )
)
select top 100 sum(sales)
from (
    select CS_QUANTITY * CS_LIST_PRICE sales
    from catalog_sales,
      date_dim
    where D_YEAR = 1998
      and D_MOY = 1
      and CS_SOLD_DATE_SK = D_DATE_SK
      and CS_ITEM_SK in (
        select item_sk
        from frequent_ss_items
      )
      and CS_BILL_CUSTOMER_SK in (
        select C_CUSTOMER_SK
        from best_ss_customer
      )
    union all
    select WS_QUANTITY * WS_LIST_PRICE sales
    from web_sales,
      date_dim
    where D_YEAR = 1998
      and D_MOY = 1
      and WS_SOLD_DATE_SK = D_DATE_SK
      and WS_ITEM_SK in (
        select item_sk
        from frequent_ss_items
      )
      and WS_BILL_CUSTOMER_SK in (
        select C_CUSTOMER_SK
        from best_ss_customer
      )
  ) as y option (label = 'TPCDS-Q23a');