SELECT "sum"("cs_ext_discount_amt") "excess discount amount"
FROM
  ${catalog}.${database}.catalog_sales
, ${catalog}.${database}.item
, ${catalog}.${database}.date_dim
WHERE ("i_manufact_id" = 283)
   AND ("i_item_sk" = "cs_item_sk")
   AND ("d_date" BETWEEN CAST('1999-02-22' AS DATE) AND (CAST('1999-02-22' AS DATE) + INTERVAL  '90' DAY))
   AND ("d_date_sk" = "cs_sold_date_sk")
   AND ("cs_ext_discount_amt" > (
      SELECT (DECIMAL '1.3' * "avg"("cs_ext_discount_amt"))
      FROM
        ${catalog}.${database}.catalog_sales
      , ${catalog}.${database}.date_dim
      WHERE ("cs_item_sk" = "i_item_sk")
         AND ("d_date" BETWEEN CAST('1999-02-22' AS DATE) AND (CAST('1999-02-22' AS DATE) + INTERVAL  '90' DAY))
         AND ("d_date_sk" = "cs_sold_date_sk")
   ))
LIMIT 100;
