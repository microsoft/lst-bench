SELECT "sum"("ss_quantity")
FROM
  ${catalog}.${database}.store_sales
, ${catalog}.${database}.store
, ${catalog}.${database}.customer_demographics
, ${catalog}.${database}.customer_address
, ${catalog}.${database}.date_dim
WHERE ("s_store_sk" = "ss_store_sk")
   AND ("ss_sold_date_sk" = "d_date_sk")
   AND ("d_year" = 2001)
   AND ((("cd_demo_sk" = "ss_cdemo_sk")
         AND ("cd_marital_status" = 'W')
         AND ("cd_education_status" = '2 yr Degree')
         AND ("ss_sales_price" BETWEEN DECIMAL '100.00' AND DECIMAL '150.00'))
      OR (("cd_demo_sk" = "ss_cdemo_sk")
         AND ("cd_marital_status" = 'S')
         AND ("cd_education_status" = 'Advanced Degree')
         AND ("ss_sales_price" BETWEEN DECIMAL '50.00' AND DECIMAL '100.00'))
      OR (("cd_demo_sk" = "ss_cdemo_sk")
         AND ("cd_marital_status" = 'D')
         AND ("cd_education_status" = 'Primary')
         AND ("ss_sales_price" BETWEEN DECIMAL '150.00' AND DECIMAL '200.00')))
   AND ((("ss_addr_sk" = "ca_address_sk")
         AND ("ca_country" = 'United States')
         AND ("ca_state" IN ('IL', 'KY', 'OR'))
         AND ("ss_net_profit" BETWEEN 0 AND 2000))
      OR (("ss_addr_sk" = "ca_address_sk")
         AND ("ca_country" = 'United States')
         AND ("ca_state" IN ('VA', 'FL', 'AL'))
         AND ("ss_net_profit" BETWEEN 150 AND 3000))
      OR (("ss_addr_sk" = "ca_address_sk")
         AND ("ca_country" = 'United States')
         AND ("ca_state" IN ('OK', 'IA', 'TX'))
         AND ("ss_net_profit" BETWEEN 50 AND 25000)));
