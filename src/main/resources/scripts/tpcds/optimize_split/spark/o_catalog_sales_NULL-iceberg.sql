CALL ${catalog}.system.rewrite_data_files(table => '${database}.catalog_sales', where => 'cs_sold_date_sk IS NULL');
