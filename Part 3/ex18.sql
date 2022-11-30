CREATE OR REPLACE PROCEDURE get_productive_peers()
LANGUAGE SQL AS
$$
WITH pc AS (
    SELECT peer, count(task) AS TaskCount
    FROM
        (SELECT DISTINCT peer, task
        FROM checks
        JOIN xp ON checks.id = xp.checkid
        GROUP BY peer, task
        ORDER BY peer, task) AS allChecks
    GROUP BY peer)
SELECT peer, TaskCount
FROM pc
WHERE TaskCount = (SELECT max(TaskCount) FROM pc)
$$;

CALL get_productive_peers();


