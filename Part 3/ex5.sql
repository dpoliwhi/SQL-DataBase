CREATE OR REPLACE PROCEDURE pcd_edit_trans_points_5(result_data inout refcursor)
AS $$
BEGIN
    OPEN result_data FOR(
        WITH cast_trans_points as(
            SELECT t1.checkingpeer AS peer,
                t1.pointsamount - t2.pointsamount AS givenPoints,
                t2.checkingpeer AS checkingpeer
            FROM transferredpoints AS t1
            JOIN transferredpoints AS t2 ON t2.checkingpeer = t1.checkedpeer AND t1.checkingpeer = t2.checkedpeer
            ORDER BY peer
        )
        SELECT peer,
               SUM(givenPoints) as PointsChange
        FROM cast_trans_points
        GROUP BY Peer
        ORDER BY PointsChange DESC );
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL pcd_edit_trans_points_5('data');
FETCH ALL IN "data";
COMMIT;
END;