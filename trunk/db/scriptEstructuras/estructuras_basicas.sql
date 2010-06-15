--CREATEDB hidro_development

drop table if exists areaintereses;
drop table if exists usuarios_intereses;
drop table if exists mensajes;
drop table if exists hilos;
drop table if exists vinculotags;
drop table if exists estaciones;
drop table if exists estados;
drop table if exists servicios;
drop table if exists se_observa;
drop table if exists periodo_operacion;
drop table if exists unidads cascade;
drop table if exists tipo_objetos cascade;
drop table if exists fenomeno_meteorologicos cascade;
drop table if exists incide_tofs cascade;
drop table if exists variable_hidroclimaticas cascade;
drop table if exists afecta_fvhcs cascade;
drop table if exists se_asocia_vhctos cascade;
drop table if exists variable_socioeconomicas cascade;
drop table if exists se_relaciona_vsetos cascade;
drop table if exists tipo_instrumentos cascade;
drop table if exists se_mide_vunis cascade;
drop table if exists puede_medir_vtins cascade;
drop table if exists medios cascade;
drop table if exists metadatos_desc cascade;
drop table if exists metadatos_rowids cascade;
DROP TABLE IF EXISTS requerimientos;
DROP TABLE IF EXISTS solicitudes;
DROP TABLE if exists activewarehouse_schema_info;
DROP TABLE if exists estacion_dimension;
DROP TABLE if exists medidavarhc_facts;
DROP TABLE if exists nivelagregacion_dimension;
DROP TABLE if exists schema_info;
DROP TABLE if exists simple_captcha_data;
DROP TABLE if exists table_reports;
DROP TABLE if exists tiempo_dimension;
DROP TABLE if exists unidad_dimension;




CREATE TABLE areaintereses (
  id SERIAL NOT NULL,
  interes VARCHAR(50) NOT NULL,
  PRIMARY KEY(id)
) ;


CREATE TABLE usuarios_intereses (
  id SERIAL NOT NULL,
  usuario_id int4 NOT NULL,
  areainterese_id int4 NOT NULL,
  PRIMARY KEY(id)
) ;


CREATE TABLE mensajes (
  id SERIAL NOT NULL,
  hilo_id int4 NOT NULL,
  usuario_id int4 NOT NULL,
  mensaje VARCHAR(300) NOT NULL,
  PRIMARY KEY (id)
) ;


CREATE TABLE hilos (
  id SERIAL NOT NULL ,
  titulo VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
) ;


CREATE TABLE vinculotags (
  id SERIAL NOT NULL,
  usuario_id integer NOT NULL,
  vinculo VARCHAR(100) NOT NULL,
  tag VARCHAR(300) NOT NULL,
  descripcion VARCHAR(200) NOT NULL,
  oficial varchar(2) NOT NULL,
  PRIMARY KEY(id) 
) ;


CREATE TABLE usuarios (
  id SERIAL NOT NULL ,
  login VARCHAR(40) NOT NULL,
  crypted_password VARCHAR(40) NOT NULL,
  salt VARCHAR(40) NULL,
  nombre VARCHAR(20) NOT NULL,
  apellido VARCHAR(20) NOT NULL,
  tipo VARCHAR(14) NOT NULL,
  sexo VARCHAR(1)  NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  fecha_registro DATE NOT NULL,
  telefono VARCHAR(16) NULL, 
  nivel_estudio VARCHAR(25) NOT NULL,
  campo_trabajo VARCHAR(30) NOT NULL,
  direccion_hab VARCHAR(200) NULL,
  email_address VARCHAR(30) NULL,
  remember_token VARCHAR(255) NULL,
  remember_token_expires_at DATE NULL,
  constraint uk_usuarios unique (login),
  PRIMARY KEY(id)
) ;

CREATE TABLE estados
(
  id serial NOT NULL,
  nombre varchar(40) NOT NULL,
  CONSTRAINT estado_pk PRIMARY KEY (id)
) ;


