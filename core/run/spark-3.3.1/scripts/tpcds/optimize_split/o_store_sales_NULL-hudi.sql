CALL ${catalog}.system.run_clustering(
    table => '${database}.store_sales',
    predicate => 'ss_sold_date_sk IS NULL'
);
