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
        
        MERGE INTO
            ${catalog}.${database}.catalog_sales
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
            cs_sold_date_sk >= min_date
            AND cs_sold_date_sk <= max_date
            WHEN MATCHED THEN DELETE;
                
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
                        
                        MERGE INTO
                            ${catalog}.${database}.catalog_sales
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
                            cs_sold_date_sk >= min_date
                            AND cs_sold_date_sk <= max_date
                            WHEN MATCHED THEN DELETE;
                                
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
                                        
                                        MERGE INTO
                                            ${catalog}.${database}.catalog_sales
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
                                            cs_sold_date_sk >= min_date
                                            AND cs_sold_date_sk <= max_date
                                            WHEN MATCHED THEN DELETE;
