CALL ${catalog}.system.rewrite_data_files(table => '${database}.store_returns', where => 'sr_returned_date_sk IN (${sr_returned_date_sk})');
