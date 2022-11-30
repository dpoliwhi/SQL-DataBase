CREATE OR REPLACE PROCEDURE get_recursive_count_parenttasks()
    LANGUAGE SQL AS
$$
WITH RECURSIVE listOfParents(Task, parent, Count) AS
    (SELECT title, parenttask, 0 AS firstCount
     FROM tasks
     WHERE parenttask IS NULL
     UNION ALL
        SELECT t.title, t.parenttask, Count + 1
        FROM tasks t
        JOIN listOfParents ON listOfParents.Task = t.parenttask)
SELECT Task, Count
FROM listOfParents
$$;

CALL get_recursive_count_parenttasks();