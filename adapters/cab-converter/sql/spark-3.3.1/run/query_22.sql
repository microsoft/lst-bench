select
    cntrycode,
    count(*) as numcust,
    sum(c_acctbal) as totacctbal
from (
    select
        substring(c_phone, 1, 2) as cntrycode,
        c_acctbal
    from
        ${catalog}.${database}.customer
    where
        substring(c_phone, 1, 2) in ('${param1}', '${param2}', '${param3}', '${param4}', '${param5}', '${param6}', '${param7}')
        and c_acctbal > (
            select
                avg(c_acctbal)
            from
                ${catalog}.${database}.customer
            where
                c_acctbal > 0.00
                and substring (c_phone from 1 for 2) in ('${param1}', '${param2}', '${param3}', '${param4}', '${param5}', '${param6}', '${param7}')
            )
        and not exists (
            select
                *
            from
                ${catalog}.${database}.orders
            where
                o_custkey = c_custkey
        )
    ) as custsale
group by
    cntrycode
order by
    cntrycode;
