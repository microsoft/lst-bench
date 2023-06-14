delete from ${catalog}.${database}.store_returns where sr_ticket_number in (select ss_ticket_number from ${catalog}.${database}.store_sales, ${catalog}.${database}.date_dim   where ss_sold_date_sk=d_date_sk and d_date between CAST('${param1}' AS DATE) and CAST('${param2}' AS DATE));
delete from ${catalog}.${database}.store_sales where ss_sold_date_sk >= (select min(d_date_sk) from ${catalog}.${database}.date_dim  where d_date between CAST('${param1}' AS DATE) and CAST('${param2}' AS DATE)) and
                ss_sold_date_sk <= (select max(d_date_sk) from ${catalog}.${database}.date_dim  where d_date between CAST('${param1}' AS DATE) and CAST('${param2}' AS DATE));

delete from ${catalog}.${database}.store_returns where sr_ticket_number in (select ss_ticket_number from ${catalog}.${database}.store_sales, ${catalog}.${database}.date_dim   where ss_sold_date_sk=d_date_sk and d_date between CAST('${param3}' AS DATE) and CAST('${param4}' AS DATE));
delete from ${catalog}.${database}.store_sales where ss_sold_date_sk >= (select min(d_date_sk) from ${catalog}.${database}.date_dim  where d_date between CAST('${param3}' AS DATE) and CAST('${param4}' AS DATE)) and
                ss_sold_date_sk<= (select max(d_date_sk) from ${catalog}.${database}.date_dim  where d_date between CAST('${param3}' AS DATE) and CAST('${param4}' AS DATE));

delete from ${catalog}.${database}.store_returns where sr_ticket_number in (select ss_ticket_number from ${catalog}.${database}.store_sales, ${catalog}.${database}.date_dim   where ss_sold_date_sk=d_date_sk and d_date between CAST('${param5}' AS DATE) and CAST('${param6}' AS DATE));
delete from ${catalog}.${database}.store_sales where ss_sold_date_sk >= (select min(d_date_sk) from ${catalog}.${database}.date_dim  where d_date between CAST('${param5}' AS DATE) and CAST('${param6}' AS DATE)) and
                ss_sold_date_sk <= (select max(d_date_sk) from ${catalog}.${database}.date_dim  where d_date between CAST('${param5}' AS DATE) and CAST('${param6}' AS DATE));
