-- Table: unidad_dimension

-- DROP TABLE unidad_dimension;

CREATE TABLE unidad_dimension
(
  id serial NOT NULL,
  unidad_medida_u varchar(255),
  observacion_u varchar(255),
  CONSTRAINT unidad_dimension_pkey PRIMARY KEY (id)
) 
WITHOUT OIDS;
ALTER TABLE unidad_dimension OWNER TO postgres;


-- Index: index_unidad_dimension_on_observacion_u

-- DROP INDEX index_unidad_dimension_on_observacion_u;

CREATE INDEX index_unidad_dimension_on_observacion_u
  ON unidad_dimension
  USING btree
  (observacion_u);

-- Index: index_unidad_dimension_on_unidad_medida_u

-- DROP INDEX index_unidad_dimension_on_unidad_medida_u;

CREATE INDEX index_unidad_dimension_on_unidad_medida_u
  ON unidad_dimension
  USING btree
  (unidad_medida_u);


-- Table: tiempo_dimension

-- DROP TABLE tiempo_dimension;

CREATE TABLE tiempo_dimension
(
  id serial NOT NULL,
  unidad_t varchar(100),
  observacion_t varchar(255),
  tiempo date,
  año int4,
  mes int4,
  dia int4,
  hora time,
  CONSTRAINT tiempo_dimension_pkey PRIMARY KEY (id)
) 
WITHOUT OIDS;
ALTER TABLE tiempo_dimension OWNER TO postgres;


-- Index: index_tiempo_dimension_on_observacion_t

-- DROP INDEX index_tiempo_dimension_on_observacion_t;

CREATE INDEX index_tiempo_dimension_on_observacion_t
  ON tiempo_dimension
  USING btree
  (observacion_t);

-- Index: index_tiempo_dimension_on_unidad_t

-- DROP INDEX index_tiempo_dimension_on_unidad_t;

CREATE INDEX index_tiempo_dimension_on_unidad_t
  ON tiempo_dimension
  USING btree
  (unidad_t);



-- Table: nivelagregacion_dimension

-- DROP TABLE nivelagregacion_dimension;

CREATE TABLE nivelagregacion_dimension
(
  id serial NOT NULL,
  nivel_agregacion varchar(255),
  CONSTRAINT nivelagregacion_dimension_pkey PRIMARY KEY (id)
) 
WITHOUT OIDS;
ALTER TABLE nivelagregacion_dimension OWNER TO postgres;


-- Index: index_nivelagregacion_dimension_on_nivel_agregacion

-- DROP INDEX index_nivelagregacion_dimension_on_nivel_agregacion;

CREATE INDEX index_nivelagregacion_dimension_on_nivel_agregacion
  ON nivelagregacion_dimension
  USING btree
  (nivel_agregacion);



-- Table: estacion_dimension

-- DROP TABLE estacion_dimension;

CREATE TABLE estacion_dimension
(
  id serial NOT NULL,
  nombre_est varchar(255),
  latitud_est float8,
  longitud_est float8,
  altura_est int4,
  CONSTRAINT estacion_dimension_pkey PRIMARY KEY (id)
) 
WITHOUT OIDS;
ALTER TABLE estacion_dimension OWNER TO postgres;


-- Index: index_estacion_dimension_on_altura_est

-- DROP INDEX index_estacion_dimension_on_altura_est;

CREATE INDEX index_estacion_dimension_on_altura_est
  ON estacion_dimension
  USING btree
  (altura_est);

-- Index: index_estacion_dimension_on_latitud_est

-- DROP INDEX index_estacion_dimension_on_latitud_est;

CREATE INDEX index_estacion_dimension_on_latitud_est
  ON estacion_dimension
  USING btree
  (latitud_est);

-- Index: index_estacion_dimension_on_longitud_est

-- DROP INDEX index_estacion_dimension_on_longitud_est;

CREATE INDEX index_estacion_dimension_on_longitud_est
  ON estacion_dimension
  USING btree
  (longitud_est);

-- Index: index_estacion_dimension_on_nombre_est

-- DROP INDEX index_estacion_dimension_on_nombre_est;

CREATE INDEX index_estacion_dimension_on_nombre_est
  ON estacion_dimension
  USING btree
  (nombre_est);



-- Table: medidavarhc_facts

-- DROP TABLE medidavarhc_facts;

CREATE TABLE medidavarhc_facts
(
  id serial NOT NULL,
  tiempo_id int4 NOT NULL,
  unidad_id int4 NOT NULL,
  estacion_type_id int4 NOT NULL,
  nivelagregacion_id int4 NOT NULL,
  valor_m float8 NOT NULL,
  observacion_m varchar(255),
  nombre_hc varchar(100),
  CONSTRAINT medidavarhc_facts_pkey PRIMARY KEY (id)
) 
WITHOUT OIDS;
ALTER TABLE medidavarhc_facts OWNER TO postgres;




-- Inserciones para las tablas.

INSERT INTO unidad_dimension (unidad_medida_u, observacion_u) values ('milimetros','no hay...');
INSERT INTO unidad_dimension (unidad_medida_u, observacion_u) values ('centimetros cubicos','no tengo...');
INSERT INTO unidad_dimension (unidad_medida_u, observacion_u) values ('hectoPascal','para la presion');
INSERT INTO unidad_dimension (unidad_medida_u, observacion_u) values ('mm de Mercurio','para la presion de nuevo');
INSERT INTO unidad_dimension (unidad_medida_u, observacion_u) values ('°C','Lo normal temperatura');
INSERT INTO unidad_dimension (unidad_medida_u, observacion_u) values ('°F','temperatura anglosajona');

INSERT INTO tiempo_dimension (unidad_t, observacion_t, tiempo) values ('mensual','ninguna','10-10-2007');
INSERT INTO tiempo_dimension (unidad_t, observacion_t, tiempo) values ('mensual','ninguna','10-11-2007');
INSERT INTO tiempo_dimension (unidad_t, observacion_t, tiempo) values ('mensual','ninguna','10-12-2007');
INSERT INTO tiempo_dimension (unidad_t, observacion_t, tiempo) values ('mensual','ninguna','10-03-2005');
INSERT INTO tiempo_dimension (unidad_t, observacion_t, tiempo) values ('diario','ninguna','12-08-2005');
INSERT INTO tiempo_dimension (unidad_t, observacion_t, tiempo) values ('diario','ninguna','09-08-2005');
INSERT INTO tiempo_dimension (unidad_t, observacion_t, tiempo) values ('diario','ninguna','07-08-2005');

INSERT INTO estacion_dimension (nombre_est, latitud_est, longitud_est, altura_est) VALUES ('taguapire',23.23423423,-22.234234234,1500);
INSERT INTO estacion_dimension (nombre_est, latitud_est, longitud_est, altura_est) VALUES ('jaji',24.23423423,-25.234234234,350);
INSERT INTO estacion_dimension (nombre_est, latitud_est, longitud_est, altura_est) VALUES ('chirimena',31.984832758734,-45.0982424,15);

INSERT INTO nivelagregacion_dimension (nivel_agregacion) VALUES ('primer nivel');
INSERT INTO nivelagregacion_dimension (nivel_agregacion) VALUES ('segundo nivel');
INSERT INTO nivelagregacion_dimension (nivel_agregacion) VALUES ('tercer nivel');