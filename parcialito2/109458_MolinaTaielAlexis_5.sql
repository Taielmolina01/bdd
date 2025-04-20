-- Se necesita saber los equipos que hicieron menor cantidad de puntos siendo
-- locales, para el año 2018. Devolviendo la fecha del partido, el nombre del equipo
-- y la cantidad de puntos.

SELECT p.fecha, t.nombre, p."puntosLocal"
FROM teams t
	INNER JOIN partido p ON t.id = p."idEquipoLocal"
WHERE SUBSTRING(p.fecha FROM 1 FOR 4) = '2018' AND p."puntosLocal" = (
	SELECT MIN(p."puntosLocal")
	FROM partido p
	WHERE SUBSTRING(p.fecha FROM 1 FOR 4) = '2018'
);

-- RESULTADO
-- fecha		nombre		puntosLocal
-- 2018-12-08		Bulls		77

