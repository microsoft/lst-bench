SELECT
    WR_ITEM_SK, WR_ORDER_NUMBER
FROM
    web_returns
WHERE
    WR_ORDER_NUMBER IN(
        SELECT
            WS_ORDER_NUMBER
        FROM
            web_sales,
            date_dim
        WHERE
            WS_SOLD_DATE_SK = D_DATE_SK
            AND D_DATE BETWEEN CAST('${param3}' AS DATE) AND CAST('${param4}' AS DATE)
    );
