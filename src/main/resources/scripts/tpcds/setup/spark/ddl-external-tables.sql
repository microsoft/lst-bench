CREATE
    SCHEMA IF NOT EXISTS ${external_catalog}.${external_database};

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.catalog_sales;

CREATE
    TABLE
        ${external_catalog}.${external_database}.catalog_sales(
            cs_sold_time_sk INT,
            cs_ship_date_sk INT,
            cs_bill_customer_sk INT,
            cs_bill_cdemo_sk INT,
            cs_bill_hdemo_sk INT,
            cs_bill_addr_sk INT,
            cs_ship_customer_sk INT,
            cs_ship_cdemo_sk INT,
            cs_ship_hdemo_sk INT,
            cs_ship_addr_sk INT,
            cs_call_center_sk INT,
            cs_catalog_page_sk INT,
            cs_ship_mode_sk INT,
            cs_warehouse_sk INT,
            cs_item_sk INT,
            cs_promo_sk INT,
            cs_order_number BIGINT,
            cs_quantity INT,
            cs_wholesale_cost DECIMAL(
                7,
                2
            ),
            cs_list_price DECIMAL(
                7,
                2
            ),
            cs_sales_price DECIMAL(
                7,
                2
            ),
            cs_ext_discount_amt DECIMAL(
                7,
                2
            ),
            cs_ext_sales_price DECIMAL(
                7,
                2
            ),
            cs_ext_wholesale_cost DECIMAL(
                7,
                2
            ),
            cs_ext_list_price DECIMAL(
                7,
                2
            ),
            cs_ext_tax DECIMAL(
                7,
                2
            ),
            cs_coupon_amt DECIMAL(
                7,
                2
            ),
            cs_ext_ship_cost DECIMAL(
                7,
                2
            ),
            cs_net_paid DECIMAL(
                7,
                2
            ),
            cs_net_paid_inc_tax DECIMAL(
                7,
                2
            ),
            cs_net_paid_inc_ship DECIMAL(
                7,
                2
            ),
            cs_net_paid_inc_ship_tax DECIMAL(
                7,
                2
            ),
            cs_net_profit DECIMAL(
                7,
                2
            ),
            cs_sold_date_sk INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}catalog_sales/" ${external_options_suffix}
        ) PARTITIONED BY(cs_sold_date_sk);

ALTER TABLE
    ${external_catalog}.${external_database}.catalog_sales RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.catalog_returns;

CREATE
    TABLE
        ${external_catalog}.${external_database}.catalog_returns(
            cr_returned_time_sk INT,
            cr_item_sk INT,
            cr_refunded_customer_sk INT,
            cr_refunded_cdemo_sk INT,
            cr_refunded_hdemo_sk INT,
            cr_refunded_addr_sk INT,
            cr_returning_customer_sk INT,
            cr_returning_cdemo_sk INT,
            cr_returning_hdemo_sk INT,
            cr_returning_addr_sk INT,
            cr_call_center_sk INT,
            cr_catalog_page_sk INT,
            cr_ship_mode_sk INT,
            cr_warehouse_sk INT,
            cr_reason_sk INT,
            cr_order_number BIGINT,
            cr_return_quantity INT,
            cr_return_amount DECIMAL(
                7,
                2
            ),
            cr_return_tax DECIMAL(
                7,
                2
            ),
            cr_return_amt_inc_tax DECIMAL(
                7,
                2
            ),
            cr_fee DECIMAL(
                7,
                2
            ),
            cr_return_ship_cost DECIMAL(
                7,
                2
            ),
            cr_refunded_cash DECIMAL(
                7,
                2
            ),
            cr_reversed_charge DECIMAL(
                7,
                2
            ),
            cr_store_credit DECIMAL(
                7,
                2
            ),
            cr_net_loss DECIMAL(
                7,
                2
            ),
            cr_returned_date_sk INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}catalog_returns/" ${external_options_suffix}
        ) PARTITIONED BY(cr_returned_date_sk);

ALTER TABLE
    ${external_catalog}.${external_database}.catalog_returns RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.inventory;

CREATE
    TABLE
        ${external_catalog}.${external_database}.inventory(
            inv_item_sk INT,
            inv_warehouse_sk INT,
            inv_quantity_on_hand INT,
            inv_date_sk INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}inventory/" ${external_options_suffix}
        ) PARTITIONED BY(inv_date_sk);

ALTER TABLE
    ${external_catalog}.${external_database}.inventory RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.store_sales;

