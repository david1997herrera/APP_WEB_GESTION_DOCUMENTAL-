--
-- PostgreSQL database cluster dump
--

\restrict GSxZMWGdi7kG7d14u3A2YqFfDTcJtH0blcqnvpm33sIBGLEx89L41D3I61RCWXX

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:bJ4uUUP4ofiQksk5YJWY/g==$GqFfb0p3rMItlDftXz5VJ8W4JATk588GN84WXoCzLCw=:F7PROKsavUMN7fvEq/FbVYiX+MBIJE3lr01nIw2d9Us=';

--
-- User Configurations
--








\unrestrict GSxZMWGdi7kG7d14u3A2YqFfDTcJtH0blcqnvpm33sIBGLEx89L41D3I61RCWXX

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict ZP6CxyrKTFA7f40U8bLGvQoMxQGUtzqL6xn3mmbanPpAo8TUceHO5X6b9nMN9WZ

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict ZP6CxyrKTFA7f40U8bLGvQoMxQGUtzqL6xn3mmbanPpAo8TUceHO5X6b9nMN9WZ

--
-- Database "gestion_documental" dump
--

--
-- PostgreSQL database dump
--

\restrict o5kkPzfM77rUxy20uB6XO1qWBAcXEf7W42fE9D092lADompqVVCRuXaQKKnQVkn

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: gestion_documental; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE gestion_documental WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE gestion_documental OWNER TO postgres;

\unrestrict o5kkPzfM77rUxy20uB6XO1qWBAcXEf7W42fE9D092lADompqVVCRuXaQKKnQVkn
\connect gestion_documental
\restrict o5kkPzfM77rUxy20uB6XO1qWBAcXEf7W42fE9D092lADompqVVCRuXaQKKnQVkn

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: area_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.area_users (
    id integer NOT NULL,
    area_id integer NOT NULL,
    user_id integer NOT NULL,
    assigned_at timestamp without time zone
);


ALTER TABLE public.area_users OWNER TO postgres;

--
-- Name: area_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.area_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.area_users_id_seq OWNER TO postgres;

--
-- Name: area_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.area_users_id_seq OWNED BY public.area_users.id;


