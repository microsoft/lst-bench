select top 100 sum(SS_NET_PROFIT) as total_sum,
  S_STATE,
  S_COUNTY,
  grouping(S_STATE) + grouping(S_COUNTY) as lochierarchy,
  rank() over (
    partition by grouping(S_STATE) + grouping(S_COUNTY),
    case
      when grouping(S_COUNTY) = 0 then S_STATE
    end
    order by sum(SS_NET_PROFIT) desc
  ) as rank_within_parent
from store_sales,
  date_dim d1,
  store
where d1.D_MONTH_SEQ between 1176 and 1176 + 11
  and d1.D_DATE_SK = SS_SOLD_DATE_SK
  and S_STORE_SK = SS_STORE_SK
  and S_STATE in (
    select S_STATE
    from (
        select S_STATE as S_STATE,
          rank() over (
            partition by S_STATE
            order by sum(SS_NET_PROFIT) desc
          ) as ranking
        from store_sales,
          store,
          date_dim
        where D_MONTH_SEQ between 1176 and 1176 + 11
          and D_DATE_SK = SS_SOLD_DATE_SK
          and S_STORE_SK = SS_STORE_SK
        group by S_STATE
      ) tmp1
    where ranking <= 5
  )
group by rollup(S_STATE, S_COUNTY)
order by lochierarchy desc,
case
    when grouping(S_STATE) + grouping(S_COUNTY) = 0 then S_STATE
  end,
  rank_within_parent option (label = 'TPCDS-Q70');