CREATE OR REPLACE PROCEDURE get_checks_percents()
LANGUAGE SQL AS
$$
WITH st AS (SELECT count(state)::numeric AS success_count
            FROM verter
            WHERE state = 'Success'),
     ft AS (SELECT count(state)::numeric AS failure_count
            FROM verter
            WHERE state = 'Failure')
SELECT round(success_count / (st.success_count + ft.failure_count) * 100.0, 2) AS SuccessfulChecks,
       round(failure_count / (st.success_count + ft.failure_count) * 100.0, 2) AS UnsuccessfulChecks
FROM st,
     ft
$$;

CALL get_checks_percents();