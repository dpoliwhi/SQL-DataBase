CREATE OR REPLACE FUNCTION fnc_get_peers_left_campus(inputDate DATE, minutes int)
    RETURNS TABLE
            (
                Peer varchar
            )
AS
$$
WITH result AS
         (SELECT peer, sum(timeOutsideCampus)::time AS time
          FROM (WITH tcome AS
                         (SELECT rowId, peer, time, state
                          FROM (SELECT row_number() over (PARTITION BY peer) AS rowId, peer, time, state
                                FROM timetracking
                                WHERE date = inputDate
                                  AND state = 1) AS tcome_all
                          WHERE rowId != 1),
                     tleave AS (SELECT rowId, peer, time, state
                                FROM (SELECT row_number() over (PARTITION BY peer) AS rowId,
                                             peer,
                                             time,
                                             state,
                                             count(peer) over (PARTITION BY peer)  AS count
                                      FROM timetracking
                                      WHERE date = inputDate
                                        AND state = 2) AS tleave_all
                                WHERE rowId != count)

                SELECT tcome.peer, (tcome.time - tleave.time)::time AS timeOutsideCampus
                FROM tcome
                         JOIN tleave ON tcome.peer = tleave.peer AND tcome.rowId = tleave.rowId + 1) AS timesOutOfCampus
          GROUP BY peer)
SELECT peer
FROM result
WHERE time >= minutes * INTERVAL '1 minute'
$$
LANGUAGE sql;

SELECT *
FROM fnc_get_peers_left_campus('2022-11-18', 5);



