CREATE OR REPLACE PROCEDURE recommended_peer(result_data INOUT REFCURSOR) AS
$$
BEGIN
    OPEN result_data FOR
        (WITH result AS
                  (SELECT nickname, recomendedpeer, row_number() over (PARTITION BY nickname) as rows
                   FROM (SELECT nickname,
                                recomendedpeer,
                                сountRcmnd,
                                max(сountRcmnd) over (PARTITION BY nickname) AS max
                         FROM (SELECT fr.nickname, recomendedpeer, count(recomendedpeer) AS сountRcmnd
                               FROM (SELECT nickname, peer2 AS friend
                                     FROM peers
                                              JOIN friends ON peers.nickname = peer1) AS fr
                                        LEFT JOIN recomendations ON fr.friend = recomendations.peer
                               WHERE nickname != recomendations.recomendedpeer
                               GROUP BY recomendedpeer, fr.nickname
                               ORDER BY fr.nickname, recomendedpeer) AS rcmd_peers_with_count
                         order by nickname) AS all_max_recomend
                   WHERE сountRcmnd = max)
         SELECT nickname, recomendedpeer
         FROM result
         WHERE rows = 1);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL recommended_peer('data');
FETCH ALL IN "data";
COMMIT;
END;

