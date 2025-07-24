SELECT
    SS_ITEM_SK, SS_TICKET_NUMBER
FROM
    store_sales
WHERE
    SS_SOLD_DATE_SK >=(
        SELECT
            MIN(D_DATE_SK)
        FROM
            date_dim
        WHERE
            D_DATE BETWEEN CAST('${param3}' AS DATE) AND CAST('${param4}' AS DATE)
    )
    AND SS_SOLD_DATE_SK <=(
        SELECT
            MAX(D_DATE_SK)
        FROM
            date_dim
        WHERE
            D_DATE BETWEEN CAST('${param3}' AS DATE) AND CAST('${param4}' AS DATE)
    );
