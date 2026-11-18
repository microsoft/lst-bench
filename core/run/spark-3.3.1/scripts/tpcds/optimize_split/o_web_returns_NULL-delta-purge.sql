REORG TABLE ${database}.web_returns WHERE wr_returned_date_sk IS NULL APPLY (PURGE);