CREATE
    TABLE
        ${external_catalog}.${external_database}.store_sales(
            ss_sold_time_sk INT,
            ss_item_sk INT,
            ss_customer_sk INT,
            ss_cdemo_sk INT,
            ss_hdemo_sk INT,
            ss_addr_sk INT,
            ss_store_sk INT,
            ss_promo_sk INT,
            ss_ticket_number BIGINT,
            ss_quantity INT,
            ss_wholesale_cost DECIMAL(
                7,
                2
            ),
            ss_list_price DECIMAL(
                7,
                2
            ),
            ss_sales_price DECIMAL(
                7,
                2
            ),
            ss_ext_discount_amt DECIMAL(
                7,
                2
            ),
            ss_ext_sales_price DECIMAL(
                7,
                2
            ),
            ss_ext_wholesale_cost DECIMAL(
                7,
                2
            ),
            ss_ext_list_price DECIMAL(
                7,
                2
            ),
            ss_ext_tax DECIMAL(
                7,
                2
            ),
            ss_coupon_amt DECIMAL(
                7,
                2
            ),
            ss_net_paid DECIMAL(
                7,
                2
            ),
            ss_net_paid_inc_tax DECIMAL(
                7,
                2
            ),
            ss_net_profit DECIMAL(
                7,
                2
            ),
            ss_sold_date_sk INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}store_sales/" ${external_options_suffix}
        ) PARTITIONED BY(ss_sold_date_sk);

ALTER TABLE
    ${external_catalog}.${external_database}.store_sales RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.store_returns;

CREATE
    TABLE
        ${external_catalog}.${external_database}.store_returns(
            sr_return_time_sk INT,
            sr_item_sk INT,
            sr_customer_sk INT,
            sr_cdemo_sk INT,
            sr_hdemo_sk INT,
            sr_addr_sk INT,
            sr_store_sk INT,
            sr_reason_sk INT,
            sr_ticket_number BIGINT,
            sr_return_quantity INT,
            sr_return_amt DECIMAL(
                7,
                2
            ),
            sr_return_tax DECIMAL(
                7,
                2
            ),
            sr_return_amt_inc_tax DECIMAL(
                7,
                2
            ),
            sr_fee DECIMAL(
                7,
                2
            ),
            sr_return_ship_cost DECIMAL(
                7,
                2
            ),
            sr_refunded_cash DECIMAL(
                7,
                2
            ),
            sr_reversed_charge DECIMAL(
                7,
                2
            ),
            sr_store_credit DECIMAL(
                7,
                2
            ),
            sr_net_loss DECIMAL(
                7,
                2
            ),
            sr_returned_date_sk INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}store_returns/" ${external_options_suffix}
        ) PARTITIONED BY(sr_returned_date_sk);

ALTER TABLE
    ${external_catalog}.${external_database}.store_returns RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.web_sales;

CREATE
    TABLE
        ${external_catalog}.${external_database}.web_sales(
            ws_sold_time_sk INT,
            ws_ship_date_sk INT,
            ws_item_sk INT,
            ws_bill_customer_sk INT,
            ws_bill_cdemo_sk INT,
            ws_bill_hdemo_sk INT,
            ws_bill_addr_sk INT,
            ws_ship_customer_sk INT,
            ws_ship_cdemo_sk INT,
            ws_ship_hdemo_sk INT,
            ws_ship_addr_sk INT,
            ws_web_page_sk INT,
            ws_web_site_sk INT,
            ws_ship_mode_sk INT,
            ws_warehouse_sk INT,
            ws_promo_sk INT,
            ws_order_number BIGINT,
            ws_quantity INT,
            ws_wholesale_cost DECIMAL(
                7,
                2
            ),
            ws_list_price DECIMAL(
                7,
                2
            ),
            ws_sales_price DECIMAL(
                7,
                2
            ),
            ws_ext_discount_amt DECIMAL(
                7,
                2
            ),
            ws_ext_sales_price DECIMAL(
                7,
                2
            ),
            ws_ext_wholesale_cost DECIMAL(
                7,
                2
            ),
            ws_ext_list_price DECIMAL(
                7,
                2
            ),
            ws_ext_tax DECIMAL(
                7,
                2
            ),
            ws_coupon_amt DECIMAL(
                7,
                2
            ),
            ws_ext_ship_cost DECIMAL(
                7,
                2
            ),
            ws_net_paid DECIMAL(
                7,
                2
            ),
            ws_net_paid_inc_tax DECIMAL(
                7,
                2
            ),
            ws_net_paid_inc_ship DECIMAL(
                7,
                2
            ),
            ws_net_paid_inc_ship_tax DECIMAL(
                7,
                2
            ),
            ws_net_profit DECIMAL(
                7,
                2
            ),
            ws_sold_date_sk INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}web_sales/" ${external_options_suffix}
        ) PARTITIONED BY(ws_sold_date_sk);

