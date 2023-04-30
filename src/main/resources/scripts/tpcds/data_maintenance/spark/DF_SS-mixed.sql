MERGE INTO
    ${catalog}.${database}.store_returns
        USING(
        SELECT
            ss_ticket_number
        FROM
            ${catalog}.${database}.store_sales,
            ${catalog}.${database}.date_dim
        WHERE
            ss_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param1}' AND '${param2}'
    ) SOURCE ON
    sr_ticket_number = ss_ticket_number
    WHEN MATCHED THEN DELETE;
        
        DELETE
        FROM
            ${catalog}.${database}.store_sales
        WHERE
            ss_sold_date_sk >=(
                SELECT
                    MIN( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param1}' AND '${param2}'
            )
            AND ss_sold_date_sk <=(
                SELECT
                    MAX( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param1}' AND '${param2}'
            );

MERGE INTO
    ${catalog}.${database}.store_returns
        USING(
        SELECT
            ss_ticket_number
        FROM
            ${catalog}.${database}.store_sales,
            ${catalog}.${database}.date_dim
        WHERE
            ss_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param3}' AND '${param4}'
    ) SOURCE ON
    sr_ticket_number = ss_ticket_number
    WHEN MATCHED THEN DELETE;
        
        DELETE
        FROM
            ${catalog}.${database}.store_sales
        WHERE
            ss_sold_date_sk >=(
                SELECT
                    MIN( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param3}' AND '${param4}'
            )
            AND ss_sold_date_sk <=(
                SELECT
                    MAX( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param3}' AND '${param4}'
            );

MERGE INTO
    ${catalog}.${database}.store_returns
        USING(
        SELECT
            ss_ticket_number
        FROM
            ${catalog}.${database}.store_sales,
            ${catalog}.${database}.date_dim
        WHERE
            ss_sold_date_sk = d_date_sk
            AND d_date BETWEEN '${param5}' AND '${param6}'
    ) SOURCE ON
    sr_ticket_number = ss_ticket_number
    WHEN MATCHED THEN DELETE;
        
        DELETE
        FROM
            ${catalog}.${database}.store_sales
        WHERE
            ss_sold_date_sk >=(
                SELECT
                    MIN( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param5}' AND '${param6}'
            )
            AND ss_sold_date_sk <=(
                SELECT
                    MAX( d_date_sk )
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param5}' AND '${param6}'
            );
