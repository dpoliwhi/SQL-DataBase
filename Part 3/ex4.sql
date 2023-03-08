CREATE OR REPLACE PROCEDURE get_checks_percents(result_data INOUT REFCURSOR) AS
$$
    BEGIN OPEN result_data FOR
(WITH st AS (SELECT count(state)::numeric AS success_count
            FROM verter
            WHERE state = 'Success'),
     ft AS (SELECT count(state)::numeric AS failure_count
            FROM verter
            WHERE state = 'Failure')
SELECT round(success_count / (st.success_count + ft.failure_count) * 100.0, 2) AS SuccessfulChecks,
       round(failure_count / (st.success_count + ft.failure_count) * 100.0, 2) AS UnsuccessfulChecks
FROM st,
     ft);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_checks_percents('data');
FETCH ALL IN "data";
COMMIT;
END;

