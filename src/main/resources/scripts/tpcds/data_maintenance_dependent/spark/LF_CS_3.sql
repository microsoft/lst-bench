SELECT
    row_number
FROM
    ${external_catalog}.${external_database}.csv_${stream_num};