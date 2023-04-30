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
        
        MERGE INTO
            ${catalog}.${database}.store_sales
                USING(
                SELECT
                    *
                FROM
                    (
                        SELECT
                            MIN( d_date_sk ) AS min_date
                        FROM
                            ${catalog}.${database}.date_dim
                        WHERE
                            d_date BETWEEN '${param1}' AND '${param2}'
                    ) r
                JOIN(
                        SELECT
                            MAX( d_date_sk ) AS max_date
                        FROM
                            ${catalog}.${database}.date_dim
                        WHERE
                            d_date BETWEEN '${param1}' AND '${param2}'
                    ) s
            ) SOURCE ON
            ss_sold_date_sk >= min_date
            AND ss_sold_date_sk <= max_date
            WHEN MATCHED THEN DELETE;
                
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
                        
                        MERGE INTO
                            ${catalog}.${database}.store_sales
                                USING(
                                SELECT
                                    *
                                FROM
                                    (
                                        SELECT
                                            MIN( d_date_sk ) AS min_date
                                        FROM
                                            ${catalog}.${database}.date_dim
                                        WHERE
                                            d_date BETWEEN '${param3}' AND '${param4}'
                                    ) r
                                JOIN(
                                        SELECT
                                            MAX( d_date_sk ) AS max_date
                                        FROM
                                            ${catalog}.${database}.date_dim
                                        WHERE
                                            d_date BETWEEN '${param3}' AND '${param4}'
                                    ) s
                            ) SOURCE ON
                            ss_sold_date_sk >= min_date
                            AND ss_sold_date_sk <= max_date
                            WHEN MATCHED THEN DELETE;
                                
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
                                        
                                        MERGE INTO
                                            ${catalog}.${database}.store_sales
                                                USING(
                                                SELECT
                                                    *
                                                FROM
                                                    (
                                                        SELECT
                                                            MIN( d_date_sk ) AS min_date
                                                        FROM
                                                            ${catalog}.${database}.date_dim
                                                        WHERE
                                                            d_date BETWEEN '${param5}' AND '${param6}'
                                                    ) r
                                                JOIN(
                                                        SELECT
                                                            MAX( d_date_sk ) AS max_date
                                                        FROM
                                                            ${catalog}.${database}.date_dim
                                                        WHERE
                                                            d_date BETWEEN '${param5}' AND '${param6}'
                                                    ) s
                                            ) SOURCE ON
                                            ss_sold_date_sk >= min_date
                                            AND ss_sold_date_sk <= max_date
                                            WHEN MATCHED THEN DELETE;
