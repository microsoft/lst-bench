CREATE
    TABLE
        ${catalog}.${database}.household_demographics(
            hd_demo_sk INT,
            hd_income_band_sk INT,
            hd_buy_potential VARCHAR(15),
            hd_dep_count INT,
            hd_vehicle_count INT
        );