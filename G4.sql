-- 1) 
-- a) Encuentre la cantidad de partidos en que Kobe Bryant marc ́o al menos 50 puntos,
-- devolviendo  ́unicamente dicha cantidad.
SELECT COUNT(DISTINCT match_id)
FROM Actions
WHERE player_name = 'Kobe Bryant' 
    AND points >= 50;

-- b) Kobe Bryant llegó a convertir 5640 puntos en los playoffs. Encuentre a aquellos ju-
-- gadores que hayan superado la marca de 5640 puntos, indicando para cada uno su
-- nombre y la cantidad de puntos que convirti ́o en playoffs. 

SELECT a.player_name, SUM(a.points) AS total_points
FROM actions a
    INNER JOIN Matches m ON m.match_id = a.match_id 
WHERE m.stage_name = 'Playoffs'
GROUP BY a.player_name
HAVING SUM(a.points) > 5640;

-- c) Encuentre la cantidad de puntos que marcó Kobe Bryant en el ultimo partido oficial
-- que jugó, indicando el nombre del equipo local, el nombre del equipo visitante y la
-- cantidad de puntos marcados por Kobe.

SELECT a.points, m.local_team, m.visiting_team
FROM actions a 
    INNER JOIN Matches m ON m.match_id = a.match_id
WHERE a.player_name = 'Kobe Bryant'
    AND a.match_id = (
        SELECT MAX(m2.date)
        FROM matches m2
            INNER JOIN actions a2 ON m2.match_id = a2.match_id
        WHERE a2.player_name = 'Kobe Bryant'
    )

-- 2) Considere las siguientes tablas que almacenan información sobre los distintos
-- circuitos de Fórmula 1®, las carreras que se corrieron en cada uno de ellos a lo largo de los
-- años, los pilotos que han participado de cada carrera y las escuderías a las que pertenecían,
-- y el tiempo que cada piloto ha marcado en cada vuelta que logró terminar:
--
-- - Circuitos(nombre_circuito, ciudad, país)
-- - Carreras(nombre_circuito, temporada)
-- - Pilotos(nombre_piloto, fecha_nacimiento, nacionalidad)
-- - Participación(nombre_piloto, nombre_circuito, temporada)
-- - EscuderíasPilotos(nombre_piloto, temporada, escudería)
-- - Timings(nombre_piloto, nombre_circuito, temporada, nro_vuelta, tiempo)
--
-- Escriba una consulta SQL que encuentre para cada circuito cuál fue la escudería que
-- logró marcar el tiempo de vuelta histórico más corto, indicando el nombre del circuito y
-- el nombre de la escudería que posee dicho récord de tiempo de vuelta. Si varias escuderías
-- ostentan el mismo récord, devuelva una línea por cada una, pero no devuelva más de una
-- vez a la misma escudería para un mismo circuito.

SELECT t.nombre_circuito, ep.escudería
FROM Timings TABLE
    INNER JOIN EscuderíasPilotos ep ON t.nombre_piloto = ep.nombre_piloto AND t.temporada = ep.temporada
WHERE (t.nombre_circuito, t.tiempo) IN (
    SELECT nombre_circuito, MIN(tiempo) AS tiempo
    FROM Timings
    GROUP BY nombre_circuito
)
GROUP BY t.nombre_circuito, ep.escudería;

-- 5) (Consultas - Investigadores) Considerando los siguientes esquemas de relaciones:
-- - Facultades(código, nombre)
-- - Investigadores(DNI, nombre, facultad)
-- - Reservas(DNI, num_serie, comienzo, fin)
-- - Equipos(num_serie, nombre, facultad)
-- Traduzca las siguientes consultas al lenguaje SQL:
    -- a) Obtener el DNI y nombre de aquellos investigadores que han realizado más de una
    -- reserva.
    -- b) Obtener un listado completa de reservas, incluyendo los siguientes datos:
    -- - DNI y nombre del investigador, junto con el nombre de su facultad.
    -- - Número de serie y nombre del equipo reservado, junto con el nombre de la facultad
    --   a la que pertenece.
    -- - Fecha de comienzo y fin de la reserva.
    -- c) Obtener el DNI y el nombre de los investigadores que han reservado equipos que no
    -- son de su facultad.
    -- d) Obtener los nombres de las facultades en las que ningún investigador ha realizado una
    -- reserva.
    -- e) Obtener los nombres de las facultades con investigadores ‘ociosos’ (investigadores que
    -- no han realizado ninguna reserva).
    -- f ) Obtener el n ́umero de serie y nombre de los equipos que nunca han sido reservados.

