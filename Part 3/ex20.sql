CREATE OR REPLACE FUNCTION fnc_get_peer_with_max_time(inputDate DATE) RETURNS TABLE
    (Peer varchar) AS
$$
SELECT peer
FROM
    (SELECT peer, sum(timeSpendInCampus) AS totalTime
    FROM
        (WITH tcome AS
            (SELECT row_number() over () AS rowId, peer, time, state
            FROM timetracking
            WHERE date = inputDate AND state = 1),
            tleave AS (SELECT  row_number() over () AS rowId, peer, time, state
            FROM timetracking
            WHERE date = inputDate AND state = 2)
        SELECT tcome.peer, (tleave.time - tcome.time)::time AS timeSpendInCampus
        FROM tcome
        JOIN tleave ON tcome.peer = tleave.peer AND tcome.rowId = tleave.rowId) as timeInCampus
    GROUP BY peer
    ORDER BY totalTime DESC) AS result
LIMIT 1
$$
LANGUAGE sql;

SELECT *
FROM fnc_get_peer_with_max_time('2022-11-18');


