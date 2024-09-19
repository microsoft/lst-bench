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
    ${catalog}.${database}.part,
    ${catalog}.${database}.supplier,
    ${catalog}.${database}.partsupp,
    ${catalog}.${database}.nation,
    ${catalog}.${database}.region
WHERE
    p_partkey = ps_partkey
    and s_suppkey = ps_suppkey
    and p_size = 15
    and p_type like '%BRASS'
    and s_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = 'EUROPE'
    and ps_supplycost = (
        SELECT min(ps_supplycost)
        FROM
            ${catalog}.${database}.partsupp, ${catalog}.${database}.supplier,
            ${catalog}.${database}.nation, ${catalog}.${database}.region
        WHERE
            p_partkey = ps_partkey
            and s_suppkey = ps_suppkey
            and s_nationkey = n_nationkey
            and n_regionkey = r_regionkey
            and r_name = 'EUROPE'
        )
ORDER BY
    s_acctbal DESC,
    n_name,
    s_name,
    p_partkey
LIMIT 100;
