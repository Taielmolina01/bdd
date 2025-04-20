-- Encontrar periodo de competición, nombre de equipo 
-- y cantidad de entrenadores. Devolviendo los 10 primeros equipos
-- que más entrenadores tuvieron por período. Además en caso de 
-- empate, por orden alfabetico del nombre del equipo.

SELECT t.nombre, epc."periodoCompeticion", COUNT(DISTINCT epc."coachId") AS cantidad_entrenadores
FROM entrenadorParticipaCompeticion epc
	INNER JOIN teams t ON t.id = epc."teamId"
GROUP BY t.nombre, epc."periodoCompeticion"
ORDER BY cantidad_entrenadores DESC, t.nombre ASC
LIMIT 10;

-- Resultado 

-- nombre			periodoCompeticion		cantidad_entrenadores
-- Bulls			2018 - 2019				2
-- Cavaliers			2018 - 2019				2
-- Cavaliers			2019 - 2020				2
-- Hawks			2020 - 2021				2
-- Kings			2021 - 2022				2
-- Knicks			2019 - 2020				2
-- Nets				2019 - 2020				2
-- Timberwolves			2020 - 2021				2
-- Timberwolves			2018 - 2019				2
-- 76ers			2020 - 2021				1
