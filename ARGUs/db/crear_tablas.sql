BEGIN;

CREATE TABLE estacion_meteorologica(
	identificador		VARCHAR(5)	PRIMARY KEY,
	serial			VARCHAR(4)	NOT NULL,
	codigo			TEXT,
	nombre			TEXT,		--NOT NULL,
	latitud			TEXT,		--NOT NULL,
	longitud		TEXT,		--NOT NULL,
	altura			DOUBLE PRECISION,
	topografia		TEXT, 
	biomasa			TEXT, 
	suelo			TEXT, 
	cuenca			TEXT, 
	referencia		DOUBLE PRECISION, 
	dimensiones		TEXT, 
	caracteristicas		TEXT, 
	ruta			TEXT, 
	plataforma		DOUBLE PRECISION,
	senial			TEXT
);

-- SELECT AddGeometryColumn('public', 'estacion_meteorologica', 'ubicacion', -1 , 'POINT', 2);

CREATE TABLE foto(
	estacion_meteorologica	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador),
 	fecha			DATE, 
	contenido		OID,
	PRIMARY KEY(estacion_meteorologica, fecha, contenido)	
);

CREATE TABLE instrumento(
	serial			TEXT, 
	marca			TEXT, 
	modelo			TEXT, 
	calibracion		OID,
	PRIMARY KEY(serial, marca, modelo)
);

CREATE TABLE emplazamiento_instrumento(
	estacion_meteorologica	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador),
	serial			TEXT,
	marca			TEXT,
	modelo			TEXT,
	fecha_inicio		DATE,
	altura			DOUBLE PRECISION, 
	fecha_fin		DATE,
	descripcion		TEXT,
	FOREIGN KEY (serial, marca, modelo) REFERENCES instrumento(serial, marca, modelo),
	PRIMARY KEY(estacion_meteorologica, serial, marca, modelo, fecha_inicio, altura),
	CONSTRAINT fecha_emplazamiento_instrumento CHECK( fecha_fin IS NULL OR fecha_fin> fecha_inicio )
);

CREATE TABLE institucion(
	acronimo		VARCHAR(15)	PRIMARY KEY, 
	nombre			TEXT		NOT NULL, 
	mision			TEXT		NOT NULL, 
	tipo			TEXT		NOT NULL, 
	alcance			TEXT		NOT NULL, 
	departamento		TEXT, 
	cargo			TEXT, 
	persona			TEXT,
	CONSTRAINT tipo CHECK (tipo in ('Industria', 'Institucion de Educacion', 'Institucion de Investigacion', 'Gubernamental', 'Consultora', 'ONG')),
	CONSTRAINT alcance CHECK (alcance in ('Mundial', 'Nacional', 'Regional', 'Municipal'))
);

CREATE TABLE periodo_operacion (
	identificador		NUMERIC		PRIMARY KEY,
	estacion_meteorologica 	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador), 
	institucion		VARCHAR(15) 	REFERENCES institucion(acronimo), 
	fecha_inicio		DATE, 
	fecha_fin		DATE
);

CREATE TABLE parametro(
	codigo			VARCHAR(4)	PRIMARY KEY, 
	nombre			TEXT		NOT NULL,
	tipo			TEXT		NOT NULL,
	agregacion		TEXT,
	parametro_fuente	VARCHAR(4)	REFERENCES parametro(codigo),
	CONSTRAINT tipo CHECK (tipo in ('valor agregado','variable hidroclimatica'))
);

CREATE TABLE unidad(
	identificador		NUMERIC		PRIMARY KEY, 
	nombre			TEXT		NOT NULL, 
	acronimo		VARCHAR(20)
);

CREATE TABLE se_representa(
	parametro		VARCHAR(4)	REFERENCES parametro(codigo), 
	unidad			NUMERIC		REFERENCES unidad(identificador),
	PRIMARY KEY(parametro, unidad)
);

CREATE TABLE periodo_observacion(
	estacion_meteorologica 	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador), 
	parametro		VARCHAR(4)	REFERENCES parametro(codigo), 
	fecha_inicio		DATE, 
	hora			CHAR(4), 
	fecha_fin		DATE,
	PRIMARY KEY(estacion_meteorologica, parametro, fecha_inicio, hora),
	CONSTRAINT hora_valida CHECK(hora ~ '[0-9]{4}')
);

