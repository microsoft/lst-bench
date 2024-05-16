CALL ${catalog}.system.rewrite_data_files(table => '${database}.inventory', where => 'inv_date_sk IS NULL');
