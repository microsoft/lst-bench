CALL ${catalog}.system.rewrite_data_files(table => '${database}.web_sales', where => 'ws_sold_date_sk IS NULL');
