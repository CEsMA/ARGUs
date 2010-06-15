rem
rem  Script de creacion de la base de datos del
rem  Repositorio de Datos Hidroclimaticos
rem
rem     Noviembre 2007
rem
rem  Autor: Soraya Abad Mota
rem
rem
rem  Borrado de las tablas
drop table estacion_m cascade constraints;
drop table institucion cascade constraints;
drop table periodo_operacion cascade constraints;
drop table periodo_observacion cascade constraints;
drop table parametro cascade constraints;
drop table unidad cascade constraints;
drop table se_representa cascade constraints;
drop table inventario_parametro cascade constraints;
drop table tipo_objeto cascade constraints;
drop table fenomeno_meteorologico cascade constraints;
drop table incide_tof cascade constraints;
drop table variable_hidroclimatica cascade constraints;
drop table afecta_fvhc cascade constraints;
drop table se_asocia_vhcto cascade constraints;
drop table variable_socioeconomica cascade constraints;
drop table se_relaciona_vseto cascade constraints;
rem
rem   Creacion de las tablas
rem
rem   Lista de entidades traducidas:
rem     Estacion_m, foto_estacion, periodo_operacion, institucion
rem     Inventario_parametro, unidad,
rem

CREATE TABLE estacion_m(
       identificador_E         VARCHAR(5)      PRIMARY KEY,
       serial_E                VARCHAR(4)      NOT NULL,
       codigo_omm_E            VARCHAR(4),
       nombre_E                VARCHAR(50),
       latitud_E               VARCHAR(6),
       longitud_E              VARCHAR(6),
       altura_E                NUMBER(4,2),
       estado_E                char(2),
       categoria_E             VARCHAR(50),
       sub_categoria_E         VARCHAR(50),
       caracteristicas_E       VARCHAR(200)
);

CREATE TABLE institucion(
       acronimo_I              VARCHAR(15),
       nombre_I                VARCHAR(50)     NOT NULL,
       mision_I                VARCHAR(200)    NOT NULL,
       tipo_I                  VARCHAR(20)     NOT NULL,
       alcance_I               VARCHAR(20)     NOT NULL,
       departamento_I          VARCHAR(50),
       cargo_I                 VARCHAR(50),
       persona_I               VARCHAR(100),
       CONSTRAINT PK_INSTITUCION PRIMARY KEY (acronimo_I),
       CONSTRAINT chk_inst_tipo CHECK (tipo_I in ('Industria', 'Educacion', 'Investigacion', 'Gobierno', 'Consultora', 'ONG')),
       CONSTRAINT chk_inst_alcance CHECK (alcance_I in ('Mundial', 'Nacional', 'Regional', 'Municipal'))
);

CREATE TABLE periodo_operacion (
       id_estacion_m_pop       VARCHAR(5),
       acronimo_I_pop          VARCHAR(15),
       fecha_inicio_pop        DATE,
       fecha_fin_pop           DATE,
       CONSTRAINT PK_POP PRIMARY KEY (id_estacion_m_pop, acronimo_I_pop),
       CONSTRAINT FK_POP_estacion FOREIGN KEY (id_estacion_m_pop) REFERENCES estacion_m,
       CONSTRAINT FK_POP_institucion FOREIGN KEY (acronimo_I_pop) REFERENCES institucion
);

CREATE TABLE parametro(
       codigo_param            VARCHAR(4)      PRIMARY KEY,
       nombre_param            VARCHAR(50)     NOT NULL,
       tipo_param              VARCHAR(25)     NOT NULL,
       CONSTRAINT chk_tipo_param CHECK (tipo_param in ('valor agregado','variable hidroclimatica'))
);

CREATE TABLE periodo_observacion(
       id_estacion_m_pobs      VARCHAR(5),
       codigo_param_pobs       VARCHAR(4),
       fecha_inicio_pobs       DATE,
       fecha_fin_pobs          DATE,
       CONSTRAINT PK_POBSERV PRIMARY KEY(id_estacion_m_pobs, codigo_param_pobs, fecha_inicio_pobs),
       CONSTRAINT FK_POBS_estacion FOREIGN KEY (id_estacion_m_pobs) REFERENCES estacion_m,
       CONSTRAINT FK_POBS_parametro FOREIGN KEY (codigo_param_pobs) REFERENCES parametro
);

