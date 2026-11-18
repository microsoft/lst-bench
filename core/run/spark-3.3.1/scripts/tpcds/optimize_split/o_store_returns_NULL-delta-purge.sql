REORG TABLE ${database}.store_returns WHERE sr_returned_date_sk IS NULL APPLY (PURGE);
