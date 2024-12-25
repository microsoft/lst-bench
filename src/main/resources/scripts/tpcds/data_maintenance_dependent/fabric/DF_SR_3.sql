SELECT
    SR_ITEM_SK, SR_TICKET_NUMBER
FROM
    store_returns
WHERE
    SR_TICKET_NUMBER IN(
        SELECT
            SS_TICKET_NUMBER
        FROM
            store_sales,
            date_dim
        WHERE
            SS_SOLD_DATE_SK = D_DATE_SK
            AND D_DATE BETWEEN CAST('${param5}' AS DATE) AND CAST('${param6}' AS DATE)
    );
