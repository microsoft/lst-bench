SELECT
    p_brand,
    p_type,
    p_size,
    count(distinct ps_suppkey) as supplier_cnt
FROM
    ${catalog}.${database}${stream_num}.partsupp,
    ${catalog}.${database}${stream_num}.part
WHERE
    p_partkey = ps_partkey
    and p_brand <> '${param1}'
    and p_type not like '${param2}%'
    and p_size in (${param3}, ${param4}, ${param5}, ${param6}, ${param7}, ${param8}, ${param9}, ${param10})
    and ps_suppkey not in (
        SELECT
            s_suppkey
        FROM
            ${catalog}.${database}${stream_num}.supplier
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
