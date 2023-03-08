CREATE OR REPLACE PROCEDURE get_recursive_count_parenttasks(result_data INOUT REFCURSOR) AS
$$
BEGIN
    OPEN result_data FOR
        (WITH RECURSIVE listOfParents(Task, parent, Count) AS
                            (SELECT title, parenttask, 0 AS firstCount
                             FROM tasks
                             WHERE parenttask IS NULL
                             UNION ALL
                             SELECT t.title, t.parenttask, Count + 1
                             FROM tasks t
                                      JOIN listOfParents ON listOfParents.Task = t.parenttask)
         SELECT Task, Count
         FROM listOfParents);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL get_recursive_count_parenttasks('data');
FETCH ALL IN "data";
COMMIT;
END;
