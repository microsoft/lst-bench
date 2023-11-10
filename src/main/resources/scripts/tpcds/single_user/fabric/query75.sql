WITH all_sales AS (
      SELECT D_YEAR,
            I_BRAND_ID,
            I_CLASS_ID,
            I_CATEGORY_ID,
            I_MANUFACT_ID,
            SUM(sales_cnt) AS sales_cnt,
            SUM(sales_amt) AS sales_amt
      FROM (
                  SELECT D_YEAR,
                        I_BRAND_ID,
                        I_CLASS_ID,
                        I_CATEGORY_ID,
                        I_MANUFACT_ID,
                        CS_QUANTITY - COALESCE(CR_RETURN_QUANTITY, 0) AS sales_cnt,
                        CS_EXT_SALES_PRICE - COALESCE(CR_RETURN_AMOUNT, 0.0) AS sales_amt
                  FROM catalog_sales
                        JOIN item ON I_ITEM_SK = CS_ITEM_SK
                        JOIN date_dim ON D_DATE_SK = CS_SOLD_DATE_SK
                        LEFT JOIN catalog_returns ON (
                              CS_ORDER_NUMBER = CR_ORDER_NUMBER
                              AND CS_ITEM_SK = CR_ITEM_SK
                        )
                  WHERE I_CATEGORY = 'Men'
                  UNION
                  SELECT D_YEAR,
                        I_BRAND_ID,
                        I_CLASS_ID,
                        I_CATEGORY_ID,
                        I_MANUFACT_ID,
                        SS_QUANTITY - COALESCE(SR_RETURN_QUANTITY, 0) AS sales_cnt,
                        SS_EXT_SALES_PRICE - COALESCE(SR_RETURN_AMT, 0.0) AS sales_amt
                  FROM store_sales
                        JOIN item ON I_ITEM_SK = SS_ITEM_SK
                        JOIN date_dim ON D_DATE_SK = SS_SOLD_DATE_SK
                        LEFT JOIN store_returns ON (
                              SS_TICKET_NUMBER = SR_TICKET_NUMBER
                              AND SS_ITEM_SK = SR_ITEM_SK
                        )
                  WHERE I_CATEGORY = 'Men'
                  UNION
                  SELECT D_YEAR,
                        I_BRAND_ID,
                        I_CLASS_ID,
                        I_CATEGORY_ID,
                        I_MANUFACT_ID,
                        WS_QUANTITY - COALESCE(WR_RETURN_QUANTITY, 0) AS sales_cnt,
                        WS_EXT_SALES_PRICE - COALESCE(WR_RETURN_AMT, 0.0) AS sales_amt
                  FROM web_sales
                        JOIN item ON I_ITEM_SK = WS_ITEM_SK
                        JOIN date_dim ON D_DATE_SK = WS_SOLD_DATE_SK
                        LEFT JOIN web_returns ON (
                              WS_ORDER_NUMBER = WR_ORDER_NUMBER
                              AND WS_ITEM_SK = WR_ITEM_SK
                        )
                  WHERE I_CATEGORY = 'Men'
            ) sales_detail
      GROUP BY D_YEAR,
            I_BRAND_ID,
            I_CLASS_ID,
            I_CATEGORY_ID,
            I_MANUFACT_ID
)
SELECT top 100 prev_yr.D_YEAR AS prev_year,
      curr_yr.D_YEAR AS year,
      curr_yr.I_BRAND_ID,
      curr_yr.I_CLASS_ID,
      curr_yr.I_CATEGORY_ID,
      curr_yr.I_MANUFACT_ID,
      prev_yr.sales_cnt AS prev_yr_cnt,
      curr_yr.sales_cnt AS curr_yr_cnt,
      curr_yr.sales_cnt - prev_yr.sales_cnt AS sales_cnt_diff,
      curr_yr.sales_amt - prev_yr.sales_amt AS sales_amt_diff
FROM all_sales curr_yr,
      all_sales prev_yr
WHERE curr_yr.I_BRAND_ID = prev_yr.I_BRAND_ID
      AND curr_yr.I_CLASS_ID = prev_yr.I_CLASS_ID
      AND curr_yr.I_CATEGORY_ID = prev_yr.I_CATEGORY_ID
      AND curr_yr.I_MANUFACT_ID = prev_yr.I_MANUFACT_ID
      AND curr_yr.D_YEAR = 2001
      AND prev_yr.D_YEAR = 2001 -1
      AND CAST(curr_yr.sales_cnt AS DECIMAL(17, 2)) / CAST(prev_yr.sales_cnt AS DECIMAL(17, 2)) < 0.9
ORDER BY sales_cnt_diff,
      sales_amt_diff option (label = 'TPCDS-Q75');