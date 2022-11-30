CREATE OR REPLACE FUNCTION fnc_get_peers_max_friends(countOfPeers bigint)
    RETURNS TABLE(Peer varchar, FriendsCount varchar)
LANGUAGE SQL
AS
$$
WITH pf AS
    (SELECT nickname, count(f.peer1) AS FriendsCount
    FROM peers
    JOIN friends f on peers.nickname = f.peer1
    GROUP BY nickname
    ORDER BY FriendsCount DESC)
SELECT nickname, FriendsCount
FROM pf
LIMIT countOfPeers;
$$;

SELECT *
FROM fnc_get_peers_max_friends(4);
