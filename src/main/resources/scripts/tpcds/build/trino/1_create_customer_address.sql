CREATE TABLE ${catalog}.${database}.customer_address(
    ca_address_sk             int                           ,
    ca_address_id             varchar(16)                      ,
    ca_street_number          varchar(10)                      ,
    ca_street_name            varchar(60)                   ,
    ca_street_type            varchar(15)                      ,
    ca_suite_number           varchar(10)                      ,
    ca_city                   varchar(60)                   ,
    ca_county                 varchar(30)                   ,
    ca_state                  varchar(2)                       ,
    ca_zip                    varchar(10)                      ,
    ca_country                varchar(20)                   ,
    ca_gmt_offset             decimal(5,2)                  ,
    ca_location_type          varchar(20)                       
) WITH (location='${data_path}${experiment_start_time}/${repetition}/customer_address/' ${tblproperties_suffix});
