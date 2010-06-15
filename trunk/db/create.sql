drop table if exists tags;
drop table if exists vinculos;
drop table if exists usuarios_vinculos_tags;
drop table if exists areaintereses;
drop table if exists usuarios_intereses;
drop table if exists mensajes;
drop table if exists hilos;
drop table if exists usuarios;


CREATE TABLE tags (
  id INT NOT NULL auto_increment,
  tag VARCHAR(20) NULL,
  PRIMARY KEY(id)
) engine=InnoDB;


CREATE TABLE vinculos (
  id INT NOT NULL auto_increment,
  vinculo VARCHAR(100) NULL,
  PRIMARY KEY(id)
) engine=InnoDB;


CREATE TABLE usuarios_vinculos_tags (
  id_usuario VARCHAR(30) NOT NULL,
  id_vinculo int NOT NULL,
  id_tag int NOT NULL,
  PRIMARY KEY(id_usuario, id_vinculo, id_tag) 
) engine=InnoDB;


CREATE TABLE areaintereses (
  id INT NOT NULL auto_increment,
  interes VARCHAR(50) NULL,
  PRIMARY KEY(id)
) engine=InnoDB;


CREATE TABLE usuarios_intereses (
  id_usuario VARCHAR(30) NOT NULL,
  id_interes VARCHAR(50) NOT NULL,
  PRIMARY KEY(id_usuario, id_interes)
) engine=InnoDB;


CREATE TABLE mensajes (
  id INT NOT NULL auto_increment,
  id_hilo INT NOT NULL,
  id_usuario VARCHAR(30) NOT NULL,
  mensaje VARCHAR(300) NOT NULL,
  PRIMARY KEY (id)
) engine=InnoDB;


CREATE TABLE hilos (
  id INT NOT NULL auto_increment,
  titulo VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
) engine=InnoDB;


CREATE TABLE usuarios (
  id INT NOT NULL auto_increment,
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
) engine=InnoDB;
