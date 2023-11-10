CREATE TABLE warehouse
(
    W_WAREHOUSE_SK            int,
    W_WAREHOUSE_ID            char(16),
    W_WAREHOUSE_NAME          varchar(20),
    W_WAREHOUSE_SQ_FT         int,
    W_STREET_NUMBER           char(10),
    W_STREET_NAME             varchar(60),
    W_STREET_TYPE             char(15),
    W_SUITE_NUMBER            char(10),
    W_CITY                    varchar(60),
    W_COUNTY                  varchar(30),
    W_STATE                   char(2),
    W_ZIP                     char(10),
    W_COUNTRY                 varchar(20),
    W_GMT_OFFSET              decimal(5,2)
);