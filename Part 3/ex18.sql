CREATE OR REPLACE PROCEDURE get_productive_peers(result_data INOUT REFCURSOR) AS
$$
BEGIN
    OPEN result_data FOR
        (WITH pc AS (SELECT peer, count(task) AS TaskCount
                     FROM (SELECT DISTINCT peer, task
                           FROM checks
                                    JOIN xp ON checks.id = xp.checkid
                           GROUP BY peer, task
                           ORDER BY peer, task) AS allChecks
                     GROUP BY peer)
         SELECT peer, TaskCount
         FROM pc
         WHERE TaskCount = (SELECT max(TaskCount) FROM pc));
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_productive_peers('data');
FETCH ALL IN "data";
COMMIT;
END;