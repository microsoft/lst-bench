CALL ${catalog}.system.rewrite_data_files(table => '${database}.web_returns', where => 'wr_returned_date_sk IN (${wr_returned_date_sk})');
