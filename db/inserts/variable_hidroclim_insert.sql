--
-- PostgreSQL database dump
--

-- Started on 2008-03-27 16:56:23 VET

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1769 (class 0 OID 0)
-- Dependencies: 1398
-- Name: variable_hidroclimaticas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('variable_hidroclimaticas_id_seq', 4, true);


--
-- TOC entry 1766 (class 0 OID 19076)
-- Dependencies: 1399
-- Data for Name: variable_hidroclimaticas; Type: TABLE DATA; Schema: public; Owner: postgres
--

--ALTER TABLE variable_hidroclimaticas DISABLE TRIGGER ALL;

COPY variable_hidroclimaticas (id, nombre_hc, tipo_hc, descripcion_hc, acumulada_hc) FROM stdin;
1	temperatura	S	del aire	N
3	presion	S	del aire	N
2	precipitacion	S	lluvia	S
\.


--ALTER TABLE variable_hidroclimaticas ENABLE TRIGGER ALL;

-- Completed on 2008-03-27 16:56:23 VET

--
-- PostgreSQL database dump complete
--

