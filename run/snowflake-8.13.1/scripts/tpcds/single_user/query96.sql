SELECT
    COUNT(*)
FROM
    ${catalog}.${database}.store_sales ${asof_sf},
    ${catalog}.${database}.household_demographics,
    ${catalog}.${database}.time_dim,
    ${catalog}.${database}.store
WHERE
    ss_sold_time_sk = time_dim.t_time_sk
    AND ss_hdemo_sk = household_demographics.hd_demo_sk
    AND ss_store_sk = s_store_sk
    AND time_dim.t_hour = 8
    AND time_dim.t_minute >= 30
    AND household_demographics.hd_dep_count = 5
    AND store.s_store_name = 'ese'
ORDER BY
    COUNT(*) LIMIT 100;
