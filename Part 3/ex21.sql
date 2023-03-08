CREATE OR REPLACE PROCEDURE pcd_time_peer_by_time_21(limit_time time, num_of_inputs int,result_data inout refcursor)
AS $$
BEGIN
    OPEN result_data FOR(
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
            ORDER BY peer);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL pcd_time_peer_by_time_21('12:00:00',2,'data');
FETCH ALL IN "data";
COMMIT;
END;
