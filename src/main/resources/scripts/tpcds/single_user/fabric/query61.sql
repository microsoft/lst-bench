select top 100 promotions,
     total,
     cast(promotions as decimal(15, 4)) / cast(total as decimal(15, 4)) * 100
from (
          select sum(SS_EXT_SALES_PRICE) promotions
          from store_sales,
               store,
               promotion,
               date_dim,
               customer,
               customer_address,
               item
          where SS_SOLD_DATE_SK = D_DATE_SK
               and SS_STORE_SK = S_STORE_SK
               and SS_PROMO_SK = P_PROMO_SK
               and SS_CUSTOMER_SK = C_CUSTOMER_SK
               and CA_ADDRESS_SK = C_CURRENT_ADDR_SK
               and SS_ITEM_SK = I_ITEM_SK
               and CA_GMT_OFFSET = -7
               and I_CATEGORY = 'Electronics'
               and (
                    P_CHANNEL_DMAIL = 'Y'
                    or P_CHANNEL_EMAIL = 'Y'
                    or P_CHANNEL_TV = 'Y'
               )
               and S_GMT_OFFSET = -7
               and D_YEAR = 2001
               and D_MOY = 11
     ) promotional_sales,
     (
          select sum(SS_EXT_SALES_PRICE) total
          from store_sales,
               store,
               date_dim,
               customer,
               customer_address,
               item
          where SS_SOLD_DATE_SK = D_DATE_SK
               and SS_STORE_SK = S_STORE_SK
               and SS_CUSTOMER_SK = C_CUSTOMER_SK
               and CA_ADDRESS_SK = C_CURRENT_ADDR_SK
               and SS_ITEM_SK = I_ITEM_SK
               and CA_GMT_OFFSET = -7
               and I_CATEGORY = 'Electronics'
               and S_GMT_OFFSET = -7
               and D_YEAR = 2001
               and D_MOY = 11
     ) all_sales
order by promotions,
     total option (label = 'TPCDS-Q61');