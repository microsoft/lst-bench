SELECT *
FROM
  (
   SELECT
     "avg"("ss_list_price") "b1_lp"
   , "count"("ss_list_price") "b1_cnt"
   , "count"(DISTINCT "ss_list_price") "b1_cntd"
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 0 AND 5)
      AND (("ss_list_price" BETWEEN 28 AND (28 + 10))
         OR ("ss_coupon_amt" BETWEEN 12573 AND (12573 + 1000))
         OR ("ss_wholesale_cost" BETWEEN 33 AND (33 + 20)))
)  b1
, (
   SELECT
     "avg"("ss_list_price") "b2_lp"
   , "count"("ss_list_price") "b2_cnt"
   , "count"(DISTINCT "ss_list_price") "b2_cntd"
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 6 AND 10)
      AND (("ss_list_price" BETWEEN 143 AND (143 + 10))
         OR ("ss_coupon_amt" BETWEEN 5562 AND (5562 + 1000))
         OR ("ss_wholesale_cost" BETWEEN 45 AND (45 + 20)))
)  b2
, (
   SELECT
     "avg"("ss_list_price") "b3_lp"
   , "count"("ss_list_price") "b3_cnt"
   , "count"(DISTINCT "ss_list_price") "b3_cntd"
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 11 AND 15)
      AND (("ss_list_price" BETWEEN 159 AND (159 + 10))
         OR ("ss_coupon_amt" BETWEEN 2807 AND (2807 + 1000))
         OR ("ss_wholesale_cost" BETWEEN 24 AND (24 + 20)))
)  b3
, (
   SELECT
     "avg"("ss_list_price") "b4_lp"
   , "count"("ss_list_price") "b4_cnt"
   , "count"(DISTINCT "ss_list_price") "b4_cntd"
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 16 AND 20)
      AND (("ss_list_price" BETWEEN 24 AND (24 + 10))
         OR ("ss_coupon_amt" BETWEEN 3706 AND (3706 + 1000))
         OR ("ss_wholesale_cost" BETWEEN 46 AND (46 + 20)))
)  b4
, (
   SELECT
     "avg"("ss_list_price") "b5_lp"
   , "count"("ss_list_price") "b5_cnt"
   , "count"(DISTINCT "ss_list_price") "b5_cntd"
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 21 AND 25)
      AND (("ss_list_price" BETWEEN 76 AND (76 + 10))
         OR ("ss_coupon_amt" BETWEEN 2096 AND (2096 + 1000))
         OR ("ss_wholesale_cost" BETWEEN 50 AND (50 + 20)))
)  b5
, (
   SELECT
     "avg"("ss_list_price") "b6_lp"
   , "count"("ss_list_price") "b6_cnt"
   , "count"(DISTINCT "ss_list_price") "b6_cntd"
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 26 AND 30)
      AND (("ss_list_price" BETWEEN 169 AND (169 + 10))
         OR ("ss_coupon_amt" BETWEEN 10672 AND (10672 + 1000))
         OR ("ss_wholesale_cost" BETWEEN 58 AND (58 + 20)))
)  b6
LIMIT 100;
