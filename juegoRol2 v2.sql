/*3.1*/
/*Condicion que impide que la fecha de inicio de una partida no 
sea superior a la de finalizacion de esta*/
ALTER TABLE PARTIDA ADD 
  CHECK (Fecha_inicio<=Fecha_final) ;

/*3.2*/
/*Dos o más usuarios no pueden tener el mismo apodo*/
ALTER TABLE USUARIO ADD 
  UNIQUE (Apodo) ;

/*3.3*/
/*Qué es eso de deshabilitarla sin borrarla??? RES: En las
opciones de borrado, usar ON DELETE SET NULL*/

/*3.4*/
/*El correo electronico se requiera de forma obligatoria*/
ALTER TABLE USUARIO ADD (
  Correo_electronico VARCHAR(50) DEFAULT 'Sin especificar' NOT NULL );

/*3.5*/
/*El codigo del equipo ganador de una partida o es nulo o es 
el de alguno de los dos equipos participantes en ella*/
ALTER TABLE PARTIDA 
  ADD CONSTRAINT GARANTIZAR_VALIDEZ_GANADOR 
    CHECK (Cod_Eq_ganador IN (Cod_Eq1, Cod_Eq2, NULL) ;

/*4.1*/
UPDATE PJ_TIENE_HABIL 
  SET Puntos=4 
  WHERE Codigo_PJ=4 ;

/*4.2*/
UPDATE HABILIDAD 
  SET Coste=Coste*2 
  WHERE Categoria='Velocidad' ;

/*4.3*/
UPDATE USUARIO 
  SET oro=oro+100 
  WHERE pais='España' ;

/*4.4*/
UPDATE PJ_TIENE_HABIL 
  SET Puntos=Puntos+1 
  WHERE Puntos < (SELECT AVG(Puntos) FROM PJ_TIENE_HABIL) ;

/*4.5*/
SELECT id_u 
  FROM USUARIO 
  WHERE id_u 
  NOT IN(
    (SELECT EQUIPO.id_u1 
      FROM EQUIPO,PARTIDA 
      WHERE EQUIPO.codigo_eq=PARTIDA.codigo_eq1 OR EQUIPO.codigo_eq=PARTIDA.codigo_eq2),
    (SELECT EQUIPO.id_u2 
      FROM EQUIPO,PARTIDA 
      WHERE EQUIPO.codigo_eq=PARTIDA.codigo_eq1 OR EQUIPO.codigo_eq=PARTIDA.codigo_eq2);


/*5) Creacion de vistas*/

/*5.1*/
CREATE VIEW VISTA_HABILIDADES_NECESARIAS AS( 
  SELECT 
    HABILIDAD.codigo_H,
    HABILIDAD.nombre,
    HABILIDAD.categoria,
    HABILIDAD.descripcion,
    HABILIDAD.coste,
    HAB_NECESARIA.habilidad,
    HAB_NECESARIA.h_necesaria,
    HAB_NECESARIA.puntos_necesarios 
  FROM HABILIDAD, HAB_NECESARIA 
  WHERE ( Habilidad = Codigo_H ) );

/*5.2*/
CREATE VIEW VISTA_USUARIO_EQUIPO AS( 
  /*columna1*/
  SELECT 
  USUARIO.nombre,

    /*columna2*/
    (SELECT COUNT(*)  
      FROM EQUIPO, USUARIO
      WHERE (
        USUARIO.id_u=EQUIPO.id_u1 or
        USUARIO.id_u=EQUIPO.id_u2 or
        USUARIO.id_u=EQUIPO.id_u3 or
        USUARIO.id_u=EQUIPO.id_u4 or
        USUARIO.id_u=EQUIPO.id_u5)) 
    AS Numero_Equipo,

    /*columna3*/
    (SELECT COUNT(*)  
      FROM PARTIDA, EQUIPO
      WHERE (
        EQUIPO.codigo_eq=PARTIDA.codigo_eq1 or
        EQUIPO.codigo_eq=PARTIDA.codigo_eq2)) 
    AS Numero_Partidas

  FROM USUARIO,EQUIPO
  WHERE (
    USUARIO.id_u=EQUIPO.id_u1 or 
    USUARIO.id_u=EQUIPO.id_u2 or 
    USUARIO.id_u=EQUIPO.id_u3 or 
    USUARIO.id_u=EQUIPO.id_u4 or 
    USUARIO.id_u=EQUIPO.id_u5) );

/*6) Consultas sin utilizar vistas*/
/*6.1*/
SELECT nombre FROM USUARIO WHERE (pais='spain') ;
/*6.2*/
SELECT DISTINT HABILIDAD.nombre FROM HABILIDAD, PJ_TIENE_HABIL WHERE (
  HABILIDAD.codigo_h <> PJ_TIENE_HABIL.codigo_h) ;
/*6.3*/
SELECT USUARIO.nombre FROM USUARIO, EQUIPO WHERE (
  USUARIO.id_u<>EQUIPO.id_u1 AND 
  USUARIO.id_u<>EQUIPO.id_u2 AND 
  USUARIO.id_u<>EQUIPO.id_u3 AND 
  USUARIO.id_u<>EQUIPO.id_u4 AND 
  USUARIO.id_u<>EQUIPO.id_u5) ;
/*6.4*/ /*Los usuarios que hayan participado en una partida, 
ademas cuenta las partidas*/
SELECT USUARIO.nombre,
  (SELECT COUNT(*) FROM PARTIDA, EQUIPO, USUARIO WHERE((
  USUARIO.id_u=EQUIPO.id_u1 OR 
  USUARIO.id_u=EQUIPO.id_u2 OR 
  USUARIO.id_u=EQUIPO.id_u3 OR 
  USUARIO.id_u=EQUIPO.id_u4 OR 
  USUARIO.id_u=EQUIPO.id_u5) AND(
  EQUIPO.codigo_eq=PARTIDA.codigo_eq1 OR
  EQUIPO.codigo_eq=PARTIDA.codigo_eq2))
FROM PARTIDA, EQUIPO WHERE (
  USUARIO.id_u=EQUIPO.id_u1 OR 
  USUARIO.id_u=EQUIPO.id_u2 OR 
  USUARIO.id_u=EQUIPO.id_u3 OR 
  USUARIO.id_u=EQUIPO.id_u4 OR 
  USUARIO.id_u=EQUIPO.id_u5)
/*6.5*/
SELECT PARTIDA.codigo_p,
  SYSDATE-to_date(PARTIDA.fecha_fin) /*Fecha actual - fecha de finalización de la partida*/
FROM PARTIDA;
/*6.6*/

/*7.1*/
CREATE TABLE RESUMEN_PARTIDA(
  codigo_rp NUMBER(20),
  codigo_p NUMBER(20),
  id_u NUMBER(10),
  puntuacion NUMBER(20),
  dinero NUMBER(10),
   );
CREATE TABLE RESUMEN_VIDA(
  codigo_rp
  codigo_pj NUMBER(12),
  vida NUMBER(5)
);

ALTER TABLE RESUMEN_PARTIDA(
  ADD CONSTRAINT ClavePrimariaRESUMEN_PARTIDA
    PRIMARY KEY codigo_rp,
  ADD CONSTRAINT puntuacion31
    FOREIGN KEY (codigo_p) REFERENCES PARTIDA(codigo_p)
    ON DELETE CASCADE,
  ADD CONSTRAINT puntuacion2
    FOREIGN KEY (id_u) REFERENCES USUARIO(id_u)
    ON DELETE CASCADE );

ALTER TABLE RESUMEN_VIDA(
  ADD CONSTRAINT puntuacion3
    FOREIGN KEY (codigo_rp) REFERENCES RESUMEN_PARTIDA(codigo_rp)
    ON DELETE CASCADE);
ADD CONSTRAINT puntuacion4
    FOREIGN KEY (codigo_pj) REFERENCES PERSONAJE_JUGADOR(codigo_pj)
    ON DELETE CASCADE );

/*7.2*/
CREATE TABLE HISTORICO_Partidas_Terminadas(
  codigo_rp NUMBER(20),/*NUEVO!!Codigo de RESUMEN_PARTIDA*/
   /*Tabla de PARTIDA*/
  codigo_p NUMBER(20),
  codigo_eq1 NUMBER(10) NOT NULL,
  codigo_eq2 NUMBER(10) NOT NULL,
  codigo_eq_ganador NUMBER(10),
  codigo_es NUMBER(6),
  fecha_ini DATE NOT NULL, 
  fecha_fin DATE );

ALTER TABLE HISTORICO_Partidas_Terminadas
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
    ON DELETE SET NULL 
  ADD CONSTRAINT Resumen_partida1
    FOREIGN KEY (codigo_rp) REFERENCES RESUMEN_PARTIDA(codigo_rp)
    ON DELETE SET NULL  ;