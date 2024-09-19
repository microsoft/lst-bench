DROP
    VIEW IF EXISTS ${external_catalog}.${external_database}.csv_${stream_num};

CREATE
    VIEW ${external_catalog}.${external_database}.csv_${stream_num} AS SELECT
        d1.d_date_sk cs_sold_date_sk,
        t_time_sk cs_sold_time_sk,
        d2.d_date_sk cs_ship_date_sk,
        c1.c_customer_sk cs_bill_customer_sk,
        c1.c_current_cdemo_sk cs_bill_cdemo_sk,
        c1.c_current_hdemo_sk cs_bill_hdemo_sk,
        c1.c_current_addr_sk cs_bill_addr_sk,
        c2.c_customer_sk cs_ship_customer_sk,
        c2.c_current_cdemo_sk cs_ship_cdemo_sk,
        c2.c_current_hdemo_sk cs_ship_hdemo_sk,
        c2.c_current_addr_sk cs_ship_addr_sk,
        cc_call_center_sk cs_call_center_sk,
        cp_catalog_page_sk cs_catalog_page_sk,
        sm_ship_mode_sk cs_ship_mode_sk,
        w_warehouse_sk cs_warehouse_sk,
        i_item_sk cs_item_sk,
        p_promo_sk cs_promo_sk,
        cord_order_id cs_order_number,
        clin_quantity cs_quantity,
        i_wholesale_cost cs_wholesale_cost,
        i_current_price cs_list_price,
        clin_sales_price cs_sales_price,
        (
            i_current_price - clin_sales_price
        )* clin_quantity cs_ext_discount_amt,
        clin_sales_price * clin_quantity cs_ext_sales_price,
        i_wholesale_cost * clin_quantity cs_ext_wholesale_cost,
        i_current_price * clin_quantity CS_EXT_LIST_PRICE,
        i_current_price * cc_tax_percentage CS_EXT_TAX,
        clin_coupon_amt cs_coupon_amt,
        clin_ship_cost * clin_quantity CS_EXT_SHIP_COST,
        (
            clin_sales_price * clin_quantity
        )- clin_coupon_amt cs_net_paid,
        (
            (
                clin_sales_price * clin_quantity
            )- clin_coupon_amt
        )*(
            1 + cc_tax_percentage
        ) cs_net_paid_inc_tax,
        (
            clin_sales_price * clin_quantity
        )- clin_coupon_amt +(
            clin_ship_cost * clin_quantity
        ) CS_NET_PAID_INC_SHIP,
        (
            clin_sales_price * clin_quantity
        )- clin_coupon_amt +(
            clin_ship_cost * clin_quantity
        )+ i_current_price * cc_tax_percentage CS_NET_PAID_INC_SHIP_TAX,
        (
            (
                clin_sales_price * clin_quantity
            )- clin_coupon_amt
        )-(clin_quantity*i_wholesale_cost) cs_net_profit
    FROM
        ${external_catalog}.${external_database}.s_catalog_order_${stream_num}
    LEFT OUTER JOIN ${catalog}.${database}.date_dim d1 ON
        (
            CAST(
                cord_order_date AS DATE
            )= d1.d_date
        )
    LEFT OUTER JOIN ${catalog}.${database}.time_dim ON
        (
            cord_order_time = t_time
        )
    LEFT OUTER JOIN ${catalog}.${database}.customer c1 ON
        (
            cord_bill_customer_id = c1.c_customer_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.customer c2 ON
        (
            cord_ship_customer_id = c2.c_customer_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.call_center ON
        (
            cord_call_center_id = cc_call_center_id
            AND cc_rec_end_date IS NULL
        )
    LEFT OUTER JOIN ${catalog}.${database}.ship_mode ON
        (
            cord_ship_mode_id = sm_ship_mode_id
        )
    JOIN ${external_catalog}.${external_database}.s_catalog_order_lineitem_${stream_num} ON
        (
            cord_order_id = clin_order_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.date_dim d2 ON
        (
            CAST(
                clin_ship_date AS DATE
            )= d2.d_date
        )
    LEFT OUTER JOIN ${catalog}.${database}.catalog_page ON
        (
            clin_catalog_page_number = cp_catalog_page_number
            AND clin_catalog_number = cp_catalog_number
        )
    LEFT OUTER JOIN ${catalog}.${database}.warehouse ON
        (
            clin_warehouse_id = w_warehouse_id
        )
    LEFT OUTER JOIN ${catalog}.${database}.item ON
        (
            clin_item_id = i_item_id
            AND i_rec_end_date IS NULL
        )
    LEFT OUTER JOIN ${catalog}.${database}.promotion ON
        (
            clin_promotion_id = p_promo_id
        );

INSERT
    INTO
        ${catalog}.${database}.catalog_sales SELECT
            cs_sold_date_sk,
            cs_sold_time_sk,
            cs_ship_date_sk,
            cs_bill_customer_sk,
            cs_bill_cdemo_sk,
            cs_bill_hdemo_sk,
            cs_bill_addr_sk,
            cs_ship_customer_sk,
            cs_ship_cdemo_sk,
            cs_ship_hdemo_sk,
            cs_ship_addr_sk,
            cs_call_center_sk,
            cs_catalog_page_sk,
            cs_ship_mode_sk,
            cs_warehouse_sk,
            cs_item_sk,
            cs_promo_sk,
            cs_order_number,
            cs_quantity,
            cs_wholesale_cost,
            cs_list_price,
            cs_sales_price,
            cs_ext_discount_amt,
            cs_ext_sales_price,
            cs_ext_wholesale_cost,
            cs_ext_list_price,
            cs_ext_tax,
            cs_coupon_amt,
            cs_ext_ship_cost,
            cs_net_paid,
            cs_net_paid_inc_tax,
            cs_net_paid_inc_ship,
            cs_net_paid_inc_ship_tax,
            cs_net_profit
        FROM
            ${external_catalog}.${external_database}.csv_${stream_num};
