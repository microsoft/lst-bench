CALL ${catalog}.system.run_clustering(
    table => '${database}.inventory',
    predicate => 'inv_date_sk IN (${inv_date_sk})'
);
