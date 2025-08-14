
COPY Evento (periodo, nombre)
FROM '/tmp/evento.csv' 
DELIMITER ',' 
CSV HEADER;

COPY Competicion (periodoEvento, nombreEvento)
FROM '/tmp/competicion.csv'
DELIMITER ','
CSV HEADER;

COPY Exhibicion (periodoEvento, nombreEvento, ciudad, estado, pais)
FROM '/tmp/exhibicion.csv'
DELIMITER ','
CSV HEADER;

COPY Equipo (id, nombre, ciudad, estado, estadio, pais, fechaFundacion, conferencia)
FROM '/tmp/teams.csv'
DELIMITER ','
CSV HEADER;

COPY Persona (id, nombre, apellido, fechaNacimiento, nacionalidad)
FROM '/tmp/personas.csv'
DELIMITER ','
CSV HEADER;

COPY Jugador (idPersona, estatura, peso, manoHabil)
FROM '/tmp/jugador.csv'
DELIMITER ','
CSV HEADER;

COPY JugadorPosicion (idPersona, posicion)
FROM '/tmp/jugadorPosicion.csv'
DELIMITER ','
CSV HEADER;

COPY Entrenador (idPersona, seleccion)
FROM '/tmp/entrenadores.csv'
DELIMITER ','
CSV HEADER;

COPY Premio (periodoEvento, nombreEvento, nombre)
FROM '/tmp/premio.csv'
DELIMITER ','
CSV HEADER;

COPY premioindividual (periodoevento, nombreevento, nombrepremio, idpersona)
FROM '/tmp/premioIndividual.csv'
DELIMITER ','
CSV HEADER;

COPY premiocolectivo (periodoevento, nombreevento, nombrepremio, idequipo)
FROM '/tmp/premioColectivo.csv'
DELIMITER ','
CSV HEADER;

COPY partido (id, periodocompeticion, nombrecompeticion, idequipolocal, idequipovisitante, fecha, puntoslocal, puntosvisitante, instancia)
FROM '/tmp/partido.csv'
DELIMITER ','
CSV HEADER;

COPY JuegaPartido (idJugador, idPartido, puntos, asistencias, tapones, rebotes, robos, porcentajeTirosLibres, porcentajeTirosCampo, porcentajeTriples)
FROM '/tmp/juegaPartido.csv'
DELIMITER ','
CSV HEADER;

COPY DrafteaJugador (idJugador, idEquipo, anio, posicionDraft)
FROM '/tmp/DrafteaJugador.csv'
DELIMITER ','
CSV HEADER;

COPY JugadorParticipaCompeticion (periodoCompeticion, nombreCompeticion, idEquipo, idJugador)
FROM '/tmp/JugadorParticipaCompeticion.csv'
DELIMITER ','
CSV HEADER;

COPY JugadorParticipaExhibicion (periodoExhibicion, nombreExhibicion, idJugador, participaTriples, participaDunk, participaSkills, equipoRepresentado)
FROM '/tmp/jugadorParticipaExhibicion.csv'
DELIMITER ','
CSV HEADER;


COPY EntrenadorParticipaCompeticion (periodoCompeticion, nombreCompeticion, idEquipo, idEntrenador)
FROM '/tmp/EntrenadorParticipaCompeticion.csv'
DELIMITER ','
CSV HEADER;