-- a)

SELECT i.DNI, i.nombre
FROM Investigadores i
    INNER JOIN Reservas r ON r.DNI = i.DNI
GROUP BY i.DNI, i.nombre
HAVING COUNT(r.DNI, r.num_serie, r.comienzo) >= 1

-- b)

SELECT i.DNI, 
                i.nombre AS nombre_investigador, 
                i.facultad AS facultad_investigador, 
                e.num_serie, 
                e.nombre AS nombre_equipo, 
                e.facultad AS facultad_equipo,
                r.comienzo, 
                r.fin
FROM Investigadores i
    INNER JOIN Reservas r ON i.DNI = r.DNI
    INNER JOIN Equipos e ON r.num_serie = e.num_serie

-- c)

SELECT DISTINCT i.DNI, i.nombre
FROM Investigadores i
    INNER JOIN Reservas r ON i.DNI = r.DNI
    INNER JOIN Equipos e ON r.num_serie = e.num_serie AND e.facultad <> i.facultad

-- d)

SELECT f.nombre
FROM Facultades f
    INNER JOIN Investigadores i ON i.facultad = f.código
    INNER JOIN Reservas r ON r.DNI < i.DNI

-- Está mal porque estoy mirando dnis que sean distintos a los una row de reserva 
-- no implica que nunca hayan hecho una reserva

SELECT f.nombre
FROM Facultades f
    INNER JOIN Investigadores i ON i.facultad = f.código
WHERE i.facultad NOT IN (
    SELECT DISTINCT i2.facultad
    FROM Investigadores i2
    INNER JOIN Reservas r ON r.DNI = i2.DNI
)

-- e)

SELECT DISTINCT f.nombre
FROM Facultades f
    INNER JOIN Investigadores i ON i.facultad = f.código
    LEFT JOIN Reservas r ON i.DNI = r.DNI
WHERE r.DNI IS NULL;

-- f) 

SELECT e.num_serie, e.nombre
FROM Equipos e
    LEFT JOIN Reservas r ON e.num_serie = r.num_serie
WHERE r.num_serie IS NULL;

-- (Histograma) Una heladería almacena información sobre sus clientes, las ventas que rea-
-- liza, y los gustos pedidos en cada venta.

-- - Clientes(nro_cliente, nombre, domicilio)
-- - Ventas(nro_factura, fecha, nro_cliente, monto)
-- - Degustación(nro_factura, gusto)

-- A la heladería le interesa saber si sus clientes son propensos a probar gustos variados,
-- o si en general se aferran cada uno a unos pocos gustos. Para ello se desea construir un
-- histograma que indique para cada número entero positivo i la cantidad de clientes que
-- han probado i gustos distintos desde el 1 de enero de este año. Se pide:
-- a) Escriba una consulta en SQL que construya una vista NroGustosPorCliente(nro_cliente,
-- nro_gustos) que para cada cliente que probó algún gusto desde el 1 de enero de 2017
-- devuelva el número de cliente y la cantidad de gustos distintos que probó.

-- b) A partir de la vista anterior, escriba una consulta en SQL que devuelva, para cada
-- número entero positivo i, la cantidad de clientes que probó esa cantidad de gustos
-- distintos desde el 1 de enero de 2017.

-- Nota: Omitiremos los i para los cuales la cantidad de clientes es cero.

-- a)

CREATE VIEW NroGustosPorCliente AS
SELECT v.nro_cliente AS nro_cliente, COUNT(DISTINCT d.gusto) AS nro_gustos
FROM Ventas v 
    INNER JOIN Degustación d ON v.nro_factura = d.nro_factura
WHERE YEAR(v.fecha) > 2016
GROUP BY v.nro_cliente

-- b)

SELECT nro_gustos, COUNT(nro_cliente) AS cantidad_clientes
FROM NroGustosPorCliente
GROUP BY nro_gustos

