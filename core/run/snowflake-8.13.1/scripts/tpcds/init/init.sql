CREATE
    SCHEMA IF NOT EXISTS ${catalog}.${database};

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.catalog_sales;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.catalog_returns;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.inventory;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.store_sales;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.store_returns;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.web_sales;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.web_returns;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.call_center;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.catalog_page;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.customer;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.customer_address;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.customer_demographics;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.date_dim;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.household_demographics;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.income_band;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.item;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.promotion;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.reason;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.ship_mode;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.store;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.time_dim;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.warehouse;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.web_page;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.web_site;
