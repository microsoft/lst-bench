select top 100 I_BRAND_ID brand_id,
  I_BRAND brand,
  I_MANUFACT_ID,
  I_MANUFACT,
  sum(SS_EXT_SALES_PRICE) ext_price
from date_dim,
  store_sales,
  item,
  customer,
  customer_address,
  store
where D_DATE_SK = SS_SOLD_DATE_SK
  and SS_ITEM_SK = I_ITEM_SK
  and I_MANAGER_ID = 29
  and D_MOY = 11
  and D_YEAR = 2001
  and SS_CUSTOMER_SK = C_CUSTOMER_SK
  and C_CURRENT_ADDR_SK = CA_ADDRESS_SK
  and substring(CA_ZIP, 1, 5) <> substring(S_ZIP, 1, 5)
  and SS_STORE_SK = S_STORE_SK
group by I_BRAND,
  I_BRAND_ID,
  I_MANUFACT_ID,
  I_MANUFACT
order by ext_price desc,
  I_BRAND,
  I_BRAND_ID,
  I_MANUFACT_ID,
  I_MANUFACT option (label = 'TPCDS-Q19');