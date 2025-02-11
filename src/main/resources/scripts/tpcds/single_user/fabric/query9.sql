select case
            when (
                  select count(*)
                  from store_sales
                  where SS_QUANTITY between 1 and 20
            ) > 24114 then (
                  select avg(SS_EXT_TAX)
                  from store_sales
                  where SS_QUANTITY between 1 and 20
            )
            else (
                  select avg(SS_NET_PROFIT)
                  from store_sales
                  where SS_QUANTITY between 1 and 20
            )
      end bucket1,
      case
            when (
                  select count(*)
                  from store_sales
                  where SS_QUANTITY between 21 and 40
            ) > 21602 then (
                  select avg(SS_EXT_TAX)
                  from store_sales
                  where SS_QUANTITY between 21 and 40
            )
            else (
                  select avg(SS_NET_PROFIT)
                  from store_sales
                  where SS_QUANTITY between 21 and 40
            )
      end bucket2,
      case
            when (
                  select count(*)
                  from store_sales
                  where SS_QUANTITY between 41 and 60
            ) > 391592 then (
                  select avg(SS_EXT_TAX)
                  from store_sales
                  where SS_QUANTITY between 41 and 60
            )
            else (
                  select avg(SS_NET_PROFIT)
                  from store_sales
                  where SS_QUANTITY between 41 and 60
            )
      end bucket3,
      case
            when (
                  select count(*)
                  from store_sales
                  where SS_QUANTITY between 61 and 80
            ) > 60278 then (
                  select avg(SS_EXT_TAX)
                  from store_sales
                  where SS_QUANTITY between 61 and 80
            )
            else (
                  select avg(SS_NET_PROFIT)
                  from store_sales
                  where SS_QUANTITY between 61 and 80
            )
      end bucket4,
      case
            when (
                  select count(*)
                  from store_sales
                  where SS_QUANTITY between 81 and 100
            ) > 384990 then (
                  select avg(SS_EXT_TAX)
                  from store_sales
                  where SS_QUANTITY between 81 and 100
            )
            else (
                  select avg(SS_NET_PROFIT)
                  from store_sales
                  where SS_QUANTITY between 81 and 100
            )
      end bucket5
from reason
where R_REASON_SK = 1 option (label = 'TPCDS-Q9');