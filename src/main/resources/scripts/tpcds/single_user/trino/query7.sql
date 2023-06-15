SELECT
  "i_item_id"
, "avg"("ss_quantity") "agg1"
, "avg"("ss_list_price") "agg2"
, "avg"("ss_coupon_amt") "agg3"
, "avg"("ss_sales_price") "agg4"
FROM
  ${catalog}.${database}.store_sales
, ${catalog}.${database}.customer_demographics
, ${catalog}.${database}.date_dim
, ${catalog}.${database}.item
, ${catalog}.${database}.promotion
WHERE ("ss_sold_date_sk" = "d_date_sk")
   AND ("ss_item_sk" = "i_item_sk")
   AND ("ss_cdemo_sk" = "cd_demo_sk")
   AND ("ss_promo_sk" = "p_promo_sk")
   AND ("cd_gender" = 'M')
   AND ("cd_marital_status" = 'M')
   AND ("cd_education_status" = '4 yr Degree')
   AND (("p_channel_email" = 'N')
      OR ("p_channel_event" = 'N'))
   AND ("d_year" = 2001)
GROUP BY "i_item_id"
ORDER BY "i_item_id" ASC
LIMIT 100;
