delete from ${catalog}.${database}.web_returns where wr_order_number in (select ws_order_number from ${catalog}.${database}.web_sales, ${catalog}.${database}.date_dim where ws_sold_date_sk=d_date_sk and d_date between CAST('${param1}' AS DATE) and CAST('${param2}' AS DATE));
delete from ${catalog}.${database}.web_sales where ws_sold_date_sk >= (select min(d_date_sk) from ${catalog}.${database}.date_dim where d_date between CAST('${param1}' AS DATE) and CAST('${param2}' AS DATE)) and
                 ws_sold_date_sk <= (select max(d_date_sk) from ${catalog}.${database}.date_dim where d_date between CAST('${param1}' AS DATE) and CAST('${param2}' AS DATE));

delete from ${catalog}.${database}.web_returns where wr_order_number in (select ws_order_number from ${catalog}.${database}.web_sales, ${catalog}.${database}.date_dim where ws_sold_date_sk=d_date_sk and d_date between CAST('${param3}' AS DATE) and CAST('${param4}' AS DATE));
delete from ${catalog}.${database}.web_sales where ws_sold_date_sk >= (select min(d_date_sk) from ${catalog}.${database}.date_dim where d_date between CAST('${param3}' AS DATE) and CAST('${param4}' AS DATE)) and
                ws_sold_date_sk<= (select max(d_date_sk) from ${catalog}.${database}.date_dim where d_date between CAST('${param3}' AS DATE) and CAST('${param4}' AS DATE));

delete from ${catalog}.${database}.web_returns where wr_order_number in (select ws_order_number from ${catalog}.${database}.web_sales, ${catalog}.${database}.date_dim where ws_sold_date_sk=d_date_sk and d_date between CAST('${param5}' AS DATE) and CAST('${param6}' AS DATE));
delete from ${catalog}.${database}.web_sales where ws_sold_date_sk >= (select min(d_date_sk) from ${catalog}.${database}.date_dim where d_date between CAST('${param5}' AS DATE) and CAST('${param6}' AS DATE)) and
                ws_sold_date_sk<= (select max(d_date_sk) from ${catalog}.${database}.date_dim where d_date between CAST('${param5}' AS DATE) and CAST('${param6}' AS DATE));
