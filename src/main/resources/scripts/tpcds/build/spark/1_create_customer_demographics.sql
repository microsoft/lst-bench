CREATE
    TABLE
        ${catalog}.${database}.customer_demographics(
            cd_demo_sk INT,
            cd_gender VARCHAR(1),
            cd_marital_status VARCHAR(1),
            cd_education_status VARCHAR(20),
            cd_purchase_estimate INT,
            cd_credit_rating VARCHAR(10),
            cd_dep_count INT,
            cd_dep_employed_count INT,
            cd_dep_college_count INT
        )
            USING ${table_format} OPTIONS(
            PATH '${data_path}${experiment_start_time}/${repetition}/customer_demographics/'
        ) TBLPROPERTIES(
            'primaryKey' = 'cd_demo_sk' ${tblproperties_suffix}
        );
