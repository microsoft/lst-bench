drop stage if exists ${external_catalog}.${external_database}.${snowflake_stage};

create stage ${external_catalog}.${external_database}.${snowflake_stage}
                url="${external_data_path}"
                file_format = (
                    TYPE = CSV
                    FIELD_DELIMITER = "|"
                    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
                    ENCODING = "iso-8859-1"
                );

copy into ${external_catalog}.${external_database}.catalog_sales
from @${external_catalog}.${external_database}.${snowflake_stage}/catalog_sales/;

copy into ${external_catalog}.${external_database}.catalog_returns
from @${external_catalog}.${external_database}.${snowflake_stage}/catalog_returns/;

copy into ${external_catalog}.${external_database}.inventory
from @${external_catalog}.${external_database}.${snowflake_stage}/inventory/;

copy into ${external_catalog}.${external_database}.store_sales
from @${external_catalog}.${external_database}.${snowflake_stage}/store_sales/;

copy into ${external_catalog}.${external_database}.store_returns
from @${external_catalog}.${external_database}.${snowflake_stage}/store_returns/;

copy into ${external_catalog}.${external_database}.web_sales
from @${external_catalog}.${external_database}.${snowflake_stage}/web_sales/;

copy into ${external_catalog}.${external_database}.web_returns
from @${external_catalog}.${external_database}.${snowflake_stage}/web_returns/;

copy into ${external_catalog}.${external_database}.call_center
from @${external_catalog}.${external_database}.${snowflake_stage}/call_center/;

copy into ${external_catalog}.${external_database}.catalog_page
from @${external_catalog}.${external_database}.${snowflake_stage}/catalog_page/;

copy into ${external_catalog}.${external_database}.customer
from @${external_catalog}.${external_database}.${snowflake_stage}/customer/;

copy into ${external_catalog}.${external_database}.customer_address
from @${external_catalog}.${external_database}.${snowflake_stage}/customer_address/;

copy into ${external_catalog}.${external_database}.customer_demographics
from @${external_catalog}.${external_database}.${snowflake_stage}/customer_demographics/;

copy into ${external_catalog}.${external_database}.date_dim
from @${external_catalog}.${external_database}.${snowflake_stage}/date_dim/;

copy into ${external_catalog}.${external_database}.household_demographics
from @${external_catalog}.${external_database}.${snowflake_stage}/household_demographics/;

copy into ${external_catalog}.${external_database}.income_band
from @${external_catalog}.${external_database}.${snowflake_stage}/income_band/;

copy into ${external_catalog}.${external_database}.item
from @${external_catalog}.${external_database}.${snowflake_stage}/item/;

copy into ${external_catalog}.${external_database}.promotion
from @${external_catalog}.${external_database}.${snowflake_stage}/promotion/;

copy into ${external_catalog}.${external_database}.reason
from @${external_catalog}.${external_database}.${snowflake_stage}/reason/;

copy into ${external_catalog}.${external_database}.ship_mode
from @${external_catalog}.${external_database}.${snowflake_stage}/ship_mode/;

copy into ${external_catalog}.${external_database}.store
from @${external_catalog}.${external_database}.${snowflake_stage}/store/;

copy into ${external_catalog}.${external_database}.time_dim
from @${external_catalog}.${external_database}.${snowflake_stage}/time_dim/;

copy into ${external_catalog}.${external_database}.warehouse
from @${external_catalog}.${external_database}.${snowflake_stage}/warehouse/;

copy into ${external_catalog}.${external_database}.web_page
from @${external_catalog}.${external_database}.${snowflake_stage}/web_page/;

copy into ${external_catalog}.${external_database}.web_site
from @${external_catalog}.${external_database}.${snowflake_stage}/web_site/;
