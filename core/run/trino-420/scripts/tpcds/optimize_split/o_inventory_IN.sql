ALTER TABLE ${catalog}.${database}.inventory EXECUTE optimize WHERE inv_date_sk IN (${inv_date_sk});
