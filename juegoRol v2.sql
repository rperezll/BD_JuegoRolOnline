/*TAREA 1*/

/*****CREATE TABLES*******/

/*DROP TABLE PERSONAJE_GENERICO*/
CREATE TABLE PERSONAJE_GENERICO(
  codigo_pg NUMBER(3),
  nombre VARCHAR(10) NOT NULL,
  apodo VARCHAR(10) NOT NULL,
  descripcion VARCHAR(255) );
   
/*DROP TABLE ESCENARIO*/   
CREATE TABLE ESCENARIO(
  codigo_es NUMBER(6),
  descripcion varchar(50) NOT NULL,
  url_mapa VARCHAR(255) );

/*DROP TABLE HABILIDAD*/
CREATE TABLE HABILIDAD(
  codigo_h NUMBER(3),
  nombre VARCHAR(20) NOT NULL,
  categoria VARCHAR(50)NOT NULL,
  descripcion VARCHAR(50),
  coste NUMBER(6) );

/*DROP TABLE PG_TIENE_H*/
CREATE TABLE PG_TIENE_H(
  codigo_pg NUMBER(3),   /*!!*/
  codigo_h  NUMBER(3),
  puntos NUMBER(9) );

/*DROP TABLE HAB_NECESARIA*/
CREATE TABLE HAB_NECESARIA(
  habilidad NUMBER(3),
  h_necesaria NUMBER(3), 
  puntos_necesarios NUMBER(9) );
   
/*DROP TABLE PERSONAJE_JUGADOR*/    
CREATE TABLE PERSONAJE_JUGADOR(
  codigo_pg NUMBER(3) UNIQUE, 
  codigo_pj NUMBER(12) UNIQUE,
  nombre VARCHAR(50) UNIQUE,
  id_u NUMBER(10) );   

/*DROP TABLE USUARIO*/
CREATE TABLE USUARIO(
  id_u NUMBER(10),
  nombre VARCHAR(50) NOT NULL,
  apodo VARCHAR(20) NOT NULL,
  pais VARCHAR(20) NOT NULL,
  IBAN NUMBER(34) DEFAULT NULL,
  oro NUMBER(8,2) DEFAULT '0',
  contrasena VARCHAR(32), 
  codigo_pg_capitan NUMBER(3),
  codigo_pj_capitan NUMBER(12) );
  
/*DROP TABLE EQUIPO*/    
CREATE TABLE EQUIPO(
  codigo_eq NUMBER(10),
  nombre varchar(20) UNIQUE,
  fecha_creacion DATE NOT NULL,
  id_u1 NUMBER(10),
  id_u2 NUMBER(10),
  id_u3 NUMBER(10),
  id_u4 NUMBER(10),
  id_u5 NUMBER(10) );

/*DROP TABLE PARTIDA*/  
CREATE TABLE PARTIDA(
  codigo_p NUMBER(20),
  codigo_eq1 NUMBER(10) NOT NULL,
  codigo_eq2 NUMBER(10) NOT NULL,
  codigo_eq_ganador NUMBER(10),
  codigo_es NUMBER(6),
  fecha_ini DATE NOT NULL, 
  fecha_fin DATE );

/*DROP TABLE PJ_TIENE_HABIL*/
CREATE TABLE PJ_TIENE_HABIL(
  codigo_pg NUMBER(3),
  codigo_pj NUMBER(12),
  codigo_h NUMBER(3),
  puntos NUMBER(9) );



/*******ALTER TABLES*********/

ALTER TABLE PERSONAJE_GENERICO
  ADD CONSTRAINT ClavePrimaria_personaje_generico
    PRIMARY KEY (codigo_pg) ;

ALTER TABLE ESCENARIO
  ADD CONSTRAINT ClavePrimaria_escenario
    PRIMARY KEY (codigo_es) ;

ALTER TABLE HABILIDAD
  ADD CONSTRAINT ClavePrimaria_habilidad
    PRIMARY KEY (codigo_h),
  ADD CONSTRAINT categoria_h 
    CHECK (categoria IN ('Fuerza','Velocidad','Punteria','Otras')),
  ADD CONSTRAINT oroMinimo 
    CHECK (coste>'0') ;

ALTER TABLE PG_TIENE_H
  ADD CONSTRAINT puntuacionMinima 
    CHECK (puntos>'0'),
  ADD CONSTRAINT ClavePrimaria_tieneh 
    PRIMARY KEY (codigo_pg,codigo_h),
  ADD CONSTRAINT pg_tiene_h_p_g
    FOREIGN KEY (codigo_pg) REFERENCES PERSONAJE_GENERICO(codigo_pg)
    ON DELETE CASCADE,
  ADD CONSTRAINT pg_tiene_h_h
    FOREIGN KEY (codigo_h) REFERENCES HABILIDAD(codigo_h)
    ON DELETE CASCADE ;

