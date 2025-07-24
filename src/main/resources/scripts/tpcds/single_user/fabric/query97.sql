with ssci as (
  select SS_CUSTOMER_SK customer_sk,
    SS_ITEM_SK item_sk
  from store_sales,
    date_dim
  where SS_SOLD_DATE_SK = D_DATE_SK
    and D_MONTH_SEQ between 1176 and 1176 + 11
  group by SS_CUSTOMER_SK,
    SS_ITEM_SK
),
csci as(
  select CS_BILL_CUSTOMER_SK customer_sk,
    CS_ITEM_SK item_sk
  from catalog_sales,
    date_dim
  where CS_SOLD_DATE_SK = D_DATE_SK
    and D_MONTH_SEQ between 1176 and 1176 + 11
  group by CS_BILL_CUSTOMER_SK,
    CS_ITEM_SK
)
select top 100 sum(
    case
      when ssci.customer_sk is not null
      and csci.customer_sk is null then 1
      else 0
    end
  ) store_only,
  sum(
    case
      when ssci.customer_sk is null
      and csci.customer_sk is not null then 1
      else 0
    end
  ) catalog_only,
  sum(
    case
      when ssci.customer_sk is not null
      and csci.customer_sk is not null then 1
      else 0
    end
  ) store_and_catalog
from ssci
  full outer join csci on (
    ssci.customer_sk = csci.customer_sk
    and ssci.item_sk = csci.item_sk
  ) option (label = 'TPCDS-Q97');