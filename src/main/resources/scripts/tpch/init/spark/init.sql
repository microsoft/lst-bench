CREATE
    SCHEMA IF NOT EXISTS ${catalog}.${database};

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.customer;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.lineitem;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.nation;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.orders;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.part;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.partsupp;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.region;

DROP
    TABLE
        IF EXISTS ${catalog}.${database}.supplier;