CREATE TABLE inventario_parametro( 
	institucion		VARCHAR(15) 	REFERENCES institucion(acronimo), 
	estacion_meteorologica	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador), 
	parametro	 	VARCHAR(4)	REFERENCES parametro(codigo), 	
	unidad			NUMERIC		REFERENCES unidad(identificador),	 
	frecuencia		TEXT, 
	fecha_inicio		TIMESTAMP, 
	fecha_fin		TIMESTAMP,
	PRIMARY KEY(institucion, estacion_meteorologica, parametro, unidad, frecuencia, fecha_inicio, fecha_fin),
	CONSTRAINT frecuencia CHECK (frecuencia in ('horario', 'diario', 'semanal', 'mensual', 'trimestral', 'anual', 'decadario'))
);

CREATE TABLE labor_mantenimiento(
	identificador		SERIAL 		PRIMARY KEY, 
	nombre			TEXT		NOT NULL, 
	descripcion		TEXT		NOT NULL
);

CREATE TABLE se_programa(
	estacion_meteorologica	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador), 
	labor_mantenimiento	NUMERIC		REFERENCES labor_mantenimiento(identificador), 
	frecuencia		INTEGER		NOT NULL,
	PRIMARY KEY(estacion_meteorologica, labor_mantenimiento)	
);

CREATE TABLE visita_mantenimiento(
	estacion_meteorologica	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador), 
	labor_mantenimiento	NUMERIC		REFERENCES labor_mantenimiento(identificador), 
	fecha			DATE, 
	persona			TEXT		NOT NULL,
	PRIMARY KEY(estacion_meteorologica, labor_mantenimiento, fecha)
);

CREATE TABLE cambio(
	estacion_meteorologica  VARCHAR(5)	REFERENCES estacion_meteorologica(identificador),
	identificador		SERIAL,
	fecha			DATE 		NOT NULL,
	tipo			VARCHAR(10)	NOT NULL,
	descripcion		TEXT		NOT NULL,	
	PRIMARY KEY(estacion_meteorologica, identificador),
	CONSTRAINT tipo CHECK (tipo in ('nombre','serial'))
);

CREATE TABLE categoria(
	identificador		NUMERIC		PRIMARY KEY,
	categoria		TEXT		NOT NULL,
	sub_categoria		TEXT,
	sub_sub_categoria	TEXT,
	sub_sub_sub_categoria	TEXT
);

CREATE TABLE es_categoria(
	estacion_meteorologica	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador),
	categoria		NUMERIC		REFERENCES categoria(identificador),
	PRIMARY KEY(estacion_meteorologica, categoria)
);

CREATE TABLE anio(
	numero_anio  		CHAR(4) 	PRIMARY KEY,
	CONSTRAINT anio_valido CHECK(numero_anio ~ '[0-9]{4}')
);

CREATE TABLE mes(
	numero_anio		CHAR(4)		REFERENCES anio(numero_anio), 
	numero_mes		CHAR(2), 
	nombre			VARCHAR(10)	NOT NULL,
	PRIMARY KEY(numero_anio, numero_mes),
	CONSTRAINT mes_valido CHECK(numero_mes ~ '[0-9]{2}'),
	CONSTRAINT anio_valido CHECK(numero_anio ~ '[0-9]{4}')
);

CREATE TABLE pais(
	nombre_pais		TEXT		PRIMARY KEY, 
	forma_ubicacion		TEXT
);
-- SELECT AddGeometryColumn('public', 'pais', 'forma_ubicacion', -1 , 'MULTIPOLYGON', 2);

CREATE TABLE estado(
	nombre_pais		TEXT 		REFERENCES pais(nombre_pais),
	nombre_estado		TEXT,
	forma_ubicacion		TEXT,
	PRIMARY KEY(nombre_pais, nombre_estado)
);
-- SELECT AddGeometryColumn('public', 'estado', 'forma_ubicacion', -1 , 'POLYGON', 2);

