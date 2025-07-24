select top 100 I_ITEM_ID,
        CA_COUNTRY,
        CA_STATE,
        CA_COUNTY,
        avg(cast(CS_QUANTITY as decimal(12, 2))) agg1,
        avg(cast(CS_LIST_PRICE as decimal(12, 2))) agg2,
        avg(cast(CS_COUPON_AMT as decimal(12, 2))) agg3,
        avg(cast(CS_SALES_PRICE as decimal(12, 2))) agg4,
        avg(cast(CS_NET_PROFIT as decimal(12, 2))) agg5,
        avg(cast(C_BIRTH_YEAR as decimal(12, 2))) agg6,
        avg(cast(cd1.CD_DEP_COUNT as decimal(12, 2))) agg7
from catalog_sales,
        customer_demographics cd1,
        customer_demographics cd2,
        customer,
        customer_address,
        date_dim,
        item
where CS_SOLD_DATE_SK = D_DATE_SK
        and CS_ITEM_SK = I_ITEM_SK
        and CS_BILL_CDEMO_SK = cd1.CD_DEMO_SK
        and CS_BILL_CUSTOMER_SK = C_CUSTOMER_SK
        and cd1.CD_GENDER = 'M'
        and cd1.CD_EDUCATION_STATUS = '4 yr Degree'
        and C_CURRENT_CDEMO_SK = cd2.CD_DEMO_SK
        and C_CURRENT_ADDR_SK = CA_ADDRESS_SK
        and C_BIRTH_MONTH in (10, 2, 2, 8, 4, 4)
        and D_YEAR = 2002
        and CA_STATE in (
                'MO',
                'OK',
                'GA',
                'MD',
                'KY',
                'OR',
                'MT'
        )
group by rollup (I_ITEM_ID, CA_COUNTRY, CA_STATE, CA_COUNTY)
order by CA_COUNTRY,
        CA_STATE,
        CA_COUNTY,
        I_ITEM_ID option (label = 'TPCDS-Q18');