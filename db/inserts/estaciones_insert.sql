--
-- PostgreSQL database dump
--

-- Started on 2008-03-27 16:52:31 VET

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1769 (class 0 OID 0)
-- Dependencies: 1361
-- Name: estaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('estaciones_id_seq', 6, true);


--
-- TOC entry 1766 (class 0 OID 16579)
-- Dependencies: 1362
-- Data for Name: estaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

--ALTER TABLE estaciones DISABLE TRIGGER ALL;

COPY estaciones (latitud, longitud, pais, informacion, nombre, estado_id, codigo_omm, altura, actual) FROM stdin;
12.985345	-3.4083469	Ni idea...	Tengo mucha información, pero no te la voy a dar... :P	Caurimare	1	ven-300	2300	SI
10.823488	-66.09346	Venezuela	Al azar...	Cachamay	1	ven-123	1500	SI
10.234344	-66.992271	Venezuela	xxx	Barbacoa2	1	ven-130	670	SI
10.2343	-66.1231	Venezuela	No tengo mucha info...	Barbacoa1	2	ven-134	1900	SI
0	4	Venezuela	Aqui yace una buena estación hidroclimática	Taguapire	2	ven-135	100	SI
8.37222	-62.643398	Venezuela	A cargo de la ONG "Amigos de los tepuyes"	Caroní	5	ven-234	400	SI
10.566667	-71.733299	Venezuela	Cerca de la ciudad de Cabimas	Cabimero	3	ven-121	120	SI
10.2863	-67.622101	Venezuela	En el poblado Mata Seca. A cargo de la Alcaldía MBI	El limon	2	ven-909	456	SI
\.


--ALTER TABLE estaciones ENABLE TRIGGER ALL;

-- Completed on 2008-03-27 16:52:31 VET

--
-- PostgreSQL database dump complete
--

