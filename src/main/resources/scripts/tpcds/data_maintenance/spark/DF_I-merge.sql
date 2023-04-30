MERGE INTO
    ${catalog}.${database}.inventory
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
                    d_date BETWEEN '${param7}' AND '${param8}'
            ) r
        JOIN(
                SELECT
                    MAX( d_date_sk ) AS max_date
                FROM
                    ${catalog}.${database}.date_dim
                WHERE
                    d_date BETWEEN '${param7}' AND '${param8}'
            ) s
    ) SOURCE ON
    inv_date_sk >= min_date
    AND inv_date_sk <= max_date
    WHEN MATCHED THEN DELETE;
        
        MERGE INTO
            ${catalog}.${database}.inventory
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
                            d_date BETWEEN '${param9}' AND '${param10}'
                    ) r
                JOIN(
                        SELECT
                            MAX( d_date_sk ) AS max_date
                        FROM
                            ${catalog}.${database}.date_dim
                        WHERE
                            d_date BETWEEN '${param9}' AND '${param10}'
                    ) s
            ) SOURCE ON
            inv_date_sk >= min_date
            AND inv_date_sk <= max_date
            WHEN MATCHED THEN DELETE;
                
                MERGE INTO
                    ${catalog}.${database}.inventory
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
                                    d_date BETWEEN '${param11}' AND '${param12}'
                            ) r
                        JOIN(
                                SELECT
                                    MAX( d_date_sk ) AS max_date
                                FROM
                                    ${catalog}.${database}.date_dim
                                WHERE
                                    d_date BETWEEN '${param11}' AND '${param12}'
                            ) s
                    ) SOURCE ON
                    inv_date_sk >= min_date
                    AND inv_date_sk <= max_date
                    WHEN MATCHED THEN DELETE;
