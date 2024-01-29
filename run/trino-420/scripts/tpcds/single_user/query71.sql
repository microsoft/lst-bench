SELECT
  "i_brand_id" "brand_id"
, "i_brand" "brand"
, "t_hour"
, "t_minute"
, "sum"("ext_price") "ext_price"
FROM
  ${catalog}.${database}.item
, (
   SELECT
     "ws_ext_sales_price" "ext_price"
   , "ws_sold_date_sk" "sold_date_sk"
   , "ws_item_sk" "sold_item_sk"
   , "ws_sold_time_sk" "time_sk"
   FROM
     ${catalog}.${database}.web_sales
   , ${catalog}.${database}.date_dim
   WHERE ("d_date_sk" = "ws_sold_date_sk")
      AND ("d_moy" = 11)
      AND ("d_year" = 2001)
UNION ALL    SELECT
     "cs_ext_sales_price" "ext_price"
   , "cs_sold_date_sk" "sold_date_sk"
   , "cs_item_sk" "sold_item_sk"
   , "cs_sold_time_sk" "time_sk"
   FROM
     ${catalog}.${database}.catalog_sales
   , ${catalog}.${database}.date_dim
   WHERE ("d_date_sk" = "cs_sold_date_sk")
      AND ("d_moy" = 11)
      AND ("d_year" = 2001)
UNION ALL    SELECT
     "ss_ext_sales_price" "ext_price"
   , "ss_sold_date_sk" "sold_date_sk"
   , "ss_item_sk" "sold_item_sk"
   , "ss_sold_time_sk" "time_sk"
   FROM
     ${catalog}.${database}.store_sales
   , ${catalog}.${database}.date_dim
   WHERE ("d_date_sk" = "ss_sold_date_sk")
      AND ("d_moy" = 11)
      AND ("d_year" = 2001)
)  tmp
, ${catalog}.${database}.time_dim
WHERE ("sold_item_sk" = "i_item_sk")
   AND ("i_manager_id" = 1)
   AND ("time_sk" = "t_time_sk")
   AND (("t_meal_time" = 'breakfast')
      OR ("t_meal_time" = 'dinner'))
GROUP BY "i_brand", "i_brand_id", "t_hour", "t_minute"
ORDER BY "ext_price" DESC, "i_brand_id" ASC;
