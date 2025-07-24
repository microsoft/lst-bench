SELECT
    INV_DATE_SK, INV_ITEM_SK, INV_WAREHOUSE_SK
FROM
    inventory
WHERE
    INV_DATE_SK >=(
        SELECT
            MIN(D_DATE_SK)
        FROM
            date_dim
        WHERE
            D_DATE BETWEEN CAST('${param7}' AS DATE) AND CAST('${param8}' AS DATE)
    )
    AND INV_DATE_SK <=(
        SELECT
            MAX(D_DATE_SK)
        FROM
            date_dim
        WHERE
            D_DATE BETWEEN CAST('${param7}' AS DATE) AND CAST('${param8}' AS DATE)
    );
