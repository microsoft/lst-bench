REORG TABLE ${database}.catalog_returns WHERE cr_returned_date_sk IN (${cr_returned_date_sk}) APPLY (PURGE);
