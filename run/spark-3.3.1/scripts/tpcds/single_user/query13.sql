SELECT
    AVG( ss_quantity ),
    AVG( ss_ext_sales_price ),
    AVG( ss_ext_wholesale_cost ),
    SUM( ss_ext_wholesale_cost )
FROM
    ${catalog}.${database}.store_sales ${asof},
    ${catalog}.${database}.store,
    ${catalog}.${database}.customer_demographics,
    ${catalog}.${database}.household_demographics,
    ${catalog}.${database}.customer_address,
    ${catalog}.${database}.date_dim
WHERE
    s_store_sk = ss_store_sk
    AND ss_sold_date_sk = d_date_sk
    AND d_year = 2001
    AND(
        (
            ss_hdemo_sk = hd_demo_sk
            AND cd_demo_sk = ss_cdemo_sk
            AND cd_marital_status = 'U'
            AND cd_education_status = '4 yr Degree'
            AND ss_sales_price BETWEEN 100.00 AND 150.00
            AND hd_dep_count = 3
        )
        OR(
            ss_hdemo_sk = hd_demo_sk
            AND cd_demo_sk = ss_cdemo_sk
            AND cd_marital_status = 'S'
            AND cd_education_status = 'Unknown'
            AND ss_sales_price BETWEEN 50.00 AND 100.00
            AND hd_dep_count = 1
        )
        OR(
            ss_hdemo_sk = hd_demo_sk
            AND cd_demo_sk = ss_cdemo_sk
            AND cd_marital_status = 'D'
            AND cd_education_status = '2 yr Degree'
            AND ss_sales_price BETWEEN 150.00 AND 200.00
            AND hd_dep_count = 1
        )
    )
    AND(
        (
            ss_addr_sk = ca_address_sk
            AND ca_country = 'United States'
            AND ca_state IN(
                'CO',
                'MI',
                'MN'
            )
            AND ss_net_profit BETWEEN 100 AND 200
        )
        OR(
            ss_addr_sk = ca_address_sk
            AND ca_country = 'United States'
            AND ca_state IN(
                'NC',
                'NY',
                'TX'
            )
            AND ss_net_profit BETWEEN 150 AND 300
        )
        OR(
            ss_addr_sk = ca_address_sk
            AND ca_country = 'United States'
            AND ca_state IN(
                'CA',
                'NE',
                'TN'
            )
            AND ss_net_profit BETWEEN 50 AND 250
        )
    );
