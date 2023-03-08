CREATE OR REPLACE PROCEDURE pcd_for_each_month_the_percentage_of_early_entrances_25(result_data inout refcursor)
AS $$
BEGIN
    OPEN result_data FOR(
            WITH timetrack_with_eq_month AS (
            SELECT
                Peer,
                date,
                time,
                EXTRACT(MONTH FROM timetracking.date) as month_number,
                TO_CHAR(timetracking.date, 'Month') AS month_name
            FROM timetracking JOIN peers on timetracking.peer = peers.nickname
                                            AND EXTRACT(MONTH FROM peers.birthday) = EXTRACT(MONTH FROM timetracking.date)
            WHERE state = 1
            ), total_entries AS(
            SELECT DISTINCT
                month_name,
                SUM(month_number) as num
            FROM timetrack_with_eq_month
            GROUP BY month_name
            ORDER BY month_name
            ), early_entries AS(
            SELECT DISTINCT
                month_name,
                SUM(month_number) as num
            FROM timetrack_with_eq_month
            WHERE time < '12:00:00'::time
            GROUP BY month_name
            ORDER BY month_name
            )
            SELECT
                early_entries.month_name as Month,
                ROUND((early_entries.num::float / total_entries.num::float) * 100) as EarlyEntries
            FROM early_entries JOIN total_entries on early_entries.month_name = total_entries.month_name);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL pcd_for_each_month_the_percentage_of_early_entrances_25('data');
FETCH ALL IN "data";
COMMIT;
END;
