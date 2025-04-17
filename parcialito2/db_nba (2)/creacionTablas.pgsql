
DROP TABLE IF EXISTS EntrenadorParticipaCompeticion CASCADE;
DROP TABLE IF EXISTS JugadorParticipaExhibicion CASCADE;
DROP TABLE IF EXISTS JugadorParticipaCompeticion CASCADE;
DROP TABLE IF EXISTS DrafteaJugador CASCADE;
DROP TABLE IF EXISTS JuegaPartido CASCADE;
DROP TABLE IF EXISTS Partido CASCADE;
DROP TABLE IF EXISTS PremioColectivo CASCADE;
DROP TABLE IF EXISTS PremioIndividual CASCADE;
DROP TABLE IF EXISTS Premio CASCADE;
DROP TABLE IF EXISTS Entrenador CASCADE;
DROP TABLE IF EXISTS JugadorPosicion CASCADE;
DROP TABLE IF EXISTS Jugador CASCADE;
DROP TABLE IF EXISTS Persona CASCADE;
DROP TABLE IF EXISTS Equipo CASCADE;
DROP TABLE IF EXISTS Exhibicion CASCADE;
DROP TABLE IF EXISTS Competicion CASCADE;
DROP TABLE IF EXISTS Evento CASCADE;


CREATE TABLE Evento (
    periodo VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pkEvento PRIMARY KEY (periodo, nombre )
);
CREATE TABLE Competicion (
    periodoEvento VARCHAR(100) NOT NULL,
    nombreEvento VARCHAR(100) NOT NULL,
    CONSTRAINT pkCompeticion PRIMARY KEY (periodoEvento, nombreEvento),
    CONSTRAINT fkCompeticionEvento FOREIGN KEY (periodoEvento, nombreEvento)
        REFERENCES Evento(periodo, nombre) ON DELETE CASCADE
);
CREATE TABLE Exhibicion (
    periodoEvento VARCHAR(100) NOT NULL,
    nombreEvento VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100),
    estado VARCHAR(100),
    pais VARCHAR(100),
    CONSTRAINT pkExhibicion PRIMARY KEY (periodoEvento, nombreEvento),
    CONSTRAINT fkExhibicionEvento FOREIGN KEY (periodoEvento, nombreEvento)
        REFERENCES Evento(periodo, nombre) ON DELETE CASCADE
);
CREATE TABLE Equipo (
    id INTEGER NOT NULL,
    nombre VARCHAR(100),
    ciudad VARCHAR(100), 
    estado VARCHAR(100),
    estadio VARCHAR(100),
    pais VARCHAR(100), 
    fechaFundacion INTEGER,
    conferencia VARCHAR(50),
    CONSTRAINT pkEquipo PRIMARY KEY (id),
    CONSTRAINT chkConferencia CHECK (conferencia IN ('Eastern', 'Western'))
);
CREATE TABLE Persona (
    id INTEGER NOT NULL,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    fechaNacimiento DATE,  
    nacionalidad VARCHAR(100), 
    CONSTRAINT pkPersona PRIMARY KEY (id)
);
CREATE TABLE Jugador (
    idPersona INTEGER NOT NULL, 
    estatura DECIMAL(5, 2), -- (5,2) significa 
    peso DECIMAL(5, 2),  
    manoHabil VARCHAR(10),  
    CONSTRAINT pkJugador PRIMARY KEY (idPersona), 
    CONSTRAINT fkJugadorPersona FOREIGN KEY (idPersona)
        REFERENCES Persona(id) ON DELETE CASCADE
);
CREATE TABLE JugadorPosicion (
    idPersona INTEGER NOT NULL,
    posicion VARCHAR(50),
    CONSTRAINT pkJugadorPosicion PRIMARY KEY (idPersona, posicion),
    CONSTRAINT fkJugadorPosicionJugador FOREIGN KEY (idPersona)
        REFERENCES Jugador(idPersona) ON DELETE CASCADE
);
CREATE TABLE Entrenador (
    idPersona INTEGER NOT NULL, 
    seleccion VARCHAR(100),
    CONSTRAINT pkEntrenador PRIMARY KEY (idPersona),
    CONSTRAINT fkEntrenadorPersona FOREIGN KEY (idPersona)
        REFERENCES Persona(id) ON DELETE CASCADE
);
CREATE TABLE Premio (
    periodoEvento VARCHAR(100) NOT NULL,
    nombreEvento VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pkPremio PRIMARY KEY (periodoEvento, nombreEvento, nombre),
    CONSTRAINT fkPremioEvento FOREIGN KEY (periodoEvento, nombreEvento)
        REFERENCES Evento(periodo, nombre) ON DELETE CASCADE
);

