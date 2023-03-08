CREATE OR REPLACE PROCEDURE pcd_get_list_peer_complete_last_proj_in_block_9(ex text, result_data inout refcursor)
AS $$
BEGIN
    IF(ex='C') THEN ex ='C8'; END IF;
    OPEN result_data FOR(

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
        JOIN verter v ON c.id = v.checkid AND v.state = 'Success');
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL pcd_get_list_peer_complete_last_proj_in_block_9('A','data');
FETCH ALL IN "data";
COMMIT;
END;