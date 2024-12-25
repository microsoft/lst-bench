select top 100 asceding.rnk,
  i1.I_PRODUCT_NAME best_performing,
  i2.I_PRODUCT_NAME worst_performing
from(
    select *
    from (
        select item_sk,
          rank() over (
            order by rank_col asc
          ) rnk
        from (
            select SS_ITEM_SK item_sk,
              avg(SS_NET_PROFIT) rank_col
            from store_sales ss1
            where SS_STORE_SK = 22
            group by SS_ITEM_SK
            having avg(SS_NET_PROFIT) > 0.9 *(
                select avg(SS_NET_PROFIT) rank_col
                from store_sales
                where SS_STORE_SK = 22
                  and SS_CDEMO_SK is null
                group by SS_STORE_SK
              )
          ) V1
      ) V11
    where rnk < 11
  ) asceding,
  (
    select *
    from (
        select item_sk,
          rank() over (
            order by rank_col desc
          ) rnk
        from (
            select SS_ITEM_SK item_sk,
              avg(SS_NET_PROFIT) rank_col
            from store_sales ss1
            where SS_STORE_SK = 22
            group by SS_ITEM_SK
            having avg(SS_NET_PROFIT) > 0.9 *(
                select avg(SS_NET_PROFIT) rank_col
                from store_sales
                where SS_STORE_SK = 22
                  and SS_CDEMO_SK is null
                group by SS_STORE_SK
              )
          ) V2
      ) V21
    where rnk < 11
  ) descending,
  item i1,
  item i2
where asceding.rnk = descending.rnk
  and i1.I_ITEM_SK = asceding.item_sk
  and i2.I_ITEM_SK = descending.item_sk
order by asceding.rnk option (label = 'TPCDS-Q44');