-- 5) (Suma de matrices ralas) Una base de datos guarda una matriz cuadrada rala A de grandes
-- dimensiones a trav ́es de una tabla A(i, j, v), en donde los atributos i y j identifican al
-- elemento (i, j) de la matriz, mientras que v representa su valor, aij . La tabla s ́olo almacena
-- aquellas posiciones para las cuales el valor aij es no nulo.
-- Escriba una consulta en lenguaje SQL que devuelva como resultado una tabla B(i, j, v)
-- que represente, con el mismo formato, a la matriz B que resulta de elevar A al cuadrado
-- (es decir, B = A2 = A · A). S ́olo almacene aquellas posiciones para las cuales el valor bij
-- es no nulo. En el Cuadro 1 encontrar ́a un peque ̃no ejemplo ilustrativo.

-- 6) (Club de golf ) Un club de golf mantiene en una base de datos un registro de todos sus ho-
-- yos, las personas afiliadas al club, las distintas partidas jugadas entre ellas y la puntuaci ́on
-- de cada jugador para cada hoyo en cada una de las partidas:
-- - Hoyos(nro hoyo, h ́andicap, par)
-- - Socios(nro socio, apellido, nombre)
-- - Partidas(cod partida, fecha, hora)
-- - JugadoresPartidas(cod partida, nro socio)
-- - Puntuaciones(cod partida, nro hoyo, nro socio, puntuaci ́on)
-- Escriba una consulta SQL que liste el n ́umero de socio, apellido y nombre de las personas
-- que hayan logrado alguna vez realizar al menos 3 birdies en una misma partida. Se dice
-- que una persona realiza un birdie cuando obtiene una puntuaci ́on 1 unidad menor al par
-- del hoyo (por ejemplo, si un hoyo tiene par 4 y el jugador lo completa en 3 golpes).
-- Nota: En una partida de golf pueden jugar entre dos y cuatro personas, cada una de las cuales deber ́a
-- completar una cantidad de hoyos (generalmente 9  ́o 18). Cada hoyo de un campo de golf posee un par
-- predeterminado –que es la cantidad de golpes esperada en que un profesional meter ́ıa la pelota en dicho
-- hoyo– y un h ́andicap predeterminado que mide la dificultad. Para cada persona y cada hoyo se registra la
-- puntuaci ́on obtenida en la partida, definida como la cantidad de golpes realizados por la persona hasta
-- meter la pelota en ese hoyo.

SELECT s.nro_socio, s.apellido, s.nombre
FROM Socios s
WHERE s.nro_socio IN (
    SELECT p.nro_socio
    FROM Puntuaciones p
        INNER JOIN Hoyos h ON h.Nro_hoyo = p.nro_hoyo
    WHERE p.puntuacion = h.par - 1
    GROUP BY p.nro_socio, p.cod_partida
    HAVING COUNT(*) >= 3
)

-- 7) (Subconsultas correlacionadas) Dadas las siguientes relaciones que guardan informaci ́on
-- sobre los alumnos de una facultad y sus calificaciones:
-- Alumnos(padr ́on, apellido, nombre)
-- Notas(padr ́on, materia, fecha, nota)

-- Considere la siguiente consulta SQL que busca para cada alumno su mejor nota hist ́ori-
-- ca:

-- SELECT DISTINCT a.padron, a.apellido, a.nombre, n.nota as mejor_nota
-- FROM Alumnos a, Notas n
-- WHERE a.padron = n.padron
-- AND n.nota >= ALL (SELECT n2.nota

-- FROM Alumnos a2, Notas n2
-- WHERE a2.padron=a.padron AND a2.padron=n2.padron);
-- Esta consulta incluye una subconsulta correlacionada (es decir, que hace referencia a

-- atributos de las tablas de la consulta externa). T ́ıpicamente la existencia de una sub-
-- consulta correlacionada genera un mayor costo de procesamiento porque la misma debe

-- reejecutarse para cada una de las tuplas obtenidas en la consulta externa, a menos que el
-- motor de base de datos logre optimizar la ejecuci ́on para evitarlo.

-- Escriba una consulta SQL equivalente a la anterior, que no contenga subconsultas co-
-- rrelacionadas.