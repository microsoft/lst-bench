CALL ${catalog}.system.run_clustering(
    table => '${database}.web_sales',
    predicate => 'ws_sold_date_sk IN (${ws_sold_date_sk})'
);
