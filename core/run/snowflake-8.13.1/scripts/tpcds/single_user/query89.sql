SELECT
    *
FROM
    (
        SELECT
            i_category,
            i_class,
            i_brand,
            s_store_name,
            s_company_name,
            d_moy,
            SUM( ss_sales_price ) sum_sales,
            AVG( SUM( ss_sales_price )) OVER(
                PARTITION BY i_category,
                i_brand,
                s_store_name,
                s_company_name
            ) avg_monthly_sales
        FROM
            ${catalog}.${database}.item,
            ${catalog}.${database}.store_sales ${asof_sf},
            ${catalog}.${database}.date_dim,
            ${catalog}.${database}.store
        WHERE
            ss_item_sk = i_item_sk
            AND ss_sold_date_sk = d_date_sk
            AND ss_store_sk = s_store_sk
            AND d_year IN(2001)
            AND(
                (
                    i_category IN(
                        'Children',
                        'Jewelry',
                        'Home'
                    )
                    AND i_class IN(
                        'infants',
                        'birdal',
                        'flatware'
                    )
                )
                OR(
                    i_category IN(
                        'Electronics',
                        'Music',
                        'Books'
                    )
                    AND i_class IN(
                        'audio',
                        'classical',
                        'science'
                    )
                )
            )
        GROUP BY
            i_category,
            i_class,
            i_brand,
            s_store_name,
            s_company_name,
            d_moy
    ) tmp1
WHERE
    CASE
        WHEN(
            avg_monthly_sales <> 0
        ) THEN(
            ABS( sum_sales - avg_monthly_sales )/ avg_monthly_sales
        )
        ELSE NULL
    END > 0.1
ORDER BY
    sum_sales - avg_monthly_sales,
    s_store_name LIMIT 100;