CREATE TABLE emplazamiento_estacion(
	identificador		NUMERIC		PRIMARY KEY,
	estacion_meteorologica	VARCHAR(5)	REFERENCES estacion_meteorologica(identificador),
	pais			TEXT, 
	estado			TEXT, 
	fecha_inicio		DATE, 
	fecha_fin		DATE,
	FOREIGN KEY (pais, estado) REFERENCES estado(nombre_pais, nombre_estado),
	CONSTRAINT fecha_emplazamiento_estacion CHECK( fecha_fin IS NULL OR fecha_fin > fecha_inicio )
);

CREATE TABLE municipio(
	nombre_pais		TEXT, 
	nombre_estado		TEXT,  
	nombre_municipio	TEXT, 
	forma_ubicacion		TEXT,
	PRIMARY KEY(nombre_pais, nombre_estado, nombre_municipio),
	FOREIGN KEY (nombre_pais, nombre_estado) REFERENCES estado(nombre_pais, nombre_estado)
);
-- SELECT AddGeometryColumn('public', 'municipio', 'forma_ubicacion', -1 , 'POLYGON', 2);

CREATE TABLE parroquia(
	nombre_pais		TEXT, 
	nombre_estado		TEXT, 
	nombre_municipio	TEXT, 
	nombre_parroquia	TEXT, 
	forma_ubicacion		TEXT,
	PRIMARY KEY (nombre_pais, nombre_estado, nombre_municipio, nombre_parroquia),
	FOREIGN KEY (nombre_pais, nombre_estado, nombre_municipio) REFERENCES municipio(nombre_pais, nombre_estado, nombre_municipio)
);
-- SELECT AddGeometryColumn('public', 'parroquia', 'forma_ubicacion', -1 , 'POLYGON', 2);

CREATE TABLE centro_poblado(
	nombre_pais		TEXT,
	nombre_estado		TEXT,
	nombre_municipio	TEXT,
	nombre_parroquia	TEXT,
	nombre_centro_poblado	TEXT,
	demarcacion_sanitaria	CHAR(1),
	identificador		INTEGER		NOT NULL UNIQUE,
	ubicacion		TEXT,
	FOREIGN KEY (nombre_pais, nombre_estado, nombre_municipio, nombre_parroquia) REFERENCES parroquia(nombre_pais, nombre_estado, nombre_municipio, nombre_parroquia),	
	PRIMARY KEY(nombre_pais, nombre_estado, nombre_municipio, nombre_parroquia, nombre_centro_poblado),
	CONSTRAINT demarcacion_valida CHECK(demarcacion_sanitaria ~ '[a-zA-Z]{1}')
);
-- SELECT AddGeometryColumn('public', 'centro_poblado', 'ubicacion', -1 , 'POINT', 2);

CREATE TABLE poblacion(
	pais			TEXT, 
	estado			TEXT, 
	municipio		TEXT, 
	parroquia		TEXT, 
	centro_poblado		TEXT, 
	anio			CHAR(4), 
	cantidad		INTEGER,
	PRIMARY KEY(pais, estado, municipio, parroquia, centro_poblado, anio),
	FOREIGN KEY (anio) REFERENCES anio(numero_anio),
	FOREIGN KEY (pais, estado, municipio, parroquia, centro_poblado) REFERENCES centro_poblado(nombre_pais, nombre_estado, nombre_municipio, nombre_parroquia, nombre_centro_poblado),
	CONSTRAINT anio_valido CHECK(anio ~ '[0-9]{4}')
);

CREATE TABLE casos_malaria(
	pais			TEXT,
	estado			TEXT,
	municipio		TEXT,
	parroquia		TEXT,
	centro_poblado		TEXT,
	anio			CHAR(4),
	mes			CHAR(2),
	cantidad		INTEGER, 
	FOREIGN KEY (pais, estado, municipio, parroquia, centro_poblado) REFERENCES centro_poblado(nombre_pais, nombre_estado, nombre_municipio, nombre_parroquia, nombre_centro_poblado),	
	FOREIGN KEY (anio, mes) REFERENCES mes(numero_anio, numero_mes),	
	PRIMARY KEY(pais, estado, municipio, parroquia, centro_poblado, anio, mes),
	CONSTRAINT mes_valido CHECK(mes ~ '[0-9]{2}'),
	CONSTRAINT anio_valido CHECK(anio ~ '[0-9]{4}')
);

END;
