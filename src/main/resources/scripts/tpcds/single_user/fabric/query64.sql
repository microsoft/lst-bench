with cs_ui as (
       select CS_ITEM_SK,
              sum(CS_EXT_LIST_PRICE) as sale,
              sum(
                     CR_REFUNDED_CASH + CR_REVERSED_CHARGE + CR_STORE_CREDIT
              ) as refund
       from catalog_sales,
              catalog_returns
       where CS_ITEM_SK = CR_ITEM_SK
              and CS_ORDER_NUMBER = CR_ORDER_NUMBER
       group by CS_ITEM_SK
       having sum(CS_EXT_LIST_PRICE) > 2 * sum(
                     CR_REFUNDED_CASH + CR_REVERSED_CHARGE + CR_STORE_CREDIT
              )
),
cross_sales as (
       select I_PRODUCT_NAME product_name,
              I_ITEM_SK item_sk,
              S_STORE_NAME store_name,
              S_ZIP store_zip,
              ad1.CA_STREET_NUMBER b_street_number,
              ad1.CA_STREET_NAME b_street_name,
              ad1.CA_CITY b_city,
              ad1.CA_ZIP b_zip,
              ad2.CA_STREET_NUMBER c_street_number,
              ad2.CA_STREET_NAME c_street_name,
              ad2.CA_CITY c_city,
              ad2.CA_ZIP c_zip,
              d1.D_YEAR as syear,
              d2.D_YEAR as fsyear,
              d3.D_YEAR s2year,
              count(*) cnt,
              sum(SS_WHOLESALE_COST) s1,
              sum(SS_LIST_PRICE) s2,
              sum(SS_COUPON_AMT) s3
       FROM store_sales,
              store_returns,
              cs_ui,
              date_dim d1,
              date_dim d2,
              date_dim d3,
              store,
              customer,
              customer_demographics cd1,
              customer_demographics cd2,
              promotion,
              household_demographics hd1,
              household_demographics hd2,
              customer_address ad1,
              customer_address ad2,
              income_band ib1,
              income_band ib2,
              item
       WHERE SS_STORE_SK = S_STORE_SK
              AND SS_SOLD_DATE_SK = d1.D_DATE_SK
              AND SS_CUSTOMER_SK = C_CUSTOMER_SK
              AND SS_CDEMO_SK = cd1.CD_DEMO_SK
              AND SS_HDEMO_SK = hd1.HD_DEMO_SK
              AND SS_ADDR_SK = ad1.CA_ADDRESS_SK
              and SS_ITEM_SK = I_ITEM_SK
              and SS_ITEM_SK = SR_ITEM_SK
              and SS_TICKET_NUMBER = SR_TICKET_NUMBER
              and SS_ITEM_SK = cs_ui.CS_ITEM_SK
              and C_CURRENT_CDEMO_SK = cd2.CD_DEMO_SK
              AND C_CURRENT_HDEMO_SK = hd2.HD_DEMO_SK
              AND C_CURRENT_ADDR_SK = ad2.CA_ADDRESS_SK
              and C_FIRST_SALES_DATE_SK = d2.D_DATE_SK
              and C_FIRST_SHIPTO_DATE_SK = d3.D_DATE_SK
              and SS_PROMO_SK = P_PROMO_SK
              and hd1.HD_INCOME_BAND_SK = ib1.IB_INCOME_BAND_SK
              and hd2.HD_INCOME_BAND_SK = ib2.IB_INCOME_BAND_SK
              and cd1.CD_MARITAL_STATUS <> cd2.CD_MARITAL_STATUS
              and I_COLOR in (
                     'firebrick',
                     'chartreuse',
                     'plum',
                     'white',
                     'chiffon',
                     'yellow'
              )
              and I_CURRENT_PRICE between 49 and 49 + 10
              and I_CURRENT_PRICE between 49 + 1 and 49 + 15
       group by I_PRODUCT_NAME,
              I_ITEM_SK,
              S_STORE_NAME,
              S_ZIP,
              ad1.CA_STREET_NUMBER,
              ad1.CA_STREET_NAME,
              ad1.CA_CITY,
              ad1.CA_ZIP,
              ad2.CA_STREET_NUMBER,
              ad2.CA_STREET_NAME,
              ad2.CA_CITY,
              ad2.CA_ZIP,
              d1.D_YEAR,
              d2.D_YEAR,
              d3.D_YEAR
)
select cs1.product_name,
       cs1.store_name,
       cs1.store_zip,
       cs1.b_street_number,
       cs1.b_street_name,
       cs1.b_city,
       cs1.b_zip,
       cs1.c_street_number,
       cs1.c_street_name,
       cs1.c_city,
       cs1.c_zip,
       cs1.syear,
       cs1.cnt,
       cs1.s1 as s11,
       cs1.s2 as s21,
       cs1.s3 as s31,
       cs2.s1 as s12,
       cs2.s2 as s22,
       cs2.s3 as s32,
       cs2.syear,
       cs2.cnt
from cross_sales cs1,
       cross_sales cs2
where cs1.item_sk = cs2.item_sk
       and cs1.syear = 1999
       and cs2.syear = 1999 + 1
       and cs2.cnt <= cs1.cnt
       and cs1.store_name = cs2.store_name
       and cs1.store_zip = cs2.store_zip
order by cs1.product_name,
       cs1.store_name,
       cs2.cnt,
       cs1.s1,
       cs2.s1 option (label = 'TPCDS-Q64');