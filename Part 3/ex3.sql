CREATE OR REPLACE FUNCTION fnc_peer_dont_leave_the_campus(chooseDate date) RETURNS TABLE(Peer varchar) AS
$$
WITH time_entering_temp AS (
    SELECT  peer,
        date as date_in,
        time,
        state,
        LEAD(date+time) OVER (PARTITION BY peer ORDER BY peer) as timesize,
        LEAD(date+time) OVER (PARTITION BY peer ORDER BY date+time) - (time + date) as res
    FROM timetracking
), time_filtered AS (
    SELECT *,
           timesize::date as date_out
    FROM time_entering_temp
    WHERE state = 1  AND res >= interval '1 day'
)
SELECT peer
FROM time_filtered
WHERE date_in < chooseDate AND date_out > chooseDate
$$
LANGUAGE sql;

SELECT *
FROM fnc_peer_dont_leave_the_campus('2022-02-02');

