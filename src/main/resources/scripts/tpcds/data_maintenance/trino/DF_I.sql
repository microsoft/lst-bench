delete from ${catalog}.${database}.inventory where inv_date_sk >= ( select min(d_date_sk) from ${catalog}.${database}.date_dim  where  d_date between CAST('${param7}' AS DATE) and CAST('${param8}' AS DATE)) and
                inv_date_sk <= ( select max(d_date_sk) from ${catalog}.${database}.date_dim  where  d_date between CAST('${param7}' AS DATE) and CAST('${param8}' AS DATE));

delete from ${catalog}.${database}.inventory where inv_date_sk >= ( select min(d_date_sk) from ${catalog}.${database}.date_dim  where  d_date between CAST('${param9}' AS DATE) and CAST('${param10}' AS DATE)) and
                inv_date_sk <= ( select max(d_date_sk) from ${catalog}.${database}.date_dim  where  d_date between CAST('${param9}' AS DATE) and CAST('${param10}' AS DATE));

delete from ${catalog}.${database}.inventory where inv_date_sk >= ( select min(d_date_sk) from ${catalog}.${database}.date_dim  where  d_date between CAST('${param11}' AS DATE) and CAST('${param12}' AS DATE)) and
                inv_date_sk <= ( select max(d_date_sk) from ${catalog}.${database}.date_dim  where  d_date between CAST('${param11}' AS DATE) and CAST('${param12}' AS DATE));
