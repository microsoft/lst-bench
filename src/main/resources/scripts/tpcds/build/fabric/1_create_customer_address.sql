CREATE TABLE customer_address
(
    CA_ADDRESS_SK                   int,
    CA_ADDRESS_ID                   char(16),
    CA_STREET_NUMBER                char(10),
    CA_STREET_NAME                  varchar(60),
    CA_STREET_TYPE                  char(15),
    CA_SUITE_NUMBER                 char(10),
    CA_CITY                         varchar(60),
    CA_COUNTY                       varchar(30),
    CA_STATE                        char(2),
    CA_ZIP                          char(10),
    CA_COUNTRY                      varchar(20),
    CA_GMT_OFFSET                   decimal(5,2),
    CA_LOCATION_TYPE                char(20)
);