CREATE TABLE unidad(
       id_unid         NUMBER(4),
       nombre_unid     VARCHAR(100)            NOT NULL,
       acronimo_unid   VARCHAR(20),
       CONSTRAINT PK_unidad    PRIMARY KEY (id_unid)
);

CREATE TABLE se_representa(
       codigo_parametro_sr     VARCHAR(4),
       id_unidad_sr            NUMBER(4),
       CONSTRAINT PK_se_repr PRIMARY KEY  (codigo_parametro_sr, id_unidad_sr),
       CONSTRAINT FK_SR_CODIGO FOREIGN KEY (codigo_parametro_sr) REFERENCES parametro,
       CONSTRAINT FK_SR_UNIDAD FOREIGN KEY (id_unidad_sr) REFERENCES unidad
 );

CREATE TABLE inventario_parametro(
       id_institucion_ip       VARCHAR(15),
       id_estacion_m_ip        VARCHAR(5),
       codigo_parametro_ip     VARCHAR(4),
       id_unidad_ip            NUMBER(4),
       frecuencia_ip           VARCHAR(10),
       fecha_inicio_ip         DATE,
       fecha_fin_ip            DATE,
       CONSTRAINT PK_inv_param PRIMARY KEY (id_institucion_ip, id_estacion_m_ip, codigo_parametro_ip, id_unidad_ip, frecuencia_ip, fecha_inicio_ip, fecha_fin_ip),
       CONSTRAINT FK_INST_IP FOREIGN KEY (id_institucion_ip) REFERENCES institucion,
       CONSTRAINT FK_ESTACION_IP FOREIGN KEY (id_estacion_m_ip) REFERENCES estacion_m,
       CONSTRAINT FK_PARAMETRO_IP FOREIGN KEY (codigo_parametro_ip) REFERENCES parametro,
       CONSTRAINT FK_UNIDAD_IP FOREIGN KEY (id_unidad_ip) REFERENCES unidad,
       CONSTRAINT CHK_inv_param CHECK (frecuencia_ip in ('horario', 'diario', 'semanal', 'mensual', 'trimestral', 'anual', 'decadario'))
);

CREATE TABLE tipo_objeto(
       nombre_generico_TO      VARCHAR(20),
       clase_TO                CHAR(1),
       descrip_TO              VARCHAR(150),
       alcance_geo_TO          VARCHAR(200),
       CONSTRAINT PK_tipo_objeto PRIMARY KEY (nombre_generico_TO),
       CONSTRAINT CHK_clase_tipo_objetom CHECK (clase_TO in ('A', 'E'))
);
CREATE TABLE fenomeno_meteorologico(
       nombre_F        VARCHAR(20),
       descrip_F       VARCHAR(150),
       lugar_geo_F     VARCHAR(200),
       primera_obs_F   DATE,
       periodicidad_F  VARCHAR(15),
       CONSTRAINT PK_fenomeno_m PRIMARY KEY (nombre_F)
);
CREATE TABLE incide_tof(
       id_tipo_objeto_tof      VARCHAR(20),
       id_fenomeno_tof         VARCHAR(20),
       CONSTRAINT PK_incide  PRIMARY KEY (id_tipo_objeto_tof,id_fenomeno_tof),
       CONSTRAINT FK_tipo_objeto_tof FOREIGN KEY (id_tipo_objeto_tof) REFERENCES tipo_objeto,
       CONSTRAINT FK_fenomeno_tof FOREIGN KEY (id_fenomeno_tof) REFERENCES fenomeno_meteorologico
);

CREATE TABLE variable_hidroclimatica(
       nombre_hc       VARCHAR2(100),
       tipo_hc         CHAR(1),
       descripcion_hc  VARCHAR2(400),
       acumulada_hc    CHAR(1),
       CONSTRAINT PK_VARIABLE_HIDROCLIMATICA PRIMARY KEY (nombre_hc),
       CONSTRAINT DOM_HC_TIPO CHECK (tipo_hc in ('S','D')),
       CONSTRAINT DOM_HC_ACUMULADA CHECK (acumulada_hc in ('S','N'))
);

