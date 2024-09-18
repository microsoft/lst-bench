INSERT
    INTO
        experiment_telemetry
    VALUES ${tuples};

--COPY experiment_telemetry TO '${data_path}experiment/experiment_telemetry.csv'(
--    ESCAPE '\',
--    HEADER
--);

