-- Encontrar a todos los jugadores que hayan jugado
-- en la temporada '18-19 y 20-21' pero no en la 19-20 ni en la 21-22

SELECT p.apellido, p.nombre, p.id
FROM personas p
  INNER JOIN jugador j ON p.id = j."idPersona" 
  LEFT JOIN jugadorparticipacompeticion jpc ON j."idPersona" = jpc."idJugador"
GROUP BY p.id, p.apellido, p.nombre
HAVING 
  SUM(CASE WHEN jpc."periodoCompeticion" IN ('2018 - 2019', '2020 - 2021') THEN 1 ELSE 0 END) = 2
  AND
  SUM(CASE WHEN jpc."periodoCompeticion" IN ('2019 - 2020', '2021 - 2022') THEN 1 ELSE 0 END) = 0

-- Resultado --

-- apellido 		nombre		id
-- Alkins		Rawle		1628959
-- Anigbogu		Ike		1628387
-- Edwards		Vincent		1629053
-- Nunnally		James		203263