CREATE TABLE estaciones
(
  id serial NOT NULL,
  latitud float4 NOT NULL,
  longitud float4 NOT NULL,
  pais varchar(80) NOT NULL,
  informacion varchar(300) NOT NULL,
  nombre varchar(100),
  codigoOMM varchar(100),
  altura float4,
  actual varchar(2),
  estado_id int4 NOT NULL,
  CONSTRAINT estaciones_pkey PRIMARY KEY (id),
  CONSTRAINT DOM_HC_ESTACION CHECK (actual in ('SI','NO')),
  CONSTRAINT estacion_fk FOREIGN KEY (estado_id)
      REFERENCES estados (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
) ;


CREATE TABLE variable_hidroclimaticas (
       id              SERIAL NOT NULL,
       nombre_hc       VARCHAR(100),
       tipo_hc         CHAR(1),
       descripcion_hc  VARCHAR(400),
       acumulada_hc    CHAR(1),
       CONSTRAINT PK_VARIABLE_HIDROCLIMATICA PRIMARY KEY (id),
       CONSTRAINT DOM_HC_TIPO CHECK (tipo_hc in ('S','D')),
       CONSTRAINT DOM_HC_ACUMULADA CHECK (acumulada_hc in ('S','N'))
);

CREATE TABLE se_observas
(
  id SERIAL NOT NULL,
  id_estacion int4 NOT NULL,
  id_variable int4 NOT NULL,
  CONSTRAINT se_observa_pk PRIMARY KEY (id_estacion, id_variable),
  CONSTRAINT se_observa_fk1 FOREIGN KEY (id_estacion) REFERENCES estaciones (id),
  CONSTRAINT se_observa_fk2 FOREIGN KEY (id_variable) REFERENCES variable_hidroclimaticas (id)
) ;


CREATE TABLE servicios
(
  id serial NOT NULL,
  nombre varchar(30) NOT NULL,
  descripcion varchar(200) NOT NULL,
  habilitado bool NOT NULL,
  autor varchar(30) NOT NULL,
  usuario_id int4 NOT NULL,
  url_wsdl varchar(100) NULL,
  url_owls varchar(100) NULL,
  tags varchar(255) NULL,
  CONSTRAINT servicios_pkey PRIMARY KEY (id),
  CONSTRAINT cargadopor_fk FOREIGN KEY (usuario_id)
      REFERENCES usuarios (id) MATCH SIMPLE
) ;

CREATE TABLE periodo_operacions
(
  id SERIAL NOT NULL,
  estacion_id_po int4 NOT NULL,
  fecha_inicio_po DATE NOT NULL,
  fecha_fin_po DATE NOT NULL,
  CONSTRAINT periodo_op_pk PRIMARY KEY (estacion_id_po,fecha_inicio_po,fecha_fin_po),
  CONSTRAINT periodo_op_fk FOREIGN KEY (estacion_id_po) REFERENCES estaciones (id)
) ;

CREATE TABLE requerimientos
(
  id SERIAL NOT NULL,
  requerimiento varchar(50) NOT NULL,
  detalles varchar(250) NULL,
  CONSTRAINT pk_requerimientos PRIMARY KEY (id)
);

CREATE TABLE solicitudes
(
  id SERIAL NOT NULL,
  solicitante int4 NOT NULL,
  prioridad varchar(20) NOT NULL,
  atendido_por int4 NULL,
  requerimiento varchar(50) NOT NULL,
  comentarios varchar(250) NULL,
  CONSTRAINT pk_solicitudes PRIMARY KEY (id)
);



-- PARTE DE SORAYA EN POSTGRES

CREATE TABLE unidads(
       id              SERIAL,
       nombre_unid     VARCHAR(100)            NOT NULL,
       acronimo_unid   VARCHAR(20),
       CONSTRAINT PK_unidad    PRIMARY KEY (id)
);

    
CREATE TABLE tipo_objetos(
       id                      SERIAL NOT NULL,
       nombre_generico_TO      VARCHAR(20),
       clase_TO                CHAR(1),
       descrip_TO              VARCHAR(150),
       alcance_geo_TO          VARCHAR(200),
       CONSTRAINT PK_tipo_objeto PRIMARY KEY (id),
       CONSTRAINT CHK_clase_tipo_objetom CHECK (clase_TO in ('A', 'E'))
);

CREATE TABLE fenomeno_meteorologicos (
       id              SERIAL NOT NULL,
       nombre_F        VARCHAR(20),
       descrip_F       VARCHAR(150),
       lugar_geo_F     VARCHAR(200),
       primera_obs_F   DATE,
       periodicidad_F  VARCHAR(15),
       CONSTRAINT PK_fenomeno_m PRIMARY KEY (id)
);

CREATE TABLE incide_tofs(
       id                      SERIAL NOT NULL,
       id_tipo_objeto_tof      VARCHAR(20),
       id_fenomeno_tof         VARCHAR(20),
       CONSTRAINT PK_incide  PRIMARY KEY (id_tipo_objeto_tof,id_fenomeno_tof),
       CONSTRAINT FK_tipo_objeto_tof FOREIGN KEY (id_tipo_objeto_tof) REFERENCES tipo_objetos (id),
       CONSTRAINT FK_fenomeno_tof FOREIGN KEY (id_fenomeno_tof) REFERENCES fenomeno_meteorologicos (id) 
);


CREATE TABLE afecta_fvhcs(
       id                      SERIAL NOT NULL,
       id_fenomeno_fvhc        int4,
       id_varhidroclim_fvhc    int4,
       CONSTRAINT PK_afecta  PRIMARY KEY (id_fenomeno_fvhc,id_varhidroclim_fvhc),
       CONSTRAINT FK_fenomeno_fvhc FOREIGN KEY (id_fenomeno_fvhc) REFERENCES fenomeno_meteorologicos (id),
       CONSTRAINT FK_variable_fvhc FOREIGN KEY (id_varhidroclim_fvhc) REFERENCES variable_hidroclimaticas (id)
);

CREATE TABLE se_asocia_vhctos(
       id                      SERIAL NOT NULL,
       id_varhidroclim_vhcto   int4,
       id_tipo_objeto_vhcto    int4,
       CONSTRAINT PK_se_asocia  PRIMARY KEY (id_varhidroclim_vhcto,id_tipo_objeto_vhcto),
       CONSTRAINT FK_variable_vhcto FOREIGN KEY (id_varhidroclim_vhcto) REFERENCES variable_hidroclimaticas (id),
       CONSTRAINT FK_tipo_objeto_vhcto FOREIGN KEY (id_tipo_objeto_vhcto) REFERENCES tipo_objetos(id)
);

CREATE TABLE variable_socioeconomicas(
       id               SERIAL NOT NULL,
       nombre_vse       VARCHAR(100),
       descripcion_vse  VARCHAR(400),
       CONSTRAINT PK_VARIABLE_SOCIOECONOMICA PRIMARY KEY (id)
);

CREATE TABLE se_relaciona_vsetos(
       id                      SERIAL NOT NULL,
       id_varsocioe_vseto      int4,
       id_tipo_objeto_vseto    int4,
       CONSTRAINT PK_se_relaciona  PRIMARY KEY (id_varsocioe_vseto,id_tipo_objeto_vseto),
       CONSTRAINT FK_variable_vseto FOREIGN KEY (id_varsocioe_vseto) REFERENCES variable_socioeconomicas (id),
       CONSTRAINT FK_tipo_objeto_vseto FOREIGN KEY (id_tipo_objeto_vseto) REFERENCES tipo_objetos (id)
);

-- Parte que añadí (Alfredo)
CREATE TABLE medios (
       id                   SERIAL NOT NULL,
       nombre_med           VARCHAR(100),
       descripcion_med      VARCHAR(400),
       propiedades_med      VARCHAR(400),
       id_tipo_instrumento  VARCHAR(100),
       CONSTRAINT PK_medio PRIMARY KEY (id)
);

CREATE TABLE tipo_instrumentos (
       id                   SERIAL NOT NULL,
       nombre_ti            VARCHAR(100),
       tipo_ti              VARCHAR(1),
       tipo_registrador_ti  VARCHAR(2),
       descripcion_ti       VARCHAR(400),
       restriccion_ti       VARCHAR(200),
       id_medio             INT4,
       CONSTRAINT PK_TIPO_INSTRUMENTO PRIMARY KEY (id),
       CONSTRAINT DOM_TINS_TIPO CHECK (tipo_ti in ('M','R','A')),
       CONSTRAINT DOM_TINS_TIPO_REG CHECK (tipo_registrador_ti in ('M','E','EM')),
       CONSTRAINT FK_tipo_ins_medio FOREIGN KEY (id_medio) REFERENCES medios (id)
);

CREATE TABLE se_mide_vunis(
       id                        SERIAL NOT NULL,
       id_varhidroclim_vuni      int4,
       id_unid_vuni          int4,
       CONSTRAINT PK_se_mide  PRIMARY KEY (id_varhidroclim_vuni,id_unid_vuni),
       CONSTRAINT FK_variable_vuni FOREIGN KEY (id_varhidroclim_vuni) REFERENCES variable_hidroclimaticas (id),
       CONSTRAINT FK_tipo_ins_vuni FOREIGN KEY (id_unid_vuni) REFERENCES unidads (id)
);

CREATE TABLE puede_medir_vtins(
       id                         SERIAL NOT NULL,
       id_varhidroclim_vtins      int4,
       id_tipo_ins_vtins          int4,
       CONSTRAINT PK_puede_medir  PRIMARY KEY (id_varhidroclim_vtins,id_tipo_ins_vtins),
       CONSTRAINT FK_variable_vtins FOREIGN KEY (id_varhidroclim_vtins) REFERENCES variable_hidroclimaticas (id),
       CONSTRAINT FK_tipo_ins_vtins FOREIGN KEY (id_tipo_ins_vtins) REFERENCES tipo_instrumentos (id)
);



-- Esquema de metadatos
CREATE TABLE metadatos_desc (
  id_metadesc SERIAL NOT NULL,
  tipo_variable VARCHAR(50) NOT NULL,
  codigo_estacion_muni VARCHAR(15) NOT NULL,
  variable VARCHAR(50) NOT NULL,
  granularidad VARCHAR(200) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  PRIMARY KEY(id_metadesc) 
) ;

CREATE TABLE metadatos_rowids (
  id_descriptor int4 NOT NULL,
  row_id_medida int4 NOT NULL,
  PRIMARY KEY(id_descriptor,row_id_medida),
  CONSTRAINT FK_rows_meta FOREIGN KEY (id_descriptor) REFERENCES metadatos_desc (id_metadesc)
) ;

-- Algunas tablas faltantes
CREATE TABLE consultas
(
  id serial NOT NULL,
  usuario_id int4 NOT NULL,
  texto_pregunta text NOT NULL,
  id_pred int4,
  pred bool,
  sql_query text,
  CONSTRAINT consultas_pkey PRIMARY KEY (id)
) ;

CREATE TABLE consultatags
(
  id serial NOT NULL,
  consulta_id int4 NOT NULL,
  tag varchar(30)  NOT NULL,
  CONSTRAINT consultatags_pkey PRIMARY KEY (id)
) 
;


CREATE TABLE activewarehouse_schema_info
(
  version int4
) 
;


CREATE TABLE estacion_dimension
(
  id serial NOT NULL,
  nombre_est varchar(255),
  latitud_est float8,
  longitud_est float8,
  altura_est int4,
  CONSTRAINT estacion_dimension_pkey PRIMARY KEY (id)
)
;



CREATE TABLE medidavarhc_facts
(
  id serial NOT NULL,
  tiempo_id int4 NOT NULL,
  unidad_id int4 NOT NULL,
  estacion_id int4 NOT NULL,
  nivelagregacion_id int4 NOT NULL,
  variable_id int4 NOT NULL,
  valor_m float8 NOT NULL,
  observacion_m varchar(255),
  CONSTRAINT medidavarhc_facts_pkey PRIMARY KEY (id)
) 
;



CREATE TABLE nivelagregacion_dimension
(
  id serial NOT NULL,
  nivel_agregacion varchar(255),
  CONSTRAINT nivelagregacion_dimension_pkey PRIMARY KEY (id)
) 
;


CREATE TABLE schema_info
(
  version int4
) 
;


CREATE TABLE simple_captcha_data
(
  "key" varchar(40) NOT NULL,
  value varchar(6),
  created_at date,
  updated_at date,
  id serial NOT NULL,
  CONSTRAINT simple_captcha_data_id PRIMARY KEY (id)
) 
;



CREATE TABLE table_reports
(
  id serial NOT NULL,
  title varchar(255),
  cube_name varchar(255) NOT NULL,
  column_dimension_name varchar(255),
  column_hierarchy varchar(255),
  column_constraints text,
  column_stage int4,
  column_param_prefix varchar(255),
  row_dimension_name varchar(255),
  row_hierarchy varchar(255),
  row_constraints text,
  row_stage int4,
  row_param_prefix varchar(255),
  fact_attributes text,
  created_at timestamp,
  updated_at timestamp,
  CONSTRAINT table_reports_pkey PRIMARY KEY (id)
) 
;


CREATE TABLE tiempo_dimension
(
  id serial NOT NULL,
  unidad_t varchar(255),
  observacion_t varchar(255),
  tiempo date,
  dia int2,
  mes int2,
  anio int2,
  hora time,
  CONSTRAINT tiempo_dimension_pkey PRIMARY KEY (id)
) 
;



CREATE TABLE unidad_dimension
(
  id serial NOT NULL,
  unidad_medida_u varchar(255),
  observacion_u varchar(255),
  CONSTRAINT unidad_dimension_pkey PRIMARY KEY (id)
) 
;



