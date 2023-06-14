SELECT
  (CASE WHEN ((
      SELECT "count"(*)
      FROM
        ${catalog}.${database}.store_sales
      WHERE ("ss_quantity" BETWEEN 1 AND 20)
   ) > 31002) THEN (
   SELECT "avg"("ss_ext_discount_amt")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 1 AND 20)
) ELSE (
   SELECT "avg"("ss_net_paid")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 1 AND 20)
) END) "bucket1"
, (CASE WHEN ((
      SELECT "count"(*)
      FROM
        ${catalog}.${database}.store_sales
      WHERE ("ss_quantity" BETWEEN 21 AND 40)
   ) > 588) THEN (
   SELECT "avg"("ss_ext_discount_amt")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 21 AND 40)
) ELSE (
   SELECT "avg"("ss_net_paid")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 21 AND 40)
) END) "bucket2"
, (CASE WHEN ((
      SELECT "count"(*)
      FROM
        ${catalog}.${database}.store_sales
      WHERE ("ss_quantity" BETWEEN 41 AND 60)
   ) > 2456) THEN (
   SELECT "avg"("ss_ext_discount_amt")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 41 AND 60)
) ELSE (
   SELECT "avg"("ss_net_paid")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 41 AND 60)
) END) "bucket3"
, (CASE WHEN ((
      SELECT "count"(*)
      FROM
        ${catalog}.${database}.store_sales
      WHERE ("ss_quantity" BETWEEN 61 AND 80)
   ) > 21645) THEN (
   SELECT "avg"("ss_ext_discount_amt")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 61 AND 80)
) ELSE (
   SELECT "avg"("ss_net_paid")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 61 AND 80)
) END) "bucket4"
, (CASE WHEN ((
      SELECT "count"(*)
      FROM
        ${catalog}.${database}.store_sales
      WHERE ("ss_quantity" BETWEEN 81 AND 100)
   ) > 20553) THEN (
   SELECT "avg"("ss_ext_discount_amt")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 81 AND 100)
) ELSE (
   SELECT "avg"("ss_net_paid")
   FROM
     ${catalog}.${database}.store_sales
   WHERE ("ss_quantity" BETWEEN 81 AND 100)
) END) "bucket5"
FROM
  ${catalog}.${database}.reason
WHERE ("r_reason_sk" = 1);