ALTER TABLE
    ${external_catalog}.${external_database}.web_sales RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.web_returns;

CREATE
    TABLE
        ${external_catalog}.${external_database}.web_returns(
            wr_returned_time_sk INT,
            wr_item_sk INT,
            wr_refunded_customer_sk INT,
            wr_refunded_cdemo_sk INT,
            wr_refunded_hdemo_sk INT,
            wr_refunded_addr_sk INT,
            wr_returning_customer_sk INT,
            wr_returning_cdemo_sk INT,
            wr_returning_hdemo_sk INT,
            wr_returning_addr_sk INT,
            wr_web_page_sk INT,
            wr_reason_sk INT,
            wr_order_number BIGINT,
            wr_return_quantity INT,
            wr_return_amt DECIMAL(
                7,
                2
            ),
            wr_return_tax DECIMAL(
                7,
                2
            ),
            wr_return_amt_inc_tax DECIMAL(
                7,
                2
            ),
            wr_fee DECIMAL(
                7,
                2
            ),
            wr_return_ship_cost DECIMAL(
                7,
                2
            ),
            wr_refunded_cash DECIMAL(
                7,
                2
            ),
            wr_reversed_charge DECIMAL(
                7,
                2
            ),
            wr_account_credit DECIMAL(
                7,
                2
            ),
            wr_net_loss DECIMAL(
                7,
                2
            ),
            wr_returned_date_sk INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}web_returns/" ${external_options_suffix}
        ) PARTITIONED BY(wr_returned_date_sk);

ALTER TABLE
    ${external_catalog}.${external_database}.web_returns RECOVER PARTITIONS;

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.call_center;

CREATE
    TABLE
        ${external_catalog}.${external_database}.call_center(
            cc_call_center_sk INT,
            cc_call_center_id VARCHAR(16),
            cc_rec_start_date DATE,
            cc_rec_end_date DATE,
            cc_closed_date_sk INT,
            cc_open_date_sk INT,
            cc_name VARCHAR(50),
            cc_class VARCHAR(50),
            cc_employees INT,
            cc_sq_ft INT,
            cc_hours VARCHAR(20),
            cc_manager VARCHAR(40),
            cc_mkt_id INT,
            cc_mkt_class VARCHAR(50),
            cc_mkt_desc VARCHAR(100),
            cc_market_manager VARCHAR(40),
            cc_division INT,
            cc_division_name VARCHAR(50),
            cc_company INT,
            cc_company_name VARCHAR(50),
            cc_street_number VARCHAR(10),
            cc_street_name VARCHAR(60),
            cc_street_type VARCHAR(15),
            cc_suite_number VARCHAR(10),
            cc_city VARCHAR(60),
            cc_county VARCHAR(30),
            cc_state VARCHAR(2),
            cc_zip VARCHAR(10),
            cc_country VARCHAR(20),
            cc_gmt_offset DECIMAL(
                5,
                2
            ),
            cc_tax_percentage DECIMAL(
                5,
                2
            )
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}call_center/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.catalog_page;

CREATE
    TABLE
        ${external_catalog}.${external_database}.catalog_page(
            cp_catalog_page_sk INT,
            cp_catalog_page_id VARCHAR(16),
            cp_start_date_sk INT,
            cp_end_date_sk INT,
            cp_department VARCHAR(50),
            cp_catalog_number INT,
            cp_catalog_page_number INT,
            cp_description VARCHAR(100),
            cp_type VARCHAR(100)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}catalog_page/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.customer;

CREATE
    TABLE
        ${external_catalog}.${external_database}.customer(
            c_customer_sk INT,
            c_customer_id VARCHAR(16),
            c_current_cdemo_sk INT,
            c_current_hdemo_sk INT,
            c_current_addr_sk INT,
            c_first_shipto_date_sk INT,
            c_first_sales_date_sk INT,
            c_salutation VARCHAR(10),
            c_first_name VARCHAR(20),
            c_last_name VARCHAR(30),
            c_preferred_cust_flag VARCHAR(1),
            c_birth_day INT,
            c_birth_month INT,
            c_birth_year INT,
            c_birth_country VARCHAR(20),
            c_login VARCHAR(13),
            c_email_address VARCHAR(50),
            c_last_review_date_sk VARCHAR(10)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}customer/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.customer_address;

