----------------------------------- Function 1
CREATE OR REPLACE PROCEDURE p2p_insert(checkedPeer_ VARCHAR, checkingPeer_ VARCHAR, taskname_ VARCHAR, state_ status, time_ time)
AS $$
DECLARE
    checkStartedP2P bigint := (SELECT COUNT(p2p.id)
                              FROM P2P JOIN checks ON P2P.checkid=checks.id
                              WHERE checkedPeer_=peer AND
                                    checkingpeer=checkingPeer_ AND
                                    taskname_ = task AND
                                    checkstatus='Start'
                              GROUP BY date_of_check,time_p2p
                              ORDER BY date_of_check DESC, time_p2p DESC
                              LIMIT 1);
    CheckIdMax bigint := (SELECT count(id) FROM checks);
    P2PIdLast bigint := (SELECT count(id) FROM p2p);
    NumStartedP2P bigint;
    NumEndedP2P bigint;
    IDCheckStart bigint;
BEGIN
    NumStartedP2P = (   SELECT COUNT(p2p.id)
                        FROM P2P JOIN checks ON P2P.checkid=checks.id
                        WHERE checkedPeer_=peer AND
                            checkingpeer=checkingPeer_ AND
                            taskname_ = task AND
                            checkstatus = 'Start');
    NumEndedP2P = (     SELECT COUNT(p2p.id)
                        FROM P2P JOIN checks ON P2P.checkid=checks.id
                        WHERE checkedPeer_=peer AND
                            checkingPeer_=checkingpeer AND
                            taskname_ = task AND
                            checkstatus != 'Start');
    IF(NumEndedP2P IS NULL) THEN NumEndedP2P=0; END IF;
    IF(NumStartedP2P IS NULL) THEN NumStartedP2P=0; END IF;
    IF (P2PIdLast IS NULL)
    THEN
        P2PIdLast=0;
    END IF;
    IF (state_='Start')
    THEN
        IF(NumStartedP2P != NumEndedP2P)
        THEN
            RAISE EXCEPTION 'Prevent check not completed!';
        END IF;
        INSERT INTO checks VALUES(CheckIdMax+1, checkedPeer_, taskname_, NOW());
        INSERT INTO P2P VALUES(P2PIdLast+1, CheckIdMax+1, checkingPeer_, state_, time_);
    ELSE
        IDCheckStart = (SELECT checks.id
                        FROM P2P JOIN checks on p2p.checkid = checks.id
                        WHERE   checkedPeer_ = peer AND
                                checkingPeer_ = checkingpeer AND
                                taskname_ = task AND
                                checkstatus = 'Start'
                        ORDER BY checks.id DESC
                        LIMIT 1);
        IF((NumStartedP2P-NumEndedP2P) <= 0)
        THEN
            RAISE EXCEPTION 'This check has not yet begun.';
        END IF;
        INSERT INTO P2P VALUES(P2PIdLast+1,IDCheckStart,checkingPeer_,state_,time_);
    END IF;
END
$$ LANGUAGE plpgsql;
-- For testing first function in part 2
/*
CALL p2p_insert('hlowell', 'jcraster', 'C2_SimpleBashUtils', 'Start', '14:32');
CALL p2p_insert('hlowell', 'jcraster', 'C2_SimpleBashUtils', 'Success', '14:32');
*/
----------------------------------- Function 2
CREATE OR REPLACE PROCEDURE insert_in_verter_table(checkedPeer_ VARCHAR, task_ VARCHAR, state_ status, time_ TIME)
AS $$
DECLARE
    LastIdOfCheck BIGINT := (SELECT id
                             FROM checks
                             WHERE  task_ = checks.task AND
                                    checkedPeer_= peer
                             ORDER BY id DESC
                             LIMIT 1);
    lastVerterId BIGINT := (SELECT MAX(id)+1 FROM verter);
BEGIN
    IF(lastVerterId IS NULL) THEN lastVerterId := 0; END IF;
    if(LastIdOfCheck IS NULL)
    THEN
        RAISE exception 'This check is not be found!';
    END IF;
    INSERT INTO verter VALUES(lastVerterId,LastIdOfCheck,state_,time_);
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
