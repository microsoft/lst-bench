CALL ${catalog}.system.run_clustering(
    table => '${database}.inventory',
    predicate => 'inv_date_sk IS NULL'
);
