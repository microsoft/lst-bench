select top 100 I_PRODUCT_NAME,
    I_BRAND,
    I_CLASS,
    I_CATEGORY,
    avg(cast(INV_QUANTITY_ON_HAND as bigint)) qoh
from inventory,
    date_dim,
    item
where INV_DATE_SK = D_DATE_SK
    and INV_ITEM_SK = I_ITEM_SK
    and D_MONTH_SEQ between 1176 and 1176 + 11
group by rollup(
        I_PRODUCT_NAME,
        I_BRAND,
        I_CLASS,
        I_CATEGORY
    )
order by qoh,
    I_PRODUCT_NAME,
    I_BRAND,
    I_CLASS,
    I_CATEGORY option (label = 'TPCDS-Q22');