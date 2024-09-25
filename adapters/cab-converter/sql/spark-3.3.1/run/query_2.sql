SELECT
    s_acctbal,
    s_name,
    n_name,
    p_partkey,
    p_mfgr,
    s_address,
    s_phone,
    s_comment
FROM
    ${catalog}.${database}${stream_num}.part,
    ${catalog}.${database}${stream_num}.supplier,
    ${catalog}.${database}${stream_num}.partsupp,
    ${catalog}.${database}${stream_num}.nation,
    ${catalog}.${database}${stream_num}.region
WHERE
    p_partkey = ps_partkey
    and s_suppkey = ps_suppkey
    and p_size = ${param1}
    and p_type like '%${param2}'
    and s_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = '${param3}'
    and ps_supplycost = (
        SELECT min(ps_supplycost)
        FROM
            ${catalog}.${database}${stream_num}.partsupp, ${catalog}.${database}${stream_num}.supplier,
            ${catalog}.${database}${stream_num}.nation, ${catalog}.${database}${stream_num}.region
        WHERE
            p_partkey = ps_partkey
            and s_suppkey = ps_suppkey
            and s_nationkey = n_nationkey
            and n_regionkey = r_regionkey
            and r_name = '${param3}'
        )
ORDER BY
    s_acctbal DESC,
    n_name,
    s_name,
    p_partkey
LIMIT 100;