--
-- Name: areas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.areas (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.areas OWNER TO postgres;

--
-- Name: areas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.areas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.areas_id_seq OWNER TO postgres;

--
-- Name: areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.areas_id_seq OWNED BY public.areas.id;


--
-- Name: files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.files (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    original_filename character varying(255) NOT NULL,
    file_path character varying(500) NOT NULL,
    file_size integer NOT NULL,
    file_type character varying(100) NOT NULL,
    task_id integer,
    uploaded_by integer NOT NULL,
    uploaded_at timestamp without time zone,
    created_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.files OWNER TO postgres;

--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.files_id_seq OWNER TO postgres;

--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;


--
-- Name: purchase_requisitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_requisitions (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    amount numeric(12,2),
    status character varying(20) NOT NULL,
    requester_id integer NOT NULL,
    target_user_id integer,
    reviewer_id integer,
    approver_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    reviewed_at timestamp without time zone,
    approved_at timestamp without time zone,
    area_id integer
);


ALTER TABLE public.purchase_requisitions OWNER TO postgres;

--
-- Name: purchase_requisitions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_requisitions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_requisitions_id_seq OWNER TO postgres;

--
-- Name: purchase_requisitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_requisitions_id_seq OWNED BY public.purchase_requisitions.id;


--
-- Name: scheduled_task_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scheduled_task_users (
    id integer NOT NULL,
    scheduled_task_id integer NOT NULL,
    user_id integer NOT NULL,
    assigned_at timestamp without time zone
);


ALTER TABLE public.scheduled_task_users OWNER TO postgres;

--
-- Name: scheduled_task_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scheduled_task_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scheduled_task_users_id_seq OWNER TO postgres;

--
-- Name: scheduled_task_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scheduled_task_users_id_seq OWNED BY public.scheduled_task_users.id;


--
-- Name: scheduled_tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scheduled_tasks (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    area_id integer NOT NULL,
    created_by integer NOT NULL,
    frequency character varying(20) NOT NULL,
    "interval" integer NOT NULL,
    priority character varying(10) NOT NULL,
    start_date timestamp without time zone NOT NULL,
    run_time time without time zone,
    end_date timestamp without time zone,
    next_run_at timestamp without time zone,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.scheduled_tasks OWNER TO postgres;

--
-- Name: scheduled_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scheduled_tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scheduled_tasks_id_seq OWNER TO postgres;

--
-- Name: scheduled_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scheduled_tasks_id_seq OWNED BY public.scheduled_tasks.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    area_id integer NOT NULL,
    created_by integer NOT NULL,
    assigned_to integer,
    status character varying(20),
    priority character varying(10),
    required_files integer,
    uploaded_files integer,
    due_date timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    completed_at timestamp without time zone,
    scheduled_task_id integer
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_id_seq OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(80) NOT NULL,
    email character varying(120) NOT NULL,
    password_hash character varying(128),
    role character varying(20) NOT NULL,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: area_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_users ALTER COLUMN id SET DEFAULT nextval('public.area_users_id_seq'::regclass);


--
-- Name: areas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas ALTER COLUMN id SET DEFAULT nextval('public.areas_id_seq'::regclass);


--
-- Name: files id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);


--
-- Name: purchase_requisitions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requisitions ALTER COLUMN id SET DEFAULT nextval('public.purchase_requisitions_id_seq'::regclass);


--
-- Name: scheduled_task_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_task_users ALTER COLUMN id SET DEFAULT nextval('public.scheduled_task_users_id_seq'::regclass);


--
-- Name: scheduled_tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_tasks ALTER COLUMN id SET DEFAULT nextval('public.scheduled_tasks_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: area_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.area_users (id, area_id, user_id, assigned_at) FROM stdin;
19	13	13	2026-03-27 17:33:47.55729
20	14	15	2026-03-27 17:34:04.346604
22	16	18	2026-03-27 17:34:32.498951
23	17	17	2026-03-27 17:34:53.437817
24	15	14	2026-03-27 17:35:29.562144
25	5	10	2026-03-27 17:35:45.568759
26	6	9	2026-03-27 17:36:05.178894
27	7	10	2026-03-27 17:36:44.420806
28	8	5	2026-03-27 17:37:07.101731
30	11	12	2026-03-27 17:38:24.837709
31	18	16	2026-03-27 17:48:15.59588
32	5	33	2026-03-30 16:20:45.325496
33	12	34	2026-04-04 00:29:14.375623
\.


--
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.areas (id, name, description, is_active, created_at, updated_at) FROM stdin;
12	Coordinación y Ventas	Coordinar la planificación comercial y gestionar la venta de la producción florícola, mediante la programación de pedidos, comunicación con clientes y seguimiento de despachos, asegurando el cumplimiento de requisitos, volúmenes, calidad y tiempos de entrega.	t	2026-03-27 16:15:22.43809	2026-03-27 17:26:01.927958
13	Jefatura de Finca	Planificar, coordinar y supervisar el proceso agrícola de la florícola mediante la ejecución de programas de cultivo y la administración del personal de campo, asegurando el cumplimiento de la producción, calidad, requerimientos Flor Verde y tiempos establecidos.	t	2026-03-27 16:16:45.632422	2026-03-27 17:26:11.786034
14	Supervisión de Postcosecha 	Supervisar el proceso de postcosecha mediante la coordinación de clasificación, hidratación, empaque, despacho y manejo de tiempos de frio, asegurando el cumplimiento de estándares de calidad, trazabilidad, requisitos Flor Verde y tiempos de entrega.	t	2026-03-27 16:22:59.706439	2026-03-27 17:26:19.466417
15	Supervisor de Calidad y Sanidad 	Asegurar la integridad técnica del proceso productivo florícola mediante la supervisión permanente de los parámetros de calidad del producto y la correcta ejecución de los programas fitosanitarios, garantizando el cumplimiento de los estándares internos de producción, las normativas fitosanitarias vigentes y los requisitos de calidad exigidos por los mercados internacionales.	t	2026-03-27 16:26:57.948233	2026-03-27 17:26:27.819125
16	Departamento Médico 	Diseñar y ejecutar el sistema de medicina laboral y preventiva para proteger la salud del personal, controlar riesgos propios de la floricultura y sostener el cumplimiento legal y de certificaciones.	t	2026-03-27 17:29:08.83425	2026-03-27 17:29:08.834252
17	Departamento SST	Supervisar la gestión de seguridad y salud en el trabajo mediante la implementación de programas preventivos, identificación de riesgos y control del cumplimiento normativo y flor verde asegurando condiciones laborales seguras y la prevención de incidentes y enfermedades ocupacionales.	t	2026-03-27 17:31:51.802674	2026-03-27 17:31:51.802675
18	Bodega	Administrar el almacenamiento y control de materiales e insumos mediante la recepción, custodia y despacho, asegurando disponibilidad, orden, trazabilidad y uso adecuado de los recursos.	t	2026-03-27 17:37:55.516462	2026-03-27 17:37:55.516463
5	Gerencia General	Dirigir y Supervisar la gestión integral de la empresa mediante la planificación estratégica, la toma de decisiones y el control de las operaciones, asegurando el cumplimiento de objetivos productivos, comerciales, financieros, legales y cumplimiento de certificaciones.	t	2026-03-27 15:52:13.317719	2026-03-27 17:23:42.132225
8	Jefatura Administrativa y RRHH	Coordinar y controlar la gestión administrativa y de talento humano mediante la administración de recursos, ejecución de procesos de personal y cumplimiento legal vigente en Ecuador, asegurando el soporte operativo, el cumplimiento de requisitos Flor Verde y la adecuada gestión de los colaboradores.	t	2026-03-27 16:01:49.264547	2026-09-01 17:10:55.197082
6	Gerencia Administrativa 	Planificar, coordinar y controlar la gestión administrativa y financiera de la empresa florícola, mediante la administración de recursos, presupuesto, servicios de apoyo, cumplimiento normas y cumplimiento de certificaciones, asegurando la eficiencia operativa y el soporte a las áreas productivas y comerciales.	t	2026-03-27 15:54:41.223469	2026-09-01 20:39:29.265696
7	Gerencia Técnica 	Planificar, dirigir y controlar la producción florícola mediante la gestión técnica del cultivo, implementación de programas agronómicos y supervisión de estándares de calidad, asegurando rendimiento, sanidad vegetal y cumplimiento de los requisitos productivos.	t	2026-03-27 15:56:22.83959	2026-03-27 17:24:17.420381
11	Cartera y Adquisiciones 	Planificar y gestionar la adquisición de bienes y servicios mediante la selección y evaluación de proveedores, negociación de condiciones comerciales y seguimiento de órdenes de compra, asegurando la calidad, el cumplimiento de requisitos Flor Verde, costos adecuados y tiempos de entrega oportunos.	t	2026-03-27 16:10:38.013903	2026-03-27 17:25:31.466044
\.


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.files (id, filename, original_filename, file_path, file_size, file_type, task_id, uploaded_by, uploaded_at, created_at, is_active) FROM stdin;
13	28159da6-e712-4b9f-94ae-e2c62081fd0a_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	uploads/tasks/47/28159da6-e712-4b9f-94ae-e2c62081fd0a_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	64418	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	47	5	2026-04-08 18:48:50.130693	2026-04-08 18:48:50.130695	t
17	7dbdc09a-dd36-4b6b-a7c9-f83837628840_Acta_Buzon_de_sugerencias_dic_2025.pdf	Acta_Buzon_de_sugerencias_dic_2025.pdf	uploads/tasks/57/7dbdc09a-dd36-4b6b-a7c9-f83837628840_Acta_Buzon_de_sugerencias_dic_2025.pdf	1840708	application/pdf	57	5	2026-04-09 16:08:30.642595	2026-04-09 16:08:30.642598	t
18	a4a2b21c-ca7a-494a-9272-e045cf639559_Acta_apertura_de_buzon_ene2026.pdf	Acta_apertura_de_buzon_ene2026.pdf	uploads/tasks/57/a4a2b21c-ca7a-494a-9272-e045cf639559_Acta_apertura_de_buzon_ene2026.pdf	2039980	application/pdf	57	5	2026-04-09 16:08:49.965204	2026-04-09 16:08:49.965206	t
19	ac6d071c-b954-446c-b686-d8b8a5292ca6_Acta_Buzon_sugerencias_feb_2026.pdf	Acta_Buzon_sugerencias_feb_2026.pdf	uploads/tasks/57/ac6d071c-b954-446c-b686-d8b8a5292ca6_Acta_Buzon_sugerencias_feb_2026.pdf	2858192	application/pdf	57	5	2026-04-09 16:09:08.854737	2026-04-09 16:09:08.85474	t
20	35e1ba91-3bcd-4a0f-82d5-905451286225_Acta_Buzon_de_Sugerencias_marz_2026.pdf	Acta_Buzon_de_Sugerencias_marz_2026.pdf	uploads/tasks/57/35e1ba91-3bcd-4a0f-82d5-905451286225_Acta_Buzon_de_Sugerencias_marz_2026.pdf	1746253	application/pdf	57	5	2026-04-09 16:09:23.671299	2026-04-09 16:09:23.671302	t
21	1e5f583b-f0e0-4fb0-8382-7f8161fc398c_Actas_Clubs_dic2025.pdf	Actas_Clubs_dic2025.pdf	uploads/tasks/63/1e5f583b-f0e0-4fb0-8382-7f8161fc398c_Actas_Clubs_dic2025.pdf	6779024	application/pdf	63	5	2026-04-09 17:09:18.48696	2026-04-09 17:09:18.486963	t
23	84a23231-7286-4cfe-8a50-bdd578f73a00_Acta_Clubs_ene2026.pdf	Acta_Clubs_ene2026.pdf	uploads/tasks/63/84a23231-7286-4cfe-8a50-bdd578f73a00_Acta_Clubs_ene2026.pdf	6728498	application/pdf	63	5	2026-04-09 17:09:46.787992	2026-04-09 17:09:46.787995	t
24	ccdf72b9-9d31-4475-8b8f-cb7f8aef23ec_Actas_Clubs_feb2026.pdf	Actas_Clubs_feb2026.pdf	uploads/tasks/63/ccdf72b9-9d31-4475-8b8f-cb7f8aef23ec_Actas_Clubs_feb2026.pdf	8036835	application/pdf	63	5	2026-04-09 17:10:02.605492	2026-04-09 17:10:02.605495	t
25	277938f4-9360-45ef-8e1b-72c0373fcd50_Acta_Clubs_marz2026.pdf	Acta_Clubs_marz2026.pdf	uploads/tasks/63/277938f4-9360-45ef-8e1b-72c0373fcd50_Acta_Clubs_marz2026.pdf	3576057	application/pdf	63	5	2026-04-09 17:10:19.225391	2026-04-09 17:10:19.225394	t
26	e68012ca-b346-4fce-8108-f3ab748853fa_Horas_extras_feb2026.pdf	Horas_extras_feb2026.pdf	uploads/tasks/61/e68012ca-b346-4fce-8108-f3ab748853fa_Horas_extras_feb2026.pdf	8255598	application/pdf	61	5	2026-04-09 17:31:01.562344	2026-04-09 17:31:01.562347	t
27	3b3e9d8f-e733-4ea5-9c7d-d69f1b2c3d09_Horas_extras_marz2026.pdf	Horas_extras_marz2026.pdf	uploads/tasks/61/3b3e9d8f-e733-4ea5-9c7d-d69f1b2c3d09_Horas_extras_marz2026.pdf	10299495	application/pdf	61	5	2026-04-09 17:31:19.031261	2026-04-09 17:31:19.031264	t
28	44478af2-76dd-4eb5-958b-da8a503eb408_Registro_de_entrega_de_botellones_para_areas.pdf	Registro_de_entrega_de_botellones_para_areas.pdf	uploads/tasks/74/44478af2-76dd-4eb5-958b-da8a503eb408_Registro_de_entrega_de_botellones_para_areas.pdf	647498	application/pdf	74	5	2026-04-09 17:33:21.366947	2026-04-09 17:33:21.366949	t
29	2af0a9cb-9551-4675-a2e8-5788d7a9b36d_Informe_Analisis_consolidado_del_personal_cesante_ene-maz2026.docx	Informe_Analisis_consolidado_del_personal_cesante_ene-maz2026.docx	uploads/tasks/64/2af0a9cb-9551-4675-a2e8-5788d7a9b36d_Informe_Analisis_consolidado_del_personal_cesante_ene-maz2026.docx	169200	application/vnd.openxmlformats-officedocument.wordprocessingml.document	64	5	2026-04-09 21:01:36.687129	2026-04-09 21:01:36.687132	t
31	e775e4c5-8ad3-4a8d-9277-bae12d765d84_Acta_de_planificacion_T._Clubs.pdf	Acta_de_planificacion_T._Clubs.pdf	uploads/tasks/62/e775e4c5-8ad3-4a8d-9277-bae12d765d84_Acta_de_planificacion_T._Clubs.pdf	2383381	application/pdf	62	5	2026-04-13 13:11:19.629858	2026-04-13 13:11:19.629861	t
32	1bede671-c1b7-4359-a7f1-68808dda46f1_Inspeccion_aleatoria_de_canceles_Abril_2026.pdf	Inspeccion_aleatoria_de_canceles_Abril_2026.pdf	uploads/tasks/58/1bede671-c1b7-4359-a7f1-68808dda46f1_Inspeccion_aleatoria_de_canceles_Abril_2026.pdf	2295746	application/pdf	58	5	2026-04-13 18:02:34.576263	2026-04-13 18:02:34.576266	t
33	0d007e48-86ba-4c39-9363-7ded40aed8ae_Acta_Buzon_Abril_2026.pdf	Acta_Buzon_Abril_2026.pdf	uploads/tasks/57/0d007e48-86ba-4c39-9363-7ded40aed8ae_Acta_Buzon_Abril_2026.pdf	1473279	application/pdf	57	5	2026-04-23 16:24:16.135426	2026-04-23 16:24:16.13543	t
34	2b64f910-3d9a-4287-8a71-0f93c45b2aea_Plan_de_desarrollo_personal_2026_RM.docx	Plan_de_desarrollo_personal_2026_RM.docx	uploads/tasks/51/2b64f910-3d9a-4287-8a71-0f93c45b2aea_Plan_de_desarrollo_personal_2026_RM.docx	2695986	application/vnd.openxmlformats-officedocument.wordprocessingml.document	51	5	2026-04-23 16:28:24.467037	2026-04-23 16:28:24.46704	t
36	5cef4203-0e23-44f5-b7be-9b684a705997_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	uploads/tasks/243/5cef4203-0e23-44f5-b7be-9b684a705997_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	64418	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	243	5	2026-05-05 19:42:41.519287	2026-05-05 19:42:41.519291	t
37	0e773cc2-ca86-4b69-a07a-180257706d5d_Registro_hidratacion_Abril_26.pdf	Registro_hidratacion_Abril_26.pdf	uploads/tasks/74/0e773cc2-ca86-4b69-a07a-180257706d5d_Registro_hidratacion_Abril_26.pdf	704554	application/pdf	74	5	2026-05-13 17:59:05.920744	2026-05-13 17:59:05.920747	t
38	44ed904d-0b93-491e-912f-d84114b36f5f_Horas_extras_abril2026.pdf	Horas_extras_abril2026.pdf	uploads/tasks/61/44ed904d-0b93-491e-912f-d84114b36f5f_Horas_extras_abril2026.pdf	745855	application/pdf	61	5	2026-05-15 16:43:55.09764	2026-05-15 16:43:55.097643	t
39	afa3ac2d-9a4b-433c-8f38-142f95479d47_Horas_extras_Enero2026.pdf	Horas_extras_Enero2026.pdf	uploads/tasks/61/afa3ac2d-9a4b-433c-8f38-142f95479d47_Horas_extras_Enero2026.pdf	745599	application/pdf	61	5	2026-05-15 16:54:38.824675	2026-05-15 16:54:38.824677	t
40	8b4e00ec-0ec3-43df-9408-0ca416452340_Horas_extras_rol_Mayo_2026.pdf	Horas_extras_rol_Mayo_2026.pdf	uploads/tasks/61/8b4e00ec-0ec3-43df-9408-0ca416452340_Horas_extras_rol_Mayo_2026.pdf	8946703	application/pdf	61	5	2026-06-04 19:57:37.144833	2026-06-04 19:57:37.144835	t
41	9e605852-b69d-4d58-987c-bb57f61e75b0_Horas_extras_rol_Mayo_2026.pdf	Horas_extras_rol_Mayo_2026.pdf	uploads/tasks/61/9e605852-b69d-4d58-987c-bb57f61e75b0_Horas_extras_rol_Mayo_2026.pdf	8946703	application/pdf	61	5	2026-06-04 19:57:42.300849	2026-06-04 19:57:42.300852	t
42	3716ca29-4f4b-4168-b09a-c9021d05b3e7_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	uploads/tasks/47/3716ca29-4f4b-4168-b09a-c9021d05b3e7_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	64479	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	47	5	2026-06-04 20:57:05.3299	2026-06-04 20:57:05.329903	t
43	8c505b67-ba14-40aa-9701-8a8791799c81_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	uploads/tasks/47/8c505b67-ba14-40aa-9701-8a8791799c81_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	64479	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	47	5	2026-06-04 20:57:09.837156	2026-06-04 20:57:09.837158	t
46	6340f9f8-d08b-4e8a-a537-f1e46c8f806e_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	uploads/tasks/396/6340f9f8-d08b-4e8a-a537-f1e46c8f806e_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	49282	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	396	5	2026-06-04 20:59:15.053031	2026-06-04 20:59:15.053033	t
48	3799f2f5-c52e-4108-b66d-d5b4f8d7378b_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	uploads/tasks/235/3799f2f5-c52e-4108-b66d-d5b4f8d7378b_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	64479	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	235	5	2026-06-04 21:00:11.495183	2026-06-04 21:00:11.495185	t
44	66d8a890-e4b3-427f-ac3a-90de47a44cc5_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	uploads/tasks/403/66d8a890-e4b3-427f-ac3a-90de47a44cc5_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	64479	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	403	5	2026-06-04 20:57:42.252268	2026-06-04 20:57:42.25227	t
45	4ee16c75-da17-471d-a10d-e4ec8c62847f_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	uploads/tasks/396/4ee16c75-da17-471d-a10d-e4ec8c62847f_REGISTRO_CONSUMO_ENERGIA_ELECTRICA.xlsx	64479	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	396	5	2026-06-04 20:58:13.96462	2026-06-04 20:58:13.964622	t
47	685d2124-7815-48aa-b312-f003063ee80e_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	uploads/tasks/235/685d2124-7815-48aa-b312-f003063ee80e_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	49282	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	235	5	2026-06-04 20:59:46.503497	2026-06-04 20:59:46.503499	t
49	9eb8d8dc-5345-44e6-88dd-7c3aa071172f_REGISTRO_CONSUMO_ENERGIA_ELECTRICA_1.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA_1.xlsx	uploads/tasks/507/9eb8d8dc-5345-44e6-88dd-7c3aa071172f_REGISTRO_CONSUMO_ENERGIA_ELECTRICA_1.xlsx	68256	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	507	5	2026-07-06 15:28:39.911918	2026-07-06 15:28:39.911921	t
50	ca3b124c-9564-498d-a9db-01c5e1346389_REGISTRO_CONSUMO_ENERGIA_ELECTRICA_1.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA_1.xlsx	uploads/tasks/499/ca3b124c-9564-498d-a9db-01c5e1346389_REGISTRO_CONSUMO_ENERGIA_ELECTRICA_1.xlsx	68256	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	499	5	2026-07-06 15:29:13.230168	2026-07-06 15:29:13.230171	t
51	4c334d8c-f146-4002-9516-4329318afac6_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	uploads/tasks/499/4c334d8c-f146-4002-9516-4329318afac6_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	49290	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	499	5	2026-07-06 15:31:44.440325	2026-07-06 15:31:44.440328	t
52	bfc0d9a6-a6a2-49bd-bde6-31b6fc788d5f_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	uploads/tasks/499/bfc0d9a6-a6a2-49bd-bde6-31b6fc788d5f_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	49290	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	499	5	2026-07-06 15:31:47.547043	2026-07-06 15:31:47.547045	t
53	b28db220-ad38-451b-8d4d-a417b5017785_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	uploads/tasks/499/b28db220-ad38-451b-8d4d-a417b5017785_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	49290	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	499	5	2026-07-06 15:31:54.192619	2026-07-06 15:31:54.192621	t
54	c5133830-694b-473f-9751-3f1cbf882b07_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	uploads/tasks/499/c5133830-694b-473f-9751-3f1cbf882b07_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	49290	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	499	5	2026-07-06 15:31:55.408463	2026-07-06 15:31:55.408466	t
55	e98bcb46-814a-45b1-bf32-26ad30c06357_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	uploads/tasks/499/e98bcb46-814a-45b1-bf32-26ad30c06357_CONSUMO_MENSUAL_DE_COMBUSTIBLE.xlsx	49290	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	499	5	2026-07-06 15:31:57.229933	2026-07-06 15:31:57.229936	t
56	5cacfc55-7d41-404a-a662-c9b31a404b5b_Informe_Inspeccion_de_espacios_de_descanso.docx	Informe_Inspeccion_de_espacios_de_descanso.docx	uploads/tasks/405/5cacfc55-7d41-404a-a662-c9b31a404b5b_Informe_Inspeccion_de_espacios_de_descanso.docx	801577	application/vnd.openxmlformats-officedocument.wordprocessingml.document	405	5	2026-07-06 15:36:55.964362	2026-07-06 15:36:55.964364	t
57	0647e266-9e14-434b-af5b-4e01e06b7b08_Informe_Inspeccion_de_espacios_de_descanso_06.docx	Informe_Inspeccion_de_espacios_de_descanso_06.docx	uploads/tasks/405/0647e266-9e14-434b-af5b-4e01e06b7b08_Informe_Inspeccion_de_espacios_de_descanso_06.docx	801362	application/vnd.openxmlformats-officedocument.wordprocessingml.document	405	5	2026-07-06 15:37:17.471212	2026-07-06 15:37:17.471215	t
58	51bd94d1-31f9-48f2-b706-c03d7a935270_Informe_Inspeccion_de_espacios_de_descanso_05.docx	Informe_Inspeccion_de_espacios_de_descanso_05.docx	uploads/tasks/405/51bd94d1-31f9-48f2-b706-c03d7a935270_Informe_Inspeccion_de_espacios_de_descanso_05.docx	801357	application/vnd.openxmlformats-officedocument.wordprocessingml.document	405	5	2026-07-06 15:37:41.428741	2026-07-06 15:37:41.428743	t
60	bbcd8eb1-2ed1-4bc8-ac0a-225d01b60ca2_INFORME_DE_RESULTADOS.docx	INFORME_DE_RESULTADOS.docx	uploads/tasks/33/bbcd8eb1-2ed1-4bc8-ac0a-225d01b60ca2_INFORME_DE_RESULTADOS.docx	167003	application/vnd.openxmlformats-officedocument.wordprocessingml.document	33	5	2026-07-06 16:57:23.33273	2026-07-06 16:57:23.332732	t
61	be89ee33-6da5-44cb-b58f-fc92039e9844_Horas_extras_Junio2026.pdf	Horas_extras_Junio2026.pdf	uploads/tasks/61/be89ee33-6da5-44cb-b58f-fc92039e9844_Horas_extras_Junio2026.pdf	10792692	application/pdf	61	5	2026-07-06 17:48:08.518178	2026-07-06 17:48:08.51818	t
62	e580c6c9-987c-45e2-86d4-c83f3041892e_Informe_Analisis_de_las_encuestas_al_personal_cesante_jun_2026.docx	Informe_Analisis_de_las_encuestas_al_personal_cesante_jun_2026.docx	uploads/tasks/64/e580c6c9-987c-45e2-86d4-c83f3041892e_Informe_Analisis_de_las_encuestas_al_personal_cesante_jun_2026.docx	169489	application/vnd.openxmlformats-officedocument.wordprocessingml.document	64	5	2026-07-09 16:48:02.339112	2026-07-09 16:48:02.339114	t
63	505e7e4a-d74b-4aeb-bc9e-66afb212dcad_Inspeccion_aleatoria_de_canceles_Junio_2026.docx	Inspeccion_aleatoria_de_canceles_Junio_2026.docx	uploads/tasks/58/505e7e4a-d74b-4aeb-bc9e-66afb212dcad_Inspeccion_aleatoria_de_canceles_Junio_2026.docx	752232	application/vnd.openxmlformats-officedocument.wordprocessingml.document	58	5	2026-07-09 17:05:54.665468	2026-07-09 17:05:54.66547	t
66	851f4a66-1a5b-4d23-9008-d9cb146ed663_Registro_de_hidratacion_mayo2026.pdf	Registro_de_hidratacion_mayo2026.pdf	uploads/tasks/74/851f4a66-1a5b-4d23-9008-d9cb146ed663_Registro_de_hidratacion_mayo2026.pdf	867684	application/pdf	74	5	2026-07-09 17:24:00.617927	2026-07-09 17:24:00.61793	t
67	602182f9-858e-4f69-8848-8a078f6ba91f_Registro_de_Hidratacion_Junio_2026.pdf	Registro_de_Hidratacion_Junio_2026.pdf	uploads/tasks/74/602182f9-858e-4f69-8848-8a078f6ba91f_Registro_de_Hidratacion_Junio_2026.pdf	520254	application/pdf	74	5	2026-07-09 17:24:18.275046	2026-07-09 17:24:18.275049	t
68	a3bd38ad-11d9-4324-b895-9387a4eddfde_Informe_condiciones_de_transporte_julio2026.docx	Informe_condiciones_de_transporte_julio2026.docx	uploads/tasks/66/a3bd38ad-11d9-4324-b895-9387a4eddfde_Informe_condiciones_de_transporte_julio2026.docx	767818	application/vnd.openxmlformats-officedocument.wordprocessingml.document	66	5	2026-07-21 14:04:16.445978	2026-07-21 14:04:16.44598	t
70	5425e0ee-942c-4536-870f-3d437e52173a_REGISTRO_CONSUMO_ENERGIA_ELECTRICA_ABRIL.xlsx	REGISTRO_CONSUMO_ENERGIA_ELECTRICA_ABRIL.xlsx	uploads/tasks/47/5425e0ee-942c-4536-870f-3d437e52173a_REGISTRO_CONSUMO_ENERGIA_ELECTRICA_ABRIL.xlsx	68369	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	47	5	2026-09-01 19:22:53.525224	2026-09-01 19:22:53.525226	t
73	cad3b19d-49a7-4147-994e-0628703b0d54_INFORME_AUDITORIA_INTERNA_Estandar_Florverde_V7.1.3_Espanol_RoseMirovich_17-12-2025_Rev_1.xlsx	INFORME_AUDITORIA_INTERNA_Estandar_Florverde_V7.1.3_Espanol_RoseMirovich_17-12-2025_Rev_1.xlsx	uploads/tasks/705/cad3b19d-49a7-4147-994e-0628703b0d54_INFORME_AUDITORIA_INTERNA_Estandar_Florverde_V7.1.3_Espanol_RoseMirovich_17-12-2025_Rev_1.xlsx	339065	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	705	9	2026-09-01 20:26:40.888964	2026-09-01 20:26:40.888967	t
\.


--
-- Data for Name: purchase_requisitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_requisitions (id, title, description, amount, status, requester_id, target_user_id, reviewer_id, approver_id, created_at, updated_at, reviewed_at, approved_at, area_id) FROM stdin;
1	Compra de mousepad	Comprar un mousepad de 10"	20.00	aprobada	1	9	9	9	2026-03-25 21:57:24.923963	2026-03-25 21:59:22.61203	2026-03-25 21:59:04.259462	2026-03-25 21:59:22.612027	\N
\.


--
-- Data for Name: scheduled_task_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scheduled_task_users (id, scheduled_task_id, user_id, assigned_at) FROM stdin;
14	12	5	2026-04-01 16:43:29.388244
15	13	13	2026-04-01 16:46:12.756677
16	14	9	2026-04-01 17:26:24.081513
17	15	17	2026-04-01 17:36:56.882354
18	16	13	2026-04-01 17:45:15.49894
19	16	15	2026-04-01 17:45:15.498941
20	17	12	2026-04-01 22:28:58.240526
21	17	13	2026-04-01 22:28:58.240528
22	18	12	2026-04-01 22:39:18.25257
23	18	13	2026-04-01 22:39:18.252571
24	19	5	2026-04-02 04:53:46.736061
25	20	17	2026-04-02 05:04:33.189631
26	21	17	2026-04-02 05:09:49.338696
27	22	17	2026-04-02 05:13:17.902746
28	22	5	2026-04-02 05:13:17.902748
29	23	5	2026-04-02 05:21:28.68814
30	24	9	2026-04-02 05:22:58.149263
31	25	9	2026-04-02 05:25:11.665573
32	26	9	2026-04-03 16:49:04.453567
33	27	9	2026-04-03 16:51:20.360707
34	28	9	2026-04-03 17:21:30.380542
35	28	5	2026-04-03 17:21:30.380543
36	29	5	2026-04-03 18:33:10.521524
37	30	13	2026-04-03 18:45:27.366811
38	30	15	2026-04-03 18:45:27.366812
39	30	16	2026-04-03 18:45:27.366812
40	31	5	2026-04-03 18:47:03.727991
41	32	12	2026-04-03 18:49:28.258767
42	33	13	2026-04-03 19:12:47.736803
43	33	15	2026-04-03 19:12:47.736804
45	35	17	2026-04-03 19:13:58.872661
46	36	18	2026-04-03 19:29:15.244237
47	37	5	2026-04-03 19:30:25.561633
48	38	5	2026-04-03 19:39:41.957511
49	39	5	2026-04-03 19:42:56.875474
50	40	9	2026-04-03 21:20:34.28816
51	40	10	2026-04-03 21:20:34.288161
52	41	13	2026-04-03 23:11:26.289309
53	41	16	2026-04-03 23:11:26.28931
54	42	12	2026-04-04 00:34:23.533497
\.


--
-- Data for Name: scheduled_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scheduled_tasks (id, title, description, area_id, created_by, frequency, "interval", priority, start_date, run_time, end_date, next_run_at, is_active, created_at, updated_at) FROM stdin;
17	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	personalizada	1	alta	2026-02-01 00:00:00	00:00:00	2026-12-31 00:00:00	2026-09-10 00:00:00	t	2026-04-01 22:28:58.239873	2026-09-09 00:00:13.931423
14	Rendición de cuentas CSAD 2026	Documento Base: 1.1.4. ACTA DE REUNION EXTRAORDINARIA DEL CSAD (22/12/2025)	6	9	personalizada	1	alta	2026-10-11 00:00:00	00:00:00	2026-11-11 00:00:00	2026-10-11 00:00:00	t	2026-04-01 17:26:24.080847	2026-04-01 17:26:24.080849
15	ANALIZAR RESULTADOS DE ENCUESTAS Y PLANES DE MEJORA (BIENESTAR LABORAL)	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	17	9	personalizada	1	alta	2026-11-01 00:00:00	00:00:00	2026-12-01 00:00:00	2026-11-01 00:00:00	t	2026-04-01 17:36:56.881544	2026-04-01 17:36:56.881546
42	ACTUALIZACIÓN DE LISTADO DE PROVEEDORES 	SUBIR ARCHIVO LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 12.11 PRODUCTO NO CONFORME	12	9	personalizada	1	alta	2026-11-23 00:00:00	00:00:00	2026-12-31 00:00:00	2026-11-23 00:00:00	t	2026-04-04 00:34:23.533036	2026-04-04 00:34:23.533037
22	INFORME MENSUAL DE INSPECCION DE ESPACIOS DE DESCANSOS	SUBIR EL ARCHIVO LA SEGUNDA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	mensual	1	alta	2026-03-02 00:00:00	00:00:00	2026-12-31 00:00:00	2026-09-28 00:00:00	t	2026-04-02 05:13:17.902077	2026-08-29 00:00:07.863625
36	PLAN ANUAL DE CAPACITACION 2027 DEPARTAMENTO MEDICO	 PRESENTAR PLANIFICACION DE CAPACITACIONES PARA EL AÑO 2027 	16	9	personalizada	1	alta	2026-11-02 00:00:00	00:00:00	2026-12-11 00:00:00	2026-11-02 00:00:00	t	2026-04-03 19:29:15.243669	2026-04-03 19:29:15.243671
37	PLAN ANUAL DE CAPACITACION 2027 JEFATURA ADMINISTRATIVA Y RRHH	PRESENTAR PLANIFICACION DE CAPACITACIONES PARA EL AÑO 2027	8	9	personalizada	1	alta	2026-11-02 00:00:00	00:00:00	2026-12-11 00:00:00	2026-11-02 00:00:00	t	2026-04-03 19:30:25.561191	2026-04-03 19:30:25.561192
27	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	personalizada	1	alta	2026-06-15 00:00:00	00:00:00	2026-12-31 00:00:00	2026-09-10 00:00:00	t	2026-04-03 16:51:20.36021	2026-09-09 00:00:13.931423
12	REGISTRO MENSUAL DE CONSUMO ELECTRICO Y COMBUSTIBLE 	Documento base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\nSubir ambos registro de manera mensual de forma separada, 2 registros mensuales. 	8	9	mensual	1	alta	2026-03-01 00:00:00	00:00:00	2026-12-26 00:00:00	2026-09-27 00:00:00	t	2026-04-01 16:43:29.38768	2026-08-28 00:00:07.863649
20	INFORME DE TRAZABILIDAD DE CONSUMO ENERGETICO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	17	9	mensual	1	alta	2026-11-14 00:00:00	00:00:00	2026-12-12 00:00:00	2026-11-14 00:00:00	t	2026-04-02 05:04:33.18897	2026-04-02 05:04:33.188972
21	INFORME ANUAL DE CUMPLIMIENTO SST 	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES\r\n(NORMAS SST 100%)	17	9	personalizada	1	alta	2026-12-01 00:00:00	00:00:00	2027-01-09 00:00:00	2026-12-01 00:00:00	t	2026-04-02 05:09:49.338098	2026-04-02 05:09:49.338099
23	INFORME DE ENCUESTA ANUAL DE SATISFACCIÓN LABORAL 	Documento base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	personalizada	1	alta	2026-11-14 00:00:00	00:00:00	2026-12-12 00:00:00	2026-11-14 00:00:00	t	2026-04-02 05:21:28.687478	2026-04-02 05:21:28.68748
24	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL 	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALE	6	9	personalizada	1	alta	2026-11-14 00:00:00	00:00:00	2026-12-12 00:00:00	2026-11-14 00:00:00	t	2026-04-02 05:22:58.1487	2026-04-02 05:22:58.148702
28	REPORTE ANUAL DE  SOSTENIBILIDAD	SUBIR Y PUBLICAR EL DOCUMENTO PARA INFORMAR A LOS TRABAJADORES 	6	9	personalizada	1	media	2026-11-02 00:00:00	00:00:00	2026-12-31 00:00:00	2026-11-02 00:00:00	t	2026-04-03 17:21:30.379155	2026-04-03 17:21:30.379157
29	PROYECCION ANUAL DE HORAS EXTRAS 	DOCUMENTO BASE: 2.2 - 2.3 PROCEDIMIENTO PARA ASIGNACIÓN DE HORARIO LABORAL Y PROYECCIÓN DE HORAS EXTRAS 	8	9	personalizada	1	alta	2026-11-02 00:00:00	00:00:00	2026-12-31 00:00:00	2026-11-02 00:00:00	t	2026-04-03 18:33:10.520832	2026-04-03 18:33:10.520833
30	REGISTRO DE TALLAS DE UNIFROME ACTUALIZADAS POR AREA	LOS SUPERVISORES O JEFES DE CADA AREA DEBERAN REALIZAR EL REGISTRO ACTUALIZADO DE LAS TALLAS DE TODOS LOS COLABORADORES.	8	9	personalizada	1	media	2026-11-02 00:00:00	00:00:00	2026-11-14 00:00:00	2026-11-02 00:00:00	t	2026-04-03 18:45:27.366027	2026-04-03 18:45:27.366028
31	SOLICITUD DE REPOSICION DE UNIFORMES	DOCUMENTO BASE: 2.18 PROCEDIMIENTO  DE ENTREGA Y DEVOLUCIÓN DE UNIFORMES 	8	9	personalizada	1	media	2026-11-30 00:00:00	00:00:00	2026-12-07 00:00:00	2026-11-30 00:00:00	t	2026-04-03 18:47:03.727469	2026-04-03 18:47:03.72747
32	REGISTRO ACTUALZADO DE 3EROS (PROVEEDORES) APROBADOS 	DOCUEMENTO BASE: 2.19 MANUAL DE CONTRATACIÓN A TERCEROS 	11	9	personalizada	1	alta	2026-10-26 00:00:00	00:00:00	2026-11-07 00:00:00	2026-10-26 00:00:00	t	2026-04-03 18:49:28.258332	2026-04-03 18:49:28.258334
35	PLAN ANUAL DE CAPACITACION 2027 SST	PRESENTAR PLANIFICACION DE CAPACITACIONES PARA EL AÑO 2027 	17	9	personalizada	1	alta	2026-11-02 00:00:00	00:00:00	2026-12-11 00:00:00	2026-11-02 00:00:00	t	2026-04-03 19:13:58.872236	2026-04-03 19:13:58.872237
38	PLAN ANUAL DE CAPACITACION 2027 GERENCIA ADMINISTRATIVA	PRESENTAR PLANIFICACION DE CAPACITACIONES PARA EL AÑO 2027	6	9	personalizada	1	alta	2026-11-02 00:00:00	00:00:00	2026-12-11 00:00:00	2026-11-02 00:00:00	t	2026-04-03 19:39:41.956991	2026-04-03 19:39:41.956993
33	PLAN ANUAL DE CAPACITACION 2027 CULTIVO Y POSCOSECHA 	PRESENTAR PLANIFICACION DE CAPACITACIONES PARA EL AÑO 2027 	13	9	personalizada	1	alta	2026-11-01 00:00:00	00:00:00	2026-12-11 00:00:00	2026-11-01 00:00:00	t	2026-04-03 19:12:47.736263	2026-04-03 19:14:35.580054
39	INFORME DE CUMPLIMIENTO PLAN ANUAL DE CAPACITACION 2026	DOCUCUMENTO BASE: 3.1 procedimiento de capacitación anual 	8	9	personalizada	1	alta	2026-11-02 00:00:00	00:00:00	2026-12-12 00:00:00	2026-11-02 00:00:00	t	2026-04-03 19:42:56.874987	2026-04-03 19:42:56.874988
40	REVISIÓN DE MATRIZ: OBJETIVOS	DOCUMENTO BASE: 4.1 SISTEMA DE GESTIÓN DE SEGURIDAD Y SALUD EN EL TRABAJO - OBJETIVOS 	6	9	personalizada	1	alta	2026-11-02 00:00:00	00:00:00	2026-04-30 00:00:00	2026-11-02 00:00:00	t	2026-04-03 21:20:34.287585	2026-04-03 21:20:34.287586
13	REGISTRO MENSUAL DE CONSUMO DE AGUA CON DETALLE SEMANAL	Subir los registros la primera semana de cada mes\r\nDocumento Base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\n (MANTENER EL 85% SEMANAL DE RIEGO OPTIMO)	13	9	mensual	1	alta	2026-03-01 00:00:00	00:00:00	2026-12-31 00:00:00	2026-09-27 00:00:00	t	2026-04-01 16:46:12.755786	2026-08-28 00:00:07.863649
25	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	personalizada	1	alta	2026-06-01 00:00:00	00:00:00	2026-06-30 00:00:00	2026-06-30 00:00:00	t	2026-04-02 05:25:11.665117	2026-06-29 00:00:30.964486
18	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	personalizada	1	alta	2026-03-01 00:00:00	00:00:00	2026-12-31 00:00:00	2026-09-10 00:00:00	t	2026-04-01 22:39:18.252012	2026-09-09 00:00:13.931423
41	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	mensual	1	media	2026-03-30 00:00:00	00:00:00	2026-12-31 00:00:00	2026-09-26 00:00:00	t	2026-04-03 23:11:26.288745	2026-08-27 00:00:07.863637
16	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	mensual	1	alta	2026-03-01 00:00:00	00:00:00	2026-12-31 00:00:00	2026-09-27 00:00:00	t	2026-04-01 17:45:15.498027	2026-08-28 00:00:07.863649
19	REGISTRO MENSUAL DE CONSUMO ENERGETICO 	SUBIREL ARCHIVO LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	mensual	1	alta	2026-03-01 00:00:00	00:00:00	2026-12-31 00:00:00	2026-09-27 00:00:00	t	2026-04-02 04:53:46.735412	2026-08-28 00:00:07.863649
26	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	personalizada	1	alta	2026-03-01 00:00:00	00:00:00	2026-06-13 00:00:00	2026-06-09 00:00:00	t	2026-04-03 16:49:04.372365	2026-06-08 12:32:16.552685
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, title, description, area_id, created_by, assigned_to, status, priority, required_files, uploaded_files, due_date, created_at, updated_at, completed_at, scheduled_task_id) FROM stdin;
35	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	13	pendiente	alta	0	0	\N	2026-04-01 17:45:15.503067	2026-04-01 17:45:15.503068	\N	16
36	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	15	pendiente	alta	0	0	\N	2026-04-01 17:45:15.503069	2026-04-01 17:45:15.503069	\N	16
37	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-01 22:28:58.244866	2026-04-01 22:28:58.244867	\N	17
38	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-01 22:28:58.244868	2026-04-01 22:28:58.244868	\N	17
39	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-01 22:39:18.256811	2026-04-01 22:39:18.256813	\N	18
40	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-01 22:39:18.256813	2026-04-01 22:39:18.256814	\N	18
42	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-02 00:00:10.28253	2026-04-02 00:00:10.282532	\N	17
43	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-02 00:00:10.282533	2026-04-02 00:00:10.282533	\N	17
44	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-02 00:00:10.282534	2026-04-02 00:00:10.282534	\N	18
45	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-02 00:00:10.282535	2026-04-02 00:00:10.282535	\N	18
46	INFORME DE CUPLIMIENTO "100% DE COBERTURA VEGETAL EN EL SUELO"	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	13	9	13	pendiente	alta	1	0	2026-06-13 00:00:00	2026-04-02 04:48:11.687428	2026-04-02 04:48:11.687429	\N	\N
32	REGISTRO MENSUAL DE CONSUMO DE AGUA CON DETALLE SEMANAL	Subir los registros la primera semana de cada mes\r\nDocumento Base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\n (MANTENER EL 85% SEMANAL DE RIEGO OPTIMO)	13	9	13	pendiente	alta	0	0	\N	2026-04-01 16:46:12.761051	2026-04-01 16:46:12.761053	\N	13
48	INFORME DE MIGRACION A ILUMINACIÓN LED	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n(MIGRAR ILUMINACION AL 80% DE LUZ LED)	17	9	17	pendiente	alta	1	0	2026-04-30 00:00:00	2026-04-02 05:07:32.646375	2026-04-02 05:07:32.646376	\N	\N
52	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-03 00:00:10.293927	2026-04-03 00:00:10.293929	\N	17
53	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-03 00:00:10.29393	2026-04-03 00:00:10.293931	\N	17
54	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-03 00:00:10.293931	2026-04-03 00:00:10.293931	\N	18
55	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-03 00:00:10.293932	2026-04-03 00:00:10.293932	\N	18
56	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-03 16:49:04.461559	2026-04-03 16:49:04.46156	\N	26
59	PROYECCIÓN MENSUAL DE HORAS EXTRAS 2026 POSTCOSECHA	SUBIR LA 4TA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 2.2 - 2.3 PROCEDIMIENTO PARA ASIGNACIÓN DE HORARIO LABORAL Y PROYECCIÓN DE HORAS EXTRAS 	14	9	15	pendiente	alta	8	0	2026-12-31 00:00:00	2026-04-03 17:34:27.325062	2026-04-03 17:34:27.325064	\N	\N
60	PROYECCIÓN MENSUAL DE HORAS EXTRAS 2026 CULTIVO	SUBIR LA 4TA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 2.2 - 2.3 PROCEDIMIENTO PARA ASIGNACIÓN DE HORARIO LABORAL Y PROYECCIÓN DE HORAS EXTRAS 	13	9	13	pendiente	alta	9	0	2026-12-31 00:00:00	2026-04-03 17:35:31.961254	2026-04-03 17:35:31.961255	\N	\N
123	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-08 00:00:02.881818	2026-04-08 00:00:02.881819	\N	17
41	INFORME DE ESTADO DE LINDEROS FEBREO - AGOSTO	OBJETIVO: "50% DE LINDEROS CON BARRERAS VIVAS"\r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	17	9	17	pendiente	alta	1	0	2026-10-31 00:00:00	2026-04-01 22:43:37.460804	2026-09-01 19:49:17.582241	\N	\N
51	PRESENTAR E IMPLEMENTAR EL PLAN DE DESARROLLO PERSONAL 	Documento Base:  1.3. PROGRAMA DE OBJETIVOS	8	9	5	completada	alta	1	1	2026-12-12 00:00:00	2026-04-02 05:17:03.588951	2026-04-23 16:28:24.471403	2026-04-23 16:28:24.471149	\N
57	REGISTRAR ACTA DE APERTURA DE BUZON	SUBIR EL ARCHIVO LA 4TA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 1.8. PROCEDIMIENTO PARA USO DE BUZON DE SUGERENCIAS Y GESTION DE QUEJAS	8	9	5	en_progreso	alta	12	5	2026-12-31 00:00:00	2026-04-03 17:23:26.739844	2026-04-23 16:24:16.151401	\N	\N
33	INFORME: EVALUACIÓN DE CAMPAÑA "APAGA Y DESCONECTA" ENERO - JUNIO	Documento base: 1.1.4 ACTA DE REUNION EXTRAORDINARIA DEL CSAD (22/12/2025)\r\n	8	9	5	completada	alta	1	1	2026-06-13 00:00:00	2026-04-01 17:14:48.784341	2026-07-06 16:57:23.336321	2026-07-06 16:57:23.336068	\N
58	REGISTR0 E INFORME  DE INSPECCION ALEATORIA AL 2% DE CANCELES 	SUBIR DOCUMENTO 1 VEZ CADA 2 MESES EMPEZANDO EN ABRIL\r\nDOCUMENTO BASE: 2.1. PROCEDIMIENTO DE ASIGNACIÓN Y CONTROL DE USO DE CANCELES 	8	9	5	en_progreso	alta	3	2	2026-12-31 00:00:00	2026-04-03 17:31:05.927565	2026-07-09 17:05:54.669095	\N	\N
67	REGISTROS SEMESTRAL  DE EMERGENCIAS ATENDIDAD POR LAS BRIGADAS DE EMERGENCIA 	REALIZAR LOS REGISTROS EN LOS MESES DE JUNIO Y DICIEMBRE\r\nDOCUMENTO BASE: 4.12 - 4.25 PLAN DE EMERGENCIA 2026 SEGURIDAD E HIGIENE	17	9	17	pendiente	alta	2	0	2026-12-31 00:00:00	2026-04-03 21:24:23.814835	2026-04-03 21:24:23.814836	\N	\N
68	REGISTRO DE CONTROL DE LOS ELEMENTOS DE PROTECCIÓN INDIVIDUAL CULTIVO 	SUBIR EL REGISTRO LA 3ERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 4.17 PROCEDIMIENTO PARA LA DOTACION DE LOS EQUIPOS DE PROTECCIÓN PERSONAL  \r\n	13	9	13	pendiente	alta	9	0	2026-12-19 00:00:00	2026-04-03 21:28:40.377509	2026-04-03 21:28:40.37751	\N	\N
69	REGISTRO DE CONTROL DE LOS ELEMENTOS DE PROTECCIÓN INDIVIDUAL  POSCOSECHA	SUBIR EL REGISTRO LA 3ERA SEMANA DE CADA MES  DOCUMENTO BASE: 4.17 PROCEDIMIENTO PARA LA DOTACION DE LOS EQUIPOS DE PROTECCIÓN PERSONAL  	14	9	15	pendiente	alta	9	0	2026-12-19 00:00:00	2026-04-03 21:29:28.576752	2026-04-03 21:29:28.576754	\N	\N
70	REGISTRO DE CONTROL DE LOS ELEMENTOS DE PROTECCIÓN INDIVIDUAL DE LA EMPRESA ROSEMIROVICH ROSES CIA LTDA	SUBIR EL REGISTRO LA 3ERA SEMANA DE CADA MES.  \r\nDOCUMENTO BASE: 4.17 PROCEDIMIENTO PARA LA DOTACION DE LOS EQUIPOS DE PROTECCIÓN PERSONAL  \r\nSUBIR UN ARCHIVO POR MES ABRIL -DICIEMBRE PARA CULMINAR LA ACTIVIDAD.\r\n	17	9	17	pendiente	alta	9	0	2026-12-31 00:00:00	2026-04-03 21:42:02.007348	2026-09-01 19:46:56.955491	\N	\N
77	REPORTE MENSUAL DE PRECIPITACIONES DIARIAS	SUBIR LA PRIMERA SEMANA DE CADA  MES\r\n5.9 PD DE RECOLECCION DE PRECIPITACIONES	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:26:16.088988	2026-04-03 22:26:16.088989	\N	\N
78	REPORTE MENSUAL DE INCORPORACION DE MATERIA ORGANICA	SUBIR LA 1ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 6.19 - 6.10 PROCEDIMIENTO PARA LA APLICACIÓN DE MATERIA ORGANICA	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:29:30.878227	2026-04-03 22:29:30.878228	\N	\N
75	EGISTRO MENSUAL: AFORO DE INGRESO DE AGUA AL RESERVORIO 	PRESENTAR REGISTRO DE AFORO DE INGRESO DE AGUA AL RESERVORIO ESTE DEBE SER REGISTRADO DE MANERA SEMANAL Y PRESENTADO DE MANERA SEMANAL  \r\nDOCUMENTO BASE: 5.2. PROCEDIMIENTO DE AFORO DE INGRESO DE AGUA AL RESERVORIO	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:19:15.233799	2026-04-03 22:20:08.109253	\N	\N
85	REGISTRAR Y ACTUALIZAR DE MANERA MENSUAL MATRIZ DE DESECHOS PELIGROSOS GENERADOS POR LA FINCA	SUBIR LOS ARCHIVOS LA 3RA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 8.1.1 PD MANEJO DE DESECHOS	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 23:01:45.962448	2026-04-03 23:02:14.212375	\N	\N
86	REGISTRAR Y ACTUALIZAR BITACORA SEMANAL DE DESECHOS COMUNES	LA BITACORA SE REGISTRARÁ DE MANERA SEMANAL Y SE PRESENTARÁ LA 3ERA SEMANA DE CADA MES 	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 23:06:54.247166	2026-04-03 23:06:54.247167	\N	\N
76	REGISTRO MENSUAL DE USO DE TENSIOMETROS	SUBIR LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 5.4. PROCEDIMIENTO DE USO DE TENSIOMETROS	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:24:58.713476	2026-04-03 22:24:58.713478	\N	\N
79	REPORTE MENSUAL DE REGISTRO DE RESIDUOS VEGETALES 	SUBIR LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE 6.22 - 8.8. PROCEDIMIENTO DE ELABORACION Y MANEJO DE COMPOST	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:31:42.598346	2026-04-03 22:31:42.598348	\N	\N
66	INFORME DE AUDITORIA INTERNA: CONDICIONES DE TRANSPORTE 	REALIZAR EL INFORME EN JULIO 2026 Y ENERO 2027 \r\nDOCUMENTO BASE: 3.6 MANUAL DE PROCEDIMIENTO Y POLITICAS DE TRANPORTE PARA COLABORADORES DE LA EMPRESA 	8	9	5	completada	media	2	1	2027-01-30 00:00:00	2026-04-03 21:16:58.745246	2026-07-21 14:05:18.837178	2026-07-21 14:04:20.504756	\N
80	REGISTRO TRIMESTRAL DE ROTACION DE PERSONAL	MESES A REALIZAR JUNIO - SEPTIEMBRE - DICIEMBRE\r\nDOCUMENTO BASE: 7.15 PROCEDIMIENTO DE ROTACION DE PERSONAL DE FUMIGACION	13	9	13	pendiente	media	3	0	2026-12-31 00:00:00	2026-04-03 22:46:58.600148	2026-04-03 22:46:58.600149	\N	\N
81	REGISTRO DE VERIFICACION DE MATERIALES PARA EL CONTROL DE DERRAMES 	SUBIR LA SEGUNDA SEMANA DE CADA MES\r\nDOCUMUENTO BASE: 7.28.1 PROCEDIMIENTO PARA LA UTILIZACION CONTROLADA DE ENVASES QUIMICOS	17	9	17	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:50:23.332412	2026-04-03 22:50:23.332413	\N	\N
83	REGISTRO MENSUAL AFORO DE LANZAS DE FUMIGACION	DOCUMENTO BASE: 7.32.1 PD AFORO DE LANZAS DE FUMIGACION	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:55:08.699482	2026-04-03 22:55:08.699483	\N	\N
87	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	13	pendiente	media	0	0	\N	2026-04-03 23:11:26.29423	2026-04-03 23:11:26.294231	\N	41
88	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	16	pendiente	media	0	0	\N	2026-04-03 23:11:26.294232	2026-04-03 23:11:26.294232	\N	41
89	REGISTRO MENSUAL DE PLANIFICACION DE LABORES EN CULTIVO	SUBIR LA 3ERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 9.4 PLANIFICACIÓN DE LABORES EN CULTIVO SEMANAL	13	9	13	pendiente	alta	9	0	2026-12-31 00:00:00	2026-04-03 23:19:30.494658	2026-04-03 23:19:30.494659	\N	\N
90	REGISTRO TRIMESTRAL DE MANTENIMIENTO PREVENTIVO	PRESENTAR LOS REGISTROS TRIMESTRALES EN LOS MESES DE JUNIO / SEPTIEMBRE / DICIEMBRE \r\nDOCUMENTO BASE: 10.4 PLAN DE MANTENIMIENTO DE MAQUINRIA Y EQUIPOS	13	9	13	pendiente	alta	3	0	2026-12-31 00:00:00	2026-04-03 23:25:17.984527	2026-04-03 23:25:17.984529	\N	\N
124	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-08 00:00:02.88182	2026-04-08 00:00:02.88182	\N	17
62	ACTA DE PLANIFICACION DE REUNIONES TRIMESTRALES DE CLUBES COORPORATIVOS	MESES: MARZO(RECUPERAR) - JUNIO - SEPTIEMBRE - DICIEMBRE\r\nDOCUEMENTO BASE 2.7. POLITICA DE FUNCIONAMIENTO DE CLUBES COORPORATIVOS	8	9	5	completada	alta	1	1	2026-05-30 00:00:00	2026-04-03 18:36:49.42508	2026-04-13 13:11:19.633737	2026-04-13 13:11:19.633425	\N
64	INFORME TRIMESTRAL: ANALISIS CONSOLIDADO DE LAS ENCUESTAS REALIZADOS POR EL PERSONAL CESANTE 	MESES A REALIZAR: MARZO - JUNIO - SEPTIEMBRE - DICIEMBRE\r\nDOCUMENTO BASE: 2.9 PROCEDIMIENTO DE SELECION, INDUCCIÓN Y CONTRATACIÓN DE FINIQUITO PERSONAL 	8	9	5	en_progreso	media	4	2	2026-12-31 00:00:00	2026-04-03 18:42:00.070025	2026-07-09 16:48:02.342718	\N	\N
61	REGISTRO DE HORAS EXTRAS REALIZADAS JUNTO A CIERRE DE ROLES 	SUBIR LOS DOCUMENTOS EL 26 DE  CADA MES \r\nDOCUMENTO BASE: 2.2 - 2.3 PROCEDIMIENTO PARA ASIGNACIÓN DE HORARIO LABORAL Y PROYECCIÓN DE HORAS EXTRAS 	8	9	5	en_progreso	alta	18	7	2026-12-31 00:00:00	2026-04-03 18:31:09.560209	2026-07-06 17:48:08.521358	\N	\N
82	REGISTRO MENSUAL DE ENVASES REUTILIZADOS 	DOCUMENTO BASE: 7.28.1 PROCEDIMIENTO PARA LA UTILIZACION CONTROLADA DE ENVASES QUIMICOS.\r\nDESDE ABRIL HASTA DICIEMBRE SUBIR UN ARCHIVO POR MES TOTAL 9 ARCHIVOS PARA COMPLETAR LA ACTIVIDAD.	18	9	16	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:51:20.37978	2026-09-01 19:41:29.528413	\N	\N
84	REGISTRO MENSUAL DOTACION DE INSUMOS HIGIENE PERSONAL 	DOCUMENTO BASE: 7.35.1 PD USO DE DUCHAS CALIENTES.\r\nREGISTRO DE ASEO CON AGUA CALIENTO DESPUES DE CUMPLIMIENTO DE ACTIVIDADES EN FUMIGADORES.\r\nSUBIR UN ARCHIVO POR MES DESDE EL MES DE ABRIL HASTA DICIEMBRE, TOTAL 9 ARCHIVOS PARA COMPLETAR.	17	9	17	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 22:56:26.046121	2026-09-01 19:43:51.25276	\N	\N
91	REGISTRO TRIMESTRAL DE MANTENIMIENTO CORRECTIVO 	PRESENTAR LOS REGISTROS TRIMESTRALES EN LOS MESES DE JUNIO / SEPTIEMBRE / DICIEMBRE \r\nDOCUMENTO BASE: 10.4 PLAN DE MANTENIMIENTO DE MAQUINRIA Y EQUIPOS	13	9	13	pendiente	alta	3	0	2026-12-31 00:00:00	2026-04-03 23:27:30.47186	2026-04-03 23:27:30.471861	\N	\N
92	REGISTRO TRIMESTRAL DE FALLAS Y REPARACIONES	PRESENTAR LOS REGISTROS TRIMESTRALES EN LOS MESES DE JUNIO / SEPTIEMBRE / DICIEMBRE \r\nDOCUMENTO BASE: 10.4 PLAN DE MANTENIMIENTO DE MAQUINRIA Y EQUIPOS	13	9	13	pendiente	alta	3	0	2026-12-31 00:00:00	2026-04-03 23:28:05.786252	2026-04-03 23:28:05.786254	\N	\N
93	CHECK LIST: RECEPCIÓN DE MATERIAL VEGETAL 2026	SE DEBERA SUBIR LA INFORMACION DE ACUERDO LO REQUIERA \r\nDOCUMENTO BASE: 11.2 CHECK LIST DE RECEPCIÓN DE MATERIAL VEGETAL	13	9	13	pendiente	baja	10	0	2026-12-31 00:00:00	2026-04-03 23:39:18.127766	2026-04-03 23:39:26.91329	\N	\N
94	REGISTRO DE LIMPIEZA DE TACHOS DE HIDRATACION	SE DEBERÁ SUBIR LA 2DA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 12.1 REGISTRO DE LIMPIEZA DE TACHOS DE HIDRATACION	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 23:41:15.471232	2026-04-03 23:41:15.471233	\N	\N
95	REGISTRO MENSUAL: LIMPIEZA Y DESINFECCION DE MALLAS	PRESENTAR LA 1ERA SEMANA DE CADA MES\r\nDOCUEMENTO BASE: 12.1 REGISTRO DE LIMPIEZA Y DESINFECCION DE MALLAS	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 23:42:41.648655	2026-04-03 23:42:41.648656	\N	\N
96	REGISTRO MENSUAL: MANTENIMIENTO Y DESINFECCION DE TIJERAS DE CORTE	SE DEBE PRESENTAR LA SEGUNDA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 12.1 REGISTRO DE MANTENIMIENTO Y DESINFECCION DE TIJERAS DE CORTE	13	9	13	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-03 23:47:29.843031	2026-04-03 23:47:29.843032	\N	\N
97	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-04 00:00:02.885642	2026-04-04 00:00:02.885643	\N	17
98	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-04 00:00:02.885646	2026-04-04 00:00:02.885646	\N	17
99	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-04 00:00:02.885647	2026-04-04 00:00:02.885647	\N	18
100	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-04 00:00:02.885647	2026-04-04 00:00:02.885648	\N	18
102	REGISTRO MENSUAL: TEMPERATURA DE CUARTO FRIO	ENTREGAR LA SEGUNDA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 12.3 PD CADENA DE FRIO 	14	9	15	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-04 00:01:10.688085	2026-04-04 00:01:10.688086	\N	\N
103	CHECK LISTS DE HIDRATACION DE FLOR 	PRESENTAR LA 3ERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 12.5 CHECK LIST DE HIDRATACION DE FLOR	14	9	15	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-04 00:03:09.825356	2026-04-04 00:03:09.825358	\N	\N
104	REGISTRO MENSUAL DE EVALUACION DE FLOR	PRESENTAR LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASES: 12.10 REGISTRO DE EVALUACION DE FLOR	14	9	15	pendiente	baja	9	0	2026-12-31 00:00:00	2026-04-04 00:10:11.692176	2026-04-04 00:10:11.692177	\N	\N
105	REGISTRO MENSUAL PRUEBAS DE FLORERO	SUBIR EL REGISTRO MENSUAL LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO: 12.10 REGISTRO DE PRUEBAS DE FLORERO	14	9	15	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-04 00:11:33.882035	2026-04-04 00:11:33.882036	\N	\N
106	REGISTRO MENSUAL: SIMULACION DE VIAJE	SUBIR EL DOCUMENTO LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 12.10 REGISTRO DE SIMULACION DE VIAJE	12	9	34	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-04 00:30:48.323579	2026-04-04 00:30:48.323581	\N	\N
107	REGISTRO MENSUAL: RECLAMO / PRODUCTO NO CONFORME	SUBIR ARCHIVO LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 12.11 PRODUCTO NO CONFORME	12	9	34	pendiente	media	9	0	2026-12-31 00:00:00	2026-04-04 00:32:41.344875	2026-04-04 00:32:41.344877	\N	\N
108	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-05 00:00:02.881989	2026-04-05 00:00:02.88199	\N	17
109	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-05 00:00:02.881991	2026-04-05 00:00:02.881991	\N	17
110	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-05 00:00:02.881992	2026-04-05 00:00:02.881992	\N	18
111	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-05 00:00:02.881993	2026-04-05 00:00:02.881993	\N	18
112	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-05 00:00:02.881994	2026-04-05 00:00:02.881994	\N	26
113	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-06 00:00:02.881957	2026-04-06 00:00:02.881958	\N	17
114	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-06 00:00:02.881959	2026-04-06 00:00:02.881959	\N	17
115	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-06 00:00:02.88196	2026-04-06 00:00:02.88196	\N	18
116	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-06 00:00:02.881961	2026-04-06 00:00:02.881961	\N	18
117	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-06 00:00:02.881962	2026-04-06 00:00:02.881962	\N	26
118	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-07 00:00:02.881982	2026-04-07 00:00:02.881983	\N	17
119	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-07 00:00:02.881984	2026-04-07 00:00:02.881984	\N	17
120	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-07 00:00:02.881984	2026-04-07 00:00:02.881985	\N	18
121	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-07 00:00:02.881985	2026-04-07 00:00:02.881985	\N	18
122	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-07 00:00:02.881986	2026-04-07 00:00:02.881986	\N	26
125	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-08 00:00:02.881821	2026-04-08 00:00:02.881821	\N	18
126	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-08 00:00:02.881821	2026-04-08 00:00:02.881822	\N	18
127	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-08 00:00:02.881822	2026-04-08 00:00:02.881822	\N	26
128	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-09 00:00:02.882211	2026-04-09 00:00:02.882212	\N	17
129	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-09 00:00:02.882213	2026-04-09 00:00:02.882213	\N	17
130	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-09 00:00:02.882214	2026-04-09 00:00:02.882214	\N	18
131	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-09 00:00:02.882215	2026-04-09 00:00:02.882215	\N	18
132	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-09 00:00:02.882216	2026-04-09 00:00:02.882216	\N	26
74	REGISTRO MENSUAL DE HIDRATACIÓN DE TODAD LAS AREAS	RRHH DEBERÁ LLEVAR EL REGISTRO SEMANAL DE HIDRATACIÓN PARA EL PERSONAL (REGISTRO DE CAMBIO Y UDO DE BOTELLONES DE AGUA) Y ESTE SE SUBIRA LA PRIMERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 4.24. PROCEDIMIENTO DE HIDRATACIÓN	8	9	5	en_progreso	media	9	4	2026-12-31 00:00:00	2026-04-03 22:13:47.898552	2026-07-09 17:24:18.280227	\N	\N
47	REGISTRO MENSUAL DE CONSUMO ENERGETICO 	SUBIREL ARCHIVO LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	5	completada	alta	4	4	2026-09-01 00:00:00	2026-04-02 04:53:46.739967	2026-09-01 19:23:17.156208	2026-04-08 18:48:50.14781	19
63	ACTAS DE REUNION DE CLUBES CORPORATIVOS 	ESPECIFICAR EN LOS DOCUMENTOS EL MES DE REALIZACIÓN \r\nDOCUMENTO BASE: 2.7. POLITICA DE FUNCIONAMIENTO DE CLUBES COORPORATIVOS	8	9	5	completada	alta	4	4	2026-12-31 00:00:00	2026-04-03 18:38:23.963439	2026-04-09 17:10:19.228983	2026-04-09 17:10:19.228734	\N
133	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-10 00:00:02.88243	2026-04-10 00:00:02.882431	\N	17
134	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-10 00:00:02.882432	2026-04-10 00:00:02.882432	\N	17
135	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-10 00:00:02.882432	2026-04-10 00:00:02.882433	\N	18
136	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-10 00:00:02.882433	2026-04-10 00:00:02.882433	\N	18
137	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-10 00:00:02.882434	2026-04-10 00:00:02.882434	\N	26
138	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-11 00:00:02.881886	2026-04-11 00:00:02.881887	\N	17
139	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-11 00:00:02.881888	2026-04-11 00:00:02.881888	\N	17
140	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-11 00:00:02.881889	2026-04-11 00:00:02.881889	\N	18
141	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-11 00:00:02.881889	2026-04-11 00:00:02.88189	\N	18
142	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-11 00:00:02.88189	2026-04-11 00:00:02.881891	\N	26
143	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-12 00:00:02.88203	2026-04-12 00:00:02.882031	\N	17
144	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-12 00:00:02.882032	2026-04-12 00:00:02.882032	\N	17
145	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-12 00:00:02.882032	2026-04-12 00:00:02.882033	\N	18
146	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-12 00:00:02.882033	2026-04-12 00:00:02.882033	\N	18
147	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-12 00:00:02.882034	2026-04-12 00:00:02.882034	\N	26
148	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-13 00:00:02.881812	2026-04-13 00:00:02.881814	\N	17
149	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-13 00:00:02.881814	2026-04-13 00:00:02.881815	\N	17
150	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-13 00:00:02.881815	2026-04-13 00:00:02.881815	\N	18
151	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-13 00:00:02.881816	2026-04-13 00:00:02.881816	\N	18
152	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-13 00:00:02.881816	2026-04-13 00:00:02.881817	\N	26
153	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-14 00:00:02.882138	2026-04-14 00:00:02.882139	\N	17
154	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-14 00:00:02.88214	2026-04-14 00:00:02.88214	\N	17
155	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-14 00:00:02.882141	2026-04-14 00:00:02.882141	\N	18
156	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-14 00:00:02.882142	2026-04-14 00:00:02.882142	\N	18
157	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-14 00:00:02.882142	2026-04-14 00:00:02.882143	\N	26
158	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-15 00:00:02.882151	2026-04-15 00:00:02.882153	\N	17
159	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-15 00:00:02.882153	2026-04-15 00:00:02.882153	\N	17
160	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-15 00:00:02.882154	2026-04-15 00:00:02.882154	\N	18
161	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-15 00:00:02.882155	2026-04-15 00:00:02.882155	\N	18
162	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-15 00:00:02.882155	2026-04-15 00:00:02.882156	\N	26
163	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-16 00:00:02.895243	2026-04-16 00:00:02.895246	\N	17
164	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-16 00:00:02.895247	2026-04-16 00:00:02.895247	\N	17
165	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-16 00:00:02.895248	2026-04-16 00:00:02.895248	\N	18
166	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-16 00:00:02.895248	2026-04-16 00:00:02.895249	\N	18
167	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-16 00:00:02.895249	2026-04-16 00:00:02.895249	\N	26
168	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-17 00:00:02.882426	2026-04-17 00:00:02.882427	\N	17
169	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-17 00:00:02.882428	2026-04-17 00:00:02.882428	\N	17
170	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-17 00:00:02.882428	2026-04-17 00:00:02.882428	\N	18
171	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-17 00:00:02.882429	2026-04-17 00:00:02.882429	\N	18
172	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-17 00:00:02.88243	2026-04-17 00:00:02.88243	\N	26
173	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-18 00:00:02.896679	2026-04-18 00:00:02.896682	\N	17
174	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-18 00:00:02.896683	2026-04-18 00:00:02.896683	\N	17
175	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-18 00:00:02.896684	2026-04-18 00:00:02.896684	\N	18
176	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-18 00:00:02.896685	2026-04-18 00:00:02.896685	\N	18
177	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-18 00:00:02.896685	2026-04-18 00:00:02.896686	\N	26
178	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-19 00:00:02.88208	2026-04-19 00:00:02.882081	\N	17
179	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-19 00:00:02.882082	2026-04-19 00:00:02.882082	\N	17
180	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-19 00:00:02.882082	2026-04-19 00:00:02.882082	\N	18
181	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-19 00:00:02.882083	2026-04-19 00:00:02.882083	\N	18
182	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-19 00:00:02.882084	2026-04-19 00:00:02.882084	\N	26
183	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-20 00:00:02.882059	2026-04-20 00:00:02.88206	\N	17
184	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-20 00:00:02.882061	2026-04-20 00:00:02.882061	\N	17
185	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-20 00:00:02.882062	2026-04-20 00:00:02.882062	\N	18
186	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-20 00:00:02.882063	2026-04-20 00:00:02.882063	\N	18
187	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-20 00:00:02.882063	2026-04-20 00:00:02.882063	\N	26
188	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-21 00:00:02.882072	2026-04-21 00:00:02.882073	\N	17
189	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-21 00:00:02.882074	2026-04-21 00:00:02.882074	\N	17
223	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-28 00:00:02.894916	2026-04-28 00:00:02.894919	\N	17
190	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-21 00:00:02.882075	2026-04-21 00:00:02.882075	\N	18
191	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-21 00:00:02.882076	2026-04-21 00:00:02.882076	\N	18
192	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-21 00:00:02.882076	2026-04-21 00:00:02.882077	\N	26
193	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-22 00:00:02.881935	2026-04-22 00:00:02.881936	\N	17
194	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-22 00:00:02.881937	2026-04-22 00:00:02.881937	\N	17
195	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-22 00:00:02.881938	2026-04-22 00:00:02.881938	\N	18
196	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-22 00:00:02.881939	2026-04-22 00:00:02.881939	\N	18
197	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-22 00:00:02.881939	2026-04-22 00:00:02.88194	\N	26
198	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-23 00:00:02.8948	2026-04-23 00:00:02.894802	\N	17
199	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-23 00:00:02.894803	2026-04-23 00:00:02.894804	\N	17
200	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-23 00:00:02.894804	2026-04-23 00:00:02.894805	\N	18
201	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-23 00:00:02.894805	2026-04-23 00:00:02.894805	\N	18
202	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-23 00:00:02.894806	2026-04-23 00:00:02.894806	\N	26
203	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-24 00:00:02.881897	2026-04-24 00:00:02.881898	\N	17
204	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-24 00:00:02.881899	2026-04-24 00:00:02.881899	\N	17
205	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-24 00:00:02.8819	2026-04-24 00:00:02.8819	\N	18
206	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-24 00:00:02.8819	2026-04-24 00:00:02.881901	\N	18
207	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-24 00:00:02.881901	2026-04-24 00:00:02.881901	\N	26
208	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-25 00:00:02.881933	2026-04-25 00:00:02.881935	\N	17
209	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-25 00:00:02.881935	2026-04-25 00:00:02.881936	\N	17
210	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-25 00:00:02.881936	2026-04-25 00:00:02.881936	\N	18
211	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-25 00:00:02.881937	2026-04-25 00:00:02.881937	\N	18
212	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-25 00:00:02.881938	2026-04-25 00:00:02.881938	\N	26
213	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-26 00:00:02.882063	2026-04-26 00:00:02.882064	\N	17
214	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-26 00:00:02.882065	2026-04-26 00:00:02.882065	\N	17
215	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-26 00:00:02.882066	2026-04-26 00:00:02.882066	\N	18
216	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-26 00:00:02.882067	2026-04-26 00:00:02.882067	\N	18
217	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-26 00:00:02.882067	2026-04-26 00:00:02.882068	\N	26
218	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-27 00:00:02.882109	2026-04-27 00:00:02.882111	\N	17
219	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-27 00:00:02.882111	2026-04-27 00:00:02.882112	\N	17
220	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-27 00:00:02.882112	2026-04-27 00:00:02.882112	\N	18
221	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-27 00:00:02.882113	2026-04-27 00:00:02.882113	\N	18
222	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-27 00:00:02.882114	2026-04-27 00:00:02.882114	\N	26
224	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-28 00:00:02.89492	2026-04-28 00:00:02.89492	\N	17
225	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-28 00:00:02.894921	2026-04-28 00:00:02.894921	\N	18
226	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-28 00:00:02.894922	2026-04-28 00:00:02.894922	\N	18
227	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-28 00:00:02.894922	2026-04-28 00:00:02.894923	\N	26
228	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	13	pendiente	media	0	0	\N	2026-04-29 00:00:02.886236	2026-04-29 00:00:02.886238	\N	41
229	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	16	pendiente	media	0	0	\N	2026-04-29 00:00:02.886238	2026-04-29 00:00:02.886238	\N	41
230	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-29 00:00:02.886239	2026-04-29 00:00:02.886239	\N	17
231	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-29 00:00:02.88624	2026-04-29 00:00:02.88624	\N	17
232	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-29 00:00:02.88624	2026-04-29 00:00:02.886241	\N	18
233	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-29 00:00:02.886241	2026-04-29 00:00:02.886241	\N	18
234	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-29 00:00:02.886242	2026-04-29 00:00:02.886242	\N	26
236	REGISTRO MENSUAL DE CONSUMO DE AGUA CON DETALLE SEMANAL	Subir los registros la primera semana de cada mes\r\nDocumento Base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\n (MANTENER EL 85% SEMANAL DE RIEGO OPTIMO)	13	9	13	pendiente	alta	0	0	\N	2026-04-30 00:00:02.896113	2026-04-30 00:00:02.896113	\N	13
237	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	13	pendiente	alta	0	0	\N	2026-04-30 00:00:02.896114	2026-04-30 00:00:02.896114	\N	16
238	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	15	pendiente	alta	0	0	\N	2026-04-30 00:00:02.896115	2026-04-30 00:00:02.896115	\N	16
239	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-04-30 00:00:02.896116	2026-04-30 00:00:02.896116	\N	17
240	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-04-30 00:00:02.896116	2026-04-30 00:00:02.896117	\N	17
241	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-04-30 00:00:02.896117	2026-04-30 00:00:02.896117	\N	18
242	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-04-30 00:00:02.896118	2026-04-30 00:00:02.896118	\N	18
244	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-04-30 00:00:02.89612	2026-04-30 00:00:02.89612	\N	26
247	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-01 00:00:02.896537	2026-05-01 00:00:02.896538	\N	17
248	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-01 00:00:02.896538	2026-05-01 00:00:02.896539	\N	17
249	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-01 00:00:02.896539	2026-05-01 00:00:02.896539	\N	26
250	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-01 00:00:02.89654	2026-05-01 00:00:02.89654	\N	18
251	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-01 00:00:02.896541	2026-05-01 00:00:02.896541	\N	18
252	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-02 00:00:02.882033	2026-05-02 00:00:02.882034	\N	17
253	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-02 00:00:02.882035	2026-05-02 00:00:02.882035	\N	17
254	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-02 00:00:02.882036	2026-05-02 00:00:02.882036	\N	18
255	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-02 00:00:02.882037	2026-05-02 00:00:02.882037	\N	18
245	INFORME MENSUAL DE INSPECCION DE ESPACIOS DE DESCANSOS	SUBIR EL ARCHIVO LA SEGUNDA SEMANA DE CADA MES 07- 12\r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	\N	pendiente	alta	6	0	2026-12-31 00:00:00	2026-05-01 00:00:02.896533	2026-09-01 19:36:20.518734	\N	22
256	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-02 00:00:02.882037	2026-05-02 00:00:02.882038	\N	26
257	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-03 00:00:02.882284	2026-05-03 00:00:02.882286	\N	17
258	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-03 00:00:02.882286	2026-05-03 00:00:02.882287	\N	17
259	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-03 00:00:02.882287	2026-05-03 00:00:02.882288	\N	18
260	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-03 00:00:02.882288	2026-05-03 00:00:02.882288	\N	18
261	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-03 00:00:02.882289	2026-05-03 00:00:02.882289	\N	26
262	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-04 00:00:02.882911	2026-05-04 00:00:02.882913	\N	17
263	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-04 00:00:02.882913	2026-05-04 00:00:02.882914	\N	17
264	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-04 00:00:02.882914	2026-05-04 00:00:02.882914	\N	18
265	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-04 00:00:02.882915	2026-05-04 00:00:02.882915	\N	18
266	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-04 00:00:02.882916	2026-05-04 00:00:02.882916	\N	26
267	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-05 00:00:02.895416	2026-05-05 00:00:02.895418	\N	17
268	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-05 00:00:02.895419	2026-05-05 00:00:02.89542	\N	17
269	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-05 00:00:02.89542	2026-05-05 00:00:02.89542	\N	18
270	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-05 00:00:02.895421	2026-05-05 00:00:02.895421	\N	18
271	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-05 00:00:02.895422	2026-05-05 00:00:02.895422	\N	26
272	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-06 00:00:02.895306	2026-05-06 00:00:02.895308	\N	17
273	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-06 00:00:02.895309	2026-05-06 00:00:02.895309	\N	17
274	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-06 00:00:02.89531	2026-05-06 00:00:02.89531	\N	18
275	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-06 00:00:02.89531	2026-05-06 00:00:02.895311	\N	18
276	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-06 00:00:02.895311	2026-05-06 00:00:02.895311	\N	26
277	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-07 00:00:02.882074	2026-05-07 00:00:02.882076	\N	17
278	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-07 00:00:02.882076	2026-05-07 00:00:02.882077	\N	17
279	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-07 00:00:02.882077	2026-05-07 00:00:02.882077	\N	18
280	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-07 00:00:02.882078	2026-05-07 00:00:02.882078	\N	18
281	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-07 00:00:02.882078	2026-05-07 00:00:02.882079	\N	26
282	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-08 00:00:02.882946	2026-05-08 00:00:02.882949	\N	17
283	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-08 00:00:02.88295	2026-05-08 00:00:02.882951	\N	17
284	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-08 00:00:02.882951	2026-05-08 00:00:02.882951	\N	18
285	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-08 00:00:02.882952	2026-05-08 00:00:02.882952	\N	18
286	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-08 00:00:02.882952	2026-05-08 00:00:02.882953	\N	26
287	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-09 00:00:02.881948	2026-05-09 00:00:02.881949	\N	17
288	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-09 00:00:02.88195	2026-05-09 00:00:02.88195	\N	17
289	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-09 00:00:02.881951	2026-05-09 00:00:02.881951	\N	18
290	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-09 00:00:02.881951	2026-05-09 00:00:02.881952	\N	18
291	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-09 00:00:02.881952	2026-05-09 00:00:02.881952	\N	26
292	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-10 00:00:02.882148	2026-05-10 00:00:02.882149	\N	17
293	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-10 00:00:02.88215	2026-05-10 00:00:02.88215	\N	17
294	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-10 00:00:02.882151	2026-05-10 00:00:02.882151	\N	18
295	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-10 00:00:02.882151	2026-05-10 00:00:02.882152	\N	18
296	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-10 00:00:02.882152	2026-05-10 00:00:02.882152	\N	26
297	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-11 00:00:02.882136	2026-05-11 00:00:02.882137	\N	17
298	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-11 00:00:02.882137	2026-05-11 00:00:02.882138	\N	17
299	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-11 00:00:02.882138	2026-05-11 00:00:02.882138	\N	18
300	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-11 00:00:02.882139	2026-05-11 00:00:02.882139	\N	18
301	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-11 00:00:02.882139	2026-05-11 00:00:02.88214	\N	26
302	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-12 00:00:02.884063	2026-05-12 00:00:02.884065	\N	17
303	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-12 00:00:02.884065	2026-05-12 00:00:02.884066	\N	17
304	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-12 00:00:02.884066	2026-05-12 00:00:02.884066	\N	26
305	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-12 00:00:02.884067	2026-05-12 00:00:02.884067	\N	18
306	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-12 00:00:02.884068	2026-05-12 00:00:02.884068	\N	18
307	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-13 00:00:02.89682	2026-05-13 00:00:02.896823	\N	17
308	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-13 00:00:02.896824	2026-05-13 00:00:02.896824	\N	17
309	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-13 00:00:02.896825	2026-05-13 00:00:02.896825	\N	18
310	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-13 00:00:02.896826	2026-05-13 00:00:02.896826	\N	18
311	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-13 00:00:02.896826	2026-05-13 00:00:02.896827	\N	26
312	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-14 00:00:02.881914	2026-05-14 00:00:02.881915	\N	17
313	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-14 00:00:02.881916	2026-05-14 00:00:02.881916	\N	17
314	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-14 00:00:02.881916	2026-05-14 00:00:02.881917	\N	18
315	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-14 00:00:02.881917	2026-05-14 00:00:02.881917	\N	18
316	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-14 00:00:02.881918	2026-05-14 00:00:02.881918	\N	26
317	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-15 00:00:02.8818	2026-05-15 00:00:02.881802	\N	17
318	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-15 00:00:02.881802	2026-05-15 00:00:02.881803	\N	17
319	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-15 00:00:02.881803	2026-05-15 00:00:02.881803	\N	18
320	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-15 00:00:02.881804	2026-05-15 00:00:02.881804	\N	18
321	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-15 00:00:02.881805	2026-05-15 00:00:02.881805	\N	26
322	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-16 00:00:02.88197	2026-05-16 00:00:02.881971	\N	17
323	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-16 00:00:02.881972	2026-05-16 00:00:02.881972	\N	17
324	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-16 00:00:02.881973	2026-05-16 00:00:02.881973	\N	18
325	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-16 00:00:02.881974	2026-05-16 00:00:02.881974	\N	18
326	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-16 00:00:02.881974	2026-05-16 00:00:02.881975	\N	26
327	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-17 00:00:02.882176	2026-05-17 00:00:02.882177	\N	17
328	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-17 00:00:02.882178	2026-05-17 00:00:02.882178	\N	17
329	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-17 00:00:02.882179	2026-05-17 00:00:02.882179	\N	18
330	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-17 00:00:02.882179	2026-05-17 00:00:02.88218	\N	18
331	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-17 00:00:02.88218	2026-05-17 00:00:02.88218	\N	26
332	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-18 00:00:02.881872	2026-05-18 00:00:02.881873	\N	17
333	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-18 00:00:02.881874	2026-05-18 00:00:02.881874	\N	17
334	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-18 00:00:02.881875	2026-05-18 00:00:02.881875	\N	18
335	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-18 00:00:02.881875	2026-05-18 00:00:02.881876	\N	18
336	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-18 00:00:02.881876	2026-05-18 00:00:02.881876	\N	26
337	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-19 00:00:02.88199	2026-05-19 00:00:02.881991	\N	17
338	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-19 00:00:02.881992	2026-05-19 00:00:02.881992	\N	17
339	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-19 00:00:02.881993	2026-05-19 00:00:02.881993	\N	18
340	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-19 00:00:02.881994	2026-05-19 00:00:02.881994	\N	18
341	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-19 00:00:02.881994	2026-05-19 00:00:02.881994	\N	26
342	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-20 00:00:02.897058	2026-05-20 00:00:02.897061	\N	17
343	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-20 00:00:02.897062	2026-05-20 00:00:02.897063	\N	17
344	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-20 00:00:02.897063	2026-05-20 00:00:02.897063	\N	18
345	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-20 00:00:02.897064	2026-05-20 00:00:02.897064	\N	18
346	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-20 00:00:02.897065	2026-05-20 00:00:02.897065	\N	26
347	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-21 00:00:02.896479	2026-05-21 00:00:02.896482	\N	17
348	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-21 00:00:02.896483	2026-05-21 00:00:02.896483	\N	17
349	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-21 00:00:02.896484	2026-05-21 00:00:02.896484	\N	18
350	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-21 00:00:02.896484	2026-05-21 00:00:02.896485	\N	18
351	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-21 00:00:02.896485	2026-05-21 00:00:02.896485	\N	26
352	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-22 00:00:54.348859	2026-05-22 00:00:54.348861	\N	17
353	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-22 00:00:54.348863	2026-05-22 00:00:54.348864	\N	17
354	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-22 00:00:54.348864	2026-05-22 00:00:54.348865	\N	18
355	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-22 00:00:54.348865	2026-05-22 00:00:54.348866	\N	18
356	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-22 00:00:54.348866	2026-05-22 00:00:54.348866	\N	26
357	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-23 00:00:54.309886	2026-05-23 00:00:54.309887	\N	17
358	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-23 00:00:54.309888	2026-05-23 00:00:54.309889	\N	17
359	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-23 00:00:54.309889	2026-05-23 00:00:54.309889	\N	18
360	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-23 00:00:54.30989	2026-05-23 00:00:54.30989	\N	18
361	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-23 00:00:54.309891	2026-05-23 00:00:54.309891	\N	26
362	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-24 00:00:54.309778	2026-05-24 00:00:54.309779	\N	17
363	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-24 00:00:54.30978	2026-05-24 00:00:54.30978	\N	17
364	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-24 00:00:54.309781	2026-05-24 00:00:54.309781	\N	18
365	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-24 00:00:54.309782	2026-05-24 00:00:54.309782	\N	18
366	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-24 00:00:54.309782	2026-05-24 00:00:54.309783	\N	26
367	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-25 00:00:54.309709	2026-05-25 00:00:54.30971	\N	17
368	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-25 00:00:54.309711	2026-05-25 00:00:54.309711	\N	17
369	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-25 00:00:54.309712	2026-05-25 00:00:54.309712	\N	18
370	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-25 00:00:54.309713	2026-05-25 00:00:54.309713	\N	18
371	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-25 00:00:54.309713	2026-05-25 00:00:54.309714	\N	26
372	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-26 00:00:54.309541	2026-05-26 00:00:54.309542	\N	17
373	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-26 00:00:54.309543	2026-05-26 00:00:54.309543	\N	17
374	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-26 00:00:54.309544	2026-05-26 00:00:54.309544	\N	18
375	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-26 00:00:54.309544	2026-05-26 00:00:54.309544	\N	18
376	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-26 00:00:54.309545	2026-05-26 00:00:54.309545	\N	26
377	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-27 00:00:54.30949	2026-05-27 00:00:54.309491	\N	17
378	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-27 00:00:54.309492	2026-05-27 00:00:54.309492	\N	17
379	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-27 00:00:54.309493	2026-05-27 00:00:54.309493	\N	18
380	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-27 00:00:54.309493	2026-05-27 00:00:54.309493	\N	18
381	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-27 00:00:54.309494	2026-05-27 00:00:54.309494	\N	26
382	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-28 00:00:54.309687	2026-05-28 00:00:54.309689	\N	17
383	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-28 00:00:54.309689	2026-05-28 00:00:54.30969	\N	17
384	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-28 00:00:54.30969	2026-05-28 00:00:54.30969	\N	18
385	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-28 00:00:54.309691	2026-05-28 00:00:54.309691	\N	18
386	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-28 00:00:54.309691	2026-05-28 00:00:54.309692	\N	26
387	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-29 00:00:54.309875	2026-05-29 00:00:54.309876	\N	17
388	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-29 00:00:54.309877	2026-05-29 00:00:54.309877	\N	17
389	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-29 00:00:54.309877	2026-05-29 00:00:54.309878	\N	18
390	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-29 00:00:54.309878	2026-05-29 00:00:54.309878	\N	18
391	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-29 00:00:54.309879	2026-05-29 00:00:54.309879	\N	26
392	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	13	pendiente	media	0	0	\N	2026-05-29 00:00:54.30988	2026-05-29 00:00:54.30988	\N	41
393	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	16	pendiente	media	0	0	\N	2026-05-29 00:00:54.30988	2026-05-29 00:00:54.309881	\N	41
394	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-30 00:00:54.310419	2026-05-30 00:00:54.31042	\N	17
395	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-30 00:00:54.310421	2026-05-30 00:00:54.310421	\N	17
397	REGISTRO MENSUAL DE CONSUMO DE AGUA CON DETALLE SEMANAL	Subir los registros la primera semana de cada mes\r\nDocumento Base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\n (MANTENER EL 85% SEMANAL DE RIEGO OPTIMO)	13	9	13	pendiente	alta	0	0	\N	2026-05-30 00:00:54.310422	2026-05-30 00:00:54.310423	\N	13
398	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-30 00:00:54.310423	2026-05-30 00:00:54.310423	\N	18
399	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-30 00:00:54.310424	2026-05-30 00:00:54.310424	\N	18
400	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-30 00:00:54.310425	2026-05-30 00:00:54.310425	\N	26
401	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	13	pendiente	alta	0	0	\N	2026-05-30 00:00:54.310425	2026-05-30 00:00:54.310426	\N	16
402	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	15	pendiente	alta	0	0	\N	2026-05-30 00:00:54.310426	2026-05-30 00:00:54.310426	\N	16
406	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-05-31 00:00:54.312927	2026-05-31 00:00:54.312927	\N	17
407	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-05-31 00:00:54.312928	2026-05-31 00:00:54.312928	\N	17
408	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-05-31 00:00:54.312929	2026-05-31 00:00:54.312929	\N	18
409	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-05-31 00:00:54.312929	2026-05-31 00:00:54.31293	\N	18
410	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-05-31 00:00:54.31293	2026-05-31 00:00:54.31293	\N	26
411	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-01 00:00:54.310007	2026-06-01 00:00:54.310009	\N	25
412	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-01 00:00:54.31001	2026-06-01 00:00:54.31001	\N	17
413	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-01 00:00:54.31001	2026-06-01 00:00:54.310011	\N	17
414	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-06-01 00:00:54.310011	2026-06-01 00:00:54.310012	\N	26
415	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-01 00:00:54.310012	2026-06-01 00:00:54.310012	\N	18
416	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-01 00:00:54.310013	2026-06-01 00:00:54.310013	\N	18
417	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-02 00:00:54.309948	2026-06-02 00:00:54.309949	\N	17
418	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-02 00:00:54.30995	2026-06-02 00:00:54.30995	\N	17
419	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-02 00:00:54.30995	2026-06-02 00:00:54.30995	\N	25
485	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-27 00:00:32.239112	2026-06-27 00:00:32.239112	\N	17
486	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-27 00:00:32.239112	2026-06-27 00:00:32.239113	\N	27
420	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-02 00:00:54.309951	2026-06-02 00:00:54.309951	\N	18
421	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-02 00:00:54.309952	2026-06-02 00:00:54.309952	\N	18
422	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-06-02 00:00:54.309953	2026-06-02 00:00:54.309953	\N	26
423	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-03 00:00:54.310162	2026-06-03 00:00:54.310163	\N	17
424	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-03 00:00:54.310164	2026-06-03 00:00:54.310164	\N	17
425	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-03 00:00:54.310164	2026-06-03 00:00:54.310165	\N	25
426	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-03 00:00:54.310165	2026-06-03 00:00:54.310165	\N	18
427	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-03 00:00:54.310166	2026-06-03 00:00:54.310166	\N	18
428	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-06-03 00:00:54.310166	2026-06-03 00:00:54.310167	\N	26
429	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-04 00:00:54.310444	2026-06-04 00:00:54.310445	\N	25
430	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-04 00:00:54.310446	2026-06-04 00:00:54.310446	\N	17
431	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-04 00:00:54.310446	2026-06-04 00:00:54.310447	\N	17
432	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-04 00:00:54.310447	2026-06-04 00:00:54.310447	\N	18
433	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-04 00:00:54.310448	2026-06-04 00:00:54.310448	\N	18
434	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-06-04 00:00:54.310448	2026-06-04 00:00:54.310449	\N	26
435	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-05 00:00:54.309679	2026-06-05 00:00:54.30968	\N	17
436	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-05 00:00:54.309681	2026-06-05 00:00:54.309681	\N	17
437	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-05 00:00:54.309681	2026-06-05 00:00:54.309682	\N	25
438	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-05 00:00:54.309682	2026-06-05 00:00:54.309682	\N	18
439	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-05 00:00:54.309683	2026-06-05 00:00:54.309683	\N	18
440	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-06-05 00:00:54.309684	2026-06-05 00:00:54.309684	\N	26
441	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-06 00:00:06.082119	2026-06-06 00:00:06.082121	\N	25
442	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-06 00:00:06.082123	2026-06-06 00:00:06.082123	\N	17
443	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-06 00:00:06.082124	2026-06-06 00:00:06.082124	\N	17
444	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-06 00:00:06.082125	2026-06-06 00:00:06.082125	\N	18
445	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-06 00:00:06.082126	2026-06-06 00:00:06.082126	\N	18
446	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-06-06 00:00:06.082126	2026-06-06 00:00:06.082127	\N	26
447	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-08 12:32:16.963394	2026-06-08 12:32:16.963396	\N	17
448	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-08 12:32:16.963399	2026-06-08 12:32:16.963399	\N	17
449	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-08 12:32:16.9634	2026-06-08 12:32:16.9634	\N	25
450	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-08 12:32:16.963401	2026-06-08 12:32:16.963401	\N	18
235	REGISTRO MENSUAL DE CONSUMO ELECTRICO Y COMBUSTIBLE 	Documento base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\nSubir ambos registro de manera mensual de forma separada, 2 registros mensuales. 	8	9	5	completada	alta	2	2	2026-06-30 00:00:00	2026-04-30 00:00:02.89611	2026-09-01 19:16:41.027384	2026-06-04 20:59:46.506719	12
451	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-08 12:32:16.963402	2026-06-08 12:32:16.963402	\N	18
452	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\n	6	9	9	pendiente	alta	0	0	\N	2026-06-08 12:32:16.963402	2026-06-08 12:32:16.963403	\N	26
453	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-22 14:44:32.373155	2026-06-22 14:44:32.373157	\N	17
454	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-22 14:44:32.373159	2026-06-22 14:44:32.37316	\N	17
455	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-22 14:44:32.37316	2026-06-22 14:44:32.37316	\N	27
456	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-22 14:44:32.373161	2026-06-22 14:44:32.373162	\N	25
457	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-22 14:44:32.373162	2026-06-22 14:44:32.373162	\N	18
458	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-22 14:44:32.373163	2026-06-22 14:44:32.373163	\N	18
459	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-23 00:00:32.238615	2026-06-23 00:00:32.238616	\N	17
460	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-23 00:00:32.238617	2026-06-23 00:00:32.238617	\N	17
461	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-23 00:00:32.238617	2026-06-23 00:00:32.238618	\N	25
462	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-23 00:00:32.238618	2026-06-23 00:00:32.238618	\N	27
463	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-23 00:00:32.238619	2026-06-23 00:00:32.238619	\N	18
464	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-23 00:00:32.23862	2026-06-23 00:00:32.23862	\N	18
465	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-24 00:00:32.238806	2026-06-24 00:00:32.238807	\N	17
466	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-24 00:00:32.238808	2026-06-24 00:00:32.238808	\N	17
467	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-24 00:00:32.238809	2026-06-24 00:00:32.238809	\N	25
468	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-24 00:00:32.238809	2026-06-24 00:00:32.23881	\N	27
469	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-24 00:00:32.23881	2026-06-24 00:00:32.23881	\N	18
470	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-24 00:00:32.238811	2026-06-24 00:00:32.238811	\N	18
471	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-25 00:00:32.238593	2026-06-25 00:00:32.238594	\N	25
472	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-25 00:00:32.238595	2026-06-25 00:00:32.238595	\N	17
473	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-25 00:00:32.238596	2026-06-25 00:00:32.238596	\N	17
474	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-25 00:00:32.238597	2026-06-25 00:00:32.238597	\N	27
475	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-25 00:00:32.238597	2026-06-25 00:00:32.238598	\N	18
476	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-25 00:00:32.238598	2026-06-25 00:00:32.238598	\N	18
477	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-26 00:00:32.238489	2026-06-26 00:00:32.23849	\N	25
478	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-26 00:00:32.238491	2026-06-26 00:00:32.238491	\N	27
479	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-26 00:00:32.238492	2026-06-26 00:00:32.238492	\N	17
480	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-26 00:00:32.238492	2026-06-26 00:00:32.238493	\N	17
481	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-26 00:00:32.238493	2026-06-26 00:00:32.238493	\N	18
482	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-26 00:00:32.238494	2026-06-26 00:00:32.238494	\N	18
483	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-27 00:00:32.239109	2026-06-27 00:00:32.23911	\N	25
484	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-27 00:00:32.239111	2026-06-27 00:00:32.239111	\N	17
487	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-27 00:00:32.239113	2026-06-27 00:00:32.239113	\N	18
488	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-27 00:00:32.239114	2026-06-27 00:00:32.239114	\N	18
489	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-28 00:00:32.238693	2026-06-28 00:00:32.238695	\N	25
490	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-28 00:00:32.238695	2026-06-28 00:00:32.238695	\N	27
491	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-28 00:00:32.238696	2026-06-28 00:00:32.238696	\N	17
492	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-28 00:00:32.238697	2026-06-28 00:00:32.238697	\N	17
493	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-28 00:00:32.238697	2026-06-28 00:00:32.238698	\N	18
494	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-28 00:00:32.238698	2026-06-28 00:00:32.238698	\N	18
495	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	13	pendiente	media	0	0	\N	2026-06-28 00:00:32.238699	2026-06-28 00:00:32.238699	\N	41
496	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	16	pendiente	media	0	0	\N	2026-06-28 00:00:32.2387	2026-06-28 00:00:32.2387	\N	41
497	REGISTRO MENSUAL DE CONSUMO DE AGUA CON DETALLE SEMANAL	Subir los registros la primera semana de cada mes\r\nDocumento Base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\n (MANTENER EL 85% SEMANAL DE RIEGO OPTIMO)	13	9	13	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997179	2026-06-29 00:00:30.99718	\N	13
498	PUBLICAR INFORME ANUAL SOCIOAMBIENTAL JUNIO	DOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997183	2026-06-29 00:00:30.997183	\N	25
500	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997185	2026-06-29 00:00:30.997185	\N	27
501	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997186	2026-06-29 00:00:30.997186	\N	17
502	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997186	2026-06-29 00:00:30.997187	\N	17
503	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997187	2026-06-29 00:00:30.997187	\N	18
504	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997188	2026-06-29 00:00:30.997188	\N	18
505	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	13	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997189	2026-06-29 00:00:30.997189	\N	16
506	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	15	pendiente	alta	0	0	\N	2026-06-29 00:00:30.997189	2026-06-29 00:00:30.99719	\N	16
510	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-06-30 00:00:30.969468	2026-06-30 00:00:30.969468	\N	17
511	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-06-30 00:00:30.969469	2026-06-30 00:00:30.969469	\N	17
512	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-06-30 00:00:30.96947	2026-06-30 00:00:30.96947	\N	27
513	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-06-30 00:00:30.96947	2026-06-30 00:00:30.969471	\N	18
514	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-06-30 00:00:30.969471	2026-06-30 00:00:30.969471	\N	18
515	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-01 00:00:04.635497	2026-07-01 00:00:04.635499	\N	17
516	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-01 00:00:04.635501	2026-07-01 00:00:04.635502	\N	17
517	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-01 00:00:04.635502	2026-07-01 00:00:04.635503	\N	27
518	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-01 00:00:04.635503	2026-07-01 00:00:04.635504	\N	18
499	REGISTRO MENSUAL DE CONSUMO ELECTRICO Y COMBUSTIBLE 	Documento base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\nSubir ambos registro de manera mensual de forma separada, 2 registros mensuales. 	8	9	5	completada	alta	6	6	2026-09-01 00:00:00	2026-06-29 00:00:30.997184	2026-09-01 19:08:26.080506	2026-07-06 15:29:13.262957	12
519	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-01 00:00:04.635504	2026-07-01 00:00:04.635504	\N	18
520	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-02 00:00:04.610966	2026-07-02 00:00:04.610969	\N	27
521	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-02 00:00:04.610969	2026-07-02 00:00:04.61097	\N	17
522	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-02 00:00:04.61097	2026-07-02 00:00:04.61097	\N	17
523	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-02 00:00:04.610971	2026-07-02 00:00:04.610971	\N	18
524	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-02 00:00:04.610972	2026-07-02 00:00:04.610972	\N	18
525	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-03 00:00:04.610327	2026-07-03 00:00:04.610328	\N	17
526	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-03 00:00:04.610329	2026-07-03 00:00:04.610329	\N	17
527	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-03 00:00:04.61033	2026-07-03 00:00:04.61033	\N	27
528	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-03 00:00:04.61033	2026-07-03 00:00:04.610331	\N	18
529	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-03 00:00:04.610331	2026-07-03 00:00:04.610331	\N	18
530	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-04 00:00:04.610563	2026-07-04 00:00:04.610564	\N	17
531	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-04 00:00:04.610565	2026-07-04 00:00:04.610565	\N	17
532	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-04 00:00:04.610565	2026-07-04 00:00:04.610566	\N	27
533	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-04 00:00:04.610566	2026-07-04 00:00:04.610566	\N	18
534	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-04 00:00:04.610567	2026-07-04 00:00:04.610567	\N	18
535	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-05 00:00:04.610417	2026-07-05 00:00:04.610419	\N	17
536	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-05 00:00:04.610419	2026-07-05 00:00:04.61042	\N	17
537	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-05 00:00:04.61042	2026-07-05 00:00:04.61042	\N	27
538	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-05 00:00:04.610421	2026-07-05 00:00:04.610421	\N	18
539	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-05 00:00:04.610422	2026-07-05 00:00:04.610422	\N	18
540	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-06 13:01:38.114506	2026-07-06 13:01:38.114507	\N	17
541	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-06 13:01:38.11451	2026-07-06 13:01:38.11451	\N	17
542	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-06 13:01:38.114511	2026-07-06 13:01:38.114511	\N	27
543	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-06 13:01:38.114512	2026-07-06 13:01:38.114512	\N	18
544	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-06 13:01:38.114513	2026-07-06 13:01:38.114513	\N	18
545	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-07 00:00:37.930642	2026-07-07 00:00:37.930643	\N	17
546	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-07 00:00:37.930644	2026-07-07 00:00:37.930644	\N	17
547	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-07 00:00:37.930645	2026-07-07 00:00:37.930645	\N	27
548	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-07 00:00:37.930645	2026-07-07 00:00:37.930645	\N	18
549	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-07 00:00:37.930646	2026-07-07 00:00:37.930646	\N	18
405	INFORME MENSUAL DE INSPECCION DE ESPACIOS DE DESCANSOS	SUBIR EL ARCHIVO LA SEGUNDA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	5	completada	alta	9	3	2026-12-31 00:00:00	2026-05-31 00:00:54.312926	2026-09-01 19:14:13.194101	2026-07-06 15:36:55.967486	22
550	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-08 00:00:37.930764	2026-07-08 00:00:37.930766	\N	17
551	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-08 00:00:37.930766	2026-07-08 00:00:37.930767	\N	17
552	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-08 00:00:37.930767	2026-07-08 00:00:37.930768	\N	27
553	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-08 00:00:37.930768	2026-07-08 00:00:37.930768	\N	18
554	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-08 00:00:37.930769	2026-07-08 00:00:37.930769	\N	18
555	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-09 00:00:37.930342	2026-07-09 00:00:37.930343	\N	17
556	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-09 00:00:37.930343	2026-07-09 00:00:37.930344	\N	17
558	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-09 00:00:37.930345	2026-07-09 00:00:37.930345	\N	18
559	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-09 00:00:37.930346	2026-07-09 00:00:37.930346	\N	18
560	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-10 00:00:37.930534	2026-07-10 00:00:37.930535	\N	17
561	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-10 00:00:37.930535	2026-07-10 00:00:37.930536	\N	17
563	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-10 00:00:37.930537	2026-07-10 00:00:37.930548	\N	18
564	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-10 00:00:37.930549	2026-07-10 00:00:37.93055	\N	18
565	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-11 00:00:37.930681	2026-07-11 00:00:37.930682	\N	17
566	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-11 00:00:37.930683	2026-07-11 00:00:37.930683	\N	17
567	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-07-11 00:00:37.930684	2026-07-11 00:00:37.930684	\N	27
568	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-11 00:00:37.930684	2026-07-11 00:00:37.930684	\N	18
569	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-11 00:00:37.930685	2026-07-11 00:00:37.930685	\N	18
570	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-12 00:00:37.930255	2026-07-12 00:00:37.930256	\N	17
571	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-12 00:00:37.930257	2026-07-12 00:00:37.930257	\N	17
573	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-12 00:00:37.930258	2026-07-12 00:00:37.930258	\N	18
574	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-12 00:00:37.930259	2026-07-12 00:00:37.930259	\N	18
575	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-13 00:00:37.930788	2026-07-13 00:00:37.930789	\N	17
576	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-13 00:00:37.93079	2026-07-13 00:00:37.93079	\N	17
578	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-13 00:00:37.930791	2026-07-13 00:00:37.930792	\N	18
579	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-13 00:00:37.930792	2026-07-13 00:00:37.930792	\N	18
580	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-14 00:00:37.930253	2026-07-14 00:00:37.930254	\N	17
581	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-14 00:00:37.930255	2026-07-14 00:00:37.930255	\N	17
616	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-21 00:00:37.930348	2026-07-21 00:00:37.930349	\N	17
583	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-14 00:00:37.930256	2026-07-14 00:00:37.930257	\N	18
584	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-14 00:00:37.930257	2026-07-14 00:00:37.930257	\N	18
585	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-15 00:00:37.937004	2026-07-15 00:00:37.937005	\N	17
586	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-15 00:00:37.937006	2026-07-15 00:00:37.937006	\N	17
588	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-15 00:00:37.937008	2026-07-15 00:00:37.937008	\N	18
589	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-15 00:00:37.937008	2026-07-15 00:00:37.937009	\N	18
590	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-16 00:00:37.930643	2026-07-16 00:00:37.930645	\N	17
591	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-16 00:00:37.930645	2026-07-16 00:00:37.930646	\N	17
593	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-16 00:00:37.930647	2026-07-16 00:00:37.930647	\N	18
594	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-16 00:00:37.930648	2026-07-16 00:00:37.930648	\N	18
595	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-17 00:00:37.930517	2026-07-17 00:00:37.930518	\N	17
596	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-17 00:00:37.930519	2026-07-17 00:00:37.930519	\N	17
598	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-17 00:00:37.93052	2026-07-17 00:00:37.930521	\N	18
599	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-17 00:00:37.930521	2026-07-17 00:00:37.930521	\N	18
600	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-18 00:00:37.930527	2026-07-18 00:00:37.930528	\N	17
601	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-18 00:00:37.930529	2026-07-18 00:00:37.930529	\N	17
603	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-18 00:00:37.93053	2026-07-18 00:00:37.930531	\N	18
604	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-18 00:00:37.930531	2026-07-18 00:00:37.930531	\N	18
605	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-19 00:00:37.930496	2026-07-19 00:00:37.930497	\N	17
606	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-19 00:00:37.930498	2026-07-19 00:00:37.930498	\N	17
608	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-19 00:00:37.930499	2026-07-19 00:00:37.930499	\N	18
609	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-19 00:00:37.9305	2026-07-19 00:00:37.9305	\N	18
610	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-20 00:00:37.930497	2026-07-20 00:00:37.930498	\N	17
611	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-20 00:00:37.930499	2026-07-20 00:00:37.930499	\N	17
613	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-20 00:00:37.9305	2026-07-20 00:00:37.930501	\N	18
614	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-20 00:00:37.930501	2026-07-20 00:00:37.930501	\N	18
615	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-21 00:00:37.930347	2026-07-21 00:00:37.930348	\N	17
619	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-21 00:00:37.930351	2026-07-21 00:00:37.930351	\N	18
620	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-22 00:00:37.930602	2026-07-22 00:00:37.930604	\N	17
621	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-22 00:00:37.930604	2026-07-22 00:00:37.930605	\N	17
623	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-07-22 00:00:37.930606	2026-07-22 00:00:37.930606	\N	18
624	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-22 00:00:37.930607	2026-07-22 00:00:37.930607	\N	18
625	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-23 00:00:37.930805	2026-07-23 00:00:37.930806	\N	17
626	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-23 00:00:37.930807	2026-07-23 00:00:37.930807	\N	17
629	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-23 00:00:37.930809	2026-07-23 00:00:37.930809	\N	18
630	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-24 00:00:37.930382	2026-07-24 00:00:37.930383	\N	17
631	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-24 00:00:37.930384	2026-07-24 00:00:37.930384	\N	17
634	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-24 00:00:37.930386	2026-07-24 00:00:37.930386	\N	18
635	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-07-25 00:00:37.930205	2026-07-25 00:00:37.930206	\N	17
636	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-07-25 00:00:37.930207	2026-07-25 00:00:37.930207	\N	17
639	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-07-25 00:00:37.930209	2026-07-25 00:00:37.930209	\N	18
640	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-07 15:24:28.774297	2026-08-07 15:24:28.774299	\N	17
641	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-07 15:24:28.774301	2026-08-07 15:24:28.774301	\N	17
645	REGISTRO MENSUAL DE CONSUMO DE AGUA CON DETALLE SEMANAL	Subir los registros la primera semana de cada mes\r\nDocumento Base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\n (MANTENER EL 85% SEMANAL DE RIEGO OPTIMO)	13	9	13	pendiente	alta	0	0	\N	2026-08-07 15:24:28.774305	2026-08-07 15:24:28.774305	\N	13
647	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	13	pendiente	media	0	0	\N	2026-08-07 15:24:28.774306	2026-08-07 15:24:28.774306	\N	41
648	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	16	pendiente	media	0	0	\N	2026-08-07 15:24:28.774307	2026-08-07 15:24:28.774307	\N	41
649	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	13	pendiente	alta	0	0	\N	2026-08-07 15:24:28.774308	2026-08-07 15:24:28.774308	\N	16
650	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	15	pendiente	alta	0	0	\N	2026-08-07 15:24:28.774308	2026-08-07 15:24:28.774308	\N	16
652	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-08-07 15:24:28.77431	2026-08-07 15:24:28.77431	\N	18
653	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-07 15:24:28.77431	2026-08-07 15:24:28.774311	\N	18
654	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-08 00:00:28.511158	2026-08-08 00:00:28.511159	\N	17
655	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-08 00:00:28.51116	2026-08-08 00:00:28.51116	\N	17
658	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-08 00:00:28.511162	2026-08-08 00:00:28.511162	\N	18
659	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-09 00:00:28.511781	2026-08-09 00:00:28.511783	\N	17
660	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-09 00:00:28.511784	2026-08-09 00:00:28.511784	\N	17
663	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-09 00:00:28.511786	2026-08-09 00:00:28.511786	\N	18
664	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-10 00:00:28.511085	2026-08-10 00:00:28.511086	\N	17
665	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-10 00:00:28.511087	2026-08-10 00:00:28.511087	\N	17
668	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-10 00:00:28.511089	2026-08-10 00:00:28.511089	\N	18
669	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-11 00:00:28.511064	2026-08-11 00:00:28.511065	\N	17
670	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-11 00:00:28.511066	2026-08-11 00:00:28.511066	\N	17
673	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-11 00:00:28.511069	2026-08-11 00:00:28.511069	\N	18
674	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-26 14:36:08.14618	2026-08-26 14:36:08.146181	\N	17
675	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-26 14:36:08.146184	2026-08-26 14:36:08.146184	\N	17
678	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-26 14:36:08.146187	2026-08-26 14:36:08.146187	\N	18
679	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-27 00:00:07.868133	2026-08-27 00:00:07.868135	\N	17
680	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-27 00:00:07.868135	2026-08-27 00:00:07.868136	\N	17
683	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-27 00:00:07.868138	2026-08-27 00:00:07.868138	\N	18
684	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	13	pendiente	media	0	0	\N	2026-08-27 00:00:07.868138	2026-08-27 00:00:07.868139	\N	41
686	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-28 00:00:07.868688	2026-08-28 00:00:07.86869	\N	17
687	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-28 00:00:07.86869	2026-08-28 00:00:07.868691	\N	17
690	REGISTRO MENSUAL DE CONSUMO DE AGUA CON DETALLE SEMANAL	Subir los registros la primera semana de cada mes\r\nDocumento Base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\n (MANTENER EL 85% SEMANAL DE RIEGO OPTIMO)	13	9	13	pendiente	alta	0	0	\N	2026-08-28 00:00:07.868693	2026-08-28 00:00:07.868693	\N	13
692	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-28 00:00:07.868694	2026-08-28 00:00:07.868694	\N	18
693	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	13	pendiente	alta	0	0	\N	2026-08-28 00:00:07.868695	2026-08-28 00:00:07.868695	\N	16
694	REGISTRO MENSUAL DE AGUA POSCOSECHA	(LOGRAR REDUCIR 10% DE AGUA POR CADA 1000 TALLOS) \r\nDocumento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES	13	9	15	pendiente	alta	0	0	\N	2026-08-28 00:00:07.868696	2026-08-28 00:00:07.868696	\N	16
696	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-29 00:00:07.86801	2026-08-29 00:00:07.868012	\N	17
697	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-29 00:00:07.868012	2026-08-29 00:00:07.868013	\N	17
702	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-29 00:00:07.868016	2026-08-29 00:00:07.868017	\N	18
703	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-30 00:00:07.867762	2026-08-30 00:00:07.867763	\N	17
704	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-30 00:00:07.867764	2026-08-30 00:00:07.867764	\N	17
707	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-30 00:00:07.867766	2026-08-30 00:00:07.867766	\N	18
709	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-08-31 00:00:07.867568	2026-08-31 00:00:07.867568	\N	17
710	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-08-31 00:00:07.867569	2026-08-31 00:00:07.867569	\N	17
712	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-08-31 00:00:07.86757	2026-08-31 00:00:07.867571	\N	18
713	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-01 00:00:07.872025	2026-09-01 00:00:07.872026	\N	17
685	REGISTRO MENSUAL DE INGRESO Y CONSUMO DE COMBUSTIBLE	SUBIR LOS ARCHIVOS LA 3ERA SEMANA DE CADA MES (ENERO)\r\nDOCUMENTO BASE: 8.5 PROCEDIMIENTO DE ALMACENAMIENTO DE COMBUSTIBLE 	18	9	16	pendiente	media	1	0	2026-10-01 00:00:00	2026-08-27 00:00:07.868139	2026-09-01 19:39:39.632016	\N	41
705	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	completada	alta	1	1	2026-12-31 00:00:00	2026-08-30 00:00:07.867765	2026-09-01 20:26:40.893211	2026-09-01 20:26:40.892721	27
699	INFORME MENSUAL DE INSPECCION DE ESPACIOS DE DESCANSOS	SUBIR EL ARCHIVO LA SEGUNDA SEMANA DE CADA MES 04-06\r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	5	pendiente	alta	6	0	2026-12-31 00:00:00	2026-08-29 00:00:07.868014	2026-09-01 20:28:39.757322	\N	22
714	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-01 00:00:07.872027	2026-09-01 00:00:07.872027	\N	17
507	REGISTRO MENSUAL DE CONSUMO ENERGETICO 	SUBIREL ARCHIVO LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	5	completada	alta	1	1	2026-07-31 00:00:00	2026-06-29 00:00:30.99719	2026-09-01 19:10:29.162326	2026-07-06 15:28:39.923637	19
403	REGISTRO MENSUAL DE CONSUMO ENERGETICO 	SUBIREL ARCHIVO LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	5	completada	alta	1	1	2026-06-30 00:00:00	2026-05-30 00:00:54.310427	2026-09-01 19:11:21.333229	2026-06-04 20:57:42.255585	19
243	REGISTRO MENSUAL DE CONSUMO ENERGETICO 	SUBIREL ARCHIVO LA PRIMERA SEMANA DE CADA MES \r\nDOCUMENTO BASE: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	8	9	5	completada	alta	1	1	2026-05-31 00:00:00	2026-04-30 00:00:02.896119	2026-09-01 19:11:58.642052	2026-05-05 19:42:41.528381	19
396	REGISTRO MENSUAL DE CONSUMO ELECTRICO Y COMBUSTIBLE 	Documento base: 1.3. PLAN DE OBJETIVOS Y METAS SOCIOAMBIENTALES \r\nSubir ambos registro de manera mensual de forma separada, 2 registros mensuales. 	8	9	5	completada	alta	12	2	2026-12-31 00:00:00	2026-05-30 00:00:54.310422	2026-09-01 19:31:33.145228	2026-06-04 20:58:13.967701	12
71	REPORTE TRIMESTRAL DE EVALUACION DE ORDEN Y LIMPIEZA DE LA EMPRESA 	EL REPORTE SE REALIZARA EN LOS SIGUIENTES MESES: JUNIO - SEPTIEMBRE - DICIEMBRE. SUBIR UN DOCUMENTO EN LA ULTIMA SEMANA DE CADA MES. TOTAL 3 DOCUMENTOS PARA CULMINAR LA ACTIVIDAD. \r\nDOCUMENTO BASE: 4.21 PROCEDIMIENTO DE ORDEN Y LIMPIEZA 	17	9	17	pendiente	alta	3	0	2026-12-31 00:00:00	2026-04-03 21:46:12.112842	2026-09-01 19:45:46.528074	\N	\N
718	REGISTRO MENSUAL DE ENTREVISTAS A PERSONAS ACCIDENTADAS	DOCUEMNTO MADRE: PROCEDIMIENTO SST.10 CARPETA NUEMRO 4 CAPITULO 4.27. \r\nSUBIR UN DOCUEMNTO MENSUAL ( ABRIL- DICIEMBRE) SUBIR 9 DOCUMENTOS PARA COMPLETAR LA ACTIVIDAD. 	16	9	18	pendiente	media	9	0	2026-12-31 00:00:00	2026-09-01 19:54:07.476504	2026-09-01 19:54:07.476505	\N	\N
719	REGISTRO DE GESTIÓN SE SALUD OCUPACIONAL PARA CONTRATISTAS	DOCUEMNTO MADRE: PROCEDIMEINTO SST 10. CARPETA 4 CAPÍTULO 4.31.\r\nSUBIR EL RESGISTRO ANUAL DE LOS 7 CONTRATISTAS DE PRIMERA LÍNEA. \r\nSUBIR 7 DOCUMENTOS UNO POR CONTRATISTA.	16	9	18	pendiente	media	7	0	2026-12-31 00:00:00	2026-09-01 19:59:35.736875	2026-09-01 19:59:35.736877	\N	\N
720	RESGITRO REGISTRO DE CONTROL DE LOS ELEMENTOS DE PROTECCIÓN INDIVIDUAL EMPAQUE	SUBIR EL REGISTRO LA 3ERA SEMANA DE CADA MES DOCUMENTO BASE: 4.17 PROCEDIMIENTO PARA LA DOTACION DE LOS EQUIPOS DE PROTECCIÓN PERSONAL	14	9	15	pendiente	alta	9	0	2026-12-31 00:00:00	2026-09-01 20:03:46.640883	2026-09-01 20:03:59.739583	\N	\N
721	REGISTRO DE SIMULACIÓN DE VIAJE DE FLOR 	DOCUEMTO MADRE: PROCEDIEMITNO DE GERENCIA TÉCNICA 03, CARPETA 12 CAPITULO 12.10.\r\nSUBIR UN DOCUEMNTO POR MES TOTAL 9 DOCUEMNTOS ( ABRIL- DICIEMBRE) PARA COMPLETAR LA ACTIVIDAD SUBIR 9 DOCUMENTOS 	14	9	15	pendiente	alta	9	0	2026-12-31 00:00:00	2026-09-01 20:08:12.931093	2026-09-01 20:08:12.931094	\N	\N
717	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\nSUBIR UN DOCUMENTO\r\n\r\n	13	9	13	pendiente	alta	1	0	2026-12-31 00:00:00	2026-09-01 00:00:07.872029	2026-09-01 20:10:32.260867	\N	18
716	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\nSUBIR UN ARCHIVO POR PERIODO PARA COMPLETAR LA ACTIVIDAD.\r\n	13	9	13	pendiente	alta	1	0	2026-12-31 00:00:00	2026-09-01 00:00:07.872029	2026-09-01 20:14:13.232088	\N	18
722	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-02 00:00:08.04645	2026-09-02 00:00:08.046452	\N	17
723	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-02 00:00:08.046453	2026-09-02 00:00:08.046453	\N	17
724	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-02 00:00:08.046454	2026-09-02 00:00:08.046454	\N	27
725	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-02 00:00:08.046455	2026-09-02 00:00:08.046455	\N	18
726	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-02 00:00:08.046455	2026-09-02 00:00:08.046456	\N	18
727	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-03 00:00:07.870403	2026-09-03 00:00:07.870405	\N	17
728	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-03 00:00:07.870405	2026-09-03 00:00:07.870406	\N	17
729	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-03 00:00:07.870406	2026-09-03 00:00:07.870406	\N	27
730	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-03 00:00:07.870407	2026-09-03 00:00:07.870407	\N	18
731	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-03 00:00:07.870408	2026-09-03 00:00:07.870408	\N	18
732	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-04 00:00:07.867867	2026-09-04 00:00:07.867868	\N	17
733	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-04 00:00:07.867869	2026-09-04 00:00:07.867869	\N	17
734	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-04 00:00:07.86787	2026-09-04 00:00:07.86787	\N	27
735	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-04 00:00:07.86787	2026-09-04 00:00:07.867871	\N	18
736	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-04 00:00:07.867871	2026-09-04 00:00:07.867871	\N	18
737	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-05 00:00:07.867841	2026-09-05 00:00:07.867842	\N	17
738	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-05 00:00:07.867843	2026-09-05 00:00:07.867843	\N	17
739	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-05 00:00:07.867844	2026-09-05 00:00:07.867844	\N	27
740	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-05 00:00:07.867844	2026-09-05 00:00:07.867845	\N	18
741	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-05 00:00:07.867845	2026-09-05 00:00:07.867845	\N	18
742	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-06 00:00:07.867919	2026-09-06 00:00:07.86792	\N	17
743	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-06 00:00:07.867921	2026-09-06 00:00:07.867921	\N	17
744	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-06 00:00:07.867921	2026-09-06 00:00:07.867922	\N	27
745	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-06 00:00:07.867922	2026-09-06 00:00:07.867922	\N	18
746	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-06 00:00:07.867923	2026-09-06 00:00:07.867923	\N	18
747	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-07 00:00:07.880702	2026-09-07 00:00:07.880704	\N	17
748	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-07 00:00:07.880705	2026-09-07 00:00:07.880705	\N	17
749	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-07 00:00:07.880706	2026-09-07 00:00:07.880706	\N	27
750	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-07 00:00:07.880706	2026-09-07 00:00:07.880707	\N	18
751	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-07 00:00:07.880707	2026-09-07 00:00:07.880707	\N	18
752	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-08 18:06:15.812065	2026-09-08 18:06:15.812067	\N	17
753	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-08 18:06:15.812069	2026-09-08 18:06:15.81207	\N	17
754	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-08 18:06:15.812071	2026-09-08 18:06:15.812071	\N	27
755	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-08 18:06:15.812071	2026-09-08 18:06:15.812072	\N	18
756	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-08 18:06:15.812072	2026-09-08 18:06:15.812073	\N	18
757	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-08 18:06:15.92355	2026-09-08 18:06:15.923552	\N	17
758	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-08 18:06:15.923566	2026-09-08 18:06:15.923567	\N	17
759	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-08 18:06:15.923568	2026-09-08 18:06:15.923568	\N	27
760	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-08 18:06:15.923569	2026-09-08 18:06:15.923569	\N	18
761	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-08 18:06:15.92357	2026-09-08 18:06:15.92357	\N	18
762	INFORME DE AUDITORIA INTERNA: SOCIOAMBIENTAL DICIEMBRE	DOCUMENTO BASE:  1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES 	6	9	9	pendiente	alta	0	0	\N	2026-09-09 00:00:13.936497	2026-09-09 00:00:13.936499	\N	27
763	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	12	pendiente	alta	0	0	\N	2026-09-09 00:00:13.9365	2026-09-09 00:00:13.9365	\N	17
764	REGISTRO DE ENTREGA ENVASES (RESIDUOS PELIGROSOS) 	SE DEBE SUBIR CADA 3 MESES DESDE LA ULTIMA ENTREGA 	13	9	13	pendiente	alta	0	0	\N	2026-09-09 00:00:13.9365	2026-09-09 00:00:13.936501	\N	17
765	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	12	pendiente	alta	0	0	\N	2026-09-09 00:00:13.936501	2026-09-09 00:00:13.936501	\N	18
766	PLAN DE MONITOREO FLORA Y FAUNA SEMESTRAL	Documento Base: 1.3. PROGRAMA DE OBJETIVOS SOCIOAMBIENTALES \r\nENTREGA: \r\n1ERA: HASTA JUNIO 13 DEL 2026\r\n2DA: HASTA 31 DE DICIEMBRE 2026\r\n	13	9	13	pendiente	alta	0	0	\N	2026-09-09 00:00:13.936502	2026-09-09 00:00:13.936502	\N	18
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, role, is_active, created_at, updated_at) FROM stdin;
1	Admin	david.herrera1@live.com	pbkdf2:sha256:600000$tDA4BVy5D8RWKCiG$91ca3f62fc02cb062982c101aad430332a4af9a3b97408583ea5a730e354f4a1	admin	t	2025-10-30 18:10:41.063298	2026-03-25 21:27:45.96251
9	DGarcia	sales@rosemirovich.com	pbkdf2:sha256:600000$6dZneKaG0NNoZDAS$1ec9d521248101d1e1a834070027201467af8c3bfc0cee887650e7a141a4cde6	admin	t	2026-03-25 21:29:14.049139	2026-03-25 21:29:14.049142
10	Gerencia	gerencia@rosemirovich.com	pbkdf2:sha256:600000$qRDNezY5Nj8DgWAn$2f6337348c9ea86fd4d95e340f99429411afa32c16af9bfd9e4194b75e1f66b0	admin	t	2026-03-25 21:39:06.79363	2026-03-25 21:39:06.793633
12	PMolina	compras@rosemirovich.com	pbkdf2:sha256:600000$xhCFvvChkSokWkLQ$cd28c0723d194db3e0ecc98462d88eccc6d7c9b9f00227d6d31b9a14ac566ae8	edicion	t	2026-03-27 13:57:04.921702	2026-03-27 14:06:46.710546
13	ATapia	jefe.finca@rosemirovich.com	pbkdf2:sha256:600000$J8fvPCOUi7tNsyNn$afb31dcc6ac1e7480b456a6097e8979358f61e568aaf62cc7e6b141e82c47c9d	edicion	t	2026-03-27 14:37:00.595395	2026-03-27 14:37:00.595397
14	KQuinotoa	supervisor-cultivo@rosemirovich.com	pbkdf2:sha256:600000$77xOj2yXMHXmSWfc$c07f7d8be4f8c38fad81de5c84cb211baf54482d4518a7e7bf972ca8ed4aa8e3	edicion	t	2026-03-27 14:42:05.956809	2026-03-27 14:42:05.956811
15	GOlalla	supervisor-postcosecha@rosemirovich.com	pbkdf2:sha256:600000$1nowPSreepfPxsas$c4831c94a513c8fa90c249b043fbb475bea4267a9df53655e6fad9e100d2d5c9	edicion	t	2026-03-27 14:50:47.567726	2026-03-27 14:52:17.537002
16	MOlalla	bodega@rosemirovich.com	pbkdf2:sha256:600000$LeYjj8gJgi5uMAOj$32106012e6ff7500e0d38b4fa6f2e61dccd5891a6df1859fbfccf75eec6e49ad	edicion	t	2026-03-27 14:54:14.682694	2026-03-27 14:54:14.682696
17	ABarreno	jefesso@rosemirovich.com	pbkdf2:sha256:600000$DRaun6srSjZG0i0o$b7afefbfdb98d6c14c624fc852416a20945af7f4719d2bed11771313e26f6a86	edicion	t	2026-03-27 14:58:19.602294	2026-03-27 14:58:19.602296
18	DeptMedico	saludocupacional@rosemirovich.com	pbkdf2:sha256:600000$23wQS56ajr4HE18E$0557e7a213355c84cd8ec2b0d8614fe966fd214ca95a8964515c378a3c591936	edicion	t	2026-03-27 15:02:38.079934	2026-03-27 15:02:38.079936
5	VMora	talentohumano@rosemirovich.com	pbkdf2:sha256:600000$IBiEOIRL3pnoWyeT$8c7f9fed6905b56a9dfb408ad4dc71787ce2b6a8a2bf88ce20b8a3ee398df8a7	edicion	t	2025-10-30 18:25:04.883779	2026-03-27 15:03:27.958234
33	AND	andres.buitron130@gmail.com	pbkdf2:sha256:600000$q457UYGtVF77bBA0$d79a834ea6906aba9b7f6178fb9f6457ba8cec89e936b964db3457871327563a	edicion	t	2026-03-27 20:32:33.193092	2026-03-27 20:33:05.819449
34	CoordinacionRM	coordinacion@rosemirovich.com	pbkdf2:sha256:600000$7gnRc7rXjC4ghswd$f23cb31010c18e38c0f29b3be1bfaebd5d16419bf9705b2a11828b8956f4df07	edicion	t	2026-04-04 00:28:48.475228	2026-04-04 00:28:48.47523
\.


--
-- Name: area_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.area_users_id_seq', 33, true);


--
-- Name: areas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.areas_id_seq', 18, true);


--
-- Name: files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.files_id_seq', 73, true);


--
-- Name: purchase_requisitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_requisitions_id_seq', 1, true);


--
-- Name: scheduled_task_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scheduled_task_users_id_seq', 54, true);


--
-- Name: scheduled_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scheduled_tasks_id_seq', 42, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 766, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 34, true);


--
-- Name: area_users area_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_users
    ADD CONSTRAINT area_users_pkey PRIMARY KEY (id);


--
-- Name: areas areas_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_name_key UNIQUE (name);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: purchase_requisitions purchase_requisitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requisitions
    ADD CONSTRAINT purchase_requisitions_pkey PRIMARY KEY (id);


--
-- Name: scheduled_task_users scheduled_task_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_task_users
    ADD CONSTRAINT scheduled_task_users_pkey PRIMARY KEY (id);


--
-- Name: scheduled_tasks scheduled_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_tasks
    ADD CONSTRAINT scheduled_tasks_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: area_users unique_area_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_users
    ADD CONSTRAINT unique_area_user UNIQUE (area_id, user_id);


--
-- Name: scheduled_task_users uq_scheduled_task_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_task_users
    ADD CONSTRAINT uq_scheduled_task_user UNIQUE (scheduled_task_id, user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: area_users area_users_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_users
    ADD CONSTRAINT area_users_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: area_users area_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area_users
    ADD CONSTRAINT area_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: files files_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: files files_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: purchase_requisitions purchase_requisitions_approver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requisitions
    ADD CONSTRAINT purchase_requisitions_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES public.users(id);


--
-- Name: purchase_requisitions purchase_requisitions_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requisitions
    ADD CONSTRAINT purchase_requisitions_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: purchase_requisitions purchase_requisitions_requester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requisitions
    ADD CONSTRAINT purchase_requisitions_requester_id_fkey FOREIGN KEY (requester_id) REFERENCES public.users(id);


--
-- Name: purchase_requisitions purchase_requisitions_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requisitions
    ADD CONSTRAINT purchase_requisitions_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES public.users(id);


--
-- Name: purchase_requisitions purchase_requisitions_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requisitions
    ADD CONSTRAINT purchase_requisitions_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.users(id);


--
-- Name: scheduled_task_users scheduled_task_users_scheduled_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_task_users
    ADD CONSTRAINT scheduled_task_users_scheduled_task_id_fkey FOREIGN KEY (scheduled_task_id) REFERENCES public.scheduled_tasks(id);


--
-- Name: scheduled_task_users scheduled_task_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_task_users
    ADD CONSTRAINT scheduled_task_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: scheduled_tasks scheduled_tasks_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_tasks
    ADD CONSTRAINT scheduled_tasks_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: scheduled_tasks scheduled_tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_tasks
    ADD CONSTRAINT scheduled_tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: tasks tasks_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: tasks tasks_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: tasks tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict o5kkPzfM77rUxy20uB6XO1qWBAcXEf7W42fE9D092lADompqVVCRuXaQKKnQVkn

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict EQIHGk8WNAwD4yS8WEQTWW3kzDseVIjCdX5K6EVlgQaoOZCPj3CWlYzwVL0hqvr

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict EQIHGk8WNAwD4yS8WEQTWW3kzDseVIjCdX5K6EVlgQaoOZCPj3CWlYzwVL0hqvr

--
-- PostgreSQL database cluster dump complete
--