CREATE TABLE PremioIndividual (
    periodoEvento VARCHAR(100) NOT NULL,
    nombreEvento VARCHAR(100) NOT NULL,
    nombrePremio VARCHAR(100) NOT NULL,
    idPersona INTEGER NOT NULL,
    CONSTRAINT pkPremioIndividual PRIMARY KEY (periodoEvento, nombreEvento, nombrePremio, idPersona),

    CONSTRAINT fkPremioIndividualPremio FOREIGN KEY (periodoEvento, nombreEvento, nombrePremio)
        REFERENCES Premio(periodoEvento, nombreEvento, nombre) ON DELETE CASCADE,
    CONSTRAINT fkPremioIndividualPersona FOREIGN KEY (idPersona)
        REFERENCES Persona(id) ON DELETE CASCADE
);
CREATE TABLE PremioColectivo (
    periodoEvento VARCHAR(100) NOT NULL,
    nombreEvento VARCHAR(100) NOT NULL,
    nombrePremio VARCHAR(100) NOT NULL,
    idEquipo INTEGER NOT NULL,
    CONSTRAINT pkPremioColectivo PRIMARY KEY (periodoEvento, nombreEvento, nombrePremio),
    CONSTRAINT fkPremioColectivoPremio FOREIGN KEY (periodoEvento, nombreEvento, nombrePremio)
        REFERENCES Premio(periodoEvento, nombreEvento, nombre) ON DELETE CASCADE,
    CONSTRAINT fkPremioColectivoEquipo FOREIGN KEY (idEquipo)
        REFERENCES Equipo(id) ON DELETE SET NULL
);
CREATE TABLE Partido (
    id INTEGER NOT NULL,
    periodoCompeticion VARCHAR(100),
    nombreCompeticion VARCHAR(100),
    idEquipoLocal INTEGER,
    idEquipoVisitante INTEGER,
    fecha DATE,
    puntosLocal INTEGER,
    puntosVisitante INTEGER,
    instancia VARCHAR(100),
    CONSTRAINT pkPartido PRIMARY KEY (id),
    CONSTRAINT fkPartidoCompeticion FOREIGN KEY (periodoCompeticion, nombreCompeticion)
        REFERENCES Competicion(periodoEvento, nombreEvento) ON DELETE CASCADE,
    CONSTRAINT fkPartidoEquipoLocal FOREIGN KEY (idEquipoLocal)
        REFERENCES Equipo(id) ON DELETE SET NULL,
    CONSTRAINT fkPartidoEquipoVisitante FOREIGN KEY (idEquipoVisitante)
        REFERENCES Equipo(id) ON DELETE SET NULL
);
CREATE TABLE JuegaPartido (
    idJugador INTEGER NOT NULL,                           
    idPartido INTEGER NOT NULL,
    puntos INTEGER,                                    
    asistencias INTEGER,                               
    tapones INTEGER,                                   
    rebotes INTEGER,                                   
    robos INTEGER,                                     
    porcentajeTirosLibres DECIMAL(5, 2),               
    porcentajeTirosCampo DECIMAL(5, 2),                
    porcentajeTriples DECIMAL(5, 2),                   
    CONSTRAINT pkJuegaPartido PRIMARY KEY (idJugador, idPartido),
    CONSTRAINT fkJuegaPartidoJugador FOREIGN KEY (idJugador)  
        REFERENCES Jugador(idPersona) ON DELETE CASCADE,
    CONSTRAINT fkJuegaPartidoPartido FOREIGN KEY (idPartido)  
        REFERENCES Partido(id) ON DELETE CASCADE
);

