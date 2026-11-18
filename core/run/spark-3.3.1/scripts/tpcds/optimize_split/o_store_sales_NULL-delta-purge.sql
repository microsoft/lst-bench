REORG TABLE ${database}.store_sales WHERE ss_sold_date_sk IS NULL APPLY (PURGE);
