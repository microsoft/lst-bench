select *
from (
          select count(*) h8_30_to_9
          from store_sales,
               household_demographics,
               time_dim,
               store
          where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
               and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
               and SS_STORE_SK = S_STORE_SK
               and time_dim.T_HOUR = 8
               and time_dim.T_MINUTE >= 30
               and (
                    (
                         household_demographics.HD_DEP_COUNT = 2
                         and household_demographics.HD_VEHICLE_COUNT <= 2 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = 0
                         and household_demographics.HD_VEHICLE_COUNT <= 0 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = -1
                         and household_demographics.HD_VEHICLE_COUNT <= -1 + 2
                    )
               )
               and store.S_STORE_NAME = 'ese'
     ) s1,
     (
          select count(*) h9_to_9_30
          from store_sales,
               household_demographics,
               time_dim,
               store
          where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
               and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
               and SS_STORE_SK = S_STORE_SK
               and time_dim.T_HOUR = 9
               and time_dim.T_MINUTE < 30
               and (
                    (
                         household_demographics.HD_DEP_COUNT = 2
                         and household_demographics.HD_VEHICLE_COUNT <= 2 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = 0
                         and household_demographics.HD_VEHICLE_COUNT <= 0 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = -1
                         and household_demographics.HD_VEHICLE_COUNT <= -1 + 2
                    )
               )
               and store.S_STORE_NAME = 'ese'
     ) s2,
     (
          select count(*) h9_30_to_10
          from store_sales,
               household_demographics,
               time_dim,
               store
          where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
               and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
               and SS_STORE_SK = S_STORE_SK
               and time_dim.T_HOUR = 9
               and time_dim.T_MINUTE >= 30
               and (
                    (
                         household_demographics.HD_DEP_COUNT = 2
                         and household_demographics.HD_VEHICLE_COUNT <= 2 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = 0
                         and household_demographics.HD_VEHICLE_COUNT <= 0 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = -1
                         and household_demographics.HD_VEHICLE_COUNT <= -1 + 2
                    )
               )
               and store.S_STORE_NAME = 'ese'
     ) s3,
     (
          select count(*) h10_to_10_30
          from store_sales,
               household_demographics,
               time_dim,
               store
          where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
               and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
               and SS_STORE_SK = S_STORE_SK
               and time_dim.T_HOUR = 10
               and time_dim.T_MINUTE < 30
               and (
                    (
                         household_demographics.HD_DEP_COUNT = 2
                         and household_demographics.HD_VEHICLE_COUNT <= 2 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = 0
                         and household_demographics.HD_VEHICLE_COUNT <= 0 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = -1
                         and household_demographics.HD_VEHICLE_COUNT <= -1 + 2
                    )
               )
               and store.S_STORE_NAME = 'ese'
     ) s4,
     (
          select count(*) h10_30_to_11
          from store_sales,
               household_demographics,
               time_dim,
               store
          where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
               and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
               and SS_STORE_SK = S_STORE_SK
               and time_dim.T_HOUR = 10
               and time_dim.T_MINUTE >= 30
               and (
                    (
                         household_demographics.HD_DEP_COUNT = 2
                         and household_demographics.HD_VEHICLE_COUNT <= 2 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = 0
                         and household_demographics.HD_VEHICLE_COUNT <= 0 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = -1
                         and household_demographics.HD_VEHICLE_COUNT <= -1 + 2
                    )
               )
               and store.S_STORE_NAME = 'ese'
     ) s5,
     (
          select count(*) h11_to_11_30
          from store_sales,
               household_demographics,
               time_dim,
               store
          where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
               and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
               and SS_STORE_SK = S_STORE_SK
               and time_dim.T_HOUR = 11
               and time_dim.T_MINUTE < 30
               and (
                    (
                         household_demographics.HD_DEP_COUNT = 2
                         and household_demographics.HD_VEHICLE_COUNT <= 2 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = 0
                         and household_demographics.HD_VEHICLE_COUNT <= 0 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = -1
                         and household_demographics.HD_VEHICLE_COUNT <= -1 + 2
                    )
               )
               and store.S_STORE_NAME = 'ese'
     ) s6,
     (
          select count(*) h11_30_to_12
          from store_sales,
               household_demographics,
               time_dim,
               store
          where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
               and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
               and SS_STORE_SK = S_STORE_SK
               and time_dim.T_HOUR = 11
               and time_dim.T_MINUTE >= 30
               and (
                    (
                         household_demographics.HD_DEP_COUNT = 2
                         and household_demographics.HD_VEHICLE_COUNT <= 2 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = 0
                         and household_demographics.HD_VEHICLE_COUNT <= 0 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = -1
                         and household_demographics.HD_VEHICLE_COUNT <= -1 + 2
                    )
               )
               and store.S_STORE_NAME = 'ese'
     ) s7,
     (
          select count(*) h12_to_12_30
          from store_sales,
               household_demographics,
               time_dim,
               store
          where SS_SOLD_TIME_SK = time_dim.T_TIME_SK
               and SS_HDEMO_SK = household_demographics.HD_DEMO_SK
               and SS_STORE_SK = S_STORE_SK
               and time_dim.T_HOUR = 12
               and time_dim.T_MINUTE < 30
               and (
                    (
                         household_demographics.HD_DEP_COUNT = 2
                         and household_demographics.HD_VEHICLE_COUNT <= 2 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = 0
                         and household_demographics.HD_VEHICLE_COUNT <= 0 + 2
                    )
                    or (
                         household_demographics.HD_DEP_COUNT = -1
                         and household_demographics.HD_VEHICLE_COUNT <= -1 + 2
                    )
               )
               and store.S_STORE_NAME = 'ese'
     ) s8 option (label = 'TPCDS-Q88');