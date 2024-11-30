DELETE FROM inventory WHERE INV_DATE_SK >= ( SELECT min(D_DATE_SK) FROM date_dim  WHERE D_DATE BETWEEN CAST('${param7}' AS DATE) AND CAST('${param8}' AS DATE)) AND
                INV_DATE_SK <= ( SELECT max(D_DATE_SK) FROM date_dim WHERE D_DATE BETWEEN CAST('${param7}' AS DATE) AND CAST('${param8}' AS DATE));

DELETE FROM inventory WHERE INV_DATE_SK >= ( SELECT min(D_DATE_SK) FROM date_dim  WHERE D_DATE BETWEEN CAST('${param9}' AS DATE) AND CAST('${param10}' AS DATE)) AND
                INV_DATE_SK <= ( SELECT max(D_DATE_SK) FROM date_dim WHERE D_DATE BETWEEN CAST('${param9}' AS DATE) AND CAST('${param10}' AS DATE));

DELETE FROM inventory WHERE INV_DATE_SK >= ( SELECT min(D_DATE_SK) FROM date_dim  WHERE D_DATE BETWEEN CAST('${param11}' AS DATE) AND CAST('${param12}' AS DATE)) AND
                INV_DATE_SK <= ( SELECT max(D_DATE_SK) FROM date_dim WHERE D_DATE BETWEEN CAST('${param11}' AS DATE) AND CAST('${param12}' AS DATE));