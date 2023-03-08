CREATE OR REPLACE PROCEDURE pcd_block_statistic_11(firstblock varchar,secondblock varchar,result_data inout refcursor)
AS $$
DECLARE
    numOfPeers bigint := (SELECT count(*) FROM peers);
    index1 varchar := '1';
    index2 varchar := '1';
BEGIN
    IF(firstblock='C')
        THEN index1 ='7';
    END IF;
    IF(secondblock='C') THEN index2 ='8'; END IF;
    OPEN result_data FOR(
                WITH first AS (
                    SELECT DISTINCT
                        peer
                    FROM checks WHERE task~CONCAT(firstblock, index1)
                ), second AS(
                    SELECT DISTINCT
                        peer
                    FROM checks WHERE task~CONCAT(secondblock, index2)
                ), BothBlock AS(
                    SELECT * FROM first
                    INTERSECT
                    SELECT * FROM second
                ), DontAnyBlock AS(
                    SELECT nickname FROM peers
                    EXCEPT
                    (SELECT * FROM first
                    UNION
                    SELECT * FROM second)
                )
                SELECT
                    (SELECT count(*) FROM first)/numOfPeers::float*100 as StartedBlock1,
                    (SELECT count(*) FROM second)/numOfPeers::float*100 as StartedBlock2,
                    (SELECT count(*) FROM BothBlock)/numOfPeers::float*100 as StartedBothBlocks,
                    (SELECT count(*) FROM DontAnyBlock)/numOfPeers::float*100 as DidntStartAnyBlock
                FROM peers
                LIMIT 1);
END;
$$ LANGUAGE plpgsql;

BEGIN;
CALL pcd_block_statistic_11('A','CPP','data');
FETCH ALL IN "data";
COMMIT;
END;