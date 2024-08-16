CREATE
    TABLE
        ${catalog}.${database}.time_dim(
            t_time_sk INT,
            t_time_id VARCHAR(16),
            t_time INT,
            t_hour INT,
            t_minute INT,
            t_second INT,
            t_am_pm VARCHAR(2),
            t_shift VARCHAR(20),
            t_sub_shift VARCHAR(20),
            t_meal_time VARCHAR(20)
        );