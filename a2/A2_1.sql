
DELIMITER //
CREATE OR REPLACE PROCEDURE erreichbarVon(inFrom VARCHAR(5))
BEGIN
	WITH recursive fromSF AS (
		SELECT * FROM flights WHERE flights.from LIKE inFrom
		UNION
		SELECT f.* FROM flights AS f, fromSF AS s
			WHERE f.from LIKE s.to
	)

	SELECT DISTINCT(fromSF.to) FROM fromSF ;
	#SELECT DISTINCT(`to`) FROM fromSF;
END
//
CALL erreichbarVon('SF');

DELIMITER //
CREATE OR REPLACE PROCEDURE teilB()
BEGIN
WITH RECURSIVE paths (origin, cur_dest) AS (
		SELECT `from`, `from` FROM flights
	UNION 
		SELECT paths.origin, flights.to
			FROM paths
			JOIN flights
				ON paths.cur_dest = flights.from					
)
SELECT * FROM paths WHERE origin NOT LIKE cur_dest ORDER BY origin;
END
//
CALL teilB();

DELIMITER //
CREATE OR REPLACE PROCEDURE teilC()
BEGIN
WITH RECURSIVE paths (origin,cur_path, cur_dest) AS (
		SELECT `from`, CAST(`from` AS VARCHAR(60)), `from` FROM flights
	UNION 
		SELECT paths.origin, CONCAT(paths.cur_path,',',flights.to), flights.to
			FROM paths
			JOIN flights
				ON paths.cur_dest = flights.from and
					NOT FIND_IN_SET(flights.to, paths.cur_path)
)
SELECT * FROM paths WHERE cur_path NOT LIKE cur_dest;
END
//
CALL teilC();

DELIMITER //
CREATE OR REPLACE PROCEDURE teilD()
Begin
WITH RECURSIVE paths (origin,cur_path, cur_dest, cur_arr) AS (
		SELECT `from`, CONCAT(`from`,",",CAST(`to` AS VARCHAR(60))), `to`, arrives FROM flights
	UNION 
		SELECT paths.origin, CONCAT(paths.cur_path,',',flights.to), flights.to, flights.arrives
			FROM paths
			JOIN flights
				ON paths.cur_dest = flights.from and
					NOT FIND_IN_SET(flights.to, paths.cur_path) and
					((paths.cur_arr ) < flights.departs - INTERVAL 30 MINUTE)
)
SELECT origin, cur_path, cur_dest FROM paths;
END
//
CALL teilD();	
		
		