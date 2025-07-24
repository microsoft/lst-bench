with ss as (
   select CA_COUNTY,
      D_QOY,
      D_YEAR,
      sum(SS_EXT_SALES_PRICE) as store_sales
   from store_sales,
      date_dim,
      customer_address
   where SS_SOLD_DATE_SK = D_DATE_SK
      and SS_ADDR_SK = CA_ADDRESS_SK
   group by CA_COUNTY,
      D_QOY,
      D_YEAR
),
ws as (
   select CA_COUNTY,
      D_QOY,
      D_YEAR,
      sum(WS_EXT_SALES_PRICE) as web_sales
   from web_sales,
      date_dim,
      customer_address
   where WS_SOLD_DATE_SK = D_DATE_SK
      and WS_BILL_ADDR_SK = CA_ADDRESS_SK
   group by CA_COUNTY,
      D_QOY,
      D_YEAR
)
select ss1.CA_COUNTY,
   ss1.D_YEAR,
   ws2.web_sales / ws1.web_sales web_q1_q2_increase,
   ss2.store_sales / ss1.store_sales store_q1_q2_increase,
   ws3.web_sales / ws2.web_sales web_q2_q3_increase,
   ss3.store_sales / ss2.store_sales store_q2_q3_increase
from ss ss1,
   ss ss2,
   ss ss3,
   ws ws1,
   ws ws2,
   ws ws3
where ss1.D_QOY = 1
   and ss1.D_YEAR = 1999
   and ss1.CA_COUNTY = ss2.CA_COUNTY
   and ss2.D_QOY = 2
   and ss2.D_YEAR = 1999
   and ss2.CA_COUNTY = ss3.CA_COUNTY
   and ss3.D_QOY = 3
   and ss3.D_YEAR = 1999
   and ss1.CA_COUNTY = ws1.CA_COUNTY
   and ws1.D_QOY = 1
   and ws1.D_YEAR = 1999
   and ws1.CA_COUNTY = ws2.CA_COUNTY
   and ws2.D_QOY = 2
   and ws2.D_YEAR = 1999
   and ws1.CA_COUNTY = ws3.CA_COUNTY
   and ws3.D_QOY = 3
   and ws3.D_YEAR = 1999
   and case
      when ws1.web_sales > 0 then ws2.web_sales / ws1.web_sales
      else null
   end > case
      when ss1.store_sales > 0 then ss2.store_sales / ss1.store_sales
      else null
   end
   and case
      when ws2.web_sales > 0 then ws3.web_sales / ws2.web_sales
      else null
   end > case
      when ss2.store_sales > 0 then ss3.store_sales / ss2.store_sales
      else null
   end
order by ss1.CA_COUNTY option (label = 'TPCDS-Q31');