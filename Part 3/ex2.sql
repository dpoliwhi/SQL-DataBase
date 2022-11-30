CREATE OR REPLACE FUNCTION fnc_successful_checked_tasks()
    RETURNS TABLE (
                Peer varchar,
                Task varchar,
                XP   int) AS
$$
WITH succes_checks AS (
SELECT t1.peer  AS Peer,
       split_part(t1.task, '_', 1)  AS Task,
       t2.state AS status,
       t3.maxxp AS XP
FROM checks AS t1
JOIN verter AS t2 ON t2.checkid = t1.id
JOIN tasks AS t3 ON t1.task = t3.title)
    SELECT Peer, Task, XP
    FROM succes_checks
    WHERE status = 'Success'
$$
LANGUAGE sql;

SELECT *
FROM fnc_successful_checked_tasks();

