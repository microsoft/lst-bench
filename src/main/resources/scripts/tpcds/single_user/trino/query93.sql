SELECT
  "ss_customer_sk"
, "sum"("act_sales") "sumsales"
FROM
  (
   SELECT
     "ss_item_sk"
   , "ss_ticket_number"
   , "ss_customer_sk"
   , (CASE WHEN ("sr_return_quantity" IS NOT NULL) THEN (("ss_quantity" - "sr_return_quantity") * "ss_sales_price") ELSE ("ss_quantity" * "ss_sales_price") END) "act_sales"
   FROM
     (${catalog}.${database}.store_sales
   LEFT JOIN ${catalog}.${database}.store_returns ON ("sr_item_sk" = "ss_item_sk")
      AND ("sr_ticket_number" = "ss_ticket_number"))
   , ${catalog}.${database}.reason
   WHERE ("sr_reason_sk" = "r_reason_sk")
      AND ("r_reason_desc" = 'Did not get it on time')
)  t
GROUP BY "ss_customer_sk"
ORDER BY "sumsales" ASC, "ss_customer_sk" ASC
LIMIT 100;
