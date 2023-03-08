CREATE OR REPLACE PROCEDURE pcd_the_most_checked_for_each_day_7(result_data inout refcursor)
AS $$
BEGIN
    OPEN result_data FOR(
        WITH calc_num_of_check_for_task_in_day AS(
        SELECT task,
               date_of_check,
               COUNT(*) as num
        FROM checks
        GROUP BY task, date_of_check
        ), temp as (
            SELECT date_of_check,
                   task,
                   num,
                   RANK() OVER( PARTITION BY date_of_check ORDER BY num DESC ) as level
            FROM calc_num_of_check_for_task_in_day
        )
        SELECT date_of_check,
               task
        FROM temp
        WHERE level=1
        ORDER BY date_of_check);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL pcd_the_most_checked_for_each_day_7('data');
FETCH ALL IN "data";
COMMIT;
END;