REORG TABLE ${database}.store_returns WHERE sr_returned_date_sk IN (${sr_returned_date_sk}) APPLY (PURGE);
