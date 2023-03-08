CREATE OR REPLACE PROCEDURE get_sum_xp(result_data INOUT REFCURSOR) AS
$$
BEGIN
    OPEN result_data FOR
        (WITH pc AS (SELECT DISTINCT peer, task, max(xpamount) AS max_amount
                     FROM checks
                              JOIN xp ON checks.id = xp.checkid
                     GROUP BY peer, task
                     ORDER BY peer, task)
         SELECT peer, sum(max_amount)
         FROM pc
         GROUP BY peer);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_sum_xp('data');
FETCH ALL IN "data";
COMMIT;
END;