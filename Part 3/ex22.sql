CREATE OR REPLACE FUNCTION fnc_get_peers_leave_campus(lastDays int, times bigint) RETURNS TABLE(peer varchar)
LANGUAGE SQL AS
$$
WITH tc AS
    (SELECT peer, count(peer) AS LeaveCampusTimes
    FROM
        (SELECT peer, time, date, state
        FROM timetracking
        WHERE date >= (SELECT now()::DATE - lastDays) AND state = 2
        ORDER BY peer) AS tt
    GROUP BY peer)
SELECT peer
FROM tc
WHERE LeaveCampusTimes > times
$$;

SELECT *
FROM fnc_get_peers_leave_campus(8, 2);
