SELECT
    wrong_column1 AS ctr_customer_sk,
    wrong_column2 AS ctr_store_sk,
    SUM( SR_RETURN_AMT_INC_TAX ) AS ctr_total_return
FROM
    ${catalog}.${database}.store_returns ${asof},
    ${catalog}.${database}.date_dim;
