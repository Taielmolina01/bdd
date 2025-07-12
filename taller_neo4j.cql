Muestre en orden alfabético el nombre, apellido y posición de los primeros 10 jugadores cuyo apellido (family_name) sea “Fernández” (Obs: ‘Fernández’ con tilde)

MATCH (p:Player)
WHERE p.family_name=’Fernández’
RETURN p.given_name, p.family_name, p.position
ORDER BY p.given_name ASC
LIMIT 10


Encuentre todas las finales de la base de datos. Muestre la fecha del partido, los participantes y el resultado final.

	MATCH(m:Match)
	WHERE m.stage=’final’
	RETURN m.date, m.name, m.score

Encuentre los últimos 10 partidos jugados por la selección Argentina.

		MATCH(m:Match)
		WHERE m.name CONTAINS ‘Argentina’
		ORDER BY m.date DESC
		LIMIT 10
		RETURN m

		MATCH(m:match)-[r:IS_AWAY:IS_HOME]->[t:Team]
		WHERE t.name=’Argentina
		ORDER BY m.date DESC
		LIMIT 10
		RETURN m

Encuentre el nombre, el país y la ciudad de los estadios en los que Messi ha hecho gol.

MATCH (s:Stadium)<-[:PLAYED_AT]-(m:Match)<-[:SCORED_IN]-(p:Player)
WHERE p.family_name='Messi'
RETURN s.name, s.country, s.city

// las flechas deben ser siempre ->

Encuentre a todos los arqueros que han metido gol en contra. Indique la fecha y el partido.
		
MATCH (p:Player)-[r:SCORED_IN]->(m:Match)
WHERE p.position=’Goalkeeper’ AND r.own_goal=true
RETURN m.date, m.name
        
Encuentre a los jugadores argentinos que hicieron gol el mismo partido que hizo un gol Messi.
	
MATCH(p:Player)-[:SCORED_IN]->(m:Match)
WHERE p.family_name='Messi'
WITH m
MATCH(p2:Player)-[:SCORED_IN]->(m), (p2:Player)-[:REPRESENTS]->(t:Team)
WHERE p2.family_name<>'Messi' AND t.name='Argentina'
RETURN DISTINCT p2.family_name, p2.given_name

Encuentre todos los equipos participantes del mundial 2022 que no participaron en el mundial 2018.

MATCH(t:Team)-[:PARTICIPATES_IN]->(wc1:WorldCup)
WHERE wc1.year=2022 AND NOT EXISTS {
(t)-[:PARTICIPATES_IN]->(wc2:WorldCup)
	WHERE wc2.year=2018
}
RETURN t.name

Encuentre los jugadores finalistas del mundial 2022 que nunca jugaron un partido entrando como suplente en dicho mundial.

        MATCH (p:Player)-[:PLAYED_IN]->(m:Match)-[:PART_OF]->(wc:WorldCup)
        WHERE m.stage = 'final' AND wc.year = 2022 
        AND NOT EXISTS {
            MATCH (p)-[r:PLAYED_IN]->(m2:Match)-[:PART_OF]->(wc2:WorldCup)
            WHERE wc2.year = 2022 AND r.substitute=true
        }
        RETURN p.family_name, p.given_name

Encuentre todos los pares de equipos que se hayan enfrentado más de una vez en 
una misma edición de la Copa del Mundo. sugerencia: utilice < para distinguir
partidos/equipos para evitar duplicados

    MATCH
        (t1:Team)--(m1:Match)--(t2:Team),
        (t1)--(m2:Match)--(t2),
        (m1)-[:PART_OF]->(wc:WorldCup),
        (m2)-[:PART_OF]->(wc)
    WHERE
        m1.date < m2.date AND
        t1.team_id < t2.team_id
    RETURN 
        DISTINCT t1.name, t2.name, wc.year, m1.stage, m2.stage
    ORDER BY wc.year DESC

Encuentre el top 5 máximos goleadores históricos de los mundiales

MATCH 
    (p:Player)-[:SCORED_IN]->(:Match)
WITH p, COUNT(*) AS goals
ORDER BY goals DESC
LIMIT 5
RETURN p.family_name, p.given_name, goals

Encuentre el nombre, apellido, cantidad de partidos, cantidad de goles y
promedio de gol de los 5 jugadores con el mejor promedio de gol de los mundiales.
(sugerencia: sólo utilice partidos y goles de mundiales desde 1970)

MATCH (p:Player)-[:PLAYED_IN]->(m_played:Match)-[:PART_OF]->(wc:WorldCup)
WHERE wc.year >= 1970
WITH p, COUNT(DISTINCT m_played) AS matches

MATCH (p)-[:SCORED_IN]->(m_goals:Match)
WITH p, 
     matches, 
     COUNT(DISTINCT m_goals) AS goals, 
     TOFLOAT(COUNT(DISTINCT m_goals)) / matches AS avg_goal
ORDER BY avg_goal DESC
LIMIT 5
RETURN p.family_name, p.given_name, matches, goals, avg_goal

Encuentre al jugador más joven en haber marcado un gol.

MATCH
    (p:Player)-[s:SCORED_IN]->(m:Match)
WITH min(duration.inDays(p.birth_date, m.date).days) AS min_days

MATCH (p:Player)-[:SCORED_IN]->(m:Match)
WHERE duration.inDays(p.birth_date, m.date).days = min_days
RETURN p.family_name, p.given_name, m.name, m.date