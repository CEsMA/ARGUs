--
-- PostgreSQL database dump
--

-- Started on 2008-03-27 16:56:59 VET

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1768 (class 0 OID 0)
-- Dependencies: 1388
-- Name: unidad_dimension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('unidad_dimension_id_seq', 3, true);


--
-- TOC entry 1765 (class 0 OID 18850)
-- Dependencies: 1389
-- Data for Name: unidad_dimension; Type: TABLE DATA; Schema: public; Owner: postgres
--

--ALTER TABLE unidad_dimension DISABLE TRIGGER ALL;

COPY unidad_dimension ( unidad_medida_u, observacion_u) FROM stdin;
	milimetros cubicos	\N
	centimetros cubicos	\N
	grados celsius	\N
\.


--ALTER TABLE unidad_dimension ENABLE TRIGGER ALL;

-- Completed on 2008-03-27 16:56:59 VET

--
-- PostgreSQL database dump complete
--

