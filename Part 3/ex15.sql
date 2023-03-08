CREATE OR REPLACE PROCEDURE successful_task(task1 varchar, task2 varchar, task3 varchar, result_data INOUT REFCURSOR)
LANGUAGE plpgsql
AS $$
    BEGIN OPEN result_data FOR
    (WITH task1Success AS (
        SELECT DISTINCT peer
        FROM checks
        JOIN verter v on checks.id = v.checkid
        JOIN p2p p on checks.id = p.checkid
        WHERE task = task1
        AND (v.state = 'Success'
        AND p.checkstatus='Success')
    ),task2Success AS (
        SELECT DISTINCT peer
        FROM checks
        JOIN verter v on checks.id = v.checkid
        JOIN p2p p on checks.id = p.checkid
        WHERE task = task2
        AND (v.state = 'Success'
        AND p.checkstatus='Success')
    ), task3Success AS (
        SELECT DISTINCT peer
        FROM checks
        JOIN verter v on checks.id = v.checkid
        JOIN p2p p on checks.id = p.checkid
        WHERE task = task3
        AND (v.state = 'Success'
        AND p.checkstatus='Success')
    )
    SELECT task1Success.peer
    FROM task1Success
        INTERSECT
    SELECT task2Success.peer
    FROM task2Success
        INTERSECT
    (SELECT nickname as peer
        FROM peers
            EXCEPT
    SELECT task3Success.peer
    FROM task3Success)

    ORDER BY 1);
    END;
$$;

BEGIN;
CALL successful_task('C2_SimpleBashUtils', 'C3_s21_string+', 'A1_maze', 'data');
FETCH ALL IN "data";
COMMIT;
END;
