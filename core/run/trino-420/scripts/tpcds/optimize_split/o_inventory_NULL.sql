ALTER TABLE ${catalog}.${database}.inventory EXECUTE optimize WHERE inv_date_sk IS NULL;
