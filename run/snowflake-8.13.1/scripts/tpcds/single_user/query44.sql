SELECT
    asceding.rnk,
    i1.i_product_name best_performing,
    i2.i_product_name worst_performing
FROM
    (
        SELECT
            *
        FROM
            (
                SELECT
                    item_sk,
                    RANK() OVER(
                    ORDER BY
                        rank_col ASC
                    ) rnk
                FROM
                    (
                        SELECT
                            ss_item_sk item_sk,
                            AVG( ss_net_profit ) rank_col
                        FROM
                            ${catalog}.${database}.store_sales ${asof_sf} ss1
                        WHERE
                            ss_store_sk = 6
                        GROUP BY
                            ss_item_sk
                        HAVING
                            AVG( ss_net_profit )> 0.9 *(
                                SELECT
                                    AVG( ss_net_profit ) rank_col
                                FROM
                                    ${catalog}.${database}.store_sales ${asof_sf}
                                WHERE
                                    ss_store_sk = 6
                                    AND ss_hdemo_sk IS NULL
                                GROUP BY
                                    ss_store_sk
                            )
                    ) V1
            ) V11
        WHERE
            rnk < 11
    ) asceding,
    (
        SELECT
            *
        FROM
            (
                SELECT
                    item_sk,
                    RANK() OVER(
                    ORDER BY
                        rank_col DESC
                    ) rnk
                FROM
                    (
                        SELECT
                            ss_item_sk item_sk,
                            AVG( ss_net_profit ) rank_col
                        FROM
                            ${catalog}.${database}.store_sales ${asof_sf} ss1
                        WHERE
                            ss_store_sk = 6
                        GROUP BY
                            ss_item_sk
                        HAVING
                            AVG( ss_net_profit )> 0.9 *(
                                SELECT
                                    AVG( ss_net_profit ) rank_col
                                FROM
                                    ${catalog}.${database}.store_sales ${asof_sf}
                                WHERE
                                    ss_store_sk = 6
                                    AND ss_hdemo_sk IS NULL
                                GROUP BY
                                    ss_store_sk
                            )
                    ) V2
            ) V21
        WHERE
            rnk < 11
    ) descending,
    ${catalog}.${database}.item i1,
    ${catalog}.${database}.item i2
WHERE
    asceding.rnk = descending.rnk
    AND i1.i_item_sk = asceding.item_sk
    AND i2.i_item_sk = descending.item_sk
ORDER BY
    asceding.rnk LIMIT 100;
