select top 100 *
from (
    select avg(SS_LIST_PRICE) B1_LP,
      count(SS_LIST_PRICE) B1_CNT,
      count(distinct SS_LIST_PRICE) B1_CNTD
    from store_sales
    where SS_QUANTITY between 0 and 5
      and (
        SS_LIST_PRICE between 3 and 3 + 10
        or SS_COUPON_AMT between 4023 and 4023 + 1000
        or SS_WHOLESALE_COST between 53 and 53 + 20
      )
  ) B1,
  (
    select avg(SS_LIST_PRICE) B2_LP,
      count(SS_LIST_PRICE) B2_CNT,
      count(distinct SS_LIST_PRICE) B2_CNTD
    from store_sales
    where SS_QUANTITY between 6 and 10
      and (
        SS_LIST_PRICE between 139 and 139 + 10
        or SS_COUPON_AMT between 7945 and 7945 + 1000
        or SS_WHOLESALE_COST between 23 and 23 + 20
      )
  ) B2,
  (
    select avg(SS_LIST_PRICE) B3_LP,
      count(SS_LIST_PRICE) B3_CNT,
      count(distinct SS_LIST_PRICE) B3_CNTD
    from store_sales
    where SS_QUANTITY between 11 and 15
      and (
        SS_LIST_PRICE between 67 and 67 + 10
        or SS_COUPON_AMT between 1381 and 1381 + 1000
        or SS_WHOLESALE_COST between 67 and 67 + 20
      )
  ) B3,
  (
    select avg(SS_LIST_PRICE) B4_LP,
      count(SS_LIST_PRICE) B4_CNT,
      count(distinct SS_LIST_PRICE) B4_CNTD
    from store_sales
    where SS_QUANTITY between 16 and 20
      and (
        SS_LIST_PRICE between 103 and 103 + 10
        or SS_COUPON_AMT between 3531 and 3531 + 1000
        or SS_WHOLESALE_COST between 5 and 5 + 20
      )
  ) B4,
  (
    select avg(SS_LIST_PRICE) B5_LP,
      count(SS_LIST_PRICE) B5_CNT,
      count(distinct SS_LIST_PRICE) B5_CNTD
    from store_sales
    where SS_QUANTITY between 21 and 25
      and (
        SS_LIST_PRICE between 41 and 41 + 10
        or SS_COUPON_AMT between 4177 and 4177 + 1000
        or SS_WHOLESALE_COST between 19 and 19 + 20
      )
  ) B5,
  (
    select avg(SS_LIST_PRICE) B6_LP,
      count(SS_LIST_PRICE) B6_CNT,
      count(distinct SS_LIST_PRICE) B6_CNTD
    from store_sales
    where SS_QUANTITY between 26 and 30
      and (
        SS_LIST_PRICE between 51 and 51 + 10
        or SS_COUPON_AMT between 2207 and 2207 + 1000
        or SS_WHOLESALE_COST between 55 and 55 + 20
      )
  ) B6 option (label = 'TPCDS-Q28');