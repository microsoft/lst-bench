CREATE TABLE customer
(
    C_CUSTOMER_SK                   int,
    C_CUSTOMER_ID                   char(16),
    C_CURRENT_CDEMO_SK              int,
    C_CURRENT_HDEMO_SK              int,
    C_CURRENT_ADDR_SK               int,
    C_FIRST_SHIPTO_DATE_SK          int,
    C_FIRST_SALES_DATE_SK           int,
    C_SALUTATION                    char(10),
    C_FIRST_NAME                    char(20),
    C_LAST_NAME                     char(30),
    C_PREFERRED_CUST_FLAG           char(1),
    C_BIRTH_DAY                     int,
    C_BIRTH_MONTH                   int,
    C_BIRTH_YEAR                    int,
    C_BIRTH_COUNTRY                 varchar(20),
    C_LOGIN                         char(13),
    C_EMAIL_ADDRESS                 char(50),
    C_LAST_REVIEW_DATE_SK           varchar(10)
);