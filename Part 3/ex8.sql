CREATE OR REPLACE PROCEDURE get_last_check_duration()
LANGUAGE SQL AS
$$
WITH last_check AS (
    SELECT time_p2p
    FROM p2p
    ORDER BY checkid DESC, time_p2p DESC
    LIMIT 2
)
SELECT (max(time_p2p) - min(time_p2p))::time AS check_duration
FROM last_check
$$;

CALL get_last_check_duration();
