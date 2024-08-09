SELECT
    DISTINCT(i_product_name)
FROM
    ${catalog}.${database}.item i1
WHERE
    i_manufact_id BETWEEN 668 AND 668 + 40
    AND(
        SELECT
            COUNT(*) AS item_cnt
        FROM
            ${catalog}.${database}.item
        WHERE
            (
                i_manufact = i1.i_manufact
                AND(
                    (
                        i_category = 'Women'
                        AND(
                            i_color = 'cream'
                            OR i_color = 'ghost'
                        )
                        AND(
                            i_units = 'Ton'
                            OR i_units = 'Gross'
                        )
                        AND(
                            i_size = 'economy'
                            OR i_size = 'small'
                        )
                    )
                    OR(
                        i_category = 'Women'
                        AND(
                            i_color = 'midnight'
                            OR i_color = 'burlywood'
                        )
                        AND(
                            i_units = 'Tsp'
                            OR i_units = 'Bundle'
                        )
                        AND(
                            i_size = 'medium'
                            OR i_size = 'extra large'
                        )
                    )
                    OR(
                        i_category = 'Men'
                        AND(
                            i_color = 'lavender'
                            OR i_color = 'azure'
                        )
                        AND(
                            i_units = 'Each'
                            OR i_units = 'Lb'
                        )
                        AND(
                            i_size = 'large'
                            OR i_size = 'N/A'
                        )
                    )
                    OR(
                        i_category = 'Men'
                        AND(
                            i_color = 'chocolate'
                            OR i_color = 'steel'
                        )
                        AND(
                            i_units = 'N/A'
                            OR i_units = 'Dozen'
                        )
                        AND(
                            i_size = 'economy'
                            OR i_size = 'small'
                        )
                    )
                )
            )
            OR(
                i_manufact = i1.i_manufact
                AND(
                    (
                        i_category = 'Women'
                        AND(
                            i_color = 'floral'
                            OR i_color = 'royal'
                        )
                        AND(
                            i_units = 'Unknown'
                            OR i_units = 'Tbl'
                        )
                        AND(
                            i_size = 'economy'
                            OR i_size = 'small'
                        )
                    )
                    OR(
                        i_category = 'Women'
                        AND(
                            i_color = 'navy'
                            OR i_color = 'forest'
                        )
                        AND(
                            i_units = 'Bunch'
                            OR i_units = 'Dram'
                        )
                        AND(
                            i_size = 'medium'
                            OR i_size = 'extra large'
                        )
                    )
                    OR(
                        i_category = 'Men'
                        AND(
                            i_color = 'cyan'
                            OR i_color = 'indian'
                        )
                        AND(
                            i_units = 'Carton'
                            OR i_units = 'Cup'
                        )
                        AND(
                            i_size = 'large'
                            OR i_size = 'N/A'
                        )
                    )
                    OR(
                        i_category = 'Men'
                        AND(
                            i_color = 'coral'
                            OR i_color = 'pale'
                        )
                        AND(
                            i_units = 'Pallet'
                            OR i_units = 'Gram'
                        )
                        AND(
                            i_size = 'economy'
                            OR i_size = 'small'
                        )
                    )
                )
            )
    )> 0
ORDER BY
    i_product_name LIMIT 100;
