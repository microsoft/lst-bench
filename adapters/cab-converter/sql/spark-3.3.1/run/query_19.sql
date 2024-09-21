SELECT
    sum(l_extendedprice * (1 - l_discount) ) as revenue
FROM ${catalog}.${database}.lineitem, ${catalog}.${database}.part
WHERE
    p_partkey = l_partkey
    and (
            (
                p_brand = '${param1}'
                and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
                and l_quantity >= ${param4} and l_quantity <= ${param4} + 10
                and p_size between 1 and 5
                and l_shipmode in ('AIR', 'REG AIR')
                and l_shipinstruct = 'DELIVER IN PERSON'
            )
            or
            (
                p_brand = '${param2}'
                and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
                and l_quantity >= ${param5} and l_quantity <= ${param5} + 10
                and p_size between 1 and 10
                and l_shipmode in ('AIR', 'REG AIR')
                and l_shipinstruct = 'DELIVER IN PERSON'
            )
            or
            (
                p_partkey = l_partkey
                and p_brand = '${param3}'
                and p_container in ( 'LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
                and l_quantity >= ${param6} and l_quantity <= ${param6} + 10
                and p_size between 1 and 15
                and l_shipmode in ('AIR', 'REG AIR')
                and l_shipinstruct = 'DELIVER IN PERSON'
            )
        );
