-- Encontrar aquellos equipos que hayan ganado TODOS los premios posibles.

SELECT t.nombre, COUNT(DISTINCT p."nombrePremio") AS cantidad_premios
FROM teams t
	INNER JOIN premiocolectivo p ON t.id = p."idEquipo"
GROUP BY t.nombre
HAVING COUNT(*) = (
	SELECT COUNT(DISTINCT pc."nombrePremio")
	FROM premiocolectivo pc
)

-- Resultado
-- 	nombre			cantidad_premios
--	Warriors		3

