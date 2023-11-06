CALL ${catalog}.system.run_clustering(
    table => '${database}.catalog_sales',
    predicate => 'cs_sold_date_sk IN (${cs_sold_date_sk})'
);
