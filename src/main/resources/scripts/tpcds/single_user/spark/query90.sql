SELECT
    CAST(
        amc AS DECIMAL(
            15,
            4
        )
    )/ CAST(
        pmc AS DECIMAL(
            15,
            4
        )
    ) am_pm_ratio
FROM
    (
        SELECT
            COUNT(*) amc
        FROM
            ${catalog}.${database}.web_sales ${asof},
            ${catalog}.${database}.household_demographics,
            ${catalog}.${database}.time_dim,
            ${catalog}.${database}.web_page
        WHERE
            ws_sold_time_sk = time_dim.t_time_sk
            AND ws_ship_hdemo_sk = household_demographics.hd_demo_sk
            AND ws_web_page_sk = web_page.wp_web_page_sk
            AND time_dim.t_hour BETWEEN 9 AND 9 + 1
            AND household_demographics.hd_dep_count = 2
            AND web_page.wp_char_count BETWEEN 5000 AND 5200
    ) AT,
    (
        SELECT
            COUNT(*) pmc
        FROM
            ${catalog}.${database}.web_sales ${asof},
            ${catalog}.${database}.household_demographics,
            ${catalog}.${database}.time_dim,
            ${catalog}.${database}.web_page
        WHERE
            ws_sold_time_sk = time_dim.t_time_sk
            AND ws_ship_hdemo_sk = household_demographics.hd_demo_sk
            AND ws_web_page_sk = web_page.wp_web_page_sk
            AND time_dim.t_hour BETWEEN 15 AND 15 + 1
            AND household_demographics.hd_dep_count = 2
            AND web_page.wp_char_count BETWEEN 5000 AND 5200
    ) pt
ORDER BY
    am_pm_ratio LIMIT 100;
