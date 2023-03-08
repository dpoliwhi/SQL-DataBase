CREATE OR REPLACE PROCEDURE get_points_changes(result_data INOUT REFCURSOR) AS
$$
BEGIN
    OPEN result_data FOR
        (SELECT peer, sum(PointsChangeOne) AS pointsChange
         FROM (WITH p1 AS
                        (SELECT peer1             AS Peer,
                                sum(pointsamount) as PointsChangeOne
                         FROM fnc_transferedpoint_to_normalize()
                         GROUP BY peer1),
                    p2 AS
                        (SELECT peer2                  AS Peer,
                                sum(pointsamount) * -1 as PointsChangeTwo
                         FROM fnc_transferedpoint_to_normalize()
                         GROUP BY peer2)
               SELECT *
               FROM p1
               UNION ALL
               SELECT *
               FROM p2) AS result
         GROUP BY peer
         ORDER BY 2 DESC);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_points_changes('data');
FETCH ALL IN "data";
COMMIT;
END;