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
            cc_call_center_id string,
            cc_rec_start_date DATE,
            cc_rec_end_date DATE,
            cc_closed_date_sk INT,
            cc_open_date_sk INT,
            cc_name string,
            cc_class string,
            cc_employees INT,
            cc_sq_ft INT,
            cc_hours string,
            cc_manager string,
            cc_mkt_id INT,
            cc_mkt_class string,
            cc_mkt_desc string,
            cc_market_manager string,
            cc_division INT,
            cc_division_name string,
            cc_company INT,
            cc_company_name string,
            cc_street_number string,
            cc_street_name string,
            cc_street_type string,
            cc_suite_number string,
            cc_city string,
            cc_county string,
            cc_state string,
            cc_zip string,
            cc_country string,
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
            cp_catalog_page_id string,
            cp_start_date_sk INT,
            cp_end_date_sk INT,
            cp_department string,
            cp_catalog_number INT,
            cp_catalog_page_number INT,
            cp_description string,
            cp_type string
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
            c_customer_id string,
            c_current_cdemo_sk INT,
            c_current_hdemo_sk INT,
            c_current_addr_sk INT,
            c_first_shipto_date_sk INT,
            c_first_sales_date_sk INT,
            c_salutation string,
            c_first_name string,
            c_last_name string,
            c_preferred_cust_flag string,
            c_birth_day INT,
            c_birth_month INT,
            c_birth_year INT,
            c_birth_country string,
            c_login string,
            c_email_address string,
            c_last_review_date string
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
            ca_address_id string,
            ca_street_number string,
            ca_street_name string,
            ca_street_type string,
            ca_suite_number string,
            ca_city string,
            ca_county string,
            ca_state string,
            ca_zip string,
            ca_country string,
            ca_gmt_offset DECIMAL(
                5,
                2
            ),
            ca_location_type string
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
            cd_gender string,
            cd_marital_status string,
            cd_education_status string,
            cd_purchase_estimate INT,
            cd_credit_rating string,
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
            d_date_id string,
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
            d_day_name string,
            d_quarter_name string,
            d_holiday string,
            d_weekend string,
            d_following_holiday string,
            d_first_dom INT,
            d_last_dom INT,
            d_same_day_ly INT,
            d_same_day_lq INT,
            d_current_day string,
            d_current_week string,
            d_current_month string,
            d_current_quarter string,
            d_current_year string
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
            hd_buy_potential string,
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
            i_item_id string,
            i_rec_start_date DATE,
            i_rec_end_date DATE,
            i_item_desc string,
            i_current_price DECIMAL(
                7,
                2
            ),
            i_wholesale_cost DECIMAL(
                7,
                2
            ),
            i_brand_id INT,
            i_brand string,
            i_class_id INT,
            i_class string,
            i_category_id INT,
            i_category string,
            i_manufact_id INT,
            i_manufact string,
            i_size string,
            i_formulation string,
            i_color string,
            i_units string,
            i_container string,
            i_manager_id INT,
            i_product_name string
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
            p_promo_id string,
            p_start_date_sk INT,
            p_end_date_sk INT,
            p_item_sk INT,
            p_cost DECIMAL(
                15,
                2
            ),
            p_response_target INT,
            p_promo_name string,
            p_channel_dmail string,
            p_channel_email string,
            p_channel_catalog string,
            p_channel_tv string,
            p_channel_radio string,
            p_channel_press string,
            p_channel_event string,
            p_channel_demo string,
            p_channel_details string,
            p_purpose string,
            p_discount_active string
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
            r_reason_id string,
            r_reason_desc string
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
            sm_ship_mode_id string,
            sm_type string,
            sm_code string,
            sm_carrier string,
            sm_contract string
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
            s_store_id string,
            s_rec_start_date DATE,
            s_rec_end_date DATE,
            s_closed_date_sk INT,
            s_store_name string,
            s_number_employees INT,
            s_floor_space INT,
            s_hours string,
            s_manager string,
            s_market_id INT,
            s_geography_class string,
            s_market_desc string,
            s_market_manager string,
            s_division_id INT,
            s_division_name string,
            s_company_id INT,
            s_company_name string,
            s_street_number string,
            s_street_name string,
            s_street_type string,
            s_suite_number string,
            s_city string,
            s_county string,
            s_state string,
            s_zip string,
            s_country string,
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
            t_time_id string,
            t_time INT,
            t_hour INT,
            t_minute INT,
            t_second INT,
            t_am_pm string,
            t_shift string,
            t_sub_shift string,
            t_meal_time string
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
            w_warehouse_id string,
            w_warehouse_name string,
            w_warehouse_sq_ft INT,
            w_street_number string,
            w_street_name string,
            w_street_type string,
            w_suite_number string,
            w_city string,
            w_county string,
            w_state string,
            w_zip string,
            w_country string,
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
            wp_web_page_id string,
            wp_rec_start_date DATE,
            wp_rec_end_date DATE,
            wp_creation_date_sk INT,
            wp_access_date_sk INT,
            wp_autogen_flag string,
            wp_customer_sk INT,
            wp_url string,
            wp_type string,
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
            web_site_id string,
            web_rec_start_date DATE,
            web_rec_end_date DATE,
            web_name string,
            web_open_date_sk INT,
            web_close_date_sk INT,
            web_class string,
            web_manager string,
            web_mkt_id INT,
            web_mkt_class string,
            web_mkt_desc string,
            web_market_manager string,
            web_company_id INT,
            web_company_name string,
            web_street_number string,
            web_street_name string,
            web_street_type string,
            web_suite_number string,
            web_city string,
            web_county string,
            web_state string,
            web_zip string,
            web_country string,
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
