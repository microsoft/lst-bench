with customer_total_return as (
    select SR_CUSTOMER_SK as ctr_customer_sk,
        SR_STORE_SK as ctr_store_sk,
        sum(SR_RETURN_AMT) as ctr_total_return
    from store_returns,
        date_dim
    where SR_RETURNED_DATE_SK = D_DATE_SK
        and D_YEAR = 1999
    group by SR_CUSTOMER_SK,
        SR_STORE_SK
)
select top 100 C_CUSTOMER_ID
from customer_total_return ctr1,
    store,
    customer
where ctr1.ctr_total_return > (
        select avg(ctr_total_return) * 1.2
        from customer_total_return ctr2
        where ctr1.ctr_store_sk = ctr2.ctr_store_sk
    )
    and S_STORE_SK = ctr1.ctr_store_sk
    and S_STATE = 'TN'
    and ctr1.ctr_customer_sk = C_CUSTOMER_SK
order by C_CUSTOMER_ID option (label = 'TPCDS-Q1');