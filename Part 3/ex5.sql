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
ORDER BY Peer;