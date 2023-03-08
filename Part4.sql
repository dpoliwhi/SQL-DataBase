CREATE TABLE TableNameEmployee
(
  ID BIGINT PRIMARY KEY NOT NULL,
  FirstName VARCHAR NOT NULL,
  SecondName VARCHAR NOT NULL,
  Birthday DATE NOT NULL
);

CREATE TABLE TableNameSalary
(
  EmployeeId BIGINT NOT NULL,
  Salary NUMERIC NOT NULL,
  FOREIGN KEY (EmployeeId) REFERENCES TableNameEmployee(ID)
);

CREATE TABLE Departments
(
  ID BIGINT PRIMARY KEY NOT NULL,
  Department VARCHAR NOT NULL
);

CREATE OR REPLACE FUNCTION fnc_average_salary() RETURNS NUMERIC AS
$$
    SELECT AVG(Salary)
    FROM TableNameSalary;
$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION fnc_high_salary(x NUMERIC) RETURNS TABLE(EmployeeId BIGINT) AS
$$
    SELECT EmployeeId
    FROM TableNameSalary
    WHERE Salary > x;
$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION fnc_same_name(n VARCHAR) RETURNS TABLE(SecondName VARCHAR) AS
$$
    SELECT SecondName
    FROM TableNameEmployee
    WHERE FirstName = n;
$$
LANGUAGE sql;

CREATE OR REPLACE PROCEDURE delete_tables()
LANGUAGE plpgsql
AS $$
DECLARE
    temp record;
BEGIN
    FOR temp IN (SELECT table_name FROM information_schema.tables
                WHERE table_schema IN ('public')
                AND table_name LIKE 'tablename%')
    LOOP
        EXECUTE ('DROP TABLE public.' || temp.table_name || ' CASCADE;');
    END LOOP;
END
$$;

CALL delete_tables();

CREATE OR REPLACE PROCEDURE list_of_parameters (result_data INOUT REFCURSOR)
LANGUAGE plpgsql
AS $$
    BEGIN OPEN result_data FOR
        (WITH temp AS
            (SELECT routines.routine_name, string_agg(parameters.parameter_name, ', ') AS temp_table
    FROM information_schema.routines
    JOIN information_schema.parameters ON routines.specific_name = parameters.specific_name
    WHERE routines.specific_schema = 'public'
    AND routines.routine_type = 'FUNCTION'
    GROUP BY routines.routine_name)
    SELECT * FROM temp);
    END;
$$;

BEGIN;
CALL list_of_parameters('data');
FETCH ALL IN "data";
COMMIT;
END;

CREATE TABLE AuditEmployee
(
  Created TIMESTAMP WITH TIME ZONE NOT NULL,
  TypeEvent CHAR NOT NULL,
  Row_id BIGINT NOT NULL,
  FirstName VARCHAR NOT NULL,
  SecondName VARCHAR NOT NULL,
  Birthday DATE NOT NULL
);

CREATE OR REPLACE FUNCTION fnc_process_emp_audit() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO AuditEmployee (Created, TypeEvent, Row_id, FirstName, SecondName, Birthday)
            VALUES (now(), 'D', OLD.Row_id, OLD.FirstName, OLD.SecondName, OLD.Birthday);
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO AuditEmployee (Created, TypeEvent, Row_id, FirstName, SecondName, Birthday)
            VALUES (now(), 'U', OLD.Row_id, OLD.FirstName, OLD.SecondName, OLD.Birthday);
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO AuditEmployee (Created, TypeEvent, Row_id, FirstName, SecondName, Birthday)
            VALUES (now(), 'I', NEW.Row_id, NEW.FirstName, NEW.SecondName, NEW.Birthday);
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER fnc_trg_emp_audit
AFTER INSERT OR UPDATE OR DELETE ON TableNameEmployee
    FOR EACH ROW EXECUTE FUNCTION fnc_process_emp_audit();

CREATE OR REPLACE PROCEDURE delete_triggers(INOUT number_of_triggers BIGINT)
LANGUAGE plpgsql
AS $$
DECLARE
    temp record;
BEGIN
    number_of_triggers = (SELECT count(*)
                          FROM (SELECT DISTINCT trigger_name, event_object_table
                                FROM information_schema.triggers) AS temp);
    FOR temp IN (SELECT DISTINCT trigger_name, event_object_table
                 FROM information_schema.triggers)
    LOOP
        EXECUTE ('DROP TRIGGER ' || temp.trigger_name || ' ON ' || temp.event_object_table || ';');
    END LOOP;
END
$$;

CALL delete_triggers(NULL);

CREATE OR REPLACE PROCEDURE list_of_func(x varchar, result_data INOUT REFCURSOR)
LANGUAGE plpgsql
AS $$
    BEGIN OPEN result_data FOR
    (SELECT routine_name, routine_type
    FROM information_schema.routines
    WHERE routines.specific_schema = 'public'
    AND (routines.routine_type = 'PROCEDURE' OR routines.routine_type = 'FUNCTION')
    AND routines.routine_definition ~ x);
    END;
$$;

BEGIN;
CALL list_of_func('SELECT AVG','data');
FETCH ALL IN "data";
COMMIT;
END;
