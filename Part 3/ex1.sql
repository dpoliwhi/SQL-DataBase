CREATE OR REPLACE FUNCTION fnc_transferedpoint_to_normalize() RETURNS TABLE(Peer1 varchar, Peer2 varchar, PointsAmount int) AS
$$
WITH peers_with_id AS(
    SELECT  peers.birthday,
            peers.nickname,
            ROW_NUMBER() OVER() as id
    FROM peers
), trans_points_edited_with_duplicate AS (
SELECT t1.checkingpeer AS Peer1,
       t1.checkedpeer AS Peer2,
       t1.pointsamount - t2.pointsamount AS PointsAmount,
       p1.id as checkingpeerID,
       p2.id as checkedpeerID
FROM transferredpoints AS t1
JOIN transferredpoints AS t2 ON t2.checkingpeer = t1.checkedpeer AND t1.checkingpeer = t2.checkedpeer
JOIN peers_with_id as p1 ON t1.checkingpeer=p1.nickname
JOIN peers_with_id AS p2 ON t1.checkedpeer=p2.nickname
ORDER BY 1,2
)
    SELECT
        Peer1,Peer2,PointsAmount
    FROM trans_points_edited_with_duplicate
    WHERE checkingpeerID>checkedpeerID
$$
    LANGUAGE sql;

SELECT *
FROM fnc_transferedpoint_to_normalize();