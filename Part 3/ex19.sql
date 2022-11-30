SELECT nickname AS peer,
       SUM(xpamount) OVER (PARTITION BY nickname) AS xp
FROM peers
         JOIN checks ON peers.nickname = checks.peer
         JOIN xp ON checks.id = xp.checkid
GROUP BY nickname, xpamount
ORDER BY XP DESC
LIMIT 1;
