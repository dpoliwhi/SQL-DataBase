CREATE OR REPLACE PROCEDURE get_last_check_duration(result_data INOUT REFCURSOR) AS
$$
BEGIN
    OPEN result_data FOR
        (WITH last_check AS (SELECT time_p2p
                             FROM p2p
                             ORDER BY checkid DESC, time_p2p DESC
                             LIMIT 2)
         SELECT (max(time_p2p) - min(time_p2p))::time AS check_duration
         FROM last_check);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_last_check_duration('data');
FETCH ALL IN "data";
COMMIT;
END;