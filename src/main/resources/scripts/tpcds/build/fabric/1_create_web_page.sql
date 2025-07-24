CREATE TABLE web_page
(
    WP_WEB_PAGE_SK            int,
    WP_WEB_PAGE_ID            char(16),
    WP_REC_START_DATE         date,
    WP_REC_END_DATE           date,
    WP_CREATION_DATE_SK       int,
    WP_ACCESS_DATE_SK         int,
    WP_AUTOGEN_FLAG           char(1),
    WP_CUSTOMER_SK            int,
    WP_URL                    varchar(100),
    WP_TYPE                   char(50),
    WP_CHAR_COUNT             int,
    WP_LINK_COUNT             int,
    WP_IMAGE_COUNT            int,
    WP_MAX_AD_COUNT           int
);