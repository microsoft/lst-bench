CALL ${catalog}.system.rewrite_data_files(table => '${database}.store_sales', where => 'ss_sold_date_sk IN (${ss_sold_date_sk})');
