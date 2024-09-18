CREATE OR REPLACE FILE FORMAT ${external_catalog}.${external_database}.tpcds_dm_format
    TYPE = ${external_table_format}
    FIELD_DELIMITER = ${field_delimiter}
    SKIP_HEADER = 1
    EMPTY_FIELD_AS_NULL = TRUE
    NULL_IF = ('')
    ENCODING = 'ISO-8859-1'
    DATE_FORMAT = 'YYYY-MM-DD'
    TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF3'
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
    ESCAPE_UNENCLOSED_FIELD = NONE;

drop stage if exists ${external_catalog}.${external_database}.${snowflake_dm_stage};

create stage ${external_catalog}.${external_database}.${snowflake_dm_stage}
                url="${external_dm_data_path}"
                file_format = ${external_catalog}.${external_database}.tpcds_dm_format;


copy into ${external_catalog}.${external_database}.s_catalog_page_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_catalog_page.csv;

copy into ${external_catalog}.${external_database}.s_zip_to_gmt_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_zip_to_gmt.csv;

copy into ${external_catalog}.${external_database}.s_purchase_lineitem_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_purchase_lineitem.csv;

copy into ${external_catalog}.${external_database}.s_customer_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_customer.csv;

copy into ${external_catalog}.${external_database}.s_customer_address_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_customer_address.csv;

copy into ${external_catalog}.${external_database}.s_purchase_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_purchase.csv;

copy into ${external_catalog}.${external_database}.s_catalog_order_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_catalog_order.csv;

copy into ${external_catalog}.${external_database}.s_web_order_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_web_order.csv;

copy into ${external_catalog}.${external_database}.s_item_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_item.csv;

copy into ${external_catalog}.${external_database}.s_catalog_order_lineitem_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_catalog_order_lineitem.csv;

copy into ${external_catalog}.${external_database}.s_web_order_lineitem_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_web_order_lineitem.csv;

copy into ${external_catalog}.${external_database}.s_store_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_store.csv;

copy into ${external_catalog}.${external_database}.s_call_center_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_call_center.csv;

copy into ${external_catalog}.${external_database}.s_web_site_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_web_site.csv;

copy into ${external_catalog}.${external_database}.s_warehouse_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_warehouse.csv;

copy into ${external_catalog}.${external_database}.s_web_page_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_web_page.csv;

copy into ${external_catalog}.${external_database}.s_promotion_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_promotion.csv;

copy into ${external_catalog}.${external_database}.s_store_returns_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_store_returns.csv;

copy into ${external_catalog}.${external_database}.s_catalog_returns_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_catalog_returns.csv;

copy into ${external_catalog}.${external_database}.s_web_returns_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_web_returns.csv;

copy into ${external_catalog}.${external_database}.s_inventory_${stream_num}
from @${external_catalog}.${external_database}.${snowflake_dm_stage}/${stream_num}/s_inventory.csv;
