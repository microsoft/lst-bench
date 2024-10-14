SELECT
    CS_ITEM_SK, CS_ORDER_NUMBER
FROM
    catalog_sales
WHERE
    CS_SOLD_DATE_SK >= (
        SELECT
            MIN(D_DATE_SK)
        FROM
            date_dim
        WHERE
            D_DATE BETWEEN CAST('${param3}' AS DATE) AND CAST('${param4}' AS DATE)
    )
    AND CS_SOLD_DATE_SK <=(
        SELECT
            MAX(D_DATE_SK)
        FROM
            date_dim
        WHERE
            D_DATE BETWEEN CAST('${param3}' AS DATE) AND CAST('${param4}' AS DATE)
    );
