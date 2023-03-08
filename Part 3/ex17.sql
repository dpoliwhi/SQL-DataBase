CREATE OR REPLACE FUNCTION fnc_get_successful_days(n int)
    RETURNS TABLE (Date date) AS
$$
DECLARE
    counter       int  := 0;
    previousDate  date := (SELECT MIN(date_of_check)
                           FROM checks);
    value         record;
    checkDay      bool := FALSE;
    cur CURSOR FOR (SELECT p2p.checkstatus AS status,
                           c.date_of_check AS date
                    FROM p2p
                             JOIN checks c ON c.id = p2p.checkid
                             JOIN xp x ON c.id = x.checkid
                             JOIN tasks t ON c.task = t.title
                    WHERE checkstatus != 'Start'
                      AND xpamount >= maxxp * 0.8
                    ORDER BY date_of_check);
BEGIN
    FOR value IN cur
        LOOP
            IF value.date != previousDate THEN
                counter = 0;
                checkDay = FALSE;
            END IF;
            IF checkDay = TRUE THEN
                previousDate = value.date;
                CONTINUE;
            END IF;
            IF value.status = 'Success' THEN
                counter = counter + 1;
                IF counter = n THEN
                    counter = 0;
                    Date = value.date;
                    checkDay = TRUE;
                    RETURN NEXT;
                END IF;
            ELSE
                counter = 0;
            END IF;
            previousDate = value.date;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE get_successful_days(result_data INOUT REFCURSOR, n int) AS
$$
BEGIN
    OPEN result_data FOR
        ( SELECT *
FROM fnc_get_successful_days(n)
);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE get_successful_days(result_data INOUT REFCURSOR, n int) AS
$$
BEGIN
    OPEN result_data FOR
        ( SELECT *
FROM fnc_get_successful_days(n)
);
END;
$$ LANGUAGE plpgsql;