CREATE
    TABLE
        ${external_catalog}.${external_database}.customer_address(
            ca_address_sk INT,
            ca_address_id VARCHAR(16),
            ca_street_number VARCHAR(10),
            ca_street_name VARCHAR(60),
            ca_street_type VARCHAR(15),
            ca_suite_number VARCHAR(10),
            ca_city VARCHAR(60),
            ca_county VARCHAR(30),
            ca_state VARCHAR(2),
            ca_zip VARCHAR(10),
            ca_country VARCHAR(20),
            ca_gmt_offset DECIMAL(
                5,
                2
            ),
            ca_location_type VARCHAR(20)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}customer_address/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.customer_demographics;

CREATE
    TABLE
        ${external_catalog}.${external_database}.customer_demographics(
            cd_demo_sk INT,
            cd_gender VARCHAR(1),
            cd_marital_status VARCHAR(1),
            cd_education_status VARCHAR(20),
            cd_purchase_estimate INT,
            cd_credit_rating VARCHAR(10),
            cd_dep_count INT,
            cd_dep_employed_count INT,
            cd_dep_college_count INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}customer_demographics/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.date_dim;

CREATE
    TABLE
        ${external_catalog}.${external_database}.date_dim(
            d_date_sk INT,
            d_date_id VARCHAR(16),
            d_date DATE,
            d_month_seq INT,
            d_week_seq INT,
            d_quarter_seq INT,
            d_year INT,
            d_dow INT,
            d_moy INT,
            d_dom INT,
            d_qoy INT,
            d_fy_year INT,
            d_fy_quarter_seq INT,
            d_fy_week_seq INT,
            d_day_name VARCHAR(9),
            d_quarter_name VARCHAR(6),
            d_holiday VARCHAR(1),
            d_weekend VARCHAR(1),
            d_following_holiday VARCHAR(1),
            d_first_dom INT,
            d_last_dom INT,
            d_same_day_ly INT,
            d_same_day_lq INT,
            d_current_day VARCHAR(1),
            d_current_week VARCHAR(1),
            d_current_month VARCHAR(1),
            d_current_quarter VARCHAR(1),
            d_current_year VARCHAR(1)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}date_dim/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.household_demographics;

CREATE
    TABLE
        ${external_catalog}.${external_database}.household_demographics(
            hd_demo_sk INT,
            hd_income_band_sk INT,
            hd_buy_potential VARCHAR(15),
            hd_dep_count INT,
            hd_vehicle_count INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}household_demographics/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.income_band;

CREATE
    TABLE
        ${external_catalog}.${external_database}.income_band(
            ib_income_band_sk INT,
            ib_lower_bound INT,
            ib_upper_bound INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}income_band/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.item;

CREATE
    TABLE
        ${external_catalog}.${external_database}.item(
            i_item_sk INT,
            i_item_id VARCHAR(16),
            i_rec_start_date DATE,
            i_rec_end_date DATE,
            i_item_desc VARCHAR(200),
            i_current_price DECIMAL(
                7,
                2
            ),
            i_wholesale_cost DECIMAL(
                7,
                2
            ),
            i_brand_id INT,
            i_brand VARCHAR(50),
            i_class_id INT,
            i_class VARCHAR(50),
            i_category_id INT,
            i_category VARCHAR(50),
            i_manufact_id INT,
            i_manufact VARCHAR(50),
            i_size VARCHAR(20),
            i_formulation VARCHAR(20),
            i_color VARCHAR(20),
            i_units VARCHAR(10),
            i_container VARCHAR(10),
            i_manager_id INT,
            i_product_name VARCHAR(50)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}item/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.promotion;

CREATE
    TABLE
        ${external_catalog}.${external_database}.promotion(
            p_promo_sk INT,
            p_promo_id VARCHAR(16),
            p_start_date_sk INT,
            p_end_date_sk INT,
            p_item_sk INT,
            p_cost DECIMAL(
                15,
                2
            ),
            p_response_target INT,
            p_promo_name VARCHAR(50),
            p_channel_dmail VARCHAR(1),
            p_channel_email VARCHAR(1),
            p_channel_catalog VARCHAR(1),
            p_channel_tv VARCHAR(1),
            p_channel_radio VARCHAR(1),
            p_channel_press VARCHAR(1),
            p_channel_event VARCHAR(1),
            p_channel_demo VARCHAR(1),
            p_channel_details VARCHAR(100),
            p_purpose VARCHAR(15),
            p_discount_active VARCHAR(1)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}promotion/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.reason;

CREATE
    TABLE
        ${external_catalog}.${external_database}.reason(
            r_reason_sk INT,
            r_reason_id VARCHAR(16),
            r_reason_desc VARCHAR(100)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}reason/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.ship_mode;

