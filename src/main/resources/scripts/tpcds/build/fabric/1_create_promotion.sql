CREATE TABLE promotion
(
    P_PROMO_SK                      int,
    P_PROMO_ID                      char(16),
    P_START_DATE_SK                 int,
    P_END_DATE_SK                   int,
    P_ITEM_SK                       int,
    P_COST                          decimal(15,2),
    P_RESPONSE_TARGET               int,
    P_PROMO_NAME                    char(50),
    P_CHANNEL_DMAIL                 char(1),
    P_CHANNEL_EMAIL                 char(1),
    P_CHANNEL_CATALOG               char(1),
    P_CHANNEL_TV                    char(1),
    P_CHANNEL_RADIO                 char(1),
    P_CHANNEL_PRESS                 char(1),
    P_CHANNEL_EVENT                 char(1),
    P_CHANNEL_DEMO                  char(1),
    P_CHANNEL_DETAILS               varchar(100),
    P_PURPOSE                       char(15),
    P_DISCOUNT_ACTIVE               char(1)
);