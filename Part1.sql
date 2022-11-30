CREATE TABLE Peers
( 
  Nickname VARCHAR PRIMARY KEY NOT NULL,
  Birthday DATE NOT NULL
);

CREATE TABLE Tasks
(
	Title VARCHAR PRIMARY KEY NOT NULL,
	ParentTask VARCHAR CHECK(ParentTask != Title),
	MaxXP INT NOT NULL CHECK( MaxXP > 0 ),
	FOREIGN KEY (ParentTask) REFERENCES Tasks(Title)
);

CREATE TYPE Status AS ENUM ('Start', 'Success', 'Failure');

CREATE TABLE Checks(
	id BIGINT PRIMARY KEY,
	Peer VARCHAR NOT NULL ,
	Task VARCHAR NOT NULL ,
	date_of_check date NOT NULL,
	FOREIGN KEY (Peer) REFERENCES Peers(Nickname),
	FOREIGN KEY (Task) REFERENCES Tasks(Title)
);

CREATE TABLE TimeTracking (
    id  BIGINT NOT NULL,
    Peer VARCHAR NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    State INT CHECK(STATE IN (1,2)),
    FOREIGN KEY (Peer) REFERENCES Peers(Nickname)
);

CREATE TABLE Recomendations(
    id BIGINT PRIMARY KEY ,
    peer VARCHAR NOT NULL,
    RecomendedPeer VARCHAR NOT NULL,
    FOREIGN KEY (peer) REFERENCES Peers(Nickname),
    FOREIGN KEY (RecomendedPeer) REFERENCES Peers(Nickname),
    CONSTRAINT difference_recomendation CHECK(peer  != RecomendedPeer),
    CONSTRAINT unuque_recomendations UNIQUE (peer, RecomendedPeer)
);

CREATE TABLE Friends(
    id BIGINT PRIMARY KEY ,
    Peer1 VARCHAR NOT NULL,
    Peer2 VARCHAR NOT NULL,
    FOREIGN KEY (Peer1) REFERENCES Peers(Nickname),
    FOREIGN KEY (Peer2) REFERENCES Peers(Nickname),
    CONSTRAINT difference_friend CHECK ( Peer1 != Peer2 )
);

CREATE TABLE TransferredPoints(
    id BIGINT PRIMARY KEY,
    CheckingPeer VARCHAR NOT NULL,
    CheckedPeer VARCHAR NOT NULL ,
    PointsAmount INT CHECK(PointsAmount>=0),
    FOREIGN KEY (CheckingPeer) REFERENCES Peers(Nickname),
    FOREIGN KEY (CheckedPeer) REFERENCES Peers(Nickname),
    CONSTRAINT diff_checked_and_checking_peers CHECK(CheckingPeer!= CheckedPeer)
);

CREATE TABLE P2P
(
	id BIGINT PRIMARY KEY ,
	CheckID BIGINT NOT NULL ,
	CheckingPeer VARCHAR NOT NULL,
	CheckStatus Status NOT NULL,
	time_p2p time NOT NULL,
	FOREIGN KEY (CheckID) REFERENCES Checks(id),
	FOREIGN KEY (CheckingPeer) REFERENCES Peers(Nickname)
);

CREATE TABLE XP
(
    ID       BIGINT PRIMARY KEY,
    CheckID  BIGINT NOT NULL,
    XPAmount INT NOT NULL,
    FOREIGN KEY (CheckID) REFERENCES Checks (ID)
);

CREATE TABLE Verter
(
    ID BIGINT PRIMARY KEY,
    CheckID BIGINT NOT NULL,
    State Status NOT NULL,
    Time TIME NOT NULL,
    FOREIGN KEY (CheckID) REFERENCES Checks (ID)
);

CREATE OR REPLACE PROCEDURE from_csv(delim char, csvpath varchar, name varchar)
LANGUAGE plpgsql
AS $$
BEGIN
EXECUTE FORMAT('COPY '||name||' FROM %L CSV DELIMITER %L', csvpath, delim);
END
$$;

CREATE OR REPLACE PROCEDURE to_csv(delim char, csvpath varchar, name varchar)
LANGUAGE plpgsql
AS $$
BEGIN
EXECUTE FORMAT('COPY '||name||' TO %L CSV DELIMITER %L', csvpath, delim);
END
$$;

-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/Peers.csv', 'peers');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/Tasks.csv', 'tasks');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/Checks.csv', 'checks');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/P2P.csv', 'p2p');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/Verter.csv', 'verter');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/XP.csv', 'xp');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/TransferredPoints.csv', 'transferredpoints');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/TimeTracking.csv', 'timetracking');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/Friends.csv', 'friends');
-- CALL from_csv(';', '/home/esharika/SQL2_Info21_v1.0-1/src/data/Recomendations.csv', 'recomendations');