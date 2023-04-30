SELECT
    ca_state,
    cd_gender,
    cd_marital_status,
    cd_dep_count,
    COUNT(*) cnt1,
    MAX( cd_dep_count ) AGGONE_1,
    STDDEV_SAMP(cd_dep_count) AGGTWO_1,
    STDDEV_SAMP(cd_dep_count) AGGTHREE_1,
    cd_dep_employed_count,
    COUNT(*) cnt2,
    MAX( cd_dep_employed_count ) AGGONE_2,
    STDDEV_SAMP(cd_dep_employed_count) AGGTWO_2,
    STDDEV_SAMP(cd_dep_employed_count) AGGTHREE_2,
    cd_dep_college_count,
    COUNT(*) cnt3,
    MAX( cd_dep_college_count ) AGGONE_3,
    STDDEV_SAMP(cd_dep_college_count) AGGTWO_3,
    STDDEV_SAMP(cd_dep_college_count) AGGTHREE_3
FROM
    ${catalog}.${database}.customer c,
    ${catalog}.${database}.customer_address ca,
    ${catalog}.${database}.customer_demographics
WHERE
    c.c_current_addr_sk = ca.ca_address_sk
    AND cd_demo_sk = c.c_current_cdemo_sk
    AND EXISTS(
        SELECT
            *
        FROM
            ${catalog}.${database}.store_sales ${asof},
            ${catalog}.${database}.date_dim
        WHERE
            c.c_customer_sk = ss_customer_sk
            AND ss_sold_date_sk = d_date_sk
            AND d_year = 2000
            AND d_qoy < 4
    )
    AND(
        EXISTS(
            SELECT
                *
            FROM
                ${catalog}.${database}.web_sales ${asof},
                ${catalog}.${database}.date_dim
            WHERE
                c.c_customer_sk = ws_bill_customer_sk
                AND ws_sold_date_sk = d_date_sk
                AND d_year = 2000
                AND d_qoy < 4
        )
        OR EXISTS(
            SELECT
                *
            FROM
                ${catalog}.${database}.catalog_sales ${asof},
                ${catalog}.${database}.date_dim
            WHERE
                c.c_customer_sk = cs_ship_customer_sk
                AND cs_sold_date_sk = d_date_sk
                AND d_year = 2000
                AND d_qoy < 4
        )
    )
GROUP BY
    ca_state,
    cd_gender,
    cd_marital_status,
    cd_dep_count,
    cd_dep_employed_count,
    cd_dep_college_count
ORDER BY
    ca_state,
    cd_gender,
    cd_marital_status,
    cd_dep_count,
    cd_dep_employed_count,
    cd_dep_college_count LIMIT 100;
