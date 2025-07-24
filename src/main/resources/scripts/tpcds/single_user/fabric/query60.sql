with ss as (
        select I_ITEM_ID,
                sum(SS_EXT_SALES_PRICE) total_sales
        from store_sales,
                date_dim,
                customer_address,
                item
        where I_ITEM_ID in (
                        select I_ITEM_ID
                        from item
                        where I_CATEGORY in ('Music')
                )
                and SS_ITEM_SK = I_ITEM_SK
                and SS_SOLD_DATE_SK = D_DATE_SK
                and D_YEAR = 2001
                and D_MOY = 8
                and SS_ADDR_SK = CA_ADDRESS_SK
                and CA_GMT_OFFSET = -6
        group by I_ITEM_ID
),
cs as (
        select I_ITEM_ID,
                sum(CS_EXT_SALES_PRICE) total_sales
        from catalog_sales,
                date_dim,
                customer_address,
                item
        where I_ITEM_ID in (
                        select I_ITEM_ID
                        from item
                        where I_CATEGORY in ('Music')
                )
                and CS_ITEM_SK = I_ITEM_SK
                and CS_SOLD_DATE_SK = D_DATE_SK
                and D_YEAR = 2001
                and D_MOY = 8
                and CS_BILL_ADDR_SK = CA_ADDRESS_SK
                and CA_GMT_OFFSET = -6
        group by I_ITEM_ID
),
ws as (
        select I_ITEM_ID,
                sum(WS_EXT_SALES_PRICE) total_sales
        from web_sales,
                date_dim,
                customer_address,
                item
        where I_ITEM_ID in (
                        select I_ITEM_ID
                        from item
                        where I_CATEGORY in ('Music')
                )
                and WS_ITEM_SK = I_ITEM_SK
                and WS_SOLD_DATE_SK = D_DATE_SK
                and D_YEAR = 2001
                and D_MOY = 8
                and WS_BILL_ADDR_SK = CA_ADDRESS_SK
                and CA_GMT_OFFSET = -6
        group by I_ITEM_ID
)
select top 100 I_ITEM_ID,
        sum(total_sales) total_sales
from (
                select *
                from ss
                union all
                select *
                from cs
                union all
                select *
                from ws
        ) tmp1
group by I_ITEM_ID
order by I_ITEM_ID,
        total_sales option (label = 'TPCDS-Q60');