CREATE
    TABLE
        ${catalog}.${database}.ship_mode(
            sm_ship_mode_sk INT,
            sm_ship_mode_id VARCHAR(16),
            sm_type VARCHAR(30),
            sm_code VARCHAR(10),
            sm_carrier VARCHAR(20),
            sm_contract VARCHAR(20)
        );