CREATE
    TABLE
        ${external_catalog}.${external_database}.ship_mode(
            sm_ship_mode_sk INT,
            sm_ship_mode_id VARCHAR(16),
            sm_type VARCHAR(30),
            sm_code VARCHAR(10),
            sm_carrier VARCHAR(20),
            sm_contract VARCHAR(20)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}ship_mode/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.store;

CREATE
    TABLE
        ${external_catalog}.${external_database}.store(
            s_store_sk INT,
            s_store_id VARCHAR(16),
            s_rec_start_date DATE,
            s_rec_end_date DATE,
            s_closed_date_sk INT,
            s_store_name VARCHAR(50),
            s_number_employees INT,
            s_floor_space INT,
            s_hours VARCHAR(20),
            s_manager VARCHAR(40),
            s_market_id INT,
            s_geography_class VARCHAR(100),
            s_market_desc VARCHAR(100),
            s_market_manager VARCHAR(40),
            s_division_id INT,
            s_division_name VARCHAR(50),
            s_company_id INT,
            s_company_name VARCHAR(50),
            s_street_number VARCHAR(10),
            s_street_name VARCHAR(60),
            s_street_type VARCHAR(15),
            s_suite_number VARCHAR(10),
            s_city VARCHAR(60),
            s_county VARCHAR(30),
            s_state VARCHAR(2),
            s_zip VARCHAR(10),
            s_country VARCHAR(20),
            s_gmt_offset DECIMAL(
                5,
                2
            ),
            s_tax_precentage DECIMAL(
                5,
                2
            )
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}store/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.time_dim;

CREATE
    TABLE
        ${external_catalog}.${external_database}.time_dim(
            t_time_sk INT,
            t_time_id VARCHAR(16),
            t_time INT,
            t_hour INT,
            t_minute INT,
            t_second INT,
            t_am_pm VARCHAR(2),
            t_shift VARCHAR(20),
            t_sub_shift VARCHAR(20),
            t_meal_time VARCHAR(20)
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}time_dim/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.warehouse;

CREATE
    TABLE
        ${external_catalog}.${external_database}.warehouse(
            w_warehouse_sk INT,
            w_warehouse_id VARCHAR(16),
            w_warehouse_name VARCHAR(20),
            w_warehouse_sq_ft INT,
            w_street_number VARCHAR(10),
            w_street_name VARCHAR(60),
            w_street_type VARCHAR(15),
            w_suite_number VARCHAR(10),
            w_city VARCHAR(60),
            w_county VARCHAR(30),
            w_state VARCHAR(2),
            w_zip VARCHAR(10),
            w_country VARCHAR(20),
            w_gmt_offset DECIMAL(
                5,
                2
            )
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}warehouse/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.web_page;

CREATE
    TABLE
        ${external_catalog}.${external_database}.web_page(
            wp_web_page_sk INT,
            wp_web_page_id VARCHAR(16),
            wp_rec_start_date DATE,
            wp_rec_end_date DATE,
            wp_creation_date_sk INT,
            wp_access_date_sk INT,
            wp_autogen_flag VARCHAR(1),
            wp_customer_sk INT,
            wp_url VARCHAR(100),
            wp_type VARCHAR(50),
            wp_char_count INT,
            wp_link_count INT,
            wp_image_count INT,
            wp_max_ad_count INT
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}web_page/" ${external_options_suffix}
        );

DROP
    TABLE
        IF EXISTS ${external_catalog}.${external_database}.web_site;

CREATE
    TABLE
        ${external_catalog}.${external_database}.web_site(
            web_site_sk INT,
            web_site_id VARCHAR(16),
            web_rec_start_date DATE,
            web_rec_end_date DATE,
            web_name VARCHAR(50),
            web_open_date_sk INT,
            web_close_date_sk INT,
            web_class VARCHAR(50),
            web_manager VARCHAR(40),
            web_mkt_id INT,
            web_mkt_class VARCHAR(50),
            web_mkt_desc VARCHAR(100),
            web_market_manager VARCHAR(40),
            web_company_id INT,
            web_company_name VARCHAR(50),
            web_street_number VARCHAR(10),
            web_street_name VARCHAR(60),
            web_street_type VARCHAR(15),
            web_suite_number VARCHAR(10),
            web_city VARCHAR(60),
            web_county VARCHAR(30),
            web_state VARCHAR(2),
            web_zip VARCHAR(10),
            web_country VARCHAR(20),
            web_gmt_offset DECIMAL(
                5,
                2
            ),
            web_tax_percentage DECIMAL(
                5,
                2
            )
        )
            USING ${external_table_format} OPTIONS(
            PATH = "${external_data_path}web_site/" ${external_options_suffix}
        );
