CREATE OR REPLACE PROCEDURE pcd_peer_woth_the_most_xp_19(result_data inout refcursor)
AS $$
BEGIN
    open result_data FOR(
            SELECT DISTINCT nickname AS peer,
                   SUM(xpamount) OVER (PARTITION BY nickname) AS xp
            FROM peers
                     JOIN checks ON peers.nickname = checks.peer
                     JOIN xp ON checks.id = xp.checkid
            ORDER BY XP DESC
            LIMIT 1
            );
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL pcd_peer_woth_the_most_xp_19('data');
FETCH ALL IN "data";
COMMIT;
END;
