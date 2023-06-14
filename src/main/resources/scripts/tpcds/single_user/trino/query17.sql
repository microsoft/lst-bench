SELECT
  "i_item_id"
, "i_item_desc"
, "s_state"
, "count"("ss_quantity") "store_sales_quantitycount"
, "avg"("ss_quantity") "store_sales_quantityave"
, "stddev_samp"("ss_quantity") "store_sales_quantitystdev"
, ("stddev_samp"("ss_quantity") / "avg"("ss_quantity")) "store_sales_quantitycov"
, "count"("sr_return_quantity") "store_returns_quantitycount"
, "avg"("sr_return_quantity") "store_returns_quantityave"
, "stddev_samp"("sr_return_quantity") "store_returns_quantitystdev"
, ("stddev_samp"("sr_return_quantity") / "avg"("sr_return_quantity")) "store_returns_quantitycov"
, "count"("cs_quantity") "catalog_sales_quantitycount"
, "avg"("cs_quantity") "catalog_sales_quantityave"
, "stddev_samp"("cs_quantity") "catalog_sales_quantitystdev"
, ("stddev_samp"("cs_quantity") / "avg"("cs_quantity")) "catalog_sales_quantitycov"
FROM
  ${catalog}.${database}.store_sales
, ${catalog}.${database}.store_returns
, ${catalog}.${database}.catalog_sales
, ${catalog}.${database}.date_dim d1
, ${catalog}.${database}.date_dim d2
, ${catalog}.${database}.date_dim d3
, ${catalog}.${database}.store
, ${catalog}.${database}.item
WHERE ("d1"."d_quarter_name" = '1999Q1')
   AND ("d1"."d_date_sk" = "ss_sold_date_sk")
   AND ("i_item_sk" = "ss_item_sk")
   AND ("s_store_sk" = "ss_store_sk")
   AND ("ss_customer_sk" = "sr_customer_sk")
   AND ("ss_item_sk" = "sr_item_sk")
   AND ("ss_ticket_number" = "sr_ticket_number")
   AND ("sr_returned_date_sk" = "d2"."d_date_sk")
   AND ("d2"."d_quarter_name" IN ('1999Q1','1999Q2','1999Q3'))
   AND ("sr_customer_sk" = "cs_bill_customer_sk")
   AND ("sr_item_sk" = "cs_item_sk")
   AND ("cs_sold_date_sk" = "d3"."d_date_sk")
   AND ("d3"."d_quarter_name" IN ('1999Q1','1999Q2','1999Q3'))
GROUP BY "i_item_id", "i_item_desc", "s_state"
ORDER BY "i_item_id" ASC, "i_item_desc" ASC, "s_state" ASC
LIMIT 100;
