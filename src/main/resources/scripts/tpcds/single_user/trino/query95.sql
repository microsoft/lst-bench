WITH
  ws_wh AS (
   SELECT
     "ws1"."ws_order_number"
   , "ws1"."ws_warehouse_sk" "wh1"
   , "ws2"."ws_warehouse_sk" "wh2"
   FROM
     ${catalog}.${database}.web_sales ws1
   , ${catalog}.${database}.web_sales ws2
   WHERE ("ws1"."ws_order_number" = "ws2"."ws_order_number")
      AND ("ws1"."ws_warehouse_sk" <> "ws2"."ws_warehouse_sk")
)
SELECT
  "count"(DISTINCT "ws_order_number") "order count"
, "sum"("ws_ext_ship_cost") "total shipping cost"
, "sum"("ws_net_profit") "total net profit"
FROM
  ${catalog}.${database}.web_sales ws1
, ${catalog}.${database}.date_dim
, ${catalog}.${database}.customer_address
, ${catalog}.${database}.web_site
WHERE (CAST("d_date" AS DATE) BETWEEN CAST('2002-5-01' AS DATE) AND (CAST('2002-5-01' AS DATE) + INTERVAL  '60' DAY))
   AND ("ws1"."ws_ship_date_sk" = "d_date_sk")
   AND ("ws1"."ws_ship_addr_sk" = "ca_address_sk")
   AND ("ca_state" = 'MA')
   AND ("ws1"."ws_web_site_sk" = "web_site_sk")
   AND ("web_company_name" = 'pri')
   AND ("ws1"."ws_order_number" IN (
   SELECT "ws_order_number"
   FROM
     ws_wh
))
   AND ("ws1"."ws_order_number" IN (
   SELECT "wr_order_number"
   FROM
     ${catalog}.${database}.web_returns
   , ws_wh
   WHERE ("wr_order_number" = "ws_wh"."ws_order_number")
))
ORDER BY "count"(DISTINCT "ws_order_number") ASC
LIMIT 100;
