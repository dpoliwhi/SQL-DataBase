CREATE OR REPLACE PROCEDURE pcd_last_peer_to_arrive_23(result_data inout refcursor)
AS $$
BEGIN
    OPEN result_data FOR(
        SELECT peer
        FROM timetracking
        WHERE date = now()::timestamp::date AND state = 1
        ORDER BY time DESC
        LIMIT 1);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL pcd_last_peer_to_arrive_23('data');
FETCH ALL IN "data";
COMMIT;
END;
