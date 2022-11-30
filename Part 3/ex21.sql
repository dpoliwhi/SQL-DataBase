CREATE OR REPLACE FUNCTION fnc_time_peer_by_time(limit_time time, num_of_inputs int) RETURNS TABLE(Peer varchar)
AS $$
WITH filter_by_time_timetracking AS (
    SELECT peer,
       COUNT(peer) as cnt
    FROM timetracking
    WHERE time < limit_time AND state = 1
    GROUP BY peer
)

SELECT peer
FROM filter_by_time_timetracking
WHERE cnt >= num_of_inputs
GROUP BY peer
ORDER BY peer;
$$ LANGUAGE sql;

SELECT *
FROM fnc_time_peer_by_time('14:00:00', 2);
