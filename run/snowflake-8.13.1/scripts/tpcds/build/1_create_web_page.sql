CREATE
    TABLE
        ${catalog}.${database}.web_page(
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
        );