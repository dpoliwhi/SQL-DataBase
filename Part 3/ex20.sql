CREATE OR REPLACE PROCEDURE get_peer_with_max_time(result_data INOUT REFCURSOR, inputDate date) AS
$$
BEGIN
    OPEN result_data FOR
        (SELECT peer
         FROM (SELECT peer, sum(timeSpendInCampus) AS totalTime
               FROM (WITH tcome AS
                              (SELECT row_number() over () AS rowId, peer, time, state
                               FROM timetracking
                               WHERE date = inputDate
                                 AND state = 1),
                          tleave AS (SELECT row_number() over () AS rowId, peer, time, state
                                     FROM timetracking
                                     WHERE date = inputDate
                                       AND state = 2)
                     SELECT tcome.peer, (tleave.time - tcome.time)::time AS timeSpendInCampus
                     FROM tcome
                              JOIN tleave ON tcome.peer = tleave.peer AND tcome.rowId = tleave.rowId) as timeInCampus
               GROUP BY peer
               ORDER BY totalTime DESC) AS result
         LIMIT 1);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_peer_with_max_time('data', '2023-01-11');
FETCH ALL IN "data";
COMMIT;
END;
