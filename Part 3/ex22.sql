CREATE OR REPLACE PROCEDURE get_peers_leave_campus(result_data INOUT REFCURSOR, lastDays int, times bigint) AS
$$
BEGIN
    OPEN result_data FOR
        (WITH tc AS
                  (SELECT peer, count(peer) AS LeaveCampusTimes
                   FROM (SELECT peer, time, date, state
                         FROM timetracking
                         WHERE date >= (SELECT now()::DATE - lastDays)
                           AND state = 2
                         ORDER BY peer) AS tt
                   GROUP BY peer)
         SELECT peer
         FROM tc
         WHERE LeaveCampusTimes > times);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_peers_leave_campus('data', 100, 1);
FETCH ALL IN "data";
COMMIT;
END;
