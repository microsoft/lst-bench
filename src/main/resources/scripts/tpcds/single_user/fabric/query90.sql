select top 100 cast(amc as decimal(15, 4)) / cast(pmc as decimal(15, 4)) am_pm_ratio
from (
    select count(*) amc
    from web_sales,
      household_demographics,
      time_dim,
      web_page
    where WS_SOLD_TIME_SK = time_dim.T_TIME_SK
      and WS_SHIP_HDEMO_SK = household_demographics.HD_DEMO_SK
      and WS_WEB_PAGE_SK = web_page.WP_WEB_PAGE_SK
      and time_dim.T_HOUR between 6 and 6 + 1
      and household_demographics.HD_DEP_COUNT = 0
      and web_page.WP_CHAR_COUNT between 5000 and 5200
  ) at,
  (
    select count(*) pmc
    from web_sales,
      household_demographics,
      time_dim,
      web_page
    where WS_SOLD_TIME_SK = time_dim.T_TIME_SK
      and WS_SHIP_HDEMO_SK = household_demographics.HD_DEMO_SK
      and WS_WEB_PAGE_SK = web_page.WP_WEB_PAGE_SK
      and time_dim.T_HOUR between 19 and 19 + 1
      and household_demographics.HD_DEP_COUNT = 0
      and web_page.WP_CHAR_COUNT between 5000 and 5200
  ) pt
order by am_pm_ratio option (label = 'TPCDS-Q90');