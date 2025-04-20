-- Obtener el id del jugador, nombre, apellido y su estatura, para los cuales
-- realizaron más de 150 puntos y tienen un promedio de asistencias de al menos 8

SELECT j."idPersona", p.nombre, p.apellido, j.estatura
FROM personas p 
	INNER JOIN jugador j ON p.id = j."idPersona"
	INNER JOIN juegapartido j2 ON p.id = j2."idJugador"
GROUP BY j."idPersona", p.nombre, p.apellido, j.estatura
HAVING SUM(j2.puntos) > 150 AND AVG(j2.asistencias) > 8;

-- Resultado
-- 	idPersona		nombre		apellido		estatura
--	201935			James		Harden			195.58
--	201566			Russell		Westbrook		190.5
--	1629027			Trae		Young			185.42

