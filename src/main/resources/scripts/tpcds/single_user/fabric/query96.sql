select top 100 count(*)
from store_sales,
    household_demographics,
    time_dim,
    store
where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
    and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
    and SS_STORE_SK = S_STORE_SK
    and time_dim.T_HOUR = 15
    and time_dim.T_MINUTE >= 30
    and household_demographics.HD_DEP_COUNT = 2
    and store.S_STORE_NAME = 'ese'
order by count(*) option (label = 'TPCDS-Q96');