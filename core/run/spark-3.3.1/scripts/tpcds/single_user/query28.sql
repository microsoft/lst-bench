SELECT
    *
FROM
    (
        SELECT
            AVG( ss_list_price ) B1_LP,
            COUNT( ss_list_price ) B1_CNT,
            COUNT( DISTINCT ss_list_price ) B1_CNTD
        FROM
            ${catalog}.${database}.store_sales ${asof}
        WHERE
            ss_quantity BETWEEN 0 AND 5
            AND(
                ss_list_price BETWEEN 28 AND 28 + 10
                OR ss_coupon_amt BETWEEN 12573 AND 12573 + 1000
                OR ss_wholesale_cost BETWEEN 33 AND 33 + 20
            )
    ) B1,
    (
        SELECT
            AVG( ss_list_price ) B2_LP,
            COUNT( ss_list_price ) B2_CNT,
            COUNT( DISTINCT ss_list_price ) B2_CNTD
        FROM
            ${catalog}.${database}.store_sales ${asof}
        WHERE
            ss_quantity BETWEEN 6 AND 10
            AND(
                ss_list_price BETWEEN 143 AND 143 + 10
                OR ss_coupon_amt BETWEEN 5562 AND 5562 + 1000
                OR ss_wholesale_cost BETWEEN 45 AND 45 + 20
            )
    ) B2,
    (
        SELECT
            AVG( ss_list_price ) B3_LP,
            COUNT( ss_list_price ) B3_CNT,
            COUNT( DISTINCT ss_list_price ) B3_CNTD
        FROM
            ${catalog}.${database}.store_sales ${asof}
        WHERE
            ss_quantity BETWEEN 11 AND 15
            AND(
                ss_list_price BETWEEN 159 AND 159 + 10
                OR ss_coupon_amt BETWEEN 2807 AND 2807 + 1000
                OR ss_wholesale_cost BETWEEN 24 AND 24 + 20
            )
    ) B3,
    (
        SELECT
            AVG( ss_list_price ) B4_LP,
            COUNT( ss_list_price ) B4_CNT,
            COUNT( DISTINCT ss_list_price ) B4_CNTD
        FROM
            ${catalog}.${database}.store_sales ${asof}
        WHERE
            ss_quantity BETWEEN 16 AND 20
            AND(
                ss_list_price BETWEEN 24 AND 24 + 10
                OR ss_coupon_amt BETWEEN 3706 AND 3706 + 1000
                OR ss_wholesale_cost BETWEEN 46 AND 46 + 20
            )
    ) B4,
    (
        SELECT
            AVG( ss_list_price ) B5_LP,
            COUNT( ss_list_price ) B5_CNT,
            COUNT( DISTINCT ss_list_price ) B5_CNTD
        FROM
            ${catalog}.${database}.store_sales ${asof}
        WHERE
            ss_quantity BETWEEN 21 AND 25
            AND(
                ss_list_price BETWEEN 76 AND 76 + 10
                OR ss_coupon_amt BETWEEN 2096 AND 2096 + 1000
                OR ss_wholesale_cost BETWEEN 50 AND 50 + 20
            )
    ) B5,
    (
        SELECT
            AVG( ss_list_price ) B6_LP,
            COUNT( ss_list_price ) B6_CNT,
            COUNT( DISTINCT ss_list_price ) B6_CNTD
        FROM
            ${catalog}.${database}.store_sales ${asof}
        WHERE
            ss_quantity BETWEEN 26 AND 30
            AND(
                ss_list_price BETWEEN 169 AND 169 + 10
                OR ss_coupon_amt BETWEEN 10672 AND 10672 + 1000
                OR ss_wholesale_cost BETWEEN 58 AND 58 + 20
            )
    ) B6 LIMIT 100;
