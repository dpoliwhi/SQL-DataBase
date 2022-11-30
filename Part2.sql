----------------------------------- Function 1
CREATE PROCEDURE p2p_insert(checkedPeer_ VARCHAR, checkingPeer_ VARCHAR, taskname_ VARCHAR, state_ status, time_ time)
AS $$
DECLARE
    numP2PCheckForPeer bigint := (   SELECT count(P2P.id)
                                FROM P2P JOIN checks ON P2P.checkid=checks.id
                                WHERE   checkedPeer_ = peer AND
                                        taskname_ = task AND
                                        checkstatus = 'Start') % 3;
    findStartForP2PCheck bigint;  /*поиск начала P2P проверки*/
    idOfCheck bigint;     /*Id последней проверки для пары checkedPeer and task name*/
    numOfChecks bigint;
    lastIdP2PCheck bigint := (SELECT MAX(id) FROM p2p);
    numIdP2PCheck bigint;
BEGIN
    if(lastIdP2PCheck is NULL)
    THEN
        lastIdP2PCheck=0;
    END IF;
    IF (state_ = 'Start')
    THEN
        IF (numP2PCheckForPeer = 0)
        THEN
            IF ((SELECT MAX(checks.id) FROM checks) IS NULL)
            THEN
                numOfChecks:= 0;
            ELSE
                numOfChecks := (SELECT MAX(checks.id) FROM checks);
            END IF;
            INSERT INTO checks VALUES(numOfChecks+1,checkedPeer_,taskname_, NOW());
        END IF;
        idOfCheck := (    SELECT id
                          FROM checks
                          WHERE checkedPeer_ = peer AND
                                taskname_ = task
                          ORDER BY date_of_check  DESC, id DESC
                          LIMIT 1);
        numIdP2PCheck :=  ( SELECT count(checkid)
                            FROM P2P JOIN checks ON P2P.checkid=checks.id
                            WHERE   checkingpeer=checkingPeer_ AND
                                    checkedPeer_ = peer AND
                                    taskname_ = task AND
                                    checkstatus = 'Start' AND
                                    checkid = idOfCheck);
        IF(numIdP2PCheck != 0)
        THEN
            RAISE EXCEPTION 'You have already been checked by this peer!';
        END IF;
        INSERT INTO P2P VALUES(lastIdP2PCheck+1,idOfCheck,checkingPeer_,state_,time_);
    ELSE
        IF(numP2PCheckForPeer = 0)
        THEN
            RAISE EXCEPTION 'This check has not yet begun.';
        END IF;
        findStartForP2PCheck :=  (  SELECT checkid
                                    FROM P2P JOIN checks ON P2P.checkid=checks.id
                                    WHERE   checkingpeer=checkingPeer_ AND
                                            checkedPeer_ = peer AND
                                            taskname_ = task AND
                                            checkstatus = 'Start'
                                    ORDER BY date_of_check DESC, P2P.checkid DESC
                                    LIMIT 1);
        IF(findStartForP2PCheck IS NULL)    /* Если эта проверка началась */
        THEN
            RAISE EXCEPTION 'This check has not yet begun.';
        END IF;
        INSERT INTO P2P VALUES(lastIdP2PCheck+1,findStartForP2PCheck,checkingPeer_,state_,time_);
    END IF;
END
$$ LANGUAGE plpgsql;
-- For testing first function in part 2
/*
CALL p2p_insert('hlowell', 'adough', 'D1_Linux', 'Start', '14:32');
CALL p2p_insert('hlowell', 'adough', 'D1_Linux', 'Success', '14:32');
CALL p2p_insert('hlowell', 'jcraster', 'D1_Linux', 'Start', '14:32');
CALL p2p_insert('hlowell', 'jcraster', 'D1_Linux', 'Success', '14:32');
CALL p2p_insert('hlowell', 'phawkgir', 'D1_Linux', 'Start', '14:32');
CALL p2p_insert('hlowell', 'phawkgir', 'D1_Linux', 'Success', '14:32');

DELETE FROM P2P
WHERE id>=0;
DELETE FROM checks
WHERE id>=0;*/
----------------------------------- Function 2
CREATE OR REPLACE PROCEDURE insert_in_verter_table(checkedPeer_ VARCHAR, task_ VARCHAR, state_ status, time_ TIME)
AS $$
DECLARE
    LastIdOfCheck BIGINT := (SELECT id
                             FROM checks
                             WHERE  task_ = checks.task AND
                                    checkedPeer_= peer
                             ORDER BY date_of_check DESC
                             LIMIT 1);
    lastVerterId BIGINT := (SELECT MAX(id)+1 FROM verter);
BEGIN
    IF(lastVerterId IS NULL)
    THEN
        lastVerterId := 0;
    END IF;
    if(LastIdOfCheck IS NULL)
    THEN
        RAISE exception 'This check is not be found!';
    ELSE
        INSERT INTO verter VALUES(lastVerterId,LastIdOfCheck,state_,time_);
    end if;
END;
$$LANGUAGE plpgsql;
-- For testing second function in part 2
/*
CALL insert_in_verter_table('hlowell', 'D1_Linux', 'Start', '14:44');

DELETE FROM verter
WHERE id>=0

 */

----------------------------------- Trigger  1

CREATE OR REPLACE FUNCTION fnc_trg_add_to_TransferredPoints()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.checkstatus = 'Start'
    THEN
        UPDATE transferredpoints
        SET pointsamount = pointsamount + 1
        WHERE checkingpeer = new.checkingpeer
          AND checkedpeer = (SELECT peer FROM checks WHERE id = new.checkid);
    END IF;
    RETURN new;
END
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_p2p_insert
    AFTER INSERT
    ON P2P
    FOR EACH ROW
EXECUTE PROCEDURE fnc_trg_add_to_TransferredPoints();

----------------------------------- Trigger  2

CREATE OR REPLACE FUNCTION fnc_trg_check_xp_amount()
    RETURNS TRIGGER AS $$
DECLARE
    P2PCheckFailure BIGINT:= (SELECT count(id) FROM p2p WHERE checkid=new.checkid AND checkstatus = 'Success');
    VerterCheckFailure BIGINT:= (SELECT count(id) FROM verter WHERE checkid=new.checkid AND state = 'Success');
    MaxXP BIGINT := (SELECT maxxp FROM checks JOIN tasks t on checks.task = t.title WHERE checks.id=new.id);
BEGIN
    IF(P2PCheckFailure IS NOT NULL)
    THEN
        RAISE exception 'P2P is not success';
    END IF;
    IF(VerterCheckFailure IS NOT NULL)
    THEN
        RAISE exception 'Vertex check is not success';
    END IF;
    IF(new.xpamount > MaxXP)
    THEN
        RAISE exception 'xp amount more than maxXP';
    END IF;
    return new;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_xp_insert
    BEFORE INSERT
    ON XP
    FOR EACH ROW
EXECUTE PROCEDURE fnc_trg_check_xp_amount();
