SELECT
  "count"(DISTINCT "ws_order_number") "order count"
, "sum"("ws_ext_ship_cost") "total shipping cost"
, "sum"("ws_net_profit") "total net profit"
FROM
  ${catalog}.${database}.web_sales ws1
, ${catalog}.${database}.date_dim
, ${catalog}.${database}.customer_address
, ${catalog}.${database}.web_site
WHERE ("d_date" BETWEEN CAST('1999-4-01' AS DATE) AND (CAST('1999-4-01' AS DATE) + INTERVAL  '60' DAY))
   AND ("ws1"."ws_ship_date_sk" = "d_date_sk")
   AND ("ws1"."ws_ship_addr_sk" = "ca_address_sk")
   AND ("ca_state" = 'WI')
   AND ("ws1"."ws_web_site_sk" = "web_site_sk")
   AND ("web_company_name" = 'pri')
   AND (EXISTS (
   SELECT *
   FROM
     ${catalog}.${database}.web_sales ws2
   WHERE ("ws1"."ws_order_number" = "ws2"."ws_order_number")
      AND ("ws1"."ws_warehouse_sk" <> "ws2"."ws_warehouse_sk")
))
   AND (NOT (EXISTS (
   SELECT *
   FROM
     ${catalog}.${database}.web_returns wr1
   WHERE ("ws1"."ws_order_number" = "wr1"."wr_order_number")
)))
ORDER BY "count"(DISTINCT "ws_order_number") ASC
LIMIT 100;
