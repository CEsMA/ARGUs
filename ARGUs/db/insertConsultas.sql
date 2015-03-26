drop table if exists consultas;
drop table if exists consultatags;
CREATE TABLE consultas (
  id SERIAL NOT NULL,
  usuario_id int4 NOT NULL,
  texto_pregunta text,
  PRIMARY KEY(id)
) ;

CREATE TABLE consultatags (
  id SERIAL NOT NULL,
  consulta_id int4 NOT NULL,
  tag varchar(30),
  PRIMARY KEY(id)
) ;

insert into consultas (usuario_id, texto_pregunta) values (1,'Dado el nombre de un fenómeno meteorológico, listar las variables cuyas medidas pueden verse afectadas por el fenómeno.');
insert into consultas (usuario_id, texto_pregunta) values (1,'Dado el nombre de un fenó́meno meteorológico, listar los tipos de objetos en los que dicho fenómeno incidió.');
insert into consultas (usuario_id, texto_pregunta) values (1,'Dada una variable hidroclimática, conocer si las mediciones de dicha variable pueden englobarse o no, listar los instrumentos con que se miden, en cuá́l medio se guardan los resultados obtenidos, los tipos de objeto con los cuales se asocia y/o las unidades que se utilizan para su medición');
insert into consultas (usuario_id, texto_pregunta) values (1,'Dado un tipo de objeto epidemiológico, listar el conjunto de variables socioeconómicas con las que se relaciona, el alcance geográfico donde se han visto instancias del objeto de estudio, las variables hidroclimáticas asociadas y los fenómenos meteorológicos que incidieron en él.');

                         


