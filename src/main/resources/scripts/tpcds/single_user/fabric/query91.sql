select CC_CALL_CENTER_ID Call_Center,
        CC_NAME Call_Center_Name,
        CC_MANAGER Manager,
        sum(CR_NET_LOSS) Returns_Loss
from call_center,
        catalog_returns,
        date_dim,
        customer,
        customer_address,
        customer_demographics,
        household_demographics
where CR_CALL_CENTER_SK = CC_CALL_CENTER_SK
        and CR_RETURNED_DATE_SK = D_DATE_SK
        and CR_RETURNING_CUSTOMER_SK = C_CUSTOMER_SK
        and CD_DEMO_SK = C_CURRENT_CDEMO_SK
        and HD_DEMO_SK = C_CURRENT_HDEMO_SK
        and CA_ADDRESS_SK = C_CURRENT_ADDR_SK
        and D_YEAR = 2001
        and D_MOY = 11
        and (
                (
                        CD_MARITAL_STATUS = 'M'
                        and CD_EDUCATION_STATUS = 'Unknown'
                )
                or(
                        CD_MARITAL_STATUS = 'W'
                        and CD_EDUCATION_STATUS = 'Advanced Degree'
                )
        )
        and HD_BUY_POTENTIAL like '>10000%'
        and CA_GMT_OFFSET = -6
group by CC_CALL_CENTER_ID,
        CC_NAME,
        CC_MANAGER,
        CD_MARITAL_STATUS,
        CD_EDUCATION_STATUS
order by sum(CR_NET_LOSS) desc option (label = 'TPCDS-Q91');