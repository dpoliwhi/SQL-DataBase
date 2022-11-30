CREATE OR REPLACE FUNCTION fnc_last_peer_to_arrive(d date) RETURNS TABLE(Peer varchar) AS
$$
SELECT peer
FROM timetracking
WHERE date = d AND state = 1
ORDER BY time DESC
LIMIT 1;
$$ LANGUAGE sql;

SELECT *
FROM fnc_last_peer_to_arrive('2022-02-03');
