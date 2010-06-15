--
-- PostgreSQL database dump
--

-- Started on 2008-03-27 16:55:35 VET

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1766 (class 0 OID 0)
-- Dependencies: 1371
-- Name: consultas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('consultas_id_seq', 36, true);


--
-- TOC entry 1763 (class 0 OID 17719)
-- Dependencies: 1372
-- Data for Name: consultas; Type: TABLE DATA; Schema: public; Owner: postgres
--

--ALTER TABLE consultas DISABLE TRIGGER ALL;

COPY consultas (id, usuario_id, texto_pregunta, id_pred, pred, sql_query) FROM stdin;
1	401378	Dado el nombre de un fenómeno meteorológico, listar las variables cuyas medidas pueden verse afectadas por el fenómeno.	1	f	\N
2	1	Dado el nombre de un fenómeno meteorológico, listar los tipos de objetos en los que dicho fenómeno incidió.	2	f	\N
3	1	Dada una variable hidroclimática, conocer si las mediciones de dicha variable pueden englobarse o no, listar los instrumentos con que se miden, en cuá́l medio se guardan los resultados obtenidos, los tipos de objeto con los cuales se asocia y/o las unidades que se utilizan para su medición	3	f	\N
4	1	Dado un tipo de objeto epidemiológico, listar el conjunto de variables socioeconómicas con las que se relaciona, el alcance geográfico donde se han visto instancias del objeto de estudio, las variables hidroclimáticas asociadas y los fenómenos meteorológicos que incidieron en él.	4	f	\N
6	1	Para un conjunto de variables climáticas dadas, en un nivel de agregación provisto por el usuario, sobre una región geográfica especificada y un rango de tiempo determinado, conocer algunas variables estadísticas como las mencionadas en el punto anterior.	6	t	
5	1	Búsqueda de estaciones según parámetros (inclusivos o no) como la altitud, código OMM (clave candidata), fecha inicio y fecha fin de operaciones (ver observación e), conjunto de variables que mide y región geográfica en la que se emplaza/emplazó.	5	t	
19	1	Obtener el nombre de las estaciones de acuerdo a expresiones regulares.	0	f	select nombre from estaciones where {estaciones.nombre like [('Nombre')]}
34	1	Consulta avanzada de estaciones	0	f	select nombre, apellido from usuarios where {usuarios.campo_trabajo ='[texto: Campo]'}  AND {usuarios.fecha_registro >'[fecha: Registrado el]'} AND {usuarios.tipo ='[select:Tipo de Usuario]'} AND {usuarios.apellido like [('Apellido')]}
18	1	Seleccionar usuarios según id, login y fecha de registro.	0	f	select * from usuarios where {usuarios.login ='[select:LogiN]'} AND {usuarios.id >[texto:id]} AND {usuarios.fecha_registro >'[fecha: fecha de registro]'}
36	24	CONSULTA AVANZADA DE USUARIOS	0	f	select nombre, apellido from usuarios where {usuarios.campo_trabajo ='[texto: Campo]'}  AND {usuarios.fecha_registro >'[fecha: Registrado el]'} AND {usuarios.tipo ='[select:Tipo de Usuario]'} AND {usuarios.apellido like [('Apellido')]}
\.


--ALTER TABLE consultas ENABLE TRIGGER ALL;

-- Completed on 2008-03-27 16:55:35 VET

--
-- PostgreSQL database dump complete
--

