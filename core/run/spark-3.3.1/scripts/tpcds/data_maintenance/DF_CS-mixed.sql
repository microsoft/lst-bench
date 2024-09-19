MERGE INTO
    ${catalog}.${database}.catalog_returns
        USING(
        SELECT
            cs_order_number
        FROM
            ${catalog}.${database}.catalog_sales,
            ${catalog}.${database}.date_dim
        WHERE
            cs_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param1}' AND '${param2}'
    ) SOURCE ON
    cr_order_number = cs_order_number
    WHEN MATCHED THEN DELETE;
        
        DELETE
        FROM
            ${catalog}.${database}.catalog_sales
        WHERE
            cs_sold_date_sk >=(
                SELECT
                    MIN( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param1}' AND '${param2}'
            )
            AND cs_sold_date_sk <=(
                SELECT
                    MAX( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param1}' AND '${param2}'
            );

MERGE INTO
    ${catalog}.${database}.catalog_returns
        USING(
        SELECT
            cs_order_number
        FROM
            ${catalog}.${database}.catalog_sales,
            ${catalog}.${database}.date_dim
        WHERE
            cs_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param3}' AND '${param4}'
    ) SOURCE ON
    cr_order_number = cs_order_number
    WHEN MATCHED THEN DELETE;
        
        DELETE
        FROM
            ${catalog}.${database}.catalog_sales
        WHERE
            cs_sold_date_sk >=(
                SELECT
                    MIN( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param3}' AND '${param4}'
            )
            AND cs_sold_date_sk <=(
                SELECT
                    MAX( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param3}' AND '${param4}'
            );

MERGE INTO
    ${catalog}.${database}.catalog_returns
        USING(
        SELECT
            cs_order_number
        FROM
            ${catalog}.${database}.catalog_sales,
            ${catalog}.${database}.date_dim
        WHERE
            cs_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param5}' AND '${param6}'
    ) SOURCE ON
    cr_order_number = cs_order_number
    WHEN MATCHED THEN DELETE;
        
        DELETE
        FROM
            ${catalog}.${database}.catalog_sales
        WHERE
            cs_sold_date_sk >=(
                SELECT
                    MIN( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param5}' AND '${param6}'
            )
            AND cs_sold_date_sk <=(
                SELECT
                    MAX( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param5}' AND '${param6}'
            );
