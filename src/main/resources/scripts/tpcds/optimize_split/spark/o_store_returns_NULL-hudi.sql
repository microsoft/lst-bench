CALL ${catalog}.system.run_clustering(
    table => '${database}.store_returns',
    predicate => 'sr_returned_date_sk IS NULL'
);
