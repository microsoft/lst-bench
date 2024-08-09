CREATE
    SCHEMA IF NOT EXISTS ${external_catalog}.${external_database};

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_catalog_page_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_catalog_page_${stream_num}(
            cpag_catalog_number INTEGER,
            cpag_catalog_page_number INTEGER,
            cpag_department CHAR(20),
            cpag_id CHAR(16),
            cpag_start_date CHAR(10),
            cpag_end_date CHAR(10),
            cpag_description VARCHAR(100),
            cpag_type VARCHAR(100)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_zip_to_gmt_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_zip_to_gmt_${stream_num}(
            zipg_zip CHAR(5),
            zipg_gmt_offset INTEGER
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_purchase_lineitem_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_purchase_lineitem_${stream_num}(
            plin_purchase_id INTEGER,
            plin_line_number INTEGER,
            plin_item_id CHAR(16),
            plin_promotion_id CHAR(16),
            plin_quantity BIGINT,
            plin_sale_price DECIMAL(
                7,
                2
            ),
            plin_coupon_amt DECIMAL(
                7,
                2
            ),
            plin_comment VARCHAR(100)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_customer_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_customer_${stream_num}(
            cust_customer_id CHAR(16),
            cust_salutation CHAR(10),
            cust_last_name CHAR(20),
            cust_first_name CHAR(20),
            cust_preffered_flag CHAR(1),
            cust_birth_date CHAR(10),
            cust_birth_country CHAR(20),
            cust_login_id CHAR(13),
            cust_email_address CHAR(50),
            cust_last_login_chg_date CHAR(10),
            cust_first_shipto_date CHAR(10),
            cust_first_purchase_date CHAR(10),
            cust_last_review_date CHAR(10),
            cust_primary_machine_id CHAR(15),
            cust_secondary_machine_id CHAR(15),
            cust_street_number SMALLINT,
            cust_suite_number CHAR(10),
            cust_street_name1 CHAR(30),
            cust_street_name2 CHAR(30),
            cust_street_type CHAR(15),
            cust_city CHAR(60),
            cust_zip CHAR(10),
            cust_county CHAR(30),
            cust_state CHAR(2),
            cust_country CHAR(20),
            cust_loc_type CHAR(20),
            cust_gender CHAR(1),
            cust_marital_status CHAR(1),
            cust_educ_status CHAR(20),
            cust_credit_rating CHAR(10),
            cust_purch_est DECIMAL(
                7,
                2
            ),
            cust_buy_potential CHAR(15),
            cust_depend_cnt SMALLINT,
            cust_depend_emp_cnt SMALLINT,
            cust_depend_college_cnt SMALLINT,
            cust_vehicle_cnt SMALLINT,
            cust_annual_income DECIMAL(
                9,
                2
            )
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_customer_address_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_customer_address_${stream_num}(
            cadr_address_id CHAR(16),
            cadr_street_number INTEGER,
            cadr_street_name1 CHAR(25),
            cadr_street_name2 CHAR(25),
            cadr_street_type CHAR(15),
            cadr_suitdecimal CHAR(10),
            cadr_city CHAR(60),
            cadr_county CHAR(30),
            cadr_state CHAR(2),
            cadr_zip CHAR(10),
            cadr_country CHAR(20)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_purchase_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_purchase_${stream_num}(
            purc_purchase_id INTEGER,
            purc_store_id CHAR(16),
            purc_customer_id CHAR(16),
            purc_purchase_date CHAR(10),
            purc_purchase_time INTEGER,
            purc_register_id INTEGER,
            purc_clerk_id INTEGER,
            purc_comment CHAR(100)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_catalog_order_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_catalog_order_${stream_num}(
            cord_order_id INTEGER,
            cord_bill_customer_id CHAR(16),
            cord_ship_customer_id CHAR(16),
            cord_order_date CHAR(10),
            cord_order_time INTEGER,
            cord_ship_mode_id CHAR(16),
            cord_call_center_id CHAR(16),
            cord_order_comments VARCHAR(100)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_web_order_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_web_order_${stream_num}(
            word_order_id INTEGER,
            word_bill_customer_id CHAR(16),
            word_ship_customer_id CHAR(16),
            word_order_date CHAR(10),
            word_order_time INTEGER,
            word_ship_mode_id CHAR(16),
            word_web_site_id CHAR(16),
            word_order_comments CHAR(100)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_item_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_item_${stream_num}(
            item_item_id CHAR(16),
            item_item_description CHAR(200),
            item_list_price DECIMAL(
                7,
                2
            ),
            item_wholesale_cost DECIMAL(
                7,
                2
            ),
            item_size CHAR(20),
            item_formulation CHAR(20),
            item_color CHAR(20),
            item_units CHAR(10),
            item_container CHAR(10),
            item_manager_id INTEGER
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_catalog_order_lineitem_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_catalog_order_lineitem_${stream_num}(
            clin_order_id INTEGER,
            clin_line_number INTEGER,
            clin_item_id CHAR(16),
            clin_promotion_id CHAR(16),
            clin_quantity BIGINT,
            clin_sales_price DECIMAL(
                7,
                2
            ),
            clin_coupon_amt DECIMAL(
                7,
                2
            ),
            clin_warehouse_id CHAR(16),
            clin_ship_date CHAR(10),
            clin_catalog_number INTEGER,
            clin_catalog_page_number INTEGER,
            clin_ship_cost DECIMAL(
                7,
                2
            )
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_web_order_lineitem_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_web_order_lineitem_${stream_num}(
            wlin_order_id INTEGER,
            wlin_line_number INTEGER,
            wlin_item_id CHAR(16),
            wlin_promotion_id CHAR(16),
            wlin_quantity BIGINT,
            wlin_sales_price DECIMAL(
                7,
                2
            ),
            wlin_coupon_amt DECIMAL(
                7,
                2
            ),
            wlin_warehouse_id CHAR(16),
            wlin_ship_date CHAR(10),
            wlin_ship_cost DECIMAL(
                7,
                2
            ),
            wlin_web_page_id CHAR(16)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_store_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_store_${stream_num}(
            stor_store_id CHAR(16),
            stor_closed_date CHAR(10),
            stor_name CHAR(50),
            stor_employees INTEGER,
            stor_floor_space INTEGER,
            stor_hours CHAR(20),
            stor_store_manager CHAR(40),
            stor_market_id INTEGER,
            stor_geography_class CHAR(100),
            stor_market_manager CHAR(40),
            stor_tax_percentage DECIMAL(
                5,
                2
            )
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_call_center_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_call_center_${stream_num}(
            call_center_id CHAR(16),
            call_open_date CHAR(10),
            call_closed_date CHAR(10),
            call_center_name CHAR(50),
            call_center_class CHAR(50),
            call_center_employees INTEGER,
            call_center_sq_ft INTEGER,
            call_center_hours CHAR(20),
            call_center_manager CHAR(40),
            call_center_tax_percentage DECIMAL(
                7,
                2
            )
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_web_site_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_web_site_${stream_num}(
            wsit_web_site_id CHAR(16),
            wsit_open_date CHAR(10),
            wsit_closed_date CHAR(10),
            wsit_site_name CHAR(50),
            wsit_site_class CHAR(50),
            wsit_site_manager CHAR(40),
            wsit_tax_percentage DECIMAL(
                5,
                2
            )
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_warehouse_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_warehouse_${stream_num}(
            wrhs_warehouse_id CHAR(16),
            wrhs_warehouse_desc CHAR(200),
            wrhs_warehouse_sq_ft INTEGER
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_web_page_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_web_page_${stream_num}(
            wpag_web_page_id CHAR(16),
            wpag_create_date CHAR(10),
            wpag_access_date CHAR(10),
            wpag_autogen_flag CHAR(1),
            wpag_url CHAR(100),
            wpag_type CHAR(50),
            wpag_char_cnt INTEGER,
            wpag_link_cnt INTEGER,
            wpag_image_cnt INTEGER,
            wpag_max_ad_cnt INTEGER
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_promotion_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_promotion_${stream_num}(
            prom_promotion_id CHAR(16),
            prom_promotion_name CHAR(30),
            prom_start_date CHAR(10),
            prom_end_date CHAR(10),
            prom_cost DECIMAL(
                7,
                2
            ),
            prom_response_target CHAR(1),
            prom_channel_dmail CHAR(1),
            prom_channel_email CHAR(1),
            prom_channel_catalog CHAR(1),
            prom_channel_tv CHAR(1),
            prom_channel_radio CHAR(1),
            prom_channel_press CHAR(1),
            prom_channel_event CHAR(1),
            prom_channel_demo CHAR(1),
            prom_channel_details CHAR(100),
            prom_purpose CHAR(15),
            prom_discount_active CHAR(1),
            prom_discount_pct DECIMAL(
                5,
                2
            )
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_store_returns_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_store_returns_${stream_num}(
            sret_store_id CHAR(16),
            sret_purchase_id CHAR(16),
            sret_line_number INTEGER,
            sret_item_id CHAR(16),
            sret_customer_id CHAR(16),
            sret_return_date CHAR(10),
            sret_return_time CHAR(10),
            sret_ticket_number CHAR(20),
            sret_return_qty INTEGER,
            sret_return_amt DECIMAL(
                7,
                2
            ),
            sret_return_tax DECIMAL(
                7,
                2
            ),
            sret_return_fee DECIMAL(
                7,
                2
            ),
            sret_return_ship_cost DECIMAL(
                7,
                2
            ),
            sret_refunded_cash DECIMAL(
                7,
                2
            ),
            sret_reversed_charge DECIMAL(
                7,
                2
            ),
            sret_store_credit DECIMAL(
                7,
                2
            ),
            sret_reason_id CHAR(16)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_catalog_returns_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_catalog_returns_${stream_num}(
            cret_call_center_id CHAR(16),
            cret_order_id INTEGER,
            cret_line_number INTEGER,
            cret_item_id CHAR(16),
            cret_return_customer_id CHAR(16),
            cret_refund_customer_id CHAR(16),
            cret_return_date CHAR(10),
            cret_return_time CHAR(10),
            cret_return_qty INTEGER,
            cret_return_amt DECIMAL(
                7,
                2
            ),
            cret_return_tax DECIMAL(
                7,
                2
            ),
            cret_return_fee DECIMAL(
                7,
                2
            ),
            cret_return_ship_cost DECIMAL(
                7,
                2
            ),
            cret_refunded_cash DECIMAL(
                7,
                2
            ),
            cret_reversed_charge DECIMAL(
                7,
                2
            ),
            cret_merchant_credit DECIMAL(
                7,
                2
            ),
            cret_reason_id CHAR(16),
            cret_shipmode_id CHAR(16),
            cret_catalog_page_id CHAR(16),
            cret_warehouse_id CHAR(16)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_web_returns_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_web_returns_${stream_num}(
            wret_web_site_id CHAR(16),
            wret_order_id INTEGER,
            wret_line_number INTEGER,
            wret_item_id CHAR(16),
            wret_return_customer_id CHAR(16),
            wret_refund_customer_id CHAR(16),
            wret_return_date CHAR(10),
            wret_return_time CHAR(10),
            wret_return_qty INTEGER,
            wret_return_amt DECIMAL(
                7,
                2
            ),
            wret_return_tax DECIMAL(
                7,
                2
            ),
            wret_return_fee DECIMAL(
                7,
                2
            ),
            wret_return_ship_cost DECIMAL(
                7,
                2
            ),
            wret_refunded_cash DECIMAL(
                7,
                2
            ),
            wret_reversed_charge DECIMAL(
                7,
                2
            ),
            wret_account_credit DECIMAL(
                7,
                2
            ),
            wret_reason_id CHAR(16)
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.s_inventory_${stream_num};

CREATE
    TABLE
        ${external_catalog}.${external_database}.s_inventory_${stream_num}(
            invn_warehouse_id CHAR(16),
            invn_item_id CHAR(16),
            invn_date CHAR(10),
            invn_qty_on_hand INTEGER
        );
