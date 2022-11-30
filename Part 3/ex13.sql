WITH list_peer_birth_and_check_ AS (
        SELECT *
        FROM peers
        JOIN checks ON peers.nickname = checks.peer
        WHERE EXTRACT(DAY FROM peers.birthday) = EXTRACT(DAY FROM checks.date_of_check)
          AND EXTRACT(MONTH FROM peers.birthday) = EXTRACT(MONTH FROM checks.date_of_check)
), count_succes_peer AS (
        SELECT COUNT(DISTINCT l.id)::float as count_succes
        FROM list_peer_birth_and_check_ AS l
        JOIN checks  ON l.nickname = checks.peer
        JOIN p2p ON l.id = p2p.checkid
        JOIN verter v ON l.id = v.checkid
        WHERE p2p.checkstatus = 'Success'
          AND v.state = 'Success'
), count_failer_peer AS (
        SELECT COUNT(DISTINCT list_peer_birth_and_check_.id)::float AS count_fail
        FROM list_peer_birth_and_check_
        JOIN checks ON list_peer_birth_and_check_.nickname = checks.peer
        JOIN p2p ON list_peer_birth_and_check_.id = p2p.checkid
        JOIN verter ON list_peer_birth_and_check_.id = verter.checkid
        WHERE p2p.checkstatus = 'Failure'
          AND verter.state = 'Failure'
)

SELECT count_succes / (count_fail + count_succes)::NUMERIC * 100 AS SuccessfulChecks,
       count_fail / (count_fail + count_succes)::NUMERIC * 100 AS UnSuccessfulChecks
FROM count_succes_peer, count_failer_peer;
