with ssales as (
        select C_LAST_NAME,
                C_FIRST_NAME,
                S_STORE_NAME,
                CA_STATE,
                S_STATE,
                I_COLOR,
                I_CURRENT_PRICE,
                I_MANAGER_ID,
                I_UNITS,
                I_SIZE,
                sum(SS_EXT_SALES_PRICE) netpaid
        from store_sales,
                store_returns,
                store,
                item,
                customer,
                customer_address
        where SS_TICKET_NUMBER = SR_TICKET_NUMBER
                and SS_ITEM_SK = SR_ITEM_SK
                and SS_CUSTOMER_SK = C_CUSTOMER_SK
                and SS_ITEM_SK = I_ITEM_SK
                and SS_STORE_SK = S_STORE_SK
                and C_CURRENT_ADDR_SK = CA_ADDRESS_SK
                and C_BIRTH_COUNTRY <> upper(CA_COUNTRY)
                and S_ZIP = CA_ZIP
                and S_MARKET_ID = 8
        group by C_LAST_NAME,
                C_FIRST_NAME,
                S_STORE_NAME,
                CA_STATE,
                S_STATE,
                I_COLOR,
                I_CURRENT_PRICE,
                I_MANAGER_ID,
                I_UNITS,
                I_SIZE
)
select C_LAST_NAME,
        C_FIRST_NAME,
        S_STORE_NAME,
        sum(netpaid) paid
from ssales
where I_COLOR = 'forest'
group by C_LAST_NAME,
        C_FIRST_NAME,
        S_STORE_NAME
having sum(netpaid) > (
                select 0.05 * avg(netpaid)
                from ssales
        )
order by C_LAST_NAME,
        C_FIRST_NAME,
        S_STORE_NAME option (label = 'TPCDS-Q24a');