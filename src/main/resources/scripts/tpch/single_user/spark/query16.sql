SELECT
    p_brand,
    p_type,
    p_size,
    count(distinct ps_suppkey) as supplier_cnt
FROM
    partsupp,
    part
WHERE
    p_partkey = ps_partkey
    and p_brand <> 'Brand#45'
    and p_type not like 'MEDIUM POLISHED%'
    and p_size in (49, 14, 23, 45, 19, 3, 36, 9)
    and ps_suppkey not in (
        SELECT
            s_suppkey
        FROM
            supplier
        WHERE
            s_comment like '%Customer%Complaints%'
        )
GROUP BY
    p_brand,
    p_type,
    p_size
ORDER BY
    supplier_cnt desc,
    p_brand,
    p_type,
    p_size;
