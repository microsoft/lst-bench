SELECT "sum"("ws_ext_discount_amt") "Excess Discount Amount"
FROM
  ${catalog}.${database}.web_sales
, ${catalog}.${database}.item
, ${catalog}.${database}.date_dim
WHERE ("i_manufact_id" = 914)
   AND ("i_item_sk" = "ws_item_sk")
   AND ("d_date" BETWEEN CAST('2001-01-25' AS DATE) AND (CAST('2001-01-25' AS DATE) + INTERVAL  '90' DAY))
   AND ("d_date_sk" = "ws_sold_date_sk")
   AND ("ws_ext_discount_amt" > (
      SELECT (DECIMAL '1.3' * "avg"("ws_ext_discount_amt"))
      FROM
        ${catalog}.${database}.web_sales
      , ${catalog}.${database}.date_dim
      WHERE ("ws_item_sk" = "i_item_sk")
         AND ("d_date" BETWEEN CAST('2001-01-25' AS DATE) AND (CAST('2001-01-25' AS DATE) + INTERVAL  '90' DAY))
         AND ("d_date_sk" = "ws_sold_date_sk")
   ))
ORDER BY "sum"("ws_ext_discount_amt") ASC
LIMIT 100;
