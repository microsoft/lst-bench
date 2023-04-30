WITH inv AS(
    SELECT
        w_warehouse_name,
        w_warehouse_sk,
        i_item_sk,
        d_moy,
        stdev,
        mean,
        CASE
            mean
            WHEN 0 THEN NULL
            ELSE stdev / mean
        END cov
    FROM
        (
            SELECT
                w_warehouse_name,
                w_warehouse_sk,
                i_item_sk,
                d_moy,
                STDDEV_SAMP(inv_quantity_on_hand) stdev,
                AVG( inv_quantity_on_hand ) mean
            FROM
                ${catalog}.${database}.inventory ${asof},
                ${catalog}.${database}.item,
                ${catalog}.${database}.warehouse,
                ${catalog}.${database}.date_dim
            WHERE
                inv_item_sk = i_item_sk
                AND inv_warehouse_sk = w_warehouse_sk
                AND inv_date_sk = d_date_sk
                AND d_year = 2001
            GROUP BY
                w_warehouse_name,
                w_warehouse_sk,
                i_item_sk,
                d_moy
        ) foo
    WHERE
        CASE
            mean
            WHEN 0 THEN 0
            ELSE stdev / mean
        END > 1
) SELECT
    inv1.w_warehouse_sk AS ` inv1 w_warehouse_sk `,
    inv1.i_item_sk AS ` inv1.i_item_sk `,
    inv1.d_moy AS ` inv1.d_moy `,
    inv1.mean AS ` inv1.mean `,
    inv1.cov ` inv1.cov `,
    inv2.w_warehouse_sk AS ` inv2.w_warehouse_sk `,
    inv2.i_item_sk ` inv2.i_item_sk `,
    inv2.d_moy ` inv2.d_moy `,
    inv2.mean ` inv2.mean `,
    inv2.cov ` inv2.cov `
FROM
    inv inv1,
    inv inv2
WHERE
    inv1.i_item_sk = inv2.i_item_sk
    AND inv1.w_warehouse_sk = inv2.w_warehouse_sk
    AND inv1.d_moy = 1
    AND inv2.d_moy = 1 + 1
ORDER BY
    inv1.w_warehouse_sk,
    inv1.i_item_sk,
    inv1.d_moy,
    inv1.mean,
    inv1.cov,
    inv2.d_moy,
    inv2.mean,
    inv2.cov;

WITH inv AS(
    SELECT
        w_warehouse_name,
        w_warehouse_sk,
        i_item_sk,
        d_moy,
        stdev,
        mean,
        CASE
            mean
            WHEN 0 THEN NULL
            ELSE stdev / mean
        END cov
    FROM
        (
            SELECT
                w_warehouse_name,
                w_warehouse_sk,
                i_item_sk,
                d_moy,
                STDDEV_SAMP(inv_quantity_on_hand) stdev,
                AVG( inv_quantity_on_hand ) mean
            FROM
                ${catalog}.${database}.inventory ${asof},
                ${catalog}.${database}.item,
                ${catalog}.${database}.warehouse,
                ${catalog}.${database}.date_dim
            WHERE
                inv_item_sk = i_item_sk
                AND inv_warehouse_sk = w_warehouse_sk
                AND inv_date_sk = d_date_sk
                AND d_year = 2001
            GROUP BY
                w_warehouse_name,
                w_warehouse_sk,
                i_item_sk,
                d_moy
        ) foo
    WHERE
        CASE
            mean
            WHEN 0 THEN 0
            ELSE stdev / mean
        END > 1
) SELECT
    inv1.w_warehouse_sk AS ` inv1.w_warehouse_sk `,
    inv1.i_item_sk AS ` inv1.i_item_sk `,
    inv1.d_moy ` inv1.d_moy `,
    inv1.mean AS ` inv1.mean `,
    inv1.cov AS ` inv1.cov `,
    inv2.w_warehouse_sk AS ` inv2.w_warehouse_sk `,
    inv2.i_item_sk AS ` inv2.i_item_sk `,
    inv2.d_moy AS ` inv2.d_moy `,
    inv2.mean AS ` inv2.mean `,
    inv2.cov AS ` inv2.cov `
FROM
    inv inv1,
    inv inv2
WHERE
    inv1.i_item_sk = inv2.i_item_sk
    AND inv1.w_warehouse_sk = inv2.w_warehouse_sk
    AND inv1.d_moy = 1
    AND inv2.d_moy = 1 + 1
    AND inv1.cov > 1.5
ORDER BY
    inv1.w_warehouse_sk,
    inv1.i_item_sk,
    inv1.d_moy,
    inv1.mean,
    inv1.cov,
    inv2.d_moy,
    inv2.mean,
    inv2.cov;
