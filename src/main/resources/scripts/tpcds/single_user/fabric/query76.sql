select top 100 channel,
  col_name,
  D_YEAR,
  D_QOY,
  I_CATEGORY,
  COUNT(*) sales_cnt,
  SUM(ext_sales_price) sales_amt
FROM (
    SELECT 'store' as channel,
      'SS_CDEMO_SK' col_name,
      D_YEAR,
      D_QOY,
      I_CATEGORY,
      SS_EXT_SALES_PRICE ext_sales_price
    FROM store_sales,
      item,
      date_dim
    WHERE SS_CDEMO_SK IS NULL
      AND SS_SOLD_DATE_SK = D_DATE_SK
      AND SS_ITEM_SK = I_ITEM_SK
    UNION ALL
    SELECT 'web' as channel,
      'WS_SHIP_ADDR_SK' col_name,
      D_YEAR,
      D_QOY,
      I_CATEGORY,
      WS_EXT_SALES_PRICE ext_sales_price
    FROM web_sales,
      item,
      date_dim
    WHERE WS_SHIP_ADDR_SK IS NULL
      AND WS_SOLD_DATE_SK = D_DATE_SK
      AND WS_ITEM_SK = I_ITEM_SK
    UNION ALL
    SELECT 'catalog' as channel,
      'CS_BILL_CUSTOMER_SK' col_name,
      D_YEAR,
      D_QOY,
      I_CATEGORY,
      CS_EXT_SALES_PRICE ext_sales_price
    FROM catalog_sales,
      item,
      date_dim
    WHERE CS_BILL_CUSTOMER_SK IS NULL
      AND CS_SOLD_DATE_SK = D_DATE_SK
      AND CS_ITEM_SK = I_ITEM_SK
  ) foo
GROUP BY channel,
  col_name,
  D_YEAR,
  D_QOY,
  I_CATEGORY
ORDER BY channel,
  col_name,
  D_YEAR,
  D_QOY,
  I_CATEGORY option (label = 'TPCDS-Q76');