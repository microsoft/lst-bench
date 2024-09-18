CALL ${catalog}.system.run_clustering(
    table => '${database}.web_returns',
    predicate => 'wr_returned_date_sk IS NULL'
);