ALTER TABLE HAB_NECESARIA
  ADD CONSTRAINT puntuacionMinima2 
    CHECK (puntos_necesarios>'0'),
  ADD CONSTRAINT ClavePrimaria_h_necesaria 
    PRIMARY KEY (habilidad,h_necesaria),
    /*ON DELETE CASCADE????*/
  ADD CONSTRAINT hab_necesaria_habilidad
    FOREIGN KEY (habilidad) REFERENCES HABILIDAD(codigo_h)
    ON DELETE CASCADE,
  ADD CONSTRAINT hab_necesaria_habilidad2
    FOREIGN KEY (h_necesaria) REFERENCES HABILIDAD(codigo_h)
    ON DELETE CASCADE ;

ALTER TABLE USUARIO 
    ADD CONSTRAINT ClavePrimaria_usuario
    PRIMARY KEY (id_u);

ALTER TABLE PERSONAJE_JUGADOR
  ADD CONSTRAINT ClavePrimaria_personaje_jugador 
    PRIMARY KEY (codigo_pg,codigo_pj),
  ADD CONSTRAINT personaje_j_personaje_g
    FOREIGN KEY (codigo_pg) REFERENCES PERSONAJE_GENERICO(codigo_pg)
    ON DELETE CASCADE,
  ADD CONSTRAINT personaje_jugador_usuario 
    FOREIGN KEY (id_u) REFERENCES USUARIO(id_u)
    ON DELETE CASCADE ;

ALTER TABLE USUARIO
  ADD CONSTRAINT oroMinimo2 
    CHECK (oro>'0'),
  ADD CONSTRAINT usuario_personaje_jugador 
    FOREIGN KEY (codigo_pg_capitan) REFERENCES PERSONAJE_JUGADOR(codigo_pg) ON DELETE SET NULL,
  ADD CONSTRAINT usuario_personaje_jugador2 
    FOREIGN KEY (codigo_pj_capitan) REFERENCES PERSONAJE_JUGADOR(codigo_pj) ON DELETE SET NULL ;

ALTER TABLE EQUIPO
  ADD CONSTRAINT ClavePrimaria_equipo
    PRIMARY KEY (codigo_eq),
  ADD CONSTRAINT equipo_usuario_1
    FOREIGN KEY (id_u1) REFERENCES USUARIO(id_u)
    ON DELETE SET NULL,
  ADD CONSTRAINT equipo_usuario_2
    FOREIGN KEY (id_u2) REFERENCES USUARIO(id_u),
  ADD CONSTRAINT equipo_usuario_3
    FOREIGN KEY (id_u3) REFERENCES USUARIO(id_u),
  ADD CONSTRAINT equipo_usuario_4
    FOREIGN KEY (id_u4) REFERENCES USUARIO(id_u),
  ADD CONSTRAINT equipo_usuario_5
    FOREIGN KEY (id_u5) REFERENCES USUARIO(id_u) ;

ALTER TABLE PARTIDA
  ADD CONSTRAINT ClavePrimaria_partida
    PRIMARY KEY (codigo_p),
  ADD CONSTRAINT resultadoGanador 
    CHECK (codigo_eq_ganador IN (codigo_eq1,codigo_eq2)),
  ADD CONSTRAINT partida_equipo
    FOREIGN KEY (codigo_eq1) REFERENCES EQUIPO(codigo_eq)
    ON DELETE CASCADE,
  ADD CONSTRAINT partida_equipo2
    FOREIGN KEY (codigo_eq2) REFERENCES EQUIPO(codigo_eq)
    ON DELETE CASCADE,
  ADD CONSTRAINT partida_equipo3
    FOREIGN KEY (codigo_eq_ganador) REFERENCES EQUIPO(codigo_eq)
    ON DELETE CASCADE,
  ADD CONSTRAINT partida_escenario
    FOREIGN KEY (codigo_es) REFERENCES ESCENARIO(codigo_es)
    ON DELETE SET NULL ;

ALTER TABLE PJ_TIENE_HABIL
  ADD CONSTRAINT ClavePrimaria_PJ_TIENE_HABIL
  PRIMARY KEY (codigo_pg,codigo_pj,codigo_h),
  ADD CONSTRAINT puntuacionMinima3
    CHECK (puntos>'0'),
  ADD CONSTRAINT pj_tiene_habil_p_j_1
    FOREIGN KEY (codigo_pj) REFERENCES PERSONAJE_JUGADOR(codigo_pg)
    ON DELETE CASCADE,
  ADD CONSTRAINT pj_tiene_habil_p_j_2
    FOREIGN KEY (codigo_pg) REFERENCES PERSONAJE_JUGADOR(codigo_pg)
    ON DELETE CASCADE,
  ADD CONSTRAINT pj_tiene_habil_h
    FOREIGN KEY (codigo_h) REFERENCES HABILIDAD(codigo_h)
    ON DELETE CASCADE ;   