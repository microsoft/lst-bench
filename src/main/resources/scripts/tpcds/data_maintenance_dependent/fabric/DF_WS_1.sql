SELECT
    WS_ITEM_SK, WS_ORDER_NUMBER
FROM
    web_sales
WHERE
    WS_SOLD_DATE_SK >=(
        SELECT
            MIN(D_DATE_SK)
        FROM
            date_dim
        WHERE
            D_DATE BETWEEN CAST('${param1}' AS DATE) AND CAST('${param2}' AS DATE)
    )
    AND WS_SOLD_DATE_SK <=(
        SELECT
            MAX(D_DATE_SK)
        FROM
            date_dim
        WHERE
            D_DATE BETWEEN CAST('${param1}' AS DATE) AND CAST('${param2}' AS DATE)
    );
