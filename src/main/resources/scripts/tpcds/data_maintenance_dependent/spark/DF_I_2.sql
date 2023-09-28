SELECT
    inv_date_sk, inv_item_sk, inv_warehouse_sk
FROM
    ${catalog}.${database}.inventory
WHERE
    inv_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param9}' AND '${param10}'
    )
    AND inv_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param9}' AND '${param10}'
    );