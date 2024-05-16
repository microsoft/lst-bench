CALL ${catalog}.system.rewrite_data_files(table => '${database}.catalog_returns', where => 'cr_returned_date_sk IN (${cr_returned_date_sk})');
