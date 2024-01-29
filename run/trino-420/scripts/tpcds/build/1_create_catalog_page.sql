CREATE TABLE ${catalog}.${database}.catalog_page(
    cp_catalog_page_sk        int                           ,
    cp_catalog_page_id        varchar(16)                      ,
    cp_start_date_sk          int                           ,
    cp_end_date_sk            int                           ,
    cp_department             varchar(50)                   ,
    cp_catalog_number         int                           ,
    cp_catalog_page_number    int                           ,
    cp_description            varchar(100)                  ,
    cp_type                   varchar(100)                   
) WITH (location='${data_path}${experiment_start_time}/${repetition}/catalog_page/' ${tblproperties_suffix});
