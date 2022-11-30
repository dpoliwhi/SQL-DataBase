CURRENT_PATH=$(pwd)
touch loaderData.sql
{
    echo "CALL from_csv(';', '$CURRENT_PATH/data/Peers.csv', 'peers');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/Tasks.csv', 'tasks');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/Checks.csv', 'checks');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/P2P.csv', 'p2p');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/Verter.csv', 'verter');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/XP.csv', 'xp');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/TransferredPoints.csv', 'transferredpoints');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/TimeTracking.csv', 'timetracking');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/Friends.csv', 'friends');"
    echo "CALL from_csv(';', '$CURRENT_PATH/data/Recomendations.csv', 'recomendations');"
} > loaderData.sql
psql -d postgres -U postgres < Part1.sql
psql -d postgres -U postgres < loaderData.sql
rm -f loaderData.sql