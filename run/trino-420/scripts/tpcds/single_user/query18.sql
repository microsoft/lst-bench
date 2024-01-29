SELECT
  "i_item_id"
, "ca_country"
, "ca_state"
, "ca_county"
, "avg"(CAST("cs_quantity" AS DECIMAL(12,2))) "agg1"
, "avg"(CAST("cs_list_price" AS DECIMAL(12,2))) "agg2"
, "avg"(CAST("cs_coupon_amt" AS DECIMAL(12,2))) "agg3"
, "avg"(CAST("cs_sales_price" AS DECIMAL(12,2))) "agg4"
, "avg"(CAST("cs_net_profit" AS DECIMAL(12,2))) "agg5"
, "avg"(CAST("c_birth_year" AS DECIMAL(12,2))) "agg6"
, "avg"(CAST("cd1"."cd_dep_count" AS DECIMAL(12,2))) "agg7"
FROM
  ${catalog}.${database}.catalog_sales
, ${catalog}.${database}.customer_demographics cd1
, ${catalog}.${database}.customer_demographics cd2
, ${catalog}.${database}.customer
, ${catalog}.${database}.customer_address
, ${catalog}.${database}.date_dim
, ${catalog}.${database}.item
WHERE ("cs_sold_date_sk" = "d_date_sk")
   AND ("cs_item_sk" = "i_item_sk")
   AND ("cs_bill_cdemo_sk" = "cd1"."cd_demo_sk")
   AND ("cs_bill_customer_sk" = "c_customer_sk")
   AND ("cd1"."cd_gender" = 'M')
   AND ("cd1"."cd_education_status" = 'Primary')
   AND ("c_current_cdemo_sk" = "cd2"."cd_demo_sk")
   AND ("c_current_addr_sk" = "ca_address_sk")
   AND ("c_birth_month" IN (1,2,9,5,11,3))
   AND ("d_year" = 1998)
   AND ("ca_state" IN ('MS','NE','IA'
                   ,'MI','GA','NY','CO'))
GROUP BY ROLLUP (i_item_id, ca_country, ca_state, ca_county)
ORDER BY "ca_country" ASC, "ca_state" ASC, "ca_county" ASC, "i_item_id" ASC
LIMIT 100;
