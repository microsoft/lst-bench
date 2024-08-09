DELETE
FROM
    ${catalog}.${database}.inventory
WHERE
    inv_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param7}' AND '${param8}'
    )
    AND inv_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param7}' AND '${param8}'
    );

DELETE
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

DELETE
FROM
    ${catalog}.${database}.inventory
WHERE
    inv_date_sk >=(
        SELECT
            MIN( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param11}' AND '${param12}'
    )
    AND inv_date_sk <=(
        SELECT
            MAX( d_date_sk )
        FROM
            ${catalog}.${database}.date_dim
        WHERE
            d_date BETWEEN '${param11}' AND '${param12}'
    );
