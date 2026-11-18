REORG TABLE ${database}.catalog_returns WHERE cr_returned_date_sk IS NULL APPLY (PURGE);