CREATE TABLE afecta_fvhc(
       id_fenomeno_fvhc        VARCHAR(20),
       id_varhidroclim_fvhc    VARCHAR2(100),
       CONSTRAINT PK_afecta  PRIMARY KEY (id_fenomeno_fvhc,id_varhidroclim_fvhc),
       CONSTRAINT FK_fenomeno_fvhc FOREIGN KEY (id_fenomeno_fvhc) REFERENCES fenomeno_meteorologico,
       CONSTRAINT FK_variable_fvhc FOREIGN KEY (id_varhidroclim_fvhc) REFERENCES variable_hidroclimatica
);

CREATE TABLE se_asocia_vhcto(
       id_varhidroclim_vhcto   VARCHAR2(100),
       id_tipo_objeto_vhcto    VARCHAR(20),
       CONSTRAINT PK_se_asocia  PRIMARY KEY (id_varhidroclim_vhcto,id_tipo_objeto_vhcto),
       CONSTRAINT FK_variable_vhcto FOREIGN KEY (id_varhidroclim_vhcto) REFERENCES variable_hidroclimatica,
       CONSTRAINT FK_tipo_objeto_vhcto FOREIGN KEY (id_tipo_objeto_vhcto) REFERENCES tipo_objeto
);

CREATE TABLE variable_socioeconomica(
       nombre_vse       VARCHAR2(100),
       descripcion_vse  VARCHAR2(400),
       CONSTRAINT PK_VARIABLE_SOCIOECONOMICA PRIMARY KEY (nombre_vse)
);

CREATE TABLE se_relaciona_vseto(
       id_varsocioe_vseto      VARCHAR2(100),
       id_tipo_objeto_vseto    VARCHAR(20),
       CONSTRAINT PK_se_relaciona  PRIMARY KEY (id_varsocioe_vseto,id_tipo_objeto_vseto),
       CONSTRAINT FK_variable_vseto FOREIGN KEY (id_varsocioe_vseto) REFERENCES variable_socioeconomica,
       CONSTRAINT FK_tipo_objeto_vseto FOREIGN KEY (id_tipo_objeto_vseto) REFERENCES tipo_objeto
);

-- Parte que añadí (Alfredo)

CREATE TABLE tipo_instrumento(
       nombre_ti            VARCHAR(100),
       tipo_ti              VARCHAR(1),
       tipo_registrador_ti  VARCHAR(2),
       descripcion_ti       VARCHAR(400),
       restriccion_ti       VARCHAR(200),
       CONSTRAINT PK_TIPO_INSTRUMENTO PRIMARY KEY (nombre_ti),
       CONSTRAINT DOM_TINS_TIPO CHECK (tipo_ti in ('M','R','A')),
       CONSTRAINT DOM_TINS_TIPO_REG CHECK (tipo_registrador_ti in ('M','E','EM'))
);

CREATE TABLE se_mide_vuni(
       id_varhidroclim_vuni      VARCHAR(100),
       id_unid_vuni          NUMBER(4),
       CONSTRAINT PK_se_mide  PRIMARY KEY (id_varhidroclim_vuni,id_unid_vuni),
       CONSTRAINT FK_variable_vuni FOREIGN KEY (id_varhidroclim_vuni) REFERENCES variable_hidroclimatica,
       CONSTRAINT FK_tipo_ins_vuni FOREIGN KEY (id_unid_vuni) REFERENCES unidad
);

CREATE TABLE puede_medir_vtins(
       id_varhidroclim_vtins      VARCHAR(100),
       id_tipo_ins_vtins          VARCHAR(20),
       CONSTRAINT PK_puede_medir  PRIMARY KEY (id_varhidroclim_vtins,id_tipo_ins_vtins),
       CONSTRAINT FK_variable_vtins FOREIGN KEY (id_varhidroclim_vtins) REFERENCES variable_hidroclimatica,
       CONSTRAINT FK_tipo_ins_vtins FOREIGN KEY (id_tipo_ins_vtins) REFERENCES tipo_instrumento
);


CREATE TABLE medio (
       nombre_med           VARCHAR(100),
       descripcion_med      VARCHAR(400),
       propiedades_med      VARCHAR(400),
       id_tipo_instrumento  VARCHAR(100),
       CONSTRAINT PK_medio PRIMARY KEY (nombre_med),
       CONSTRAINT FK_tipo_ins_medio FOREIGN KEY (id_tipo_instrumento) REFERENCES tipo_instrumento
);

