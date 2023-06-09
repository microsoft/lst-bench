SELECT
  "cd_gender"
, "cd_marital_status"
, "cd_education_status"
, "count"(*) "cnt1"
, "cd_purchase_estimate"
, "count"(*) "cnt2"
, "cd_credit_rating"
, "count"(*) "cnt3"
FROM
  ${catalog}.${database}.customer c
, ${catalog}.${database}.customer_address ca
, ${catalog}.${database}.customer_demographics
WHERE ("c"."c_current_addr_sk" = "ca"."ca_address_sk")
   AND ("ca_state" IN ('IN','VA','MS'))
   AND ("cd_demo_sk" = "c"."c_current_cdemo_sk")
   AND (EXISTS (
   SELECT *
   FROM
     ${catalog}.${database}.store_sales
   , ${catalog}.${database}.date_dim
   WHERE ("c"."c_customer_sk" = "ss_customer_sk")
      AND ("ss_sold_date_sk" = "d_date_sk")
      AND ("d_year" = 2002)
      AND ("d_moy" BETWEEN 2 AND (2 + 2))
))
   AND (NOT (EXISTS (
   SELECT *
   FROM
     ${catalog}.${database}.web_sales
   , ${catalog}.${database}.date_dim
   WHERE ("c"."c_customer_sk" = "ws_bill_customer_sk")
      AND ("ws_sold_date_sk" = "d_date_sk")
      AND ("d_year" = 2002)
      AND ("d_moy" BETWEEN 2 AND (2 + 2))
)))
   AND (NOT (EXISTS (
   SELECT *
   FROM
     ${catalog}.${database}.catalog_sales
   , ${catalog}.${database}.date_dim
   WHERE ("c"."c_customer_sk" = "cs_ship_customer_sk")
      AND ("cs_sold_date_sk" = "d_date_sk")
      AND ("d_year" = 2002)
      AND ("d_moy" BETWEEN 2 AND (2 + 2))
)))
GROUP BY "cd_gender", "cd_marital_status", "cd_education_status", "cd_purchase_estimate", "cd_credit_rating"
ORDER BY "cd_gender" ASC, "cd_marital_status" ASC, "cd_education_status" ASC, "cd_purchase_estimate" ASC, "cd_credit_rating" ASC
LIMIT 100;
