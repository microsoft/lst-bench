drop view if exists ${external_catalog}.${external_database}.ssv_${stream_num};

CREATE VIEW ${external_catalog}.${external_database}.ssv_${stream_num}
AS SELECT d_date_sk ss_sold_date_sk,
t_time_sk ss_sold_time_sk,
i_item_sk ss_item_sk,
c_customer_sk ss_customer_sk,
c_current_cdemo_sk ss_cdemo_sk,
c_current_hdemo_sk ss_hdemo_sk,
c_current_addr_sk ss_addr_sk,
s_store_sk ss_store_sk,
p_promo_sk ss_promo_sk,
purc_purchase_id ss_ticket_number,
plin_quantity ss_quantity,
try_cast(i_wholesale_cost as decimal(7,2)) ss_wholesale_cost,
try_cast(i_current_price as decimal(7,2)) ss_list_price,
try_cast(plin_sale_price as decimal(7,2)) ss_sales_price,
try_cast((i_current_price-plin_sale_price)*plin_quantity as decimal(7,2)) ss_ext_discount_amt,
try_cast(plin_sale_price * plin_quantity as decimal(7,2)) ss_ext_sales_price,
try_cast(i_wholesale_cost * plin_quantity as decimal(7,2)) ss_ext_wholesale_cost,
try_cast(i_current_price * plin_quantity as decimal(7,2)) ss_ext_list_price,
try_cast(i_current_price * s_tax_precentage as decimal(7,2)) ss_ext_tax,
try_cast(plin_coupon_amt as decimal(7,2)) ss_coupon_amt,
try_cast((plin_sale_price * plin_quantity)-plin_coupon_amt as decimal(7,2)) ss_net_paid,
try_cast(((plin_sale_price * plin_quantity)-plin_coupon_amt)*(1+s_tax_precentage) as decimal(7,2)) ss_net_paid_inc_tax,
try_cast(((plin_sale_price * plin_quantity)-plin_coupon_amt)-(plin_quantity*i_wholesale_cost) as decimal(7,2)) ss_net_profit
FROM
${external_catalog}.${external_database}.s_purchase_${stream_num}
LEFT OUTER JOIN ${catalog}.${database}.customer ON (purc_customer_id = c_customer_id)
LEFT OUTER JOIN ${catalog}.${database}.store ON (purc_store_id = s_store_id)
LEFT OUTER JOIN ${catalog}.${database}.date_dim ON (cast(cast(purc_purchase_date as varchar) as date) = d_date)
LEFT OUTER JOIN ${catalog}.${database}.time_dim ON (PURC_PURCHASE_TIME = t_time)
JOIN ${external_catalog}.${external_database}.s_purchase_lineitem_${stream_num} ON (purc_purchase_id = plin_purchase_id)
LEFT OUTER JOIN ${catalog}.${database}.promotion ON plin_promotion_id = p_promo_id
LEFT OUTER JOIN ${catalog}.${database}.item ON plin_item_id = i_item_id
WHERE
purc_purchase_id = plin_purchase_id
AND i_rec_end_date is NULL
AND s_rec_end_date is NULL;

insert into ${catalog}.${database}.store_sales select
ss_sold_time_sk,ss_item_sk,ss_customer_sk,ss_cdemo_sk,ss_hdemo_sk,ss_addr_sk,ss_store_sk,ss_promo_sk,ss_ticket_number,ss_quantity,ss_wholesale_cost,ss_list_price,ss_sales_price,ss_ext_discount_amt,ss_ext_sales_price,ss_ext_wholesale_cost,ss_ext_list_price,ss_ext_tax,ss_coupon_amt,ss_net_paid,ss_net_paid_inc_tax,ss_net_profit,ss_sold_date_sk
from ${external_catalog}.${external_database}.ssv_${stream_num};
