CREATE SCHEMA IF NOT EXISTS ${external_catalog}.${external_database};

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_catalog_page_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_catalog_page_${stream_num}
(
    cpag_catalog_number         integer                       ,
    cpag_catalog_page_number    integer                       ,
    cpag_department             char(20)                      ,
    cpag_id                     char(16)                      ,
    cpag_start_date             char(10)                      ,
    cpag_end_date               char(10)                      ,
    cpag_description            varchar(100)                  ,
    cpag_type                   varchar(100)                  
) with (external_location='${external_data_path}${stream_num}/s_catalog_page/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_zip_to_gmt_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_zip_to_gmt_${stream_num}
(
    zipg_zip                    char(5)                       ,
    zipg_gmt_offset             integer                       
) with (external_location='${external_data_path}${stream_num}/s_zip_to_gmt/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_purchase_lineitem_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_purchase_lineitem_${stream_num}
(
    plin_purchase_id            integer                       ,
    plin_line_number            integer                       ,
    plin_item_id                char(16)                      ,
    plin_promotion_id           char(16)                      ,
    plin_quantity               bigint                        ,
    plin_sale_price             decimal(7,2)                  ,
    plin_coupon_amt             decimal(7,2)                  ,
    plin_comment                varchar(100)                  
) with (external_location='${external_data_path}${stream_num}/s_purchase_lineitem/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_customer_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_customer_${stream_num}
(
    cust_customer_id            char(16)                      ,
    cust_salutation             char(10)                      ,
    cust_last_name              char(20)                      ,
    cust_first_name             char(20)                      ,
    cust_preffered_flag         char(1)                       ,
    cust_birth_date             char(10)                      ,
    cust_birth_country          char(20)                      ,
    cust_login_id               char(13)                      ,
    cust_email_address          char(50)                      ,
    cust_last_login_chg_date    char(10)                      ,
    cust_first_shipto_date      char(10)                      ,
    cust_first_purchase_date    char(10)                      ,
    cust_last_review_date       char(10)                      ,
    cust_primary_machine_id     char(15)                      ,
    cust_secondary_machine_id   char(15)                      ,
    cust_street_number          smallint                      ,
    cust_suite_number           char(10)                      ,
    cust_street_name1           char(30)                      ,
    cust_street_name2           char(30)                      ,
    cust_street_type            char(15)                      ,
    cust_city                   char(60)                      ,
    cust_zip                    char(10)                      ,
    cust_county                 char(30)                      ,
    cust_state                  char(2)                       ,
    cust_country                char(20)                      ,
    cust_loc_type               char(20)                      ,
    cust_gender                 char(1)                       ,
    cust_marital_status         char(1)                       ,
    cust_educ_status            char(20)                      ,
    cust_credit_rating          char(10)                      ,
    cust_purch_est              decimal(7,2)                  ,
    cust_buy_potential          char(15)                      ,
    cust_depend_cnt             smallint                      ,
    cust_depend_emp_cnt         smallint                      ,
    cust_depend_college_cnt     smallint                      ,
    cust_vehicle_cnt            smallint                      ,
    cust_annual_income          decimal(9,2)                  
) with (external_location='${external_data_path}${stream_num}/s_customer/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_customer_address_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_customer_address_${stream_num}
(
    cadr_address_id             char(16)                      ,
    cadr_street_number          integer                       ,
    cadr_street_name1           char(25)                      ,
    cadr_street_name2           char(25)                      ,
    cadr_street_type            char(15)                      ,
    cadr_suitdecimal            char(10)                      ,
    cadr_city                   char(60)                      ,
    cadr_county                 char(30)                      ,
    cadr_state                  char(2)                       ,
    cadr_zip                    char(10)                      ,
    cadr_country                char(20)                      
) with (external_location='${external_data_path}${stream_num}/s_customer_address/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_purchase_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_purchase_${stream_num}
(
    purc_purchase_id            integer                       ,
    purc_store_id               char(16)                      ,
    purc_customer_id            char(16)                      ,
    purc_purchase_date          char(10)                      ,
    purc_purchase_time          integer                       ,
    purc_register_id            integer                       ,
    purc_clerk_id               integer                       ,
    purc_comment                char(100)                     
) with (external_location='${external_data_path}${stream_num}/s_purchase/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_catalog_order_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_catalog_order_${stream_num}
(
    cord_order_id               integer                       ,
    cord_bill_customer_id       char(16)                      ,
    cord_ship_customer_id       char(16)                      ,
    cord_order_date             char(10)                      ,
    cord_order_time             integer                       ,
    cord_ship_mode_id           char(16)                      ,
    cord_call_center_id         char(16)                      ,
    cord_order_comments         varchar(100)                  
) with (external_location='${external_data_path}${stream_num}/s_catalog_order/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_web_order_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_web_order_${stream_num}
(
    word_order_id               integer                       ,
    word_bill_customer_id       char(16)                      ,
    word_ship_customer_id       char(16)                      ,
    word_order_date             char(10)                      ,
    word_order_time             integer                       ,
    word_ship_mode_id           char(16)                      ,
    word_web_site_id            char(16)                      ,
    word_order_comments         char(100)                     
) with (external_location='${external_data_path}${stream_num}/s_web_order/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_item_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_item_${stream_num}
(
    item_item_id                char(16)                      ,
    item_item_description       char(200)                     ,
    item_list_price             decimal(7,2)                  ,
    item_wholesale_cost         decimal(7,2)                  ,
    item_size                   char(20)                      ,
    item_formulation            char(20)                      ,
    item_color                  char(20)                      ,
    item_units                  char(10)                      ,
    item_container              char(10)                      ,
    item_manager_id             integer                       
) with (external_location='${external_data_path}${stream_num}/s_item/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_catalog_order_lineitem_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_catalog_order_lineitem_${stream_num}
(
    clin_order_id               integer                       ,
    clin_line_number            integer                       ,
    clin_item_id                char(16)                      ,
    clin_promotion_id           char(16)                      ,
    clin_quantity               bigint                        ,
    clin_sales_price            decimal(7,2)                  ,
    clin_coupon_amt             decimal(7,2)                  ,
    clin_warehouse_id           char(16)                      ,
    clin_ship_date              char(10)                      ,
    clin_catalog_number         integer                       ,
    clin_catalog_page_number    integer                       ,
    clin_ship_cost              decimal(7,2)                  
) with (external_location='${external_data_path}${stream_num}/s_catalog_order_lineitem/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_web_order_lineitem_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_web_order_lineitem_${stream_num}
(
    wlin_order_id               integer                       ,
    wlin_line_number            integer                       ,
    wlin_item_id                char(16)                      ,
    wlin_promotion_id           char(16)                      ,
    wlin_quantity               bigint                       ,
    wlin_sales_price            decimal(7,2)                  ,
    wlin_coupon_amt             decimal(7,2)                  ,
    wlin_warehouse_id           char(16)                      ,
    wlin_ship_date              char(10)                      ,
    wlin_ship_cost              decimal(7,2)                  ,
    wlin_web_page_id            char(16)                      
) with (external_location='${external_data_path}${stream_num}/s_web_order_lineitem/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_store_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_store_${stream_num}
(
    stor_store_id               char(16)                      ,
    stor_closed_date            char(10)                      ,
    stor_name                   char(50)                      ,
    stor_employees              integer                       ,
    stor_floor_space            integer                       ,
    stor_hours                  char(20)                      ,
    stor_store_manager          char(40)                      ,
    stor_market_id              integer                       ,
    stor_geography_class        char(100)                     ,
    stor_market_manager         char(40)                      ,
    stor_tax_percentage         decimal(5,2)                  
) with (external_location='${external_data_path}${stream_num}/s_store/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_call_center_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_call_center_${stream_num}
(
    call_center_id              char(16)                      ,
    call_open_date              char(10)                      ,
    call_closed_date            char(10)                      ,
    call_center_name            char(50)                      ,
    call_center_class           char(50)                      ,
    call_center_employees       integer                       ,
    call_center_sq_ft           integer                       ,
    call_center_hours           char(20)                      ,
    call_center_manager         char(40)                      ,
    call_center_tax_percentage  decimal(7,2)                  
) with (external_location='${external_data_path}${stream_num}/s_call_center/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_web_site_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_web_site_${stream_num}
(
    wsit_web_site_id            char(16)                      ,
    wsit_open_date              char(10)                      ,
    wsit_closed_date            char(10)                      ,
    wsit_site_name              char(50)                      ,
    wsit_site_class             char(50)                      ,
    wsit_site_manager           char(40)                      ,
    wsit_tax_percentage         decimal(5,2)                  
) with (external_location='${external_data_path}${stream_num}/s_web_site/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_warehouse_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_warehouse_${stream_num}
(
    wrhs_warehouse_id           char(16)                      ,
    wrhs_warehouse_desc         char(200)                     ,
    wrhs_warehouse_sq_ft        integer                       
) with (external_location='${external_data_path}${stream_num}/s_warehouse/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_web_page_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_web_page_${stream_num}
(
    wpag_web_page_id            char(16)                      ,
    wpag_create_date            char(10)                      ,
    wpag_access_date            char(10)                      ,
    wpag_autogen_flag           char(1)                       ,
    wpag_url                    char(100)                     ,
    wpag_type                   char(50)                      ,
    wpag_char_cnt               integer                       ,
    wpag_link_cnt               integer                       ,
    wpag_image_cnt              integer                       ,
    wpag_max_ad_cnt             integer                       
) with (external_location='${external_data_path}${stream_num}/s_web_page/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_promotion_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_promotion_${stream_num}
(
    prom_promotion_id           char(16)                      ,
    prom_promotion_name         char(30)                      ,
    prom_start_date             char(10)                      ,
    prom_end_date               char(10)                      ,
    prom_cost                   decimal(7,2)                  ,
    prom_response_target        char(1)                       ,
    prom_channel_dmail          char(1)                       ,
    prom_channel_email          char(1)                       ,
    prom_channel_catalog        char(1)                       ,
    prom_channel_tv             char(1)                       ,
    prom_channel_radio          char(1)                       ,
    prom_channel_press          char(1)                       ,
    prom_channel_event          char(1)                       ,
    prom_channel_demo           char(1)                       ,
    prom_channel_details        char(100)                     ,
    prom_purpose                char(15)                      ,
    prom_discount_active        char(1)                       ,
    prom_discount_pct           decimal(5,2)                  
) with (external_location='${external_data_path}${stream_num}/s_promotion/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_store_returns_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_store_returns_${stream_num}
(
    sret_store_id               char(16)                      ,
    sret_purchase_id            char(16)                      ,
    sret_line_number            integer                       ,
    sret_item_id                char(16)                      ,
    sret_customer_id            char(16)                      ,
    sret_return_date            char(10)                      ,
    sret_return_time            char(10)                      ,
    sret_ticket_number          char(20)                      ,
    sret_return_qty             integer                       ,
    sret_return_amt             decimal(7,2)                  ,
    sret_return_tax             decimal(7,2)                  ,
    sret_return_fee             decimal(7,2)                  ,
    sret_return_ship_cost       decimal(7,2)                  ,
    sret_refunded_cash          decimal(7,2)                  ,
    sret_reversed_charge        decimal(7,2)                  ,
    sret_store_credit           decimal(7,2)                  ,
    sret_reason_id              char(16)                      
) with (external_location='${external_data_path}${stream_num}/s_store_returns/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_catalog_returns_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_catalog_returns_${stream_num}
(
    cret_call_center_id         char(16)                      ,
    cret_order_id               integer                       ,
    cret_line_number            integer                       ,
    cret_item_id                char(16)                      ,
    cret_return_customer_id     char(16)                      ,
    cret_refund_customer_id     char(16)                      ,
    cret_return_date            char(10)                      ,
    cret_return_time            char(10)                      ,
    cret_return_qty             integer                       ,
    cret_return_amt             decimal(7,2)                  ,
    cret_return_tax             decimal(7,2)                  ,
    cret_return_fee             decimal(7,2)                  ,
    cret_return_ship_cost       decimal(7,2)                  ,
    cret_refunded_cash          decimal(7,2)                  ,
    cret_reversed_charge        decimal(7,2)                  ,
    cret_merchant_credit        decimal(7,2)                  ,
    cret_reason_id              char(16)                      ,
    cret_shipmode_id            char(16)                      ,
    cret_catalog_page_id        char(16)                      ,
    cret_warehouse_id           char(16)                      
) with (external_location='${external_data_path}${stream_num}/s_catalog_returns/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_web_returns_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_web_returns_${stream_num}
(
    wret_web_site_id            char(16)                      ,
    wret_order_id               integer                       ,
    wret_line_number            integer                       ,
    wret_item_id                char(16)                      ,
    wret_return_customer_id     char(16)                      ,
    wret_refund_customer_id     char(16)                      ,
    wret_return_date            char(10)                      ,
    wret_return_time            char(10)                      ,
    wret_return_qty             integer                       ,
    wret_return_amt             decimal(7,2)                  ,
    wret_return_tax             decimal(7,2)                  ,
    wret_return_fee             decimal(7,2)                  ,
    wret_return_ship_cost       decimal(7,2)                  ,
    wret_refunded_cash          decimal(7,2)                  ,
    wret_reversed_charge        decimal(7,2)                  ,
    wret_account_credit         decimal(7,2)                  ,
    wret_reason_id              char(16)                      
) with (external_location='${external_data_path}${stream_num}/s_web_returns/',format='TEXTFILE',textfile_field_separator='|',null_format='');

DROP TABLE IF EXISTS ${external_catalog}.${external_database}.s_inventory_${stream_num};
CREATE TABLE ${external_catalog}.${external_database}.s_inventory_${stream_num}
(
    invn_warehouse_id           char(16)                      ,
    invn_item_id                char(16)                      ,
    invn_date                   char(10)                      ,
    invn_qty_on_hand            integer                       
) with (external_location='${external_data_path}${stream_num}/s_inventory/',format='TEXTFILE',textfile_field_separator='|',null_format='');

