CREATE
    ICEBERG TABLE
        ${catalog}.${database}.customer_demographics(
            cd_demo_sk INT,
            cd_gender string,
            cd_marital_status string,
            cd_education_status string,
            cd_purchase_estimate INT,
            cd_credit_rating string,
            cd_dep_count INT,
            cd_dep_employed_count INT,
            cd_dep_college_count INT
        )
        CATALOG = 'SNOWFLAKE'
        EXTERNAL_VOLUME = '${exvol}'
        BASE_LOCATION = '${base_location}';