CREATE TABLE DrafteaJugador (
    idJugador INTEGER NOT NULL,
    idEquipo INTEGER NOT NULL,
    anio INTEGER NOT NULL,
    posicionDraft INTEGER NOT NULL,
    CONSTRAINT pkDrafteaJugador PRIMARY KEY (idJugador),
    CONSTRAINT fkDrafteaJugadorJugador FOREIGN KEY (idJugador)  
        REFERENCES Jugador(idPersona) ON DELETE CASCADE,
    CONSTRAINT fkDrafteaJugadorEquipo FOREIGN KEY (idEquipo)  
        REFERENCES Equipo(id) ON DELETE CASCADE
);

CREATE TABLE JugadorParticipaCompeticion (
    periodoCompeticion VARCHAR(100) NOT NULL,
    nombreCompeticion VARCHAR(100) NOT NULL,
    idEquipo INTEGER NOT NULL,
    idJugador INTEGER NOT NULL,
    CONSTRAINT pkJugadorParticipaCompeticion PRIMARY KEY (periodoCompeticion, nombreCompeticion, idEquipo, idJugador),
    CONSTRAINT fkJugadorParticipaCompeticionCompeticion FOREIGN KEY (periodoCompeticion, nombreCompeticion)  
        REFERENCES Competicion(periodoEvento, nombreEvento) ON DELETE CASCADE,
    CONSTRAINT fkJugadorParticipaCompeticionEquipo FOREIGN KEY (idEquipo)
        REFERENCES Equipo(id) ON DELETE CASCADE,
    CONSTRAINT fkJugadorParticipaCompeticionJugador FOREIGN KEY (idJugador)
        REFERENCES Jugador(idPersona) ON DELETE CASCADE
);
CREATE TABLE JugadorParticipaExhibicion (
    periodoExhibicion VARCHAR NOT NULL,
    nombreExhibicion VARCHAR NOT NULL,
    idJugador INTEGER NOT NULL,
    participaTriples BOOLEAN NOT NULL,
    participaDunk BOOLEAN NOT NULL,
    participaSkills BOOLEAN NOT NULL,
    equipoRepresentado VARCHAR(100),
    CONSTRAINT pkJugadorParticipaExhibicion PRIMARY KEY (periodoExhibicion, nombreExhibicion, idJugador),
    CONSTRAINT fkJugadorParticipaExhibicionExhibicion FOREIGN KEY (periodoExhibicion, nombreExhibicion)  
        REFERENCES Exhibicion(periodoEvento, nombreEvento) ON DELETE CASCADE,
    CONSTRAINT fkJugadorParticipaExhibicionJugador FOREIGN KEY (idJugador)
        REFERENCES Jugador(idPersona) ON DELETE CASCADE
);

CREATE TABLE EntrenadorParticipaCompeticion (
    periodoCompeticion VARCHAR(100) NOT NULL,
    nombreCompeticion VARCHAR(100) NOT NULL,
    idEquipo INTEGER NOT NULL,
    idEntrenador INTEGER NOT NULL,
    CONSTRAINT pkEntrenadorParticipaCompeticion PRIMARY KEY (periodoCompeticion, nombreCompeticion, idEquipo, idEntrenador),
    CONSTRAINT fkJugadorParticipaCompeticionCompeticion FOREIGN KEY (periodoCompeticion, nombreCompeticion)  
        REFERENCES Competicion(periodoEvento, nombreEvento) ON DELETE CASCADE,
    CONSTRAINT fkJugadorParticipaCompeticionEquipo FOREIGN KEY (idEquipo)
        REFERENCES Equipo(id) ON DELETE CASCADE,
    CONSTRAINT fkJugadorParticipaCompeticionJugador FOREIGN KEY (idEntrenador)
        REFERENCES Entrenador(idPersona) ON DELETE CASCADE
);


