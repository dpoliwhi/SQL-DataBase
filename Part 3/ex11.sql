        SELECT DISTINCT *
        FROM checks
        WHERE task~CONCAT('CPP', '1') OR task~CONCAT('A', '1')