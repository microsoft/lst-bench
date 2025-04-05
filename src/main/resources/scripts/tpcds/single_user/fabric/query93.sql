select top 100 SS_CUSTOMER_SK,
      sum(act_sales) sumsales
from (
            select SS_ITEM_SK,
                  SS_TICKET_NUMBER,
                  SS_CUSTOMER_SK,
case
                        when SR_RETURN_QUANTITY is not null then (SS_QUANTITY - SR_RETURN_QUANTITY) * SS_SALES_PRICE
                        else (SS_QUANTITY * SS_SALES_PRICE)
                  end act_sales
            from store_sales
                  left outer join store_returns on (
                        SR_ITEM_SK = SS_ITEM_SK
                        and SR_TICKET_NUMBER = SS_TICKET_NUMBER
                  ),
                  reason
            where SR_REASON_SK = R_REASON_SK
                  and R_REASON_DESC = 'reason 43'
      ) t
group by SS_CUSTOMER_SK
order by sumsales,
      SS_CUSTOMER_SK option (label = 'TPCDS-Q93');