CALL ${catalog}.system.run_clustering(
    table => '${database}.catalog_returns',
    predicate => 'cr_returned_date_sk IS NULL'
);
