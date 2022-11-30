CREATE OR REPLACE FUNCTION fnc_get_list_peer_complete_last_proj_in_block(ex text) RETURNS TABLE(Peer varchar, Day date) AS
$$
WITH last_task_in_block AS (
        SELECT *
        FROM tasks
        WHERE title ~ ex
        ORDER BY title DESC
        LIMIT 1
)
SELECT peer,
       date_of_check
FROM last_task_in_block AS l
JOIN checks c ON l.title = c.task
JOIN verter v ON c.id = v.checkid AND v.state = 'Success'
$$
    LANGUAGE sql;

SELECT *
FROM fnc_get_list_peer_complete_last_proj_in_block('A');