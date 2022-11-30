WITH timetrack_with_eq_month AS (
SELECT
    Peer,
    date,
    time,
    EXTRACT(MONTH FROM timetracking.date) as month_number,
    TO_CHAR(timetracking.date, 'Month') AS month_name
FROM timetracking JOIN peers on timetracking.peer = peers.nickname
                                AND EXTRACT(MONTH FROM peers.birthday) = EXTRACT(MONTH FROM timetracking.date)
WHERE state=1
), total_entries AS(
SELECT DISTINCT
    month_name,
    count(*) OVER (PARTITION BY date) as num
FROM timetrack_with_eq_month
ORDER BY month_name
), early_entries AS(
SELECT DISTINCT
    month_name,
    count(*) OVER (PARTITION BY date) as num
FROM timetrack_with_eq_month
WHERE time < '12:00:00'::time
ORDER BY month_name
)
SELECT
    early_entries.month_name as Month,
    ROUND((early_entries.num::float / total_entries.num::float) * 100) as EarlyEntries
FROM early_entries JOIN total_entries on early_entries.month_name = total_entries.month_name
