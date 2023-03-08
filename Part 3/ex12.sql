CREATE OR REPLACE PROCEDURE get_peers_max_friends(result_data INOUT REFCURSOR, countOfPeers bigint) AS
$$
BEGIN
    OPEN result_data FOR
        (WITH pf AS
                  (SELECT nickname, count(f.peer1) AS FriendsCount
                   FROM peers
                            JOIN friends f on peers.nickname = f.peer1
                   GROUP BY nickname
                   ORDER BY FriendsCount DESC)
         SELECT nickname, FriendsCount
         FROM pf
         LIMIT countOfPeers);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_peers_max_friends('data', 4);
FETCH ALL IN "data";
COMMIT;
END;

