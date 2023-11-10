CREATE TABLE time_dim
(
    T_TIME_SK                 int,
    T_TIME_ID                 char(16),
    T_TIME                    int,
    T_HOUR                    int,
    T_MINUTE                  int,
    T_SECOND                  int,
    T_AM_PM                   char(2),
    T_SHIFT                   char(20),
    T_SUB_SHIFT               char(20),
    T_MEAL_TIME               char(20)
);