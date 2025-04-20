-- Encontrar el apellido, nombre, y promedio de porcentaje de tiros de campo de
-- todos los jugadores que tienen un porcentaje de tiros de campo mayor a 0.3 en
-- TODOS sus partidos.

SELECT 
	p.apellido, 
	p.nombre, 
	AVG(jp."porcentajeTirosCampo") AS promedio_porcentaje_tiros_campo
FROM personas p
	INNER JOIN jugador j ON p.id = j."idPersona"
	INNER JOIN juegapartido jp ON j."idPersona" = jp."idJugador"
GROUP BY p.id, p.apellido, p.nombre
HAVING COUNT(*) = (
	SELECT COUNT(*)
	FROM juegapartido jp2
	WHERE jp2."idJugador" = p.id AND 
	jp2."porcentajeTirosCampo" > 0.3
	)
	
-- Resultados --
	
-- apellido		nombre		promedio_porcentaje_tiros_campo
-- Rodriguez		Angel		0.5
-- Ford			Jordan		0.5
-- Booth		Phil		0.41100000341733295
-- Brown		Bryce		0.3330000042915344
-- Pargo		Jeremy		0.4816666742165883

