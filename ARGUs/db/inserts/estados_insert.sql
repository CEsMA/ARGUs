--
-- PostgreSQL database dump
--

-- Started on 2008-03-27 16:51:57 VET

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1766 (class 0 OID 0)
-- Dependencies: 1359
-- Name: estados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('estados_id_seq', 4, true);


--
-- TOC entry 1763 (class 0 OID 16572)
-- Dependencies: 1360
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE estados DISABLE TRIGGER ALL;

COPY estados (id, nombre) FROM stdin;
1	Miranda
2	Aragua
3	Zulia
4	Carabobo
5	Bolivar
\.


ALTER TABLE estados ENABLE TRIGGER ALL;

-- Completed on 2008-03-27 16:51:57 VET

--
-- PostgreSQL database dump complete
--

