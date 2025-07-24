select top 100 substring(R_REASON_DESC, 1, 20),
        avg(WS_QUANTITY),
        avg(WR_REFUNDED_CASH),
        avg(WR_FEE)
from web_sales,
        web_returns,
        web_page,
        customer_demographics cd1,
        customer_demographics cd2,
        customer_address,
        date_dim,
        reason
where WS_WEB_PAGE_SK = WP_WEB_PAGE_SK
        and WS_ITEM_SK = WR_ITEM_SK
        and WS_ORDER_NUMBER = WR_ORDER_NUMBER
        and WS_SOLD_DATE_SK = D_DATE_SK
        and D_YEAR = 2000
        and cd1.CD_DEMO_SK = WR_REFUNDED_CDEMO_SK
        and cd2.CD_DEMO_SK = WR_RETURNING_CDEMO_SK
        and CA_ADDRESS_SK = WR_REFUNDED_ADDR_SK
        and R_REASON_SK = WR_REASON_SK
        and (
                (
                        cd1.CD_MARITAL_STATUS = 'U'
                        and cd1.CD_MARITAL_STATUS = cd2.CD_MARITAL_STATUS
                        and cd1.CD_EDUCATION_STATUS = 'Advanced Degree'
                        and cd1.CD_EDUCATION_STATUS = cd2.CD_EDUCATION_STATUS
                        and WS_SALES_PRICE between 100.00 and 150.00
                )
                or (
                        cd1.CD_MARITAL_STATUS = 'D'
                        and cd1.CD_MARITAL_STATUS = cd2.CD_MARITAL_STATUS
                        and cd1.CD_EDUCATION_STATUS = 'Unknown'
                        and cd1.CD_EDUCATION_STATUS = cd2.CD_EDUCATION_STATUS
                        and WS_SALES_PRICE between 50.00 and 100.00
                )
                or (
                        cd1.CD_MARITAL_STATUS = 'M'
                        and cd1.CD_MARITAL_STATUS = cd2.CD_MARITAL_STATUS
                        and cd1.CD_EDUCATION_STATUS = 'Secondary'
                        and cd1.CD_EDUCATION_STATUS = cd2.CD_EDUCATION_STATUS
                        and WS_SALES_PRICE between 150.00 and 200.00
                )
        )
        and (
                (
                        CA_COUNTRY = 'United States'
                        and CA_STATE in ('OH', 'AR', 'WI')
                        and WS_NET_PROFIT between 100 and 200
                )
                or (
                        CA_COUNTRY = 'United States'
                        and CA_STATE in ('AL', 'CO', 'IA')
                        and WS_NET_PROFIT between 150 and 300
                )
                or (
                        CA_COUNTRY = 'United States'
                        and CA_STATE in ('IN', 'PA', 'KS')
                        and WS_NET_PROFIT between 50 and 250
                )
        )
group by R_REASON_DESC
order by substring(R_REASON_DESC, 1, 20),
        avg(WS_QUANTITY),
        avg(WR_REFUNDED_CASH),
        avg(WR_FEE) option (label = 'TPCDS-Q85');