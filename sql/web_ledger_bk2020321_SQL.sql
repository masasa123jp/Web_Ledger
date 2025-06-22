--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-03-21 19:36:31

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 44474)
-- Name: web_ledger; Type: SCHEMA; Schema: -; Owner: mydbuser
--

CREATE SCHEMA web_ledger;


ALTER SCHEMA web_ledger OWNER TO mydbuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 44579)
-- Name: audit_logs; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.audit_logs (
    id integer NOT NULL,
    action text NOT NULL,
    details text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE web_ledger.audit_logs OWNER TO mydbuser;

--
-- TOC entry 234 (class 1259 OID 44578)
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.audit_logs_id_seq OWNER TO mydbuser;

--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 234
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.audit_logs_id_seq OWNED BY web_ledger.audit_logs.id;


--
-- TOC entry 227 (class 1259 OID 44514)
-- Name: ledger_column_master; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.ledger_column_master (
    id integer NOT NULL,
    ledger_master_id integer NOT NULL,
    column_name text NOT NULL,
    data_type text NOT NULL,
    max_length integer,
    display_order integer,
    is_filterable boolean DEFAULT false
);


ALTER TABLE web_ledger.ledger_column_master OWNER TO mydbuser;

--
-- TOC entry 226 (class 1259 OID 44513)
-- Name: ledger_column_master_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.ledger_column_master_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.ledger_column_master_id_seq OWNER TO mydbuser;

--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 226
-- Name: ledger_column_master_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.ledger_column_master_id_seq OWNED BY web_ledger.ledger_column_master.id;


--
-- TOC entry 237 (class 1259 OID 44619)
-- Name: ledger_history; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.ledger_history (
    id integer NOT NULL,
    ledger_type_id integer NOT NULL,
    ledger_type text NOT NULL,
    update_row integer NOT NULL,
    updated_by text NOT NULL,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_details text
);


ALTER TABLE web_ledger.ledger_history OWNER TO mydbuser;

--
-- TOC entry 236 (class 1259 OID 44618)
-- Name: ledger_history_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.ledger_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.ledger_history_id_seq OWNER TO mydbuser;

--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 236
-- Name: ledger_history_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.ledger_history_id_seq OWNED BY web_ledger.ledger_history.id;


--
-- TOC entry 225 (class 1259 OID 44503)
-- Name: ledger_master; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.ledger_master (
    id integer NOT NULL,
    ledger_name text NOT NULL
);


ALTER TABLE web_ledger.ledger_master OWNER TO mydbuser;

--
-- TOC entry 224 (class 1259 OID 44502)
-- Name: ledger_master_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.ledger_master_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.ledger_master_id_seq OWNER TO mydbuser;

--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 224
-- Name: ledger_master_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.ledger_master_id_seq OWNED BY web_ledger.ledger_master.id;


--
-- TOC entry 229 (class 1259 OID 44529)
-- Name: ledger_records; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.ledger_records (
    id integer NOT NULL,
    ledger_master_id integer NOT NULL,
    data_id integer NOT NULL,
    column_id integer NOT NULL,
    data text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE web_ledger.ledger_records OWNER TO mydbuser;

--
-- TOC entry 228 (class 1259 OID 44528)
-- Name: ledger_records_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.ledger_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.ledger_records_id_seq OWNER TO mydbuser;

--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 228
-- Name: ledger_records_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.ledger_records_id_seq OWNED BY web_ledger.ledger_records.id;


--
-- TOC entry 231 (class 1259 OID 44549)
-- Name: manuals; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.manuals (
    id integer NOT NULL,
    title text NOT NULL,
    content text,
    updated_by text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE web_ledger.manuals OWNER TO mydbuser;

--
-- TOC entry 230 (class 1259 OID 44548)
-- Name: manuals_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.manuals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.manuals_id_seq OWNER TO mydbuser;

--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 230
-- Name: manuals_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.manuals_id_seq OWNED BY web_ledger.manuals.id;


--
-- TOC entry 221 (class 1259 OID 44476)
-- Name: role_master; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.role_master (
    id integer NOT NULL,
    role_name text NOT NULL
);


ALTER TABLE web_ledger.role_master OWNER TO mydbuser;

--
-- TOC entry 220 (class 1259 OID 44475)
-- Name: role_master_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.role_master_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.role_master_id_seq OWNER TO mydbuser;

--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 220
-- Name: role_master_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.role_master_id_seq OWNED BY web_ledger.role_master.id;


--
-- TOC entry 223 (class 1259 OID 44487)
-- Name: users; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.users (
    id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE web_ledger.users OWNER TO mydbuser;

--
-- TOC entry 222 (class 1259 OID 44486)
-- Name: users_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.users_id_seq OWNER TO mydbuser;

--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.users_id_seq OWNED BY web_ledger.users.id;


--
-- TOC entry 233 (class 1259 OID 44559)
-- Name: version_history; Type: TABLE; Schema: web_ledger; Owner: mydbuser
--

CREATE TABLE web_ledger.version_history (
    id integer NOT NULL,
    version text NOT NULL,
    sprint text NOT NULL,
    update_info text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE web_ledger.version_history OWNER TO mydbuser;

--
-- TOC entry 232 (class 1259 OID 44558)
-- Name: version_history_id_seq; Type: SEQUENCE; Schema: web_ledger; Owner: mydbuser
--

CREATE SEQUENCE web_ledger.version_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE web_ledger.version_history_id_seq OWNER TO mydbuser;

--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 232
-- Name: version_history_id_seq; Type: SEQUENCE OWNED BY; Schema: web_ledger; Owner: mydbuser
--

ALTER SEQUENCE web_ledger.version_history_id_seq OWNED BY web_ledger.version_history.id;


--
-- TOC entry 4795 (class 2604 OID 44582)
-- Name: audit_logs id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.audit_logs ALTER COLUMN id SET DEFAULT nextval('web_ledger.audit_logs_id_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 44517)
-- Name: ledger_column_master id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_column_master ALTER COLUMN id SET DEFAULT nextval('web_ledger.ledger_column_master_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 44622)
-- Name: ledger_history id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_history ALTER COLUMN id SET DEFAULT nextval('web_ledger.ledger_history_id_seq'::regclass);


--
-- TOC entry 4786 (class 2604 OID 44506)
-- Name: ledger_master id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_master ALTER COLUMN id SET DEFAULT nextval('web_ledger.ledger_master_id_seq'::regclass);


--
-- TOC entry 4789 (class 2604 OID 44532)
-- Name: ledger_records id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_records ALTER COLUMN id SET DEFAULT nextval('web_ledger.ledger_records_id_seq'::regclass);


--
-- TOC entry 4791 (class 2604 OID 44552)
-- Name: manuals id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.manuals ALTER COLUMN id SET DEFAULT nextval('web_ledger.manuals_id_seq'::regclass);


--
-- TOC entry 4784 (class 2604 OID 44479)
-- Name: role_master id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.role_master ALTER COLUMN id SET DEFAULT nextval('web_ledger.role_master_id_seq'::regclass);


--
-- TOC entry 4785 (class 2604 OID 44490)
-- Name: users id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.users ALTER COLUMN id SET DEFAULT nextval('web_ledger.users_id_seq'::regclass);


--
-- TOC entry 4793 (class 2604 OID 44562)
-- Name: version_history id; Type: DEFAULT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.version_history ALTER COLUMN id SET DEFAULT nextval('web_ledger.version_history_id_seq'::regclass);


--
-- TOC entry 4987 (class 0 OID 44579)
-- Dependencies: 235
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.audit_logs (id, action, details, "timestamp") FROM stdin;
1	Update Ledger	Ledger ID 1 の 予算額 を 100000 から 200000 に更新	2025-03-06 01:09:59
2	Update Ledger	Ledger ID 2 の 振替部門 を 部門B から 部門C に更新	2025-03-06 01:16:29
3	Update Ledger	Ledger ID 3 の 予算額 を 100000 から 100009 に更新	2025-03-07 14:58:30
4	Update Ledger	Ledger ID 4 の 予算額 を 100000 から 100050 に更新	2025-03-07 21:27:10
5	Update Ledger	Ledger ID 2 の 予算額 を 100000 から 100400 に更新	2025-03-08 14:32:01
6	Update Ledger	Ledger ID 2 の 予算額 を 100400 から 100440 に更新	2025-03-08 14:33:11
7	Update Ledger	Ledger ID 7 の 予算額 を 100000 から 100700 に更新	2025-03-08 23:09:23
8	Update Ledger	Ledger ID 2 の 予算名称 を 予算名B から 予算名A に更新	2025-03-08 23:31:35
9	Update Ledger	Ledger ID 2 の 予算額 を 100440 から 100000 に更新	2025-03-08 23:31:35
10	Update Ledger	Ledger ID 2 の 振替部門 を 部門C から 部門B に更新	2025-03-08 23:31:35
11	Update Ledger	Ledger ID 1 の 予算額 を 200000 から 108000 に更新	2025-03-08 23:37:15
12	Update Ledger	Ledger ID 1 の 予算額 を 108000 から 108800 に更新	2025-03-08 23:42:14
13	Update Ledger	Ledger ID 1 の 予算額 を 108800 から 100000 に更新	2025-03-08 23:59:02
14	Update Ledger	Ledger ID 3 の 稼働開始日 を 2023-01-01 から 2023-01-17 に更新	2025-03-09 14:24:56
15	Update Ledger	Ledger ID 3 の 稼働開始日 を 2023-01-17 から 2023-01-18 に更新	2025-03-09 14:25:32
16	Update Ledger	Ledger ID 10 の 稼働開始日 を 2023-01-01 から 2023-01-24 に更新	2025-03-09 14:35:07
17	Update Ledger	Ledger ID 2 の 7 行目の 発注日 を 2023-10-15 から 2024-01-15 に更新	2025-03-09 16:39:00
18	Update Ledger	Ledger ID 1 の 16 行目の 予算額 を 100000 から 99999999999999 に更新	2025-03-13 02:30:17
19	Update Ledger	Ledger ID 1 の 16 行目の 予算額 を 99999999999999 から 99999899999999 に更新	2025-03-14 00:37:47
20	Update Ledger	Ledger ID 1 の 5 行目の 予算額 を 100000 から 108000 に更新	2025-03-14 00:38:21
\.


--
-- TOC entry 4979 (class 0 OID 44514)
-- Dependencies: 227
-- Data for Name: ledger_column_master; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.ledger_column_master (id, ledger_master_id, column_name, data_type, max_length, display_order, is_filterable) FROM stdin;
1	1	ID	number	200	101	f
2	1	テーマ名	text	200	102	t
3	1	年度	number	200	103	t
4	1	予算種別	text	200	104	t
5	1	予算番号	text	200	105	t
6	1	予算名称	text	200	106	t
7	1	予算額	number	200	107	t
8	1	利用部門	text	200	108	t
9	1	振替部門	text	200	110	t
10	1	dummy1	text	200	151	f
11	1	dummy2	text	200	152	f
12	1	dummy3	text	200	153	f
13	1	dummy4	text	200	154	f
14	1	dummy5	text	200	155	f
15	1	dummy6	text	200	156	f
16	1	dummy7	text	200	157	f
17	1	dummy8	text	200	158	f
18	1	dummy9	text	200	159	f
19	1	dummy10	text	200	160	f
20	1	dummy11	text	200	161	f
21	1	dummy12	text	200	162	f
22	1	dummy13	text	200	163	f
23	1	dummy14	text	200	164	f
24	1	dummy15	text	200	165	f
25	1	dummy16	text	200	166	f
26	1	dummy17	text	200	167	f
27	1	dummy18	text	200	168	f
28	1	dummy19	text	200	169	f
29	1	dummy20	text	200	170	f
30	2	ID	number	200	101	f
31	2	年度	text	200	102	t
32	2	予算種別	number	200	103	t
33	2	予算番号	text	200	104	t
34	2	予算名称	text	200	105	t
35	2	予算額	number	200	106	t
36	2	利用部門	text	200	107	t
37	2	振替部門	text	200	108	t
38	2	発注部門	text	200	109	t
39	2	発注担当者	text	200	110	t
40	2	発注日	date	200	111	t
41	2	検収担当者	text	200	112	t
42	2	検収完了日	date	200	113	t
43	2	dummy1	text	200	151	f
44	2	dummy2	text	200	152	f
45	2	dummy3	text	200	153	f
46	2	dummy4	text	200	154	f
47	2	dummy5	text	200	155	f
48	2	dummy6	text	200	156	f
49	2	dummy7	text	200	157	f
50	2	dummy8	text	200	158	f
51	2	dummy9	text	200	159	f
52	2	dummy10	text	200	160	f
53	2	dummy11	text	200	161	f
54	2	dummy12	text	200	162	f
55	2	dummy13	text	200	163	f
56	2	dummy14	text	200	164	f
57	2	dummy15	text	200	165	f
58	2	dummy16	text	200	166	f
59	2	dummy17	text	200	167	f
60	2	dummy18	text	200	168	f
61	2	dummy19	text	200	169	f
62	2	dummy20	text	200	170	f
63	3	ID	number	200	101	f
64	3	管理部門	text	200	102	t
65	3	システムコード	text	200	103	t
66	3	システム標準名称	text	200	104	t
67	3	システム名	text	200	105	t
68	3	ホスト名	text	200	106	t
69	3	OSバージョン	text	200	107	t
70	3	稼働開始日	date	200	108	t
71	3	最終パッチ適用日	date	200	109	t
72	3	パッチ適用推進状況	text	200	110	t
73	3	稼働終了予定	date	200	111	t
74	3	移管状況	text	200	112	t
75	3	次回パッチ適用予定	date	200	113	t
76	3	次期サーバーリプレイス予定	date	200	114	t
77	3	次期サーバーバージョン	text	200	115	t
78	3	リプレイス推進状況	text	200	116	t
79	3	システム利用ユーザー部門	text	200	117	t
80	3	費用負担部門	text	200	118	t
81	3	予算コード	text	200	119	t
82	3	予算名称	text	200	120	t
83	3	予算額	number	200	121	t
84	3	振替部門	text	200	122	t
85	3	dummy1	text	200	151	f
86	3	dummy2	text	200	152	f
87	3	dummy3	text	200	153	f
88	3	dummy4	text	200	154	f
89	3	dummy5	text	200	155	f
90	3	dummy6	text	200	156	f
91	3	dummy7	text	200	157	f
92	3	dummy8	text	200	158	f
93	3	dummy9	text	200	159	f
94	3	dummy10	text	200	160	f
95	3	dummy11	text	200	161	f
96	3	dummy12	text	200	162	f
97	3	dummy13	text	200	163	f
98	3	dummy14	text	200	164	f
99	3	dummy15	text	200	165	f
100	3	dummy16	text	200	166	f
101	3	dummy17	text	200	167	f
102	3	dummy18	text	200	168	f
103	3	dummy19	text	200	169	f
104	3	dummy20	text	200	170	f
\.


--
-- TOC entry 4989 (class 0 OID 44619)
-- Dependencies: 237
-- Data for Name: ledger_history; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.ledger_history (id, ledger_type_id, ledger_type, update_row, updated_by, update_time, update_details) FROM stdin;
1	1	予算管理台帳	1	admin	2025-03-05 16:09:59	予算額 を 100000 から 200000 に更新
2	1	予算管理台帳	2	admin	2025-03-05 16:16:29	振替部門 を 部門B から 部門C に更新
3	1	予算管理台帳	1	admin	2025-03-07 05:58:30	予算額 を 100000 から 100009 に更新
4	1	予算管理台帳	1	admin	2025-03-07 12:27:10	予算額 を 100000 から 100050 に更新
5	1	予算管理台帳	1	admin	2025-03-08 05:32:01	予算額 を 100000 から 100400 に更新
6	1	予算管理台帳	1	admin	2025-03-08 05:33:11	予算額 を 100400 から 100440 に更新
7	1	予算管理台帳	1	admin	2025-03-08 23:09:23.16745	予算額 を 100000 から 100700 に更新
8	1	予算管理台帳	1	admin	2025-03-08 23:31:35.194095	予算名称 を 予算名B から 予算名A に更新
9	1	予算管理台帳	1	admin	2025-03-08 23:31:35.194095	予算額 を 100440 から 100000 に更新
10	1	予算管理台帳	1	admin	2025-03-08 23:31:35.194095	振替部門 を 部門C から 部門B に更新
11	1	予算管理台帳	1	admin	2025-03-08 23:37:15.477183	予算額 を 200000 から 108000 に更新
12	1	予算管理台帳	1	admin	2025-03-08 23:42:14.528142	予算額 を 108000 から 108800 に更新
13	1	予算管理台帳	1	admin	2025-03-08 23:59:02.698918	予算額 を 108800 から 100000 に更新
14	3	サーバー管理台帳	3	admin	2025-03-09 14:24:56.83402	稼働開始日 を 2023-01-01 から 2023-01-17 に更新
15	3	サーバー管理台帳	3	admin	2025-03-09 14:25:32.765348	稼働開始日 を 2023-01-17 から 2023-01-18 に更新
16	3	サーバー管理台帳	10	admin	2025-03-09 14:35:07.212046	稼働開始日 を 2023-01-01 から 2023-01-24 に更新
17	2	発注管理台帳	7	admin	2025-03-09 16:39:00.23291	発注日 を 2023-10-15 から 2024-01-15 に更新
18	1	予算管理台帳	16	admin	2025-03-13 02:30:17.550529	予算額 を 100000 から 99999999999999 に更新
19	1	予算管理台帳	16	admin	2025-03-14 00:37:47.117738	予算額 を 99999999999999 から 99999899999999 に更新
20	1	予算管理台帳	5	admin	2025-03-14 00:38:21.188586	予算額 を 100000 から 108000 に更新
\.


--
-- TOC entry 4977 (class 0 OID 44503)
-- Dependencies: 225
-- Data for Name: ledger_master; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.ledger_master (id, ledger_name) FROM stdin;
1	予算管理台帳
2	発注管理台帳
3	サーバー管理台帳
\.


--
-- TOC entry 4981 (class 0 OID 44529)
-- Dependencies: 229
-- Data for Name: ledger_records; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.ledger_records (id, ledger_master_id, data_id, column_id, data, created_at) FROM stdin;
1	1	1	1	1	2025-03-05 14:32:48
2	1	1	2	テーマA	2025-03-05 14:32:48
3	1	1	3	2023	2025-03-05 14:32:48
4	1	1	4	種別A	2025-03-05 14:32:48
5	1	1	5	B001	2025-03-05 14:32:48
6	1	1	6	予算名A	2025-03-05 14:32:48
8	1	1	8	部門A	2025-03-05 14:32:48
9	1	1	9	部門B	2025-03-05 14:32:48
10	1	1	10	ダミー1	2025-03-05 14:32:48
11	1	1	11	ダミー2	2025-03-05 14:32:48
12	1	1	12	ダミー3	2025-03-05 14:32:48
13	1	1	13	ダミー4	2025-03-05 14:32:48
14	1	1	14	ダミー5	2025-03-05 14:32:48
15	1	1	15	ダミー6	2025-03-05 14:32:48
16	1	1	16	ダミー7	2025-03-05 14:32:48
17	1	1	17	ダミー8	2025-03-05 14:32:48
18	1	1	18	ダミー9	2025-03-05 14:32:48
19	1	1	19	ダミー10	2025-03-05 14:32:48
20	1	1	20	ダミー11	2025-03-05 14:32:48
21	1	1	21	ダミー12	2025-03-05 14:32:48
22	1	1	22	ダミー13	2025-03-05 14:32:48
23	1	1	23	ダミー14	2025-03-05 14:32:48
24	1	1	24	ダミー15	2025-03-05 14:32:48
25	1	1	25	ダミー16	2025-03-05 14:32:48
26	1	1	26	ダミー17	2025-03-05 14:32:48
27	1	1	27	ダミー18	2025-03-05 14:32:48
28	1	1	28	ダミー19	2025-03-05 14:32:48
29	1	1	29	ダミー20	2025-03-05 14:32:48
30	1	2	1	2	2025-03-05 14:32:48
31	1	2	2	テーマA	2025-03-05 14:32:48
32	1	2	3	2023	2025-03-05 14:32:48
33	1	2	4	種別A	2025-03-05 14:32:48
34	1	2	5	B001	2025-03-05 14:32:48
37	1	2	8	部門A	2025-03-05 14:32:48
39	1	2	10	ダミー1	2025-03-05 14:32:48
40	1	2	11	ダミー2	2025-03-05 14:32:48
41	1	2	12	ダミー3	2025-03-05 14:32:48
42	1	2	13	ダミー4	2025-03-05 14:32:48
43	1	2	14	ダミー5	2025-03-05 14:32:48
44	1	2	15	ダミー6	2025-03-05 14:32:48
45	1	2	16	ダミー7	2025-03-05 14:32:48
46	1	2	17	ダミー8	2025-03-05 14:32:48
47	1	2	18	ダミー9	2025-03-05 14:32:48
48	1	2	19	ダミー10	2025-03-05 14:32:48
49	1	2	20	ダミー11	2025-03-05 14:32:48
50	1	2	21	ダミー12	2025-03-05 14:32:48
51	1	2	22	ダミー13	2025-03-05 14:32:48
52	1	2	23	ダミー14	2025-03-05 14:32:48
53	1	2	24	ダミー15	2025-03-05 14:32:48
54	1	2	25	ダミー16	2025-03-05 14:32:48
55	1	2	26	ダミー17	2025-03-05 14:32:48
56	1	2	27	ダミー18	2025-03-05 14:32:48
57	1	2	28	ダミー19	2025-03-05 14:32:48
58	1	2	29	ダミー20	2025-03-05 14:32:48
59	1	3	1	3	2025-03-05 14:32:48
60	1	3	2	テーマA	2025-03-05 14:32:48
61	1	3	3	2023	2025-03-05 14:32:48
62	1	3	4	種別A	2025-03-05 14:32:48
63	1	3	5	B001	2025-03-05 14:32:48
64	1	3	6	予算名C	2025-03-05 14:32:48
65	1	3	7	100009	2025-03-05 14:32:48
66	1	3	8	部門A	2025-03-05 14:32:48
67	1	3	9	部門B	2025-03-05 14:32:48
68	1	3	10	ダミー1	2025-03-05 14:32:48
69	1	3	11	ダミー2	2025-03-05 14:32:48
70	1	3	12	ダミー3	2025-03-05 14:32:48
71	1	3	13	ダミー4	2025-03-05 14:32:48
72	1	3	14	ダミー5	2025-03-05 14:32:48
73	1	3	15	ダミー6	2025-03-05 14:32:48
74	1	3	16	ダミー7	2025-03-05 14:32:48
75	1	3	17	ダミー8	2025-03-05 14:32:48
76	1	3	18	ダミー9	2025-03-05 14:32:48
77	1	3	19	ダミー10	2025-03-05 14:32:48
78	1	3	20	ダミー11	2025-03-05 14:32:48
79	1	3	21	ダミー12	2025-03-05 14:32:48
80	1	3	22	ダミー13	2025-03-05 14:32:48
81	1	3	23	ダミー14	2025-03-05 14:32:48
82	1	3	24	ダミー15	2025-03-05 14:32:48
83	1	3	25	ダミー16	2025-03-05 14:32:48
84	1	3	26	ダミー17	2025-03-05 14:32:48
85	1	3	27	ダミー18	2025-03-05 14:32:48
86	1	3	28	ダミー19	2025-03-05 14:32:48
87	1	3	29	ダミー20	2025-03-05 14:32:48
88	1	4	1	4	2025-03-05 14:32:48
89	1	4	2	テーマA	2025-03-05 14:32:48
90	1	4	3	2023	2025-03-05 14:32:48
91	1	4	4	種別A	2025-03-05 14:32:48
92	1	4	5	B001	2025-03-05 14:32:48
93	1	4	6	予算名D	2025-03-05 14:32:48
94	1	4	7	100050	2025-03-05 14:32:48
95	1	4	8	部門A	2025-03-05 14:32:48
96	1	4	9	部門B	2025-03-05 14:32:48
97	1	4	10	ダミー1	2025-03-05 14:32:48
98	1	4	11	ダミー2	2025-03-05 14:32:48
99	1	4	12	ダミー3	2025-03-05 14:32:48
100	1	4	13	ダミー4	2025-03-05 14:32:48
101	1	4	14	ダミー5	2025-03-05 14:32:48
102	1	4	15	ダミー6	2025-03-05 14:32:48
103	1	4	16	ダミー7	2025-03-05 14:32:48
104	1	4	17	ダミー8	2025-03-05 14:32:48
105	1	4	18	ダミー9	2025-03-05 14:32:48
106	1	4	19	ダミー10	2025-03-05 14:32:48
107	1	4	20	ダミー11	2025-03-05 14:32:48
108	1	4	21	ダミー12	2025-03-05 14:32:48
109	1	4	22	ダミー13	2025-03-05 14:32:48
110	1	4	23	ダミー14	2025-03-05 14:32:48
111	1	4	24	ダミー15	2025-03-05 14:32:48
112	1	4	25	ダミー16	2025-03-05 14:32:48
113	1	4	26	ダミー17	2025-03-05 14:32:48
114	1	4	27	ダミー18	2025-03-05 14:32:48
115	1	4	28	ダミー19	2025-03-05 14:32:48
116	1	4	29	ダミー20	2025-03-05 14:32:48
117	1	5	1	5	2025-03-05 14:32:48
118	1	5	2	テーマB	2025-03-05 14:32:48
119	1	5	3	2023	2025-03-05 14:32:48
120	1	5	4	種別B	2025-03-05 14:32:48
121	1	5	5	B002	2025-03-05 14:32:48
122	1	5	6	予算名A	2025-03-05 14:32:48
124	1	5	8	部門A	2025-03-05 14:32:48
7	1	1	7	100000	2025-03-05 14:32:48
123	1	5	7	108000	2025-03-05 14:32:48
125	1	5	9	部門B	2025-03-05 14:32:48
126	1	5	10	ダミー1	2025-03-05 14:32:48
127	1	5	11	ダミー2	2025-03-05 14:32:48
128	1	5	12	ダミー3	2025-03-05 14:32:48
129	1	5	13	ダミー4	2025-03-05 14:32:48
130	1	5	14	ダミー5	2025-03-05 14:32:48
131	1	5	15	ダミー6	2025-03-05 14:32:48
132	1	5	16	ダミー7	2025-03-05 14:32:48
133	1	5	17	ダミー8	2025-03-05 14:32:48
134	1	5	18	ダミー9	2025-03-05 14:32:48
135	1	5	19	ダミー10	2025-03-05 14:32:48
136	1	5	20	ダミー11	2025-03-05 14:32:48
137	1	5	21	ダミー12	2025-03-05 14:32:48
138	1	5	22	ダミー13	2025-03-05 14:32:48
139	1	5	23	ダミー14	2025-03-05 14:32:48
140	1	5	24	ダミー15	2025-03-05 14:32:48
141	1	5	25	ダミー16	2025-03-05 14:32:48
142	1	5	26	ダミー17	2025-03-05 14:32:48
143	1	5	27	ダミー18	2025-03-05 14:32:48
144	1	5	28	ダミー19	2025-03-05 14:32:48
145	1	5	29	ダミー20	2025-03-05 14:32:48
146	1	6	1	6	2025-03-05 14:32:48
147	1	6	2	テーマB	2025-03-05 14:32:48
148	1	6	3	2023	2025-03-05 14:32:48
149	1	6	4	種別B	2025-03-05 14:32:48
150	1	6	5	B002	2025-03-05 14:32:48
151	1	6	6	予算名B	2025-03-05 14:32:48
152	1	6	7	100000	2025-03-05 14:32:48
153	1	6	8	部門A	2025-03-05 14:32:48
154	1	6	9	部門B	2025-03-05 14:32:48
155	1	6	10	ダミー1	2025-03-05 14:32:48
156	1	6	11	ダミー2	2025-03-05 14:32:48
157	1	6	12	ダミー3	2025-03-05 14:32:48
158	1	6	13	ダミー4	2025-03-05 14:32:48
159	1	6	14	ダミー5	2025-03-05 14:32:48
160	1	6	15	ダミー6	2025-03-05 14:32:48
161	1	6	16	ダミー7	2025-03-05 14:32:48
162	1	6	17	ダミー8	2025-03-05 14:32:48
163	1	6	18	ダミー9	2025-03-05 14:32:48
164	1	6	19	ダミー10	2025-03-05 14:32:48
165	1	6	20	ダミー11	2025-03-05 14:32:48
166	1	6	21	ダミー12	2025-03-05 14:32:48
167	1	6	22	ダミー13	2025-03-05 14:32:48
168	1	6	23	ダミー14	2025-03-05 14:32:48
169	1	6	24	ダミー15	2025-03-05 14:32:48
170	1	6	25	ダミー16	2025-03-05 14:32:48
171	1	6	26	ダミー17	2025-03-05 14:32:48
172	1	6	27	ダミー18	2025-03-05 14:32:48
173	1	6	28	ダミー19	2025-03-05 14:32:48
174	1	6	29	ダミー20	2025-03-05 14:32:48
175	1	7	1	7	2025-03-05 14:32:48
176	1	7	2	テーマB	2025-03-05 14:32:48
177	1	7	3	2023	2025-03-05 14:32:48
178	1	7	4	種別B	2025-03-05 14:32:48
179	1	7	5	B002	2025-03-05 14:32:48
180	1	7	6	予算名C	2025-03-05 14:32:48
182	1	7	8	部門A	2025-03-05 14:32:48
183	1	7	9	部門B	2025-03-05 14:32:48
184	1	7	10	ダミー1	2025-03-05 14:32:48
185	1	7	11	ダミー2	2025-03-05 14:32:48
186	1	7	12	ダミー3	2025-03-05 14:32:48
187	1	7	13	ダミー4	2025-03-05 14:32:48
188	1	7	14	ダミー5	2025-03-05 14:32:48
189	1	7	15	ダミー6	2025-03-05 14:32:48
190	1	7	16	ダミー7	2025-03-05 14:32:48
191	1	7	17	ダミー8	2025-03-05 14:32:48
192	1	7	18	ダミー9	2025-03-05 14:32:48
193	1	7	19	ダミー10	2025-03-05 14:32:48
194	1	7	20	ダミー11	2025-03-05 14:32:48
195	1	7	21	ダミー12	2025-03-05 14:32:48
196	1	7	22	ダミー13	2025-03-05 14:32:48
197	1	7	23	ダミー14	2025-03-05 14:32:48
198	1	7	24	ダミー15	2025-03-05 14:32:48
199	1	7	25	ダミー16	2025-03-05 14:32:48
200	1	7	26	ダミー17	2025-03-05 14:32:48
201	1	7	27	ダミー18	2025-03-05 14:32:48
202	1	7	28	ダミー19	2025-03-05 14:32:48
203	1	7	29	ダミー20	2025-03-05 14:32:48
204	1	8	1	8	2025-03-05 14:32:48
205	1	8	2	テーマB	2025-03-05 14:32:48
206	1	8	3	2023	2025-03-05 14:32:48
207	1	8	4	種別B	2025-03-05 14:32:48
208	1	8	5	B002	2025-03-05 14:32:48
209	1	8	6	予算名D	2025-03-05 14:32:48
210	1	8	7	100000	2025-03-05 14:32:48
211	1	8	8	部門A	2025-03-05 14:32:48
212	1	8	9	部門B	2025-03-05 14:32:48
213	1	8	10	ダミー1	2025-03-05 14:32:48
214	1	8	11	ダミー2	2025-03-05 14:32:48
215	1	8	12	ダミー3	2025-03-05 14:32:48
216	1	8	13	ダミー4	2025-03-05 14:32:48
217	1	8	14	ダミー5	2025-03-05 14:32:48
218	1	8	15	ダミー6	2025-03-05 14:32:48
219	1	8	16	ダミー7	2025-03-05 14:32:48
220	1	8	17	ダミー8	2025-03-05 14:32:48
221	1	8	18	ダミー9	2025-03-05 14:32:48
222	1	8	19	ダミー10	2025-03-05 14:32:48
223	1	8	20	ダミー11	2025-03-05 14:32:48
224	1	8	21	ダミー12	2025-03-05 14:32:48
225	1	8	22	ダミー13	2025-03-05 14:32:48
226	1	8	23	ダミー14	2025-03-05 14:32:48
227	1	8	24	ダミー15	2025-03-05 14:32:48
228	1	8	25	ダミー16	2025-03-05 14:32:48
229	1	8	26	ダミー17	2025-03-05 14:32:48
230	1	8	27	ダミー18	2025-03-05 14:32:48
231	1	8	28	ダミー19	2025-03-05 14:32:48
232	1	8	29	ダミー20	2025-03-05 14:32:48
233	1	9	1	9	2025-03-05 14:32:48
234	1	9	2	テーマC	2025-03-05 14:32:48
235	1	9	3	2024	2025-03-05 14:32:48
236	1	9	4	種別A	2025-03-05 14:32:48
237	1	9	5	B003	2025-03-05 14:32:48
238	1	9	6	予算名A	2025-03-05 14:32:48
239	1	9	7	100000	2025-03-05 14:32:48
240	1	9	8	部門A	2025-03-05 14:32:48
241	1	9	9	部門B	2025-03-05 14:32:48
242	1	9	10	ダミー1	2025-03-05 14:32:48
243	1	9	11	ダミー2	2025-03-05 14:32:48
244	1	9	12	ダミー3	2025-03-05 14:32:48
245	1	9	13	ダミー4	2025-03-05 14:32:48
246	1	9	14	ダミー5	2025-03-05 14:32:48
247	1	9	15	ダミー6	2025-03-05 14:32:48
248	1	9	16	ダミー7	2025-03-05 14:32:48
249	1	9	17	ダミー8	2025-03-05 14:32:48
250	1	9	18	ダミー9	2025-03-05 14:32:48
251	1	9	19	ダミー10	2025-03-05 14:32:48
252	1	9	20	ダミー11	2025-03-05 14:32:48
253	1	9	21	ダミー12	2025-03-05 14:32:48
254	1	9	22	ダミー13	2025-03-05 14:32:48
255	1	9	23	ダミー14	2025-03-05 14:32:48
256	1	9	24	ダミー15	2025-03-05 14:32:48
257	1	9	25	ダミー16	2025-03-05 14:32:48
258	1	9	26	ダミー17	2025-03-05 14:32:48
259	1	9	27	ダミー18	2025-03-05 14:32:48
260	1	9	28	ダミー19	2025-03-05 14:32:48
261	1	9	29	ダミー20	2025-03-05 14:32:48
262	1	10	1	10	2025-03-05 14:32:48
263	1	10	2	テーマC	2025-03-05 14:32:48
264	1	10	3	2024	2025-03-05 14:32:48
265	1	10	4	種別A	2025-03-05 14:32:48
266	1	10	5	B003	2025-03-05 14:32:48
267	1	10	6	予算名B	2025-03-05 14:32:48
268	1	10	7	100000	2025-03-05 14:32:48
269	1	10	8	部門A	2025-03-05 14:32:48
270	1	10	9	部門B	2025-03-05 14:32:48
271	1	10	10	ダミー1	2025-03-05 14:32:48
272	1	10	11	ダミー2	2025-03-05 14:32:48
273	1	10	12	ダミー3	2025-03-05 14:32:48
274	1	10	13	ダミー4	2025-03-05 14:32:48
275	1	10	14	ダミー5	2025-03-05 14:32:48
276	1	10	15	ダミー6	2025-03-05 14:32:48
277	1	10	16	ダミー7	2025-03-05 14:32:48
278	1	10	17	ダミー8	2025-03-05 14:32:48
279	1	10	18	ダミー9	2025-03-05 14:32:48
280	1	10	19	ダミー10	2025-03-05 14:32:48
281	1	10	20	ダミー11	2025-03-05 14:32:48
282	1	10	21	ダミー12	2025-03-05 14:32:48
283	1	10	22	ダミー13	2025-03-05 14:32:48
284	1	10	23	ダミー14	2025-03-05 14:32:48
285	1	10	24	ダミー15	2025-03-05 14:32:48
286	1	10	25	ダミー16	2025-03-05 14:32:48
287	1	10	26	ダミー17	2025-03-05 14:32:48
288	1	10	27	ダミー18	2025-03-05 14:32:48
289	1	10	28	ダミー19	2025-03-05 14:32:48
290	1	10	29	ダミー20	2025-03-05 14:32:48
291	1	11	1	11	2025-03-05 14:32:48
292	1	11	2	テーマC	2025-03-05 14:32:48
293	1	11	3	2024	2025-03-05 14:32:48
294	1	11	4	種別A	2025-03-05 14:32:48
295	1	11	5	B003	2025-03-05 14:32:48
296	1	11	6	予算名C	2025-03-05 14:32:48
297	1	11	7	100000	2025-03-05 14:32:48
298	1	11	8	部門A	2025-03-05 14:32:48
299	1	11	9	部門B	2025-03-05 14:32:48
300	1	11	10	ダミー1	2025-03-05 14:32:48
301	1	11	11	ダミー2	2025-03-05 14:32:48
302	1	11	12	ダミー3	2025-03-05 14:32:48
303	1	11	13	ダミー4	2025-03-05 14:32:48
304	1	11	14	ダミー5	2025-03-05 14:32:48
305	1	11	15	ダミー6	2025-03-05 14:32:48
306	1	11	16	ダミー7	2025-03-05 14:32:48
307	1	11	17	ダミー8	2025-03-05 14:32:48
308	1	11	18	ダミー9	2025-03-05 14:32:48
309	1	11	19	ダミー10	2025-03-05 14:32:48
310	1	11	20	ダミー11	2025-03-05 14:32:48
311	1	11	21	ダミー12	2025-03-05 14:32:48
312	1	11	22	ダミー13	2025-03-05 14:32:48
313	1	11	23	ダミー14	2025-03-05 14:32:48
314	1	11	24	ダミー15	2025-03-05 14:32:48
315	1	11	25	ダミー16	2025-03-05 14:32:48
316	1	11	26	ダミー17	2025-03-05 14:32:48
317	1	11	27	ダミー18	2025-03-05 14:32:48
318	1	11	28	ダミー19	2025-03-05 14:32:48
319	1	11	29	ダミー20	2025-03-05 14:32:48
320	1	12	1	12	2025-03-05 14:32:48
321	1	12	2	テーマC	2025-03-05 14:32:48
322	1	12	3	2024	2025-03-05 14:32:48
323	1	12	4	種別A	2025-03-05 14:32:48
324	1	12	5	B003	2025-03-05 14:32:48
325	1	12	6	予算名D	2025-03-05 14:32:48
326	1	12	7	100000	2025-03-05 14:32:48
327	1	12	8	部門A	2025-03-05 14:32:48
328	1	12	9	部門B	2025-03-05 14:32:48
329	1	12	10	ダミー1	2025-03-05 14:32:48
330	1	12	11	ダミー2	2025-03-05 14:32:48
331	1	12	12	ダミー3	2025-03-05 14:32:48
332	1	12	13	ダミー4	2025-03-05 14:32:48
333	1	12	14	ダミー5	2025-03-05 14:32:48
334	1	12	15	ダミー6	2025-03-05 14:32:48
335	1	12	16	ダミー7	2025-03-05 14:32:48
336	1	12	17	ダミー8	2025-03-05 14:32:48
337	1	12	18	ダミー9	2025-03-05 14:32:48
338	1	12	19	ダミー10	2025-03-05 14:32:48
339	1	12	20	ダミー11	2025-03-05 14:32:48
340	1	12	21	ダミー12	2025-03-05 14:32:48
341	1	12	22	ダミー13	2025-03-05 14:32:48
342	1	12	23	ダミー14	2025-03-05 14:32:48
343	1	12	24	ダミー15	2025-03-05 14:32:48
344	1	12	25	ダミー16	2025-03-05 14:32:48
345	1	12	26	ダミー17	2025-03-05 14:32:48
346	1	12	27	ダミー18	2025-03-05 14:32:48
347	1	12	28	ダミー19	2025-03-05 14:32:48
348	1	12	29	ダミー20	2025-03-05 14:32:48
349	1	13	1	13	2025-03-05 14:32:48
350	1	13	2	テーマD	2025-03-05 14:32:48
351	1	13	3	2024	2025-03-05 14:32:48
352	1	13	4	種別B	2025-03-05 14:32:48
353	1	13	5	B004	2025-03-05 14:32:48
354	1	13	6	予算名A	2025-03-05 14:32:48
355	1	13	7	100000	2025-03-05 14:32:48
356	1	13	8	部門A	2025-03-05 14:32:48
357	1	13	9	部門B	2025-03-05 14:32:48
358	1	13	10	ダミー1	2025-03-05 14:32:48
359	1	13	11	ダミー2	2025-03-05 14:32:48
360	1	13	12	ダミー3	2025-03-05 14:32:48
361	1	13	13	ダミー4	2025-03-05 14:32:48
362	1	13	14	ダミー5	2025-03-05 14:32:48
363	1	13	15	ダミー6	2025-03-05 14:32:48
364	1	13	16	ダミー7	2025-03-05 14:32:48
365	1	13	17	ダミー8	2025-03-05 14:32:48
366	1	13	18	ダミー9	2025-03-05 14:32:48
367	1	13	19	ダミー10	2025-03-05 14:32:48
368	1	13	20	ダミー11	2025-03-05 14:32:48
369	1	13	21	ダミー12	2025-03-05 14:32:48
370	1	13	22	ダミー13	2025-03-05 14:32:48
371	1	13	23	ダミー14	2025-03-05 14:32:48
372	1	13	24	ダミー15	2025-03-05 14:32:48
373	1	13	25	ダミー16	2025-03-05 14:32:48
374	1	13	26	ダミー17	2025-03-05 14:32:48
375	1	13	27	ダミー18	2025-03-05 14:32:48
376	1	13	28	ダミー19	2025-03-05 14:32:48
377	1	13	29	ダミー20	2025-03-05 14:32:48
378	1	14	1	14	2025-03-05 14:32:48
379	1	14	2	テーマD	2025-03-05 14:32:48
380	1	14	3	2024	2025-03-05 14:32:48
381	1	14	4	種別B	2025-03-05 14:32:48
382	1	14	5	B004	2025-03-05 14:32:48
383	1	14	6	予算名B	2025-03-05 14:32:48
384	1	14	7	100000	2025-03-05 14:32:48
385	1	14	8	部門A	2025-03-05 14:32:48
386	1	14	9	部門B	2025-03-05 14:32:48
387	1	14	10	ダミー1	2025-03-05 14:32:48
388	1	14	11	ダミー2	2025-03-05 14:32:48
389	1	14	12	ダミー3	2025-03-05 14:32:48
390	1	14	13	ダミー4	2025-03-05 14:32:48
391	1	14	14	ダミー5	2025-03-05 14:32:48
392	1	14	15	ダミー6	2025-03-05 14:32:48
393	1	14	16	ダミー7	2025-03-05 14:32:48
394	1	14	17	ダミー8	2025-03-05 14:32:48
395	1	14	18	ダミー9	2025-03-05 14:32:48
396	1	14	19	ダミー10	2025-03-05 14:32:48
397	1	14	20	ダミー11	2025-03-05 14:32:48
398	1	14	21	ダミー12	2025-03-05 14:32:48
399	1	14	22	ダミー13	2025-03-05 14:32:48
400	1	14	23	ダミー14	2025-03-05 14:32:48
401	1	14	24	ダミー15	2025-03-05 14:32:48
402	1	14	25	ダミー16	2025-03-05 14:32:48
403	1	14	26	ダミー17	2025-03-05 14:32:48
404	1	14	27	ダミー18	2025-03-05 14:32:48
405	1	14	28	ダミー19	2025-03-05 14:32:48
406	1	14	29	ダミー20	2025-03-05 14:32:48
407	1	15	1	15	2025-03-05 14:32:48
408	1	15	2	テーマD	2025-03-05 14:32:48
409	1	15	3	2024	2025-03-05 14:32:48
410	1	15	4	種別B	2025-03-05 14:32:48
411	1	15	5	B004	2025-03-05 14:32:48
412	1	15	6	予算名C	2025-03-05 14:32:48
413	1	15	7	100000	2025-03-05 14:32:48
414	1	15	8	部門A	2025-03-05 14:32:48
415	1	15	9	部門B	2025-03-05 14:32:48
416	1	15	10	ダミー1	2025-03-05 14:32:48
417	1	15	11	ダミー2	2025-03-05 14:32:48
418	1	15	12	ダミー3	2025-03-05 14:32:48
419	1	15	13	ダミー4	2025-03-05 14:32:48
420	1	15	14	ダミー5	2025-03-05 14:32:48
421	1	15	15	ダミー6	2025-03-05 14:32:48
422	1	15	16	ダミー7	2025-03-05 14:32:48
423	1	15	17	ダミー8	2025-03-05 14:32:48
424	1	15	18	ダミー9	2025-03-05 14:32:48
425	1	15	19	ダミー10	2025-03-05 14:32:48
426	1	15	20	ダミー11	2025-03-05 14:32:48
427	1	15	21	ダミー12	2025-03-05 14:32:48
428	1	15	22	ダミー13	2025-03-05 14:32:48
429	1	15	23	ダミー14	2025-03-05 14:32:48
430	1	15	24	ダミー15	2025-03-05 14:32:48
431	1	15	25	ダミー16	2025-03-05 14:32:48
432	1	15	26	ダミー17	2025-03-05 14:32:48
433	1	15	27	ダミー18	2025-03-05 14:32:48
434	1	15	28	ダミー19	2025-03-05 14:32:48
435	1	15	29	ダミー20	2025-03-05 14:32:48
436	1	16	1	16	2025-03-05 14:32:48
437	1	16	2	テーマD	2025-03-05 14:32:48
438	1	16	3	2024	2025-03-05 14:32:48
439	1	16	4	種別B	2025-03-05 14:32:48
440	1	16	5	B004	2025-03-05 14:32:48
441	1	16	6	予算名D	2025-03-05 14:32:48
443	1	16	8	部門A	2025-03-05 14:32:48
444	1	16	9	部門B	2025-03-05 14:32:48
445	1	16	10	ダミー1	2025-03-05 14:32:48
446	1	16	11	ダミー2	2025-03-05 14:32:48
447	1	16	12	ダミー3	2025-03-05 14:32:48
448	1	16	13	ダミー4	2025-03-05 14:32:48
449	1	16	14	ダミー5	2025-03-05 14:32:48
450	1	16	15	ダミー6	2025-03-05 14:32:48
451	1	16	16	ダミー7	2025-03-05 14:32:48
452	1	16	17	ダミー8	2025-03-05 14:32:48
453	1	16	18	ダミー9	2025-03-05 14:32:48
454	1	16	19	ダミー10	2025-03-05 14:32:48
455	1	16	20	ダミー11	2025-03-05 14:32:48
456	1	16	21	ダミー12	2025-03-05 14:32:48
457	1	16	22	ダミー13	2025-03-05 14:32:48
458	1	16	23	ダミー14	2025-03-05 14:32:48
459	1	16	24	ダミー15	2025-03-05 14:32:48
460	1	16	25	ダミー16	2025-03-05 14:32:48
461	1	16	26	ダミー17	2025-03-05 14:32:48
462	1	16	27	ダミー18	2025-03-05 14:32:48
463	1	16	28	ダミー19	2025-03-05 14:32:48
464	1	16	29	ダミー20	2025-03-05 14:32:48
465	1	17	1	17	2025-03-05 14:32:48
466	1	17	2	テーマE	2025-03-05 14:32:48
467	1	17	3	2025	2025-03-05 14:32:48
468	1	17	4	種別A	2025-03-05 14:32:48
469	1	17	5	B005	2025-03-05 14:32:48
470	1	17	6	予算名A	2025-03-05 14:32:48
471	1	17	7	100000	2025-03-05 14:32:48
472	1	17	8	部門A	2025-03-05 14:32:48
473	1	17	9	部門B	2025-03-05 14:32:48
474	1	17	10	ダミー1	2025-03-05 14:32:48
475	1	17	11	ダミー2	2025-03-05 14:32:48
476	1	17	12	ダミー3	2025-03-05 14:32:48
477	1	17	13	ダミー4	2025-03-05 14:32:48
478	1	17	14	ダミー5	2025-03-05 14:32:48
479	1	17	15	ダミー6	2025-03-05 14:32:48
480	1	17	16	ダミー7	2025-03-05 14:32:48
481	1	17	17	ダミー8	2025-03-05 14:32:48
482	1	17	18	ダミー9	2025-03-05 14:32:48
483	1	17	19	ダミー10	2025-03-05 14:32:48
484	1	17	20	ダミー11	2025-03-05 14:32:48
485	1	17	21	ダミー12	2025-03-05 14:32:48
486	1	17	22	ダミー13	2025-03-05 14:32:48
487	1	17	23	ダミー14	2025-03-05 14:32:48
488	1	17	24	ダミー15	2025-03-05 14:32:48
489	1	17	25	ダミー16	2025-03-05 14:32:48
490	1	17	26	ダミー17	2025-03-05 14:32:48
491	1	17	27	ダミー18	2025-03-05 14:32:48
492	1	17	28	ダミー19	2025-03-05 14:32:48
493	1	17	29	ダミー20	2025-03-05 14:32:48
494	1	18	1	18	2025-03-05 14:32:48
495	1	18	2	テーマE	2025-03-05 14:32:48
496	1	18	3	2025	2025-03-05 14:32:48
497	1	18	4	種別A	2025-03-05 14:32:48
498	1	18	5	B005	2025-03-05 14:32:48
499	1	18	6	予算名B	2025-03-05 14:32:48
500	1	18	7	100000	2025-03-05 14:32:48
501	1	18	8	部門A	2025-03-05 14:32:48
502	1	18	9	部門B	2025-03-05 14:32:48
503	1	18	10	ダミー1	2025-03-05 14:32:48
504	1	18	11	ダミー2	2025-03-05 14:32:48
505	1	18	12	ダミー3	2025-03-05 14:32:48
506	1	18	13	ダミー4	2025-03-05 14:32:48
507	1	18	14	ダミー5	2025-03-05 14:32:48
508	1	18	15	ダミー6	2025-03-05 14:32:48
509	1	18	16	ダミー7	2025-03-05 14:32:48
510	1	18	17	ダミー8	2025-03-05 14:32:48
511	1	18	18	ダミー9	2025-03-05 14:32:48
512	1	18	19	ダミー10	2025-03-05 14:32:48
513	1	18	20	ダミー11	2025-03-05 14:32:48
514	1	18	21	ダミー12	2025-03-05 14:32:48
515	1	18	22	ダミー13	2025-03-05 14:32:48
516	1	18	23	ダミー14	2025-03-05 14:32:48
517	1	18	24	ダミー15	2025-03-05 14:32:48
518	1	18	25	ダミー16	2025-03-05 14:32:48
519	1	18	26	ダミー17	2025-03-05 14:32:48
520	1	18	27	ダミー18	2025-03-05 14:32:48
521	1	18	28	ダミー19	2025-03-05 14:32:48
522	1	18	29	ダミー20	2025-03-05 14:32:48
523	1	19	1	19	2025-03-05 14:32:48
524	1	19	2	テーマE	2025-03-05 14:32:48
525	1	19	3	2025	2025-03-05 14:32:48
526	1	19	4	種別A	2025-03-05 14:32:48
527	1	19	5	B005	2025-03-05 14:32:48
528	1	19	6	予算名C	2025-03-05 14:32:48
529	1	19	7	100000	2025-03-05 14:32:48
530	1	19	8	部門A	2025-03-05 14:32:48
531	1	19	9	部門B	2025-03-05 14:32:48
532	1	19	10	ダミー1	2025-03-05 14:32:48
533	1	19	11	ダミー2	2025-03-05 14:32:48
534	1	19	12	ダミー3	2025-03-05 14:32:48
535	1	19	13	ダミー4	2025-03-05 14:32:48
536	1	19	14	ダミー5	2025-03-05 14:32:48
537	1	19	15	ダミー6	2025-03-05 14:32:48
538	1	19	16	ダミー7	2025-03-05 14:32:48
539	1	19	17	ダミー8	2025-03-05 14:32:48
540	1	19	18	ダミー9	2025-03-05 14:32:48
541	1	19	19	ダミー10	2025-03-05 14:32:48
542	1	19	20	ダミー11	2025-03-05 14:32:48
543	1	19	21	ダミー12	2025-03-05 14:32:48
544	1	19	22	ダミー13	2025-03-05 14:32:48
545	1	19	23	ダミー14	2025-03-05 14:32:48
546	1	19	24	ダミー15	2025-03-05 14:32:48
547	1	19	25	ダミー16	2025-03-05 14:32:48
548	1	19	26	ダミー17	2025-03-05 14:32:48
549	1	19	27	ダミー18	2025-03-05 14:32:48
550	1	19	28	ダミー19	2025-03-05 14:32:48
551	1	19	29	ダミー20	2025-03-05 14:32:48
552	1	20	1	20	2025-03-05 14:32:48
553	1	20	2	テーマE	2025-03-05 14:32:48
554	1	20	3	2025	2025-03-05 14:32:48
555	1	20	4	種別A	2025-03-05 14:32:48
556	1	20	5	B005	2025-03-05 14:32:48
557	1	20	6	予算名D	2025-03-05 14:32:48
558	1	20	7	100000	2025-03-05 14:32:48
559	1	20	8	部門A	2025-03-05 14:32:48
560	1	20	9	部門B	2025-03-05 14:32:48
561	1	20	10	ダミー1	2025-03-05 14:32:48
562	1	20	11	ダミー2	2025-03-05 14:32:48
563	1	20	12	ダミー3	2025-03-05 14:32:48
564	1	20	13	ダミー4	2025-03-05 14:32:48
565	1	20	14	ダミー5	2025-03-05 14:32:48
566	1	20	15	ダミー6	2025-03-05 14:32:48
567	1	20	16	ダミー7	2025-03-05 14:32:48
568	1	20	17	ダミー8	2025-03-05 14:32:48
569	1	20	18	ダミー9	2025-03-05 14:32:48
570	1	20	19	ダミー10	2025-03-05 14:32:48
571	1	20	20	ダミー11	2025-03-05 14:32:48
572	1	20	21	ダミー12	2025-03-05 14:32:48
573	1	20	22	ダミー13	2025-03-05 14:32:48
574	1	20	23	ダミー14	2025-03-05 14:32:48
575	1	20	24	ダミー15	2025-03-05 14:32:48
576	1	20	25	ダミー16	2025-03-05 14:32:48
577	1	20	26	ダミー17	2025-03-05 14:32:48
578	1	20	27	ダミー18	2025-03-05 14:32:48
579	1	20	28	ダミー19	2025-03-05 14:32:48
580	1	20	29	ダミー20	2025-03-05 14:32:48
581	1	21	1	21	2025-03-05 14:32:48
582	1	21	2	テーマF	2025-03-05 14:32:48
583	1	21	3	2025	2025-03-05 14:32:48
584	1	21	4	種別B	2025-03-05 14:32:48
585	1	21	5	B006	2025-03-05 14:32:48
586	1	21	6	予算名A	2025-03-05 14:32:48
587	1	21	7	100000	2025-03-05 14:32:48
588	1	21	8	部門A	2025-03-05 14:32:48
589	1	21	9	部門B	2025-03-05 14:32:48
590	1	21	10	ダミー1	2025-03-05 14:32:48
591	1	21	11	ダミー2	2025-03-05 14:32:48
592	1	21	12	ダミー3	2025-03-05 14:32:48
593	1	21	13	ダミー4	2025-03-05 14:32:48
594	1	21	14	ダミー5	2025-03-05 14:32:48
595	1	21	15	ダミー6	2025-03-05 14:32:48
596	1	21	16	ダミー7	2025-03-05 14:32:48
597	1	21	17	ダミー8	2025-03-05 14:32:48
598	1	21	18	ダミー9	2025-03-05 14:32:48
599	1	21	19	ダミー10	2025-03-05 14:32:48
600	1	21	20	ダミー11	2025-03-05 14:32:48
601	1	21	21	ダミー12	2025-03-05 14:32:48
602	1	21	22	ダミー13	2025-03-05 14:32:48
603	1	21	23	ダミー14	2025-03-05 14:32:48
604	1	21	24	ダミー15	2025-03-05 14:32:48
605	1	21	25	ダミー16	2025-03-05 14:32:48
606	1	21	26	ダミー17	2025-03-05 14:32:48
607	1	21	27	ダミー18	2025-03-05 14:32:48
608	1	21	28	ダミー19	2025-03-05 14:32:48
609	1	21	29	ダミー20	2025-03-05 14:32:48
610	1	22	1	22	2025-03-05 14:32:48
611	1	22	2	テーマF	2025-03-05 14:32:48
612	1	22	3	2025	2025-03-05 14:32:48
613	1	22	4	種別B	2025-03-05 14:32:48
614	1	22	5	B006	2025-03-05 14:32:48
615	1	22	6	予算名B	2025-03-05 14:32:48
616	1	22	7	100000	2025-03-05 14:32:48
617	1	22	8	部門A	2025-03-05 14:32:48
618	1	22	9	部門B	2025-03-05 14:32:48
619	1	22	10	ダミー1	2025-03-05 14:32:48
620	1	22	11	ダミー2	2025-03-05 14:32:48
621	1	22	12	ダミー3	2025-03-05 14:32:48
622	1	22	13	ダミー4	2025-03-05 14:32:48
623	1	22	14	ダミー5	2025-03-05 14:32:48
624	1	22	15	ダミー6	2025-03-05 14:32:48
625	1	22	16	ダミー7	2025-03-05 14:32:48
626	1	22	17	ダミー8	2025-03-05 14:32:48
627	1	22	18	ダミー9	2025-03-05 14:32:48
628	1	22	19	ダミー10	2025-03-05 14:32:48
629	1	22	20	ダミー11	2025-03-05 14:32:48
630	1	22	21	ダミー12	2025-03-05 14:32:48
631	1	22	22	ダミー13	2025-03-05 14:32:48
632	1	22	23	ダミー14	2025-03-05 14:32:48
633	1	22	24	ダミー15	2025-03-05 14:32:48
634	1	22	25	ダミー16	2025-03-05 14:32:48
635	1	22	26	ダミー17	2025-03-05 14:32:48
636	1	22	27	ダミー18	2025-03-05 14:32:48
637	1	22	28	ダミー19	2025-03-05 14:32:48
638	1	22	29	ダミー20	2025-03-05 14:32:48
639	1	23	1	23	2025-03-05 14:32:48
640	1	23	2	テーマF	2025-03-05 14:32:48
641	1	23	3	2025	2025-03-05 14:32:48
642	1	23	4	種別B	2025-03-05 14:32:48
643	1	23	5	B006	2025-03-05 14:32:48
644	1	23	6	予算名C	2025-03-05 14:32:48
645	1	23	7	100000	2025-03-05 14:32:48
646	1	23	8	部門A	2025-03-05 14:32:48
647	1	23	9	部門B	2025-03-05 14:32:48
648	1	23	10	ダミー1	2025-03-05 14:32:48
649	1	23	11	ダミー2	2025-03-05 14:32:48
650	1	23	12	ダミー3	2025-03-05 14:32:48
651	1	23	13	ダミー4	2025-03-05 14:32:48
652	1	23	14	ダミー5	2025-03-05 14:32:48
653	1	23	15	ダミー6	2025-03-05 14:32:48
654	1	23	16	ダミー7	2025-03-05 14:32:48
655	1	23	17	ダミー8	2025-03-05 14:32:48
656	1	23	18	ダミー9	2025-03-05 14:32:48
657	1	23	19	ダミー10	2025-03-05 14:32:48
658	1	23	20	ダミー11	2025-03-05 14:32:48
659	1	23	21	ダミー12	2025-03-05 14:32:48
660	1	23	22	ダミー13	2025-03-05 14:32:48
661	1	23	23	ダミー14	2025-03-05 14:32:48
662	1	23	24	ダミー15	2025-03-05 14:32:48
663	1	23	25	ダミー16	2025-03-05 14:32:48
664	1	23	26	ダミー17	2025-03-05 14:32:48
665	1	23	27	ダミー18	2025-03-05 14:32:48
666	1	23	28	ダミー19	2025-03-05 14:32:48
667	1	23	29	ダミー20	2025-03-05 14:32:48
668	1	24	1	24	2025-03-05 14:32:48
669	1	24	2	テーマF	2025-03-05 14:32:48
670	1	24	3	2025	2025-03-05 14:32:48
671	1	24	4	種別B	2025-03-05 14:32:48
672	1	24	5	B006	2025-03-05 14:32:48
673	1	24	6	予算名D	2025-03-05 14:32:48
674	1	24	7	100000	2025-03-05 14:32:48
675	1	24	8	部門A	2025-03-05 14:32:48
676	1	24	9	部門B	2025-03-05 14:32:48
677	1	24	10	ダミー1	2025-03-05 14:32:48
678	1	24	11	ダミー2	2025-03-05 14:32:48
679	1	24	12	ダミー3	2025-03-05 14:32:48
680	1	24	13	ダミー4	2025-03-05 14:32:48
681	1	24	14	ダミー5	2025-03-05 14:32:48
682	1	24	15	ダミー6	2025-03-05 14:32:48
683	1	24	16	ダミー7	2025-03-05 14:32:48
684	1	24	17	ダミー8	2025-03-05 14:32:48
685	1	24	18	ダミー9	2025-03-05 14:32:48
686	1	24	19	ダミー10	2025-03-05 14:32:48
687	1	24	20	ダミー11	2025-03-05 14:32:48
688	1	24	21	ダミー12	2025-03-05 14:32:48
689	1	24	22	ダミー13	2025-03-05 14:32:48
690	1	24	23	ダミー14	2025-03-05 14:32:48
691	1	24	24	ダミー15	2025-03-05 14:32:48
692	1	24	25	ダミー16	2025-03-05 14:32:48
693	1	24	26	ダミー17	2025-03-05 14:32:48
694	1	24	27	ダミー18	2025-03-05 14:32:48
695	1	24	28	ダミー19	2025-03-05 14:32:48
696	1	24	29	ダミー20	2025-03-05 14:32:48
697	2	1	30	1	2025-03-05 14:32:48
698	2	1	31	2023	2025-03-05 14:32:48
699	2	1	32	種別A	2025-03-05 14:32:48
700	2	1	33	B001	2025-03-05 14:32:48
701	2	1	34	予算名A	2025-03-05 14:32:48
702	2	1	35	100000	2025-03-05 14:32:48
703	2	1	36	部門A	2025-03-05 14:32:48
704	2	1	37	部門B	2025-03-05 14:32:48
705	2	1	38	部門A	2025-03-05 14:32:48
706	2	1	39	担当者A	2025-03-05 14:32:48
707	2	1	40	2023-10-15	2025-03-05 14:32:48
708	2	1	41	担当者B	2025-03-05 14:32:48
709	2	1	42	2023-11-22	2025-03-05 14:32:48
710	2	1	43	ダミー1	2025-03-05 14:32:48
711	2	1	44	ダミー2	2025-03-05 14:32:48
712	2	1	45	ダミー3	2025-03-05 14:32:48
713	2	1	46	ダミー4	2025-03-05 14:32:48
714	2	1	47	ダミー5	2025-03-05 14:32:48
715	2	1	48	ダミー6	2025-03-05 14:32:48
716	2	1	49	ダミー7	2025-03-05 14:32:48
717	2	1	50	ダミー8	2025-03-05 14:32:48
718	2	1	51	ダミー9	2025-03-05 14:32:48
719	2	1	52	ダミー10	2025-03-05 14:32:48
720	2	1	53	ダミー11	2025-03-05 14:32:48
721	2	1	54	ダミー12	2025-03-05 14:32:48
722	2	1	55	ダミー13	2025-03-05 14:32:48
723	2	1	56	ダミー14	2025-03-05 14:32:48
724	2	1	57	ダミー15	2025-03-05 14:32:48
725	2	1	58	ダミー16	2025-03-05 14:32:48
726	2	1	59	ダミー17	2025-03-05 14:32:48
727	2	1	60	ダミー18	2025-03-05 14:32:48
728	2	1	61	ダミー19	2025-03-05 14:32:48
729	2	1	62	ダミー20	2025-03-05 14:32:48
730	2	2	30	2	2025-03-05 14:32:48
731	2	2	31	2023	2025-03-05 14:32:48
732	2	2	32	種別A	2025-03-05 14:32:48
733	2	2	33	B001	2025-03-05 14:32:48
734	2	2	34	予算名B	2025-03-05 14:32:48
735	2	2	35	100000	2025-03-05 14:32:48
736	2	2	36	部門A	2025-03-05 14:32:48
737	2	2	37	部門B	2025-03-05 14:32:48
738	2	2	38	部門A	2025-03-05 14:32:48
739	2	2	39	担当者A	2025-03-05 14:32:48
740	2	2	40	2023-10-15	2025-03-05 14:32:48
741	2	2	41	担当者B	2025-03-05 14:32:48
742	2	2	42	2023-11-22	2025-03-05 14:32:48
743	2	2	43	ダミー1	2025-03-05 14:32:48
744	2	2	44	ダミー2	2025-03-05 14:32:48
745	2	2	45	ダミー3	2025-03-05 14:32:48
746	2	2	46	ダミー4	2025-03-05 14:32:48
747	2	2	47	ダミー5	2025-03-05 14:32:48
748	2	2	48	ダミー6	2025-03-05 14:32:48
749	2	2	49	ダミー7	2025-03-05 14:32:48
750	2	2	50	ダミー8	2025-03-05 14:32:48
751	2	2	51	ダミー9	2025-03-05 14:32:48
752	2	2	52	ダミー10	2025-03-05 14:32:48
753	2	2	53	ダミー11	2025-03-05 14:32:48
754	2	2	54	ダミー12	2025-03-05 14:32:48
755	2	2	55	ダミー13	2025-03-05 14:32:48
756	2	2	56	ダミー14	2025-03-05 14:32:48
757	2	2	57	ダミー15	2025-03-05 14:32:48
758	2	2	58	ダミー16	2025-03-05 14:32:48
759	2	2	59	ダミー17	2025-03-05 14:32:48
760	2	2	60	ダミー18	2025-03-05 14:32:48
761	2	2	61	ダミー19	2025-03-05 14:32:48
762	2	2	62	ダミー20	2025-03-05 14:32:48
763	2	3	30	3	2025-03-05 14:32:48
764	2	3	31	2023	2025-03-05 14:32:48
765	2	3	32	種別A	2025-03-05 14:32:48
766	2	3	33	B001	2025-03-05 14:32:48
767	2	3	34	予算名C	2025-03-05 14:32:48
768	2	3	35	100000	2025-03-05 14:32:48
769	2	3	36	部門A	2025-03-05 14:32:48
770	2	3	37	部門B	2025-03-05 14:32:48
771	2	3	38	部門A	2025-03-05 14:32:48
772	2	3	39	担当者A	2025-03-05 14:32:48
773	2	3	40	2023-10-15	2025-03-05 14:32:48
774	2	3	41	担当者B	2025-03-05 14:32:48
775	2	3	42	2023-11-22	2025-03-05 14:32:48
776	2	3	43	ダミー1	2025-03-05 14:32:48
777	2	3	44	ダミー2	2025-03-05 14:32:48
778	2	3	45	ダミー3	2025-03-05 14:32:48
779	2	3	46	ダミー4	2025-03-05 14:32:48
780	2	3	47	ダミー5	2025-03-05 14:32:48
781	2	3	48	ダミー6	2025-03-05 14:32:48
782	2	3	49	ダミー7	2025-03-05 14:32:48
783	2	3	50	ダミー8	2025-03-05 14:32:48
784	2	3	51	ダミー9	2025-03-05 14:32:48
785	2	3	52	ダミー10	2025-03-05 14:32:48
786	2	3	53	ダミー11	2025-03-05 14:32:48
787	2	3	54	ダミー12	2025-03-05 14:32:48
788	2	3	55	ダミー13	2025-03-05 14:32:48
789	2	3	56	ダミー14	2025-03-05 14:32:48
790	2	3	57	ダミー15	2025-03-05 14:32:48
791	2	3	58	ダミー16	2025-03-05 14:32:48
792	2	3	59	ダミー17	2025-03-05 14:32:48
793	2	3	60	ダミー18	2025-03-05 14:32:48
794	2	3	61	ダミー19	2025-03-05 14:32:48
795	2	3	62	ダミー20	2025-03-05 14:32:48
796	2	4	30	4	2025-03-05 14:32:48
797	2	4	31	2023	2025-03-05 14:32:48
798	2	4	32	種別A	2025-03-05 14:32:48
799	2	4	33	B001	2025-03-05 14:32:48
800	2	4	34	予算名D	2025-03-05 14:32:48
801	2	4	35	100000	2025-03-05 14:32:48
802	2	4	36	部門A	2025-03-05 14:32:48
803	2	4	37	部門B	2025-03-05 14:32:48
804	2	4	38	部門A	2025-03-05 14:32:48
805	2	4	39	担当者A	2025-03-05 14:32:48
806	2	4	40	2023-10-15	2025-03-05 14:32:48
807	2	4	41	担当者B	2025-03-05 14:32:48
808	2	4	42	2023-11-22	2025-03-05 14:32:48
809	2	4	43	ダミー1	2025-03-05 14:32:48
810	2	4	44	ダミー2	2025-03-05 14:32:48
811	2	4	45	ダミー3	2025-03-05 14:32:48
812	2	4	46	ダミー4	2025-03-05 14:32:48
813	2	4	47	ダミー5	2025-03-05 14:32:48
814	2	4	48	ダミー6	2025-03-05 14:32:48
815	2	4	49	ダミー7	2025-03-05 14:32:48
816	2	4	50	ダミー8	2025-03-05 14:32:48
817	2	4	51	ダミー9	2025-03-05 14:32:48
818	2	4	52	ダミー10	2025-03-05 14:32:48
819	2	4	53	ダミー11	2025-03-05 14:32:48
820	2	4	54	ダミー12	2025-03-05 14:32:48
821	2	4	55	ダミー13	2025-03-05 14:32:48
822	2	4	56	ダミー14	2025-03-05 14:32:48
823	2	4	57	ダミー15	2025-03-05 14:32:48
824	2	4	58	ダミー16	2025-03-05 14:32:48
825	2	4	59	ダミー17	2025-03-05 14:32:48
826	2	4	60	ダミー18	2025-03-05 14:32:48
827	2	4	61	ダミー19	2025-03-05 14:32:48
828	2	4	62	ダミー20	2025-03-05 14:32:48
829	2	5	30	5	2025-03-05 14:32:48
830	2	5	31	2023	2025-03-05 14:32:48
831	2	5	32	種別B	2025-03-05 14:32:48
832	2	5	33	B002	2025-03-05 14:32:48
833	2	5	34	予算名A	2025-03-05 14:32:48
834	2	5	35	100000	2025-03-05 14:32:48
835	2	5	36	部門A	2025-03-05 14:32:48
836	2	5	37	部門B	2025-03-05 14:32:48
837	2	5	38	部門A	2025-03-05 14:32:48
838	2	5	39	担当者A	2025-03-05 14:32:48
839	2	5	40	2023-10-15	2025-03-05 14:32:48
840	2	5	41	担当者B	2025-03-05 14:32:48
841	2	5	42	2023-11-22	2025-03-05 14:32:48
842	2	5	43	ダミー1	2025-03-05 14:32:48
843	2	5	44	ダミー2	2025-03-05 14:32:48
844	2	5	45	ダミー3	2025-03-05 14:32:48
845	2	5	46	ダミー4	2025-03-05 14:32:48
846	2	5	47	ダミー5	2025-03-05 14:32:48
847	2	5	48	ダミー6	2025-03-05 14:32:48
848	2	5	49	ダミー7	2025-03-05 14:32:48
849	2	5	50	ダミー8	2025-03-05 14:32:48
850	2	5	51	ダミー9	2025-03-05 14:32:48
851	2	5	52	ダミー10	2025-03-05 14:32:48
852	2	5	53	ダミー11	2025-03-05 14:32:48
853	2	5	54	ダミー12	2025-03-05 14:32:48
854	2	5	55	ダミー13	2025-03-05 14:32:48
855	2	5	56	ダミー14	2025-03-05 14:32:48
856	2	5	57	ダミー15	2025-03-05 14:32:48
857	2	5	58	ダミー16	2025-03-05 14:32:48
858	2	5	59	ダミー17	2025-03-05 14:32:48
859	2	5	60	ダミー18	2025-03-05 14:32:48
860	2	5	61	ダミー19	2025-03-05 14:32:48
861	2	5	62	ダミー20	2025-03-05 14:32:48
862	2	6	30	6	2025-03-05 14:32:48
863	2	6	31	2023	2025-03-05 14:32:48
864	2	6	32	種別B	2025-03-05 14:32:48
865	2	6	33	B002	2025-03-05 14:32:48
866	2	6	34	予算名B	2025-03-05 14:32:48
867	2	6	35	100000	2025-03-05 14:32:48
868	2	6	36	部門A	2025-03-05 14:32:48
869	2	6	37	部門B	2025-03-05 14:32:48
870	2	6	38	部門A	2025-03-05 14:32:48
871	2	6	39	担当者A	2025-03-05 14:32:48
872	2	6	40	2023-10-15	2025-03-05 14:32:48
873	2	6	41	担当者B	2025-03-05 14:32:48
874	2	6	42	2023-11-22	2025-03-05 14:32:48
875	2	6	43	ダミー1	2025-03-05 14:32:48
876	2	6	44	ダミー2	2025-03-05 14:32:48
877	2	6	45	ダミー3	2025-03-05 14:32:48
878	2	6	46	ダミー4	2025-03-05 14:32:48
879	2	6	47	ダミー5	2025-03-05 14:32:48
880	2	6	48	ダミー6	2025-03-05 14:32:48
881	2	6	49	ダミー7	2025-03-05 14:32:48
882	2	6	50	ダミー8	2025-03-05 14:32:48
883	2	6	51	ダミー9	2025-03-05 14:32:48
884	2	6	52	ダミー10	2025-03-05 14:32:48
885	2	6	53	ダミー11	2025-03-05 14:32:48
886	2	6	54	ダミー12	2025-03-05 14:32:48
887	2	6	55	ダミー13	2025-03-05 14:32:48
888	2	6	56	ダミー14	2025-03-05 14:32:48
889	2	6	57	ダミー15	2025-03-05 14:32:48
890	2	6	58	ダミー16	2025-03-05 14:32:48
891	2	6	59	ダミー17	2025-03-05 14:32:48
892	2	6	60	ダミー18	2025-03-05 14:32:48
893	2	6	61	ダミー19	2025-03-05 14:32:48
894	2	6	62	ダミー20	2025-03-05 14:32:48
895	2	7	30	7	2025-03-05 14:32:48
896	2	7	31	2023	2025-03-05 14:32:48
897	2	7	32	種別B	2025-03-05 14:32:48
898	2	7	33	B002	2025-03-05 14:32:48
899	2	7	34	予算名C	2025-03-05 14:32:48
900	2	7	35	100000	2025-03-05 14:32:48
901	2	7	36	部門A	2025-03-05 14:32:48
902	2	7	37	部門B	2025-03-05 14:32:48
903	2	7	38	部門A	2025-03-05 14:32:48
904	2	7	39	担当者A	2025-03-05 14:32:48
906	2	7	41	担当者B	2025-03-05 14:32:48
907	2	7	42	2023-11-22	2025-03-05 14:32:48
908	2	7	43	ダミー1	2025-03-05 14:32:48
909	2	7	44	ダミー2	2025-03-05 14:32:48
910	2	7	45	ダミー3	2025-03-05 14:32:48
911	2	7	46	ダミー4	2025-03-05 14:32:48
912	2	7	47	ダミー5	2025-03-05 14:32:48
913	2	7	48	ダミー6	2025-03-05 14:32:48
914	2	7	49	ダミー7	2025-03-05 14:32:48
915	2	7	50	ダミー8	2025-03-05 14:32:48
916	2	7	51	ダミー9	2025-03-05 14:32:48
917	2	7	52	ダミー10	2025-03-05 14:32:48
918	2	7	53	ダミー11	2025-03-05 14:32:48
919	2	7	54	ダミー12	2025-03-05 14:32:48
920	2	7	55	ダミー13	2025-03-05 14:32:48
921	2	7	56	ダミー14	2025-03-05 14:32:48
922	2	7	57	ダミー15	2025-03-05 14:32:48
923	2	7	58	ダミー16	2025-03-05 14:32:48
924	2	7	59	ダミー17	2025-03-05 14:32:48
925	2	7	60	ダミー18	2025-03-05 14:32:48
926	2	7	61	ダミー19	2025-03-05 14:32:48
927	2	7	62	ダミー20	2025-03-05 14:32:48
928	2	8	30	8	2025-03-05 14:32:48
929	2	8	31	2023	2025-03-05 14:32:48
930	2	8	32	種別B	2025-03-05 14:32:48
931	2	8	33	B002	2025-03-05 14:32:48
932	2	8	34	予算名D	2025-03-05 14:32:48
933	2	8	35	100000	2025-03-05 14:32:48
934	2	8	36	部門A	2025-03-05 14:32:48
935	2	8	37	部門B	2025-03-05 14:32:48
936	2	8	38	部門A	2025-03-05 14:32:48
937	2	8	39	担当者A	2025-03-05 14:32:48
938	2	8	40	2023-10-15	2025-03-05 14:32:48
939	2	8	41	担当者B	2025-03-05 14:32:48
940	2	8	42	2023-11-22	2025-03-05 14:32:48
941	2	8	43	ダミー1	2025-03-05 14:32:48
942	2	8	44	ダミー2	2025-03-05 14:32:48
943	2	8	45	ダミー3	2025-03-05 14:32:48
944	2	8	46	ダミー4	2025-03-05 14:32:48
945	2	8	47	ダミー5	2025-03-05 14:32:48
946	2	8	48	ダミー6	2025-03-05 14:32:48
947	2	8	49	ダミー7	2025-03-05 14:32:48
948	2	8	50	ダミー8	2025-03-05 14:32:48
949	2	8	51	ダミー9	2025-03-05 14:32:48
950	2	8	52	ダミー10	2025-03-05 14:32:48
951	2	8	53	ダミー11	2025-03-05 14:32:48
952	2	8	54	ダミー12	2025-03-05 14:32:48
953	2	8	55	ダミー13	2025-03-05 14:32:48
954	2	8	56	ダミー14	2025-03-05 14:32:48
955	2	8	57	ダミー15	2025-03-05 14:32:48
956	2	8	58	ダミー16	2025-03-05 14:32:48
957	2	8	59	ダミー17	2025-03-05 14:32:48
958	2	8	60	ダミー18	2025-03-05 14:32:48
959	2	8	61	ダミー19	2025-03-05 14:32:48
960	2	8	62	ダミー20	2025-03-05 14:32:48
961	2	9	30	9	2025-03-05 14:32:48
962	2	9	31	2024	2025-03-05 14:32:48
963	2	9	32	種別A	2025-03-05 14:32:48
964	2	9	33	B003	2025-03-05 14:32:48
965	2	9	34	予算名A	2025-03-05 14:32:48
966	2	9	35	100000	2025-03-05 14:32:48
967	2	9	36	部門A	2025-03-05 14:32:48
968	2	9	37	部門B	2025-03-05 14:32:48
969	2	9	38	部門A	2025-03-05 14:32:48
970	2	9	39	担当者A	2025-03-05 14:32:48
971	2	9	40	2023-10-15	2025-03-05 14:32:48
972	2	9	41	担当者B	2025-03-05 14:32:48
973	2	9	42	2023-11-22	2025-03-05 14:32:48
974	2	9	43	ダミー1	2025-03-05 14:32:48
975	2	9	44	ダミー2	2025-03-05 14:32:48
976	2	9	45	ダミー3	2025-03-05 14:32:48
977	2	9	46	ダミー4	2025-03-05 14:32:48
978	2	9	47	ダミー5	2025-03-05 14:32:48
979	2	9	48	ダミー6	2025-03-05 14:32:48
980	2	9	49	ダミー7	2025-03-05 14:32:48
981	2	9	50	ダミー8	2025-03-05 14:32:48
982	2	9	51	ダミー9	2025-03-05 14:32:48
983	2	9	52	ダミー10	2025-03-05 14:32:48
984	2	9	53	ダミー11	2025-03-05 14:32:48
985	2	9	54	ダミー12	2025-03-05 14:32:48
986	2	9	55	ダミー13	2025-03-05 14:32:48
987	2	9	56	ダミー14	2025-03-05 14:32:48
988	2	9	57	ダミー15	2025-03-05 14:32:48
989	2	9	58	ダミー16	2025-03-05 14:32:48
990	2	9	59	ダミー17	2025-03-05 14:32:48
991	2	9	60	ダミー18	2025-03-05 14:32:48
992	2	9	61	ダミー19	2025-03-05 14:32:48
993	2	9	62	ダミー20	2025-03-05 14:32:48
994	2	10	30	10	2025-03-05 14:32:48
995	2	10	31	2024	2025-03-05 14:32:48
996	2	10	32	種別A	2025-03-05 14:32:48
997	2	10	33	B003	2025-03-05 14:32:48
998	2	10	34	予算名B	2025-03-05 14:32:48
999	2	10	35	100000	2025-03-05 14:32:48
1000	2	10	36	部門A	2025-03-05 14:32:48
1001	2	10	37	部門B	2025-03-05 14:32:48
1002	2	10	38	部門A	2025-03-05 14:32:48
1003	2	10	39	担当者A	2025-03-05 14:32:48
1004	2	10	40	2023-10-15	2025-03-05 14:32:48
1005	2	10	41	担当者B	2025-03-05 14:32:48
1006	2	10	42	2023-11-22	2025-03-05 14:32:48
1007	2	10	43	ダミー1	2025-03-05 14:32:48
1008	2	10	44	ダミー2	2025-03-05 14:32:48
1009	2	10	45	ダミー3	2025-03-05 14:32:48
1010	2	10	46	ダミー4	2025-03-05 14:32:48
1011	2	10	47	ダミー5	2025-03-05 14:32:48
1012	2	10	48	ダミー6	2025-03-05 14:32:48
1013	2	10	49	ダミー7	2025-03-05 14:32:48
1014	2	10	50	ダミー8	2025-03-05 14:32:48
1015	2	10	51	ダミー9	2025-03-05 14:32:48
1016	2	10	52	ダミー10	2025-03-05 14:32:48
1017	2	10	53	ダミー11	2025-03-05 14:32:48
1018	2	10	54	ダミー12	2025-03-05 14:32:48
1019	2	10	55	ダミー13	2025-03-05 14:32:48
1020	2	10	56	ダミー14	2025-03-05 14:32:48
1021	2	10	57	ダミー15	2025-03-05 14:32:48
1022	2	10	58	ダミー16	2025-03-05 14:32:48
1023	2	10	59	ダミー17	2025-03-05 14:32:48
1024	2	10	60	ダミー18	2025-03-05 14:32:48
1025	2	10	61	ダミー19	2025-03-05 14:32:48
1026	2	10	62	ダミー20	2025-03-05 14:32:48
1027	2	11	30	11	2025-03-05 14:32:48
1028	2	11	31	2024	2025-03-05 14:32:48
1029	2	11	32	種別A	2025-03-05 14:32:48
1030	2	11	33	B003	2025-03-05 14:32:48
1031	2	11	34	予算名C	2025-03-05 14:32:48
1032	2	11	35	100000	2025-03-05 14:32:48
1033	2	11	36	部門A	2025-03-05 14:32:48
1034	2	11	37	部門B	2025-03-05 14:32:48
1035	2	11	38	部門A	2025-03-05 14:32:48
1036	2	11	39	担当者A	2025-03-05 14:32:48
1037	2	11	40	2023-10-15	2025-03-05 14:32:48
1038	2	11	41	担当者B	2025-03-05 14:32:48
1039	2	11	42	2023-11-22	2025-03-05 14:32:48
1040	2	11	43	ダミー1	2025-03-05 14:32:48
1041	2	11	44	ダミー2	2025-03-05 14:32:48
1042	2	11	45	ダミー3	2025-03-05 14:32:48
1043	2	11	46	ダミー4	2025-03-05 14:32:48
1044	2	11	47	ダミー5	2025-03-05 14:32:48
1045	2	11	48	ダミー6	2025-03-05 14:32:48
1046	2	11	49	ダミー7	2025-03-05 14:32:48
1047	2	11	50	ダミー8	2025-03-05 14:32:48
1048	2	11	51	ダミー9	2025-03-05 14:32:48
1049	2	11	52	ダミー10	2025-03-05 14:32:48
1050	2	11	53	ダミー11	2025-03-05 14:32:48
1051	2	11	54	ダミー12	2025-03-05 14:32:48
1052	2	11	55	ダミー13	2025-03-05 14:32:48
1053	2	11	56	ダミー14	2025-03-05 14:32:48
1054	2	11	57	ダミー15	2025-03-05 14:32:48
1055	2	11	58	ダミー16	2025-03-05 14:32:48
1056	2	11	59	ダミー17	2025-03-05 14:32:48
1057	2	11	60	ダミー18	2025-03-05 14:32:48
1058	2	11	61	ダミー19	2025-03-05 14:32:48
1059	2	11	62	ダミー20	2025-03-05 14:32:48
1060	2	12	30	12	2025-03-05 14:32:48
1061	2	12	31	2024	2025-03-05 14:32:48
1062	2	12	32	種別A	2025-03-05 14:32:48
1063	2	12	33	B003	2025-03-05 14:32:48
1064	2	12	34	予算名D	2025-03-05 14:32:48
1065	2	12	35	100000	2025-03-05 14:32:48
1066	2	12	36	部門A	2025-03-05 14:32:48
1067	2	12	37	部門B	2025-03-05 14:32:48
1068	2	12	38	部門A	2025-03-05 14:32:48
1069	2	12	39	担当者A	2025-03-05 14:32:48
1070	2	12	40	2023-10-15	2025-03-05 14:32:48
1071	2	12	41	担当者B	2025-03-05 14:32:48
1072	2	12	42	2023-11-22	2025-03-05 14:32:48
1073	2	12	43	ダミー1	2025-03-05 14:32:48
1074	2	12	44	ダミー2	2025-03-05 14:32:48
1075	2	12	45	ダミー3	2025-03-05 14:32:48
1076	2	12	46	ダミー4	2025-03-05 14:32:48
1077	2	12	47	ダミー5	2025-03-05 14:32:48
1078	2	12	48	ダミー6	2025-03-05 14:32:48
1079	2	12	49	ダミー7	2025-03-05 14:32:48
1080	2	12	50	ダミー8	2025-03-05 14:32:48
1081	2	12	51	ダミー9	2025-03-05 14:32:48
1082	2	12	52	ダミー10	2025-03-05 14:32:48
1083	2	12	53	ダミー11	2025-03-05 14:32:48
1084	2	12	54	ダミー12	2025-03-05 14:32:48
1085	2	12	55	ダミー13	2025-03-05 14:32:48
1086	2	12	56	ダミー14	2025-03-05 14:32:48
1087	2	12	57	ダミー15	2025-03-05 14:32:48
1088	2	12	58	ダミー16	2025-03-05 14:32:48
1089	2	12	59	ダミー17	2025-03-05 14:32:48
1090	2	12	60	ダミー18	2025-03-05 14:32:48
1091	2	12	61	ダミー19	2025-03-05 14:32:48
1092	2	12	62	ダミー20	2025-03-05 14:32:48
1093	2	13	30	13	2025-03-05 14:32:48
1094	2	13	31	2024	2025-03-05 14:32:48
1095	2	13	32	種別B	2025-03-05 14:32:48
1096	2	13	33	B004	2025-03-05 14:32:48
1097	2	13	34	予算名A	2025-03-05 14:32:48
1098	2	13	35	100000	2025-03-05 14:32:48
1099	2	13	36	部門A	2025-03-05 14:32:48
1100	2	13	37	部門B	2025-03-05 14:32:48
1101	2	13	38	部門A	2025-03-05 14:32:48
1102	2	13	39	担当者A	2025-03-05 14:32:48
1103	2	13	40	2023-10-15	2025-03-05 14:32:48
1104	2	13	41	担当者B	2025-03-05 14:32:48
1105	2	13	42	2023-11-22	2025-03-05 14:32:48
1106	2	13	43	ダミー1	2025-03-05 14:32:48
1107	2	13	44	ダミー2	2025-03-05 14:32:48
1108	2	13	45	ダミー3	2025-03-05 14:32:48
1109	2	13	46	ダミー4	2025-03-05 14:32:48
1110	2	13	47	ダミー5	2025-03-05 14:32:48
1111	2	13	48	ダミー6	2025-03-05 14:32:48
1112	2	13	49	ダミー7	2025-03-05 14:32:48
1113	2	13	50	ダミー8	2025-03-05 14:32:48
1114	2	13	51	ダミー9	2025-03-05 14:32:48
1115	2	13	52	ダミー10	2025-03-05 14:32:48
1116	2	13	53	ダミー11	2025-03-05 14:32:48
1117	2	13	54	ダミー12	2025-03-05 14:32:48
1118	2	13	55	ダミー13	2025-03-05 14:32:48
1119	2	13	56	ダミー14	2025-03-05 14:32:48
1120	2	13	57	ダミー15	2025-03-05 14:32:48
1121	2	13	58	ダミー16	2025-03-05 14:32:48
1122	2	13	59	ダミー17	2025-03-05 14:32:48
1123	2	13	60	ダミー18	2025-03-05 14:32:48
1124	2	13	61	ダミー19	2025-03-05 14:32:48
1125	2	13	62	ダミー20	2025-03-05 14:32:48
1126	2	14	30	14	2025-03-05 14:32:48
1127	2	14	31	2024	2025-03-05 14:32:48
1128	2	14	32	種別B	2025-03-05 14:32:48
1129	2	14	33	B004	2025-03-05 14:32:48
1130	2	14	34	予算名B	2025-03-05 14:32:48
1131	2	14	35	100000	2025-03-05 14:32:48
1132	2	14	36	部門A	2025-03-05 14:32:48
1133	2	14	37	部門B	2025-03-05 14:32:48
1134	2	14	38	部門A	2025-03-05 14:32:48
1135	2	14	39	担当者A	2025-03-05 14:32:48
1136	2	14	40	2023-10-15	2025-03-05 14:32:48
1137	2	14	41	担当者B	2025-03-05 14:32:48
1138	2	14	42	2023-11-22	2025-03-05 14:32:48
1139	2	14	43	ダミー1	2025-03-05 14:32:48
1140	2	14	44	ダミー2	2025-03-05 14:32:48
1141	2	14	45	ダミー3	2025-03-05 14:32:48
1142	2	14	46	ダミー4	2025-03-05 14:32:48
1143	2	14	47	ダミー5	2025-03-05 14:32:48
1144	2	14	48	ダミー6	2025-03-05 14:32:48
1145	2	14	49	ダミー7	2025-03-05 14:32:48
1146	2	14	50	ダミー8	2025-03-05 14:32:48
1147	2	14	51	ダミー9	2025-03-05 14:32:48
1148	2	14	52	ダミー10	2025-03-05 14:32:48
1149	2	14	53	ダミー11	2025-03-05 14:32:48
1150	2	14	54	ダミー12	2025-03-05 14:32:48
1151	2	14	55	ダミー13	2025-03-05 14:32:48
1152	2	14	56	ダミー14	2025-03-05 14:32:48
1153	2	14	57	ダミー15	2025-03-05 14:32:48
1154	2	14	58	ダミー16	2025-03-05 14:32:48
1155	2	14	59	ダミー17	2025-03-05 14:32:48
1156	2	14	60	ダミー18	2025-03-05 14:32:48
1157	2	14	61	ダミー19	2025-03-05 14:32:48
1158	2	14	62	ダミー20	2025-03-05 14:32:48
1159	2	15	30	15	2025-03-05 14:32:48
1160	2	15	31	2024	2025-03-05 14:32:48
1161	2	15	32	種別B	2025-03-05 14:32:48
1162	2	15	33	B004	2025-03-05 14:32:48
1163	2	15	34	予算名C	2025-03-05 14:32:48
1164	2	15	35	100000	2025-03-05 14:32:48
1165	2	15	36	部門A	2025-03-05 14:32:48
1166	2	15	37	部門B	2025-03-05 14:32:48
1167	2	15	38	部門A	2025-03-05 14:32:48
1168	2	15	39	担当者A	2025-03-05 14:32:48
1169	2	15	40	2023-10-15	2025-03-05 14:32:48
1170	2	15	41	担当者B	2025-03-05 14:32:48
1171	2	15	42	2023-11-22	2025-03-05 14:32:48
1172	2	15	43	ダミー1	2025-03-05 14:32:48
1173	2	15	44	ダミー2	2025-03-05 14:32:48
1174	2	15	45	ダミー3	2025-03-05 14:32:48
1175	2	15	46	ダミー4	2025-03-05 14:32:48
1176	2	15	47	ダミー5	2025-03-05 14:32:48
1177	2	15	48	ダミー6	2025-03-05 14:32:48
1178	2	15	49	ダミー7	2025-03-05 14:32:48
1179	2	15	50	ダミー8	2025-03-05 14:32:48
1180	2	15	51	ダミー9	2025-03-05 14:32:48
1181	2	15	52	ダミー10	2025-03-05 14:32:48
1182	2	15	53	ダミー11	2025-03-05 14:32:48
1183	2	15	54	ダミー12	2025-03-05 14:32:48
1184	2	15	55	ダミー13	2025-03-05 14:32:48
1185	2	15	56	ダミー14	2025-03-05 14:32:48
1186	2	15	57	ダミー15	2025-03-05 14:32:48
1187	2	15	58	ダミー16	2025-03-05 14:32:48
1188	2	15	59	ダミー17	2025-03-05 14:32:48
1189	2	15	60	ダミー18	2025-03-05 14:32:48
1190	2	15	61	ダミー19	2025-03-05 14:32:48
1191	2	15	62	ダミー20	2025-03-05 14:32:48
1192	2	16	30	16	2025-03-05 14:32:48
1193	2	16	31	2024	2025-03-05 14:32:48
1194	2	16	32	種別B	2025-03-05 14:32:48
1195	2	16	33	B004	2025-03-05 14:32:48
1196	2	16	34	予算名D	2025-03-05 14:32:48
1197	2	16	35	100000	2025-03-05 14:32:48
1198	2	16	36	部門A	2025-03-05 14:32:48
1199	2	16	37	部門B	2025-03-05 14:32:48
1200	2	16	38	部門A	2025-03-05 14:32:48
1201	2	16	39	担当者A	2025-03-05 14:32:48
1202	2	16	40	2023-10-15	2025-03-05 14:32:48
1203	2	16	41	担当者B	2025-03-05 14:32:48
1204	2	16	42	2023-11-22	2025-03-05 14:32:48
1205	2	16	43	ダミー1	2025-03-05 14:32:48
1206	2	16	44	ダミー2	2025-03-05 14:32:48
1207	2	16	45	ダミー3	2025-03-05 14:32:48
1208	2	16	46	ダミー4	2025-03-05 14:32:48
1209	2	16	47	ダミー5	2025-03-05 14:32:48
1210	2	16	48	ダミー6	2025-03-05 14:32:48
1211	2	16	49	ダミー7	2025-03-05 14:32:48
1212	2	16	50	ダミー8	2025-03-05 14:32:48
1213	2	16	51	ダミー9	2025-03-05 14:32:48
1214	2	16	52	ダミー10	2025-03-05 14:32:48
1215	2	16	53	ダミー11	2025-03-05 14:32:48
1216	2	16	54	ダミー12	2025-03-05 14:32:48
1217	2	16	55	ダミー13	2025-03-05 14:32:48
1218	2	16	56	ダミー14	2025-03-05 14:32:48
1219	2	16	57	ダミー15	2025-03-05 14:32:48
1220	2	16	58	ダミー16	2025-03-05 14:32:48
1221	2	16	59	ダミー17	2025-03-05 14:32:48
1222	2	16	60	ダミー18	2025-03-05 14:32:48
1223	2	16	61	ダミー19	2025-03-05 14:32:48
1224	2	16	62	ダミー20	2025-03-05 14:32:48
1225	2	17	30	17	2025-03-05 14:32:48
1226	2	17	31	2025	2025-03-05 14:32:48
1227	2	17	32	種別A	2025-03-05 14:32:48
1228	2	17	33	B005	2025-03-05 14:32:48
1229	2	17	34	予算名A	2025-03-05 14:32:48
1230	2	17	35	100000	2025-03-05 14:32:48
1231	2	17	36	部門A	2025-03-05 14:32:48
1232	2	17	37	部門B	2025-03-05 14:32:48
1233	2	17	38	部門A	2025-03-05 14:32:48
1234	2	17	39	担当者A	2025-03-05 14:32:48
1235	2	17	40	2023-10-15	2025-03-05 14:32:48
1236	2	17	41	担当者B	2025-03-05 14:32:48
1237	2	17	42	2023-11-22	2025-03-05 14:32:48
1238	2	17	43	ダミー1	2025-03-05 14:32:48
1239	2	17	44	ダミー2	2025-03-05 14:32:48
1240	2	17	45	ダミー3	2025-03-05 14:32:48
1241	2	17	46	ダミー4	2025-03-05 14:32:48
1242	2	17	47	ダミー5	2025-03-05 14:32:48
1243	2	17	48	ダミー6	2025-03-05 14:32:48
1244	2	17	49	ダミー7	2025-03-05 14:32:48
1245	2	17	50	ダミー8	2025-03-05 14:32:48
1246	2	17	51	ダミー9	2025-03-05 14:32:48
1247	2	17	52	ダミー10	2025-03-05 14:32:48
1248	2	17	53	ダミー11	2025-03-05 14:32:48
1249	2	17	54	ダミー12	2025-03-05 14:32:48
1250	2	17	55	ダミー13	2025-03-05 14:32:48
1251	2	17	56	ダミー14	2025-03-05 14:32:48
1252	2	17	57	ダミー15	2025-03-05 14:32:48
1253	2	17	58	ダミー16	2025-03-05 14:32:48
1254	2	17	59	ダミー17	2025-03-05 14:32:48
1255	2	17	60	ダミー18	2025-03-05 14:32:48
1256	2	17	61	ダミー19	2025-03-05 14:32:48
1257	2	17	62	ダミー20	2025-03-05 14:32:48
1258	2	18	30	18	2025-03-05 14:32:48
1259	2	18	31	2025	2025-03-05 14:32:48
1260	2	18	32	種別A	2025-03-05 14:32:48
1261	2	18	33	B005	2025-03-05 14:32:48
1262	2	18	34	予算名B	2025-03-05 14:32:48
1263	2	18	35	100000	2025-03-05 14:32:48
1264	2	18	36	部門A	2025-03-05 14:32:48
1265	2	18	37	部門B	2025-03-05 14:32:48
1266	2	18	38	部門A	2025-03-05 14:32:48
1267	2	18	39	担当者A	2025-03-05 14:32:48
1268	2	18	40	2023-10-15	2025-03-05 14:32:48
1269	2	18	41	担当者B	2025-03-05 14:32:48
1270	2	18	42	2023-11-22	2025-03-05 14:32:48
1271	2	18	43	ダミー1	2025-03-05 14:32:48
1272	2	18	44	ダミー2	2025-03-05 14:32:48
1273	2	18	45	ダミー3	2025-03-05 14:32:48
1274	2	18	46	ダミー4	2025-03-05 14:32:48
1275	2	18	47	ダミー5	2025-03-05 14:32:48
1276	2	18	48	ダミー6	2025-03-05 14:32:48
1277	2	18	49	ダミー7	2025-03-05 14:32:48
1278	2	18	50	ダミー8	2025-03-05 14:32:48
1279	2	18	51	ダミー9	2025-03-05 14:32:48
1280	2	18	52	ダミー10	2025-03-05 14:32:48
1281	2	18	53	ダミー11	2025-03-05 14:32:48
1282	2	18	54	ダミー12	2025-03-05 14:32:48
1283	2	18	55	ダミー13	2025-03-05 14:32:48
1284	2	18	56	ダミー14	2025-03-05 14:32:48
1285	2	18	57	ダミー15	2025-03-05 14:32:48
1286	2	18	58	ダミー16	2025-03-05 14:32:48
1287	2	18	59	ダミー17	2025-03-05 14:32:48
1288	2	18	60	ダミー18	2025-03-05 14:32:48
1289	2	18	61	ダミー19	2025-03-05 14:32:48
1290	2	18	62	ダミー20	2025-03-05 14:32:48
1291	2	19	30	19	2025-03-05 14:32:48
1292	2	19	31	2025	2025-03-05 14:32:48
1293	2	19	32	種別A	2025-03-05 14:32:48
1294	2	19	33	B005	2025-03-05 14:32:48
1295	2	19	34	予算名C	2025-03-05 14:32:48
1296	2	19	35	100000	2025-03-05 14:32:48
1297	2	19	36	部門A	2025-03-05 14:32:48
1298	2	19	37	部門B	2025-03-05 14:32:48
1299	2	19	38	部門A	2025-03-05 14:32:48
1300	2	19	39	担当者A	2025-03-05 14:32:48
1301	2	19	40	2023-10-15	2025-03-05 14:32:48
1302	2	19	41	担当者B	2025-03-05 14:32:48
1303	2	19	42	2023-11-22	2025-03-05 14:32:48
1304	2	19	43	ダミー1	2025-03-05 14:32:48
1305	2	19	44	ダミー2	2025-03-05 14:32:48
1306	2	19	45	ダミー3	2025-03-05 14:32:48
1307	2	19	46	ダミー4	2025-03-05 14:32:48
1308	2	19	47	ダミー5	2025-03-05 14:32:48
1309	2	19	48	ダミー6	2025-03-05 14:32:48
1310	2	19	49	ダミー7	2025-03-05 14:32:48
1311	2	19	50	ダミー8	2025-03-05 14:32:48
1312	2	19	51	ダミー9	2025-03-05 14:32:48
1313	2	19	52	ダミー10	2025-03-05 14:32:48
1314	2	19	53	ダミー11	2025-03-05 14:32:48
1315	2	19	54	ダミー12	2025-03-05 14:32:48
1316	2	19	55	ダミー13	2025-03-05 14:32:48
1317	2	19	56	ダミー14	2025-03-05 14:32:48
1318	2	19	57	ダミー15	2025-03-05 14:32:48
1319	2	19	58	ダミー16	2025-03-05 14:32:48
1320	2	19	59	ダミー17	2025-03-05 14:32:48
1321	2	19	60	ダミー18	2025-03-05 14:32:48
1322	2	19	61	ダミー19	2025-03-05 14:32:48
1323	2	19	62	ダミー20	2025-03-05 14:32:48
1324	2	20	30	20	2025-03-05 14:32:48
1325	2	20	31	2025	2025-03-05 14:32:48
1326	2	20	32	種別A	2025-03-05 14:32:48
1327	2	20	33	B005	2025-03-05 14:32:48
1328	2	20	34	予算名D	2025-03-05 14:32:48
1329	2	20	35	100000	2025-03-05 14:32:48
1330	2	20	36	部門A	2025-03-05 14:32:48
1331	2	20	37	部門B	2025-03-05 14:32:48
1332	2	20	38	部門A	2025-03-05 14:32:48
1333	2	20	39	担当者A	2025-03-05 14:32:48
1334	2	20	40	2023-10-15	2025-03-05 14:32:48
1335	2	20	41	担当者B	2025-03-05 14:32:48
1336	2	20	42	2023-11-22	2025-03-05 14:32:48
1337	2	20	43	ダミー1	2025-03-05 14:32:48
1338	2	20	44	ダミー2	2025-03-05 14:32:48
1339	2	20	45	ダミー3	2025-03-05 14:32:48
1340	2	20	46	ダミー4	2025-03-05 14:32:48
1341	2	20	47	ダミー5	2025-03-05 14:32:48
1342	2	20	48	ダミー6	2025-03-05 14:32:48
1343	2	20	49	ダミー7	2025-03-05 14:32:48
1344	2	20	50	ダミー8	2025-03-05 14:32:48
1345	2	20	51	ダミー9	2025-03-05 14:32:48
1346	2	20	52	ダミー10	2025-03-05 14:32:48
1347	2	20	53	ダミー11	2025-03-05 14:32:48
1348	2	20	54	ダミー12	2025-03-05 14:32:48
1349	2	20	55	ダミー13	2025-03-05 14:32:48
1350	2	20	56	ダミー14	2025-03-05 14:32:48
1351	2	20	57	ダミー15	2025-03-05 14:32:48
1352	2	20	58	ダミー16	2025-03-05 14:32:48
1353	2	20	59	ダミー17	2025-03-05 14:32:48
1354	2	20	60	ダミー18	2025-03-05 14:32:48
1355	2	20	61	ダミー19	2025-03-05 14:32:48
1356	2	20	62	ダミー20	2025-03-05 14:32:48
1357	2	21	30	21	2025-03-05 14:32:48
1358	2	21	31	2025	2025-03-05 14:32:48
1359	2	21	32	種別B	2025-03-05 14:32:48
1360	2	21	33	B006	2025-03-05 14:32:48
1361	2	21	34	予算名A	2025-03-05 14:32:48
1362	2	21	35	100000	2025-03-05 14:32:48
1363	2	21	36	部門A	2025-03-05 14:32:48
1364	2	21	37	部門B	2025-03-05 14:32:48
1365	2	21	38	部門A	2025-03-05 14:32:48
1366	2	21	39	担当者A	2025-03-05 14:32:48
1367	2	21	40	2023-10-15	2025-03-05 14:32:48
1368	2	21	41	担当者B	2025-03-05 14:32:48
1369	2	21	42	2023-11-22	2025-03-05 14:32:48
1370	2	21	43	ダミー1	2025-03-05 14:32:48
1371	2	21	44	ダミー2	2025-03-05 14:32:48
1372	2	21	45	ダミー3	2025-03-05 14:32:48
1373	2	21	46	ダミー4	2025-03-05 14:32:48
1374	2	21	47	ダミー5	2025-03-05 14:32:48
1375	2	21	48	ダミー6	2025-03-05 14:32:48
1376	2	21	49	ダミー7	2025-03-05 14:32:48
1377	2	21	50	ダミー8	2025-03-05 14:32:48
1378	2	21	51	ダミー9	2025-03-05 14:32:48
1379	2	21	52	ダミー10	2025-03-05 14:32:48
1380	2	21	53	ダミー11	2025-03-05 14:32:48
1381	2	21	54	ダミー12	2025-03-05 14:32:48
1382	2	21	55	ダミー13	2025-03-05 14:32:48
1383	2	21	56	ダミー14	2025-03-05 14:32:48
1384	2	21	57	ダミー15	2025-03-05 14:32:48
1385	2	21	58	ダミー16	2025-03-05 14:32:48
1386	2	21	59	ダミー17	2025-03-05 14:32:48
1387	2	21	60	ダミー18	2025-03-05 14:32:48
1388	2	21	61	ダミー19	2025-03-05 14:32:48
1389	2	21	62	ダミー20	2025-03-05 14:32:48
1390	2	22	30	22	2025-03-05 14:32:48
1391	2	22	31	2025	2025-03-05 14:32:48
1392	2	22	32	種別B	2025-03-05 14:32:48
1393	2	22	33	B006	2025-03-05 14:32:48
1394	2	22	34	予算名B	2025-03-05 14:32:48
1395	2	22	35	100000	2025-03-05 14:32:48
1396	2	22	36	部門A	2025-03-05 14:32:48
1397	2	22	37	部門B	2025-03-05 14:32:48
1398	2	22	38	部門A	2025-03-05 14:32:48
1399	2	22	39	担当者A	2025-03-05 14:32:48
1400	2	22	40	2023-10-15	2025-03-05 14:32:48
1401	2	22	41	担当者B	2025-03-05 14:32:48
1402	2	22	42	2023-11-22	2025-03-05 14:32:48
1403	2	22	43	ダミー1	2025-03-05 14:32:48
1404	2	22	44	ダミー2	2025-03-05 14:32:48
1405	2	22	45	ダミー3	2025-03-05 14:32:48
1406	2	22	46	ダミー4	2025-03-05 14:32:48
1407	2	22	47	ダミー5	2025-03-05 14:32:48
1408	2	22	48	ダミー6	2025-03-05 14:32:48
1409	2	22	49	ダミー7	2025-03-05 14:32:48
1410	2	22	50	ダミー8	2025-03-05 14:32:48
1411	2	22	51	ダミー9	2025-03-05 14:32:48
1412	2	22	52	ダミー10	2025-03-05 14:32:48
1413	2	22	53	ダミー11	2025-03-05 14:32:48
1414	2	22	54	ダミー12	2025-03-05 14:32:48
1415	2	22	55	ダミー13	2025-03-05 14:32:48
1416	2	22	56	ダミー14	2025-03-05 14:32:48
1417	2	22	57	ダミー15	2025-03-05 14:32:48
1418	2	22	58	ダミー16	2025-03-05 14:32:48
1419	2	22	59	ダミー17	2025-03-05 14:32:48
1420	2	22	60	ダミー18	2025-03-05 14:32:48
1421	2	22	61	ダミー19	2025-03-05 14:32:48
1422	2	22	62	ダミー20	2025-03-05 14:32:48
1423	2	23	30	23	2025-03-05 14:32:48
1424	2	23	31	2025	2025-03-05 14:32:48
1425	2	23	32	種別B	2025-03-05 14:32:48
1426	2	23	33	B006	2025-03-05 14:32:48
1427	2	23	34	予算名C	2025-03-05 14:32:48
1428	2	23	35	100000	2025-03-05 14:32:48
1429	2	23	36	部門A	2025-03-05 14:32:48
1430	2	23	37	部門B	2025-03-05 14:32:48
1431	2	23	38	部門A	2025-03-05 14:32:48
1432	2	23	39	担当者A	2025-03-05 14:32:48
1433	2	23	40	2023-10-15	2025-03-05 14:32:48
1434	2	23	41	担当者B	2025-03-05 14:32:48
1435	2	23	42	2023-11-22	2025-03-05 14:32:48
1436	2	23	43	ダミー1	2025-03-05 14:32:48
1437	2	23	44	ダミー2	2025-03-05 14:32:48
1438	2	23	45	ダミー3	2025-03-05 14:32:48
1439	2	23	46	ダミー4	2025-03-05 14:32:48
1440	2	23	47	ダミー5	2025-03-05 14:32:48
1441	2	23	48	ダミー6	2025-03-05 14:32:48
1442	2	23	49	ダミー7	2025-03-05 14:32:48
1443	2	23	50	ダミー8	2025-03-05 14:32:48
1444	2	23	51	ダミー9	2025-03-05 14:32:48
1445	2	23	52	ダミー10	2025-03-05 14:32:48
1446	2	23	53	ダミー11	2025-03-05 14:32:48
1447	2	23	54	ダミー12	2025-03-05 14:32:48
1448	2	23	55	ダミー13	2025-03-05 14:32:48
1449	2	23	56	ダミー14	2025-03-05 14:32:48
1450	2	23	57	ダミー15	2025-03-05 14:32:48
1451	2	23	58	ダミー16	2025-03-05 14:32:48
1452	2	23	59	ダミー17	2025-03-05 14:32:48
1453	2	23	60	ダミー18	2025-03-05 14:32:48
1454	2	23	61	ダミー19	2025-03-05 14:32:48
1455	2	23	62	ダミー20	2025-03-05 14:32:48
1456	2	24	30	24	2025-03-05 14:32:48
1457	2	24	31	2025	2025-03-05 14:32:48
1458	2	24	32	種別B	2025-03-05 14:32:48
1459	2	24	33	B006	2025-03-05 14:32:48
1460	2	24	34	予算名D	2025-03-05 14:32:48
1461	2	24	35	100000	2025-03-05 14:32:48
1462	2	24	36	部門A	2025-03-05 14:32:48
1463	2	24	37	部門B	2025-03-05 14:32:48
1464	2	24	38	部門A	2025-03-05 14:32:48
1465	2	24	39	担当者A	2025-03-05 14:32:48
1466	2	24	40	2023-10-15	2025-03-05 14:32:48
1467	2	24	41	担当者B	2025-03-05 14:32:48
1468	2	24	42	2023-11-22	2025-03-05 14:32:48
1469	2	24	43	ダミー1	2025-03-05 14:32:48
1470	2	24	44	ダミー2	2025-03-05 14:32:48
1471	2	24	45	ダミー3	2025-03-05 14:32:48
1472	2	24	46	ダミー4	2025-03-05 14:32:48
1473	2	24	47	ダミー5	2025-03-05 14:32:48
1474	2	24	48	ダミー6	2025-03-05 14:32:48
1475	2	24	49	ダミー7	2025-03-05 14:32:48
1476	2	24	50	ダミー8	2025-03-05 14:32:48
1477	2	24	51	ダミー9	2025-03-05 14:32:48
1478	2	24	52	ダミー10	2025-03-05 14:32:48
1479	2	24	53	ダミー11	2025-03-05 14:32:48
1480	2	24	54	ダミー12	2025-03-05 14:32:48
1481	2	24	55	ダミー13	2025-03-05 14:32:48
1482	2	24	56	ダミー14	2025-03-05 14:32:48
1483	2	24	57	ダミー15	2025-03-05 14:32:48
1484	2	24	58	ダミー16	2025-03-05 14:32:48
1485	2	24	59	ダミー17	2025-03-05 14:32:48
1486	2	24	60	ダミー18	2025-03-05 14:32:48
1487	2	24	61	ダミー19	2025-03-05 14:32:48
1488	2	24	62	ダミー20	2025-03-05 14:32:48
1489	3	1	63	1	2025-03-05 14:32:48
1490	3	1	64	部門A	2025-03-05 14:32:48
1491	3	1	65	S001	2025-03-05 14:32:48
1492	3	1	66	システム標準名A	2025-03-05 14:32:48
1493	3	1	67	システム名A	2025-03-05 14:32:48
1494	3	1	68	host-001	2025-03-05 14:32:48
1495	3	1	69	OSv1.0	2025-03-05 14:32:48
1496	3	1	70	2023-01-01	2025-03-05 14:32:48
1497	3	1	71	2023-10-01	2025-03-05 14:32:48
1498	3	1	72	進行中	2025-03-05 14:32:48
1499	3	1	73	2026-03-31	2025-03-05 14:32:48
1500	3	1	74	運用移管済	2025-03-05 14:32:48
1501	3	1	75	2023-11-01	2025-03-05 14:32:48
1502	3	1	76	2024-01-01	2025-03-05 14:32:48
1503	3	1	77	バージョン2.0	2025-03-05 14:32:48
1504	3	1	78	推進中	2025-03-05 14:32:48
1505	3	1	79	ユーザー部門A	2025-03-05 14:32:48
1506	3	1	80	費用部門A	2025-03-05 14:32:48
1507	3	1	81	B001	2025-03-05 14:32:48
1508	3	1	82	予算名A	2025-03-05 14:32:48
1509	3	1	83	100000	2025-03-05 14:32:48
1510	3	1	84	部門B	2025-03-05 14:32:48
1511	3	1	85	ダミー1	2025-03-05 14:32:48
1512	3	1	86	ダミー2	2025-03-05 14:32:48
1513	3	1	87	ダミー3	2025-03-05 14:32:48
1514	3	1	88	ダミー4	2025-03-05 14:32:48
1515	3	1	89	ダミー5	2025-03-05 14:32:48
1516	3	1	90	ダミー6	2025-03-05 14:32:48
1517	3	1	91	ダミー7	2025-03-05 14:32:48
1518	3	1	92	ダミー8	2025-03-05 14:32:48
1519	3	1	93	ダミー9	2025-03-05 14:32:48
1520	3	1	94	ダミー10	2025-03-05 14:32:48
1521	3	1	95	ダミー11	2025-03-05 14:32:48
1522	3	1	96	ダミー12	2025-03-05 14:32:48
1523	3	1	97	ダミー13	2025-03-05 14:32:48
1524	3	1	98	ダミー14	2025-03-05 14:32:48
1525	3	1	99	ダミー15	2025-03-05 14:32:48
1526	3	1	100	ダミー16	2025-03-05 14:32:48
1527	3	1	101	ダミー17	2025-03-05 14:32:48
1528	3	1	102	ダミー18	2025-03-05 14:32:48
1529	3	1	103	ダミー19	2025-03-05 14:32:48
1530	3	1	104	ダミー20	2025-03-05 14:32:48
1531	3	2	63	2	2025-03-05 14:32:48
1532	3	2	64	部門A	2025-03-05 14:32:48
1533	3	2	65	S002	2025-03-05 14:32:48
1534	3	2	66	システム標準名A	2025-03-05 14:32:48
1535	3	2	67	システム名A	2025-03-05 14:32:48
1536	3	2	68	host-002	2025-03-05 14:32:48
1537	3	2	69	OSv1.0	2025-03-05 14:32:48
1538	3	2	70	2023-01-01	2025-03-05 14:32:48
1539	3	2	71	2023-10-01	2025-03-05 14:32:48
1540	3	2	72	進行中	2025-03-05 14:32:48
1541	3	2	73	2026-03-31	2025-03-05 14:32:48
1542	3	2	74	運用移管済	2025-03-05 14:32:48
1543	3	2	75	2023-11-01	2025-03-05 14:32:48
1544	3	2	76	2024-01-01	2025-03-05 14:32:48
1545	3	2	77	バージョン2.0	2025-03-05 14:32:48
1546	3	2	78	推進中	2025-03-05 14:32:48
1547	3	2	79	ユーザー部門A	2025-03-05 14:32:48
1548	3	2	80	費用部門A	2025-03-05 14:32:48
1549	3	2	81	B001	2025-03-05 14:32:48
1550	3	2	82	予算名A	2025-03-05 14:32:48
1551	3	2	83	100000	2025-03-05 14:32:48
1552	3	2	84	部門B	2025-03-05 14:32:48
1553	3	2	85	ダミー1	2025-03-05 14:32:48
1554	3	2	86	ダミー2	2025-03-05 14:32:48
1555	3	2	87	ダミー3	2025-03-05 14:32:48
1556	3	2	88	ダミー4	2025-03-05 14:32:48
1557	3	2	89	ダミー5	2025-03-05 14:32:48
1558	3	2	90	ダミー6	2025-03-05 14:32:48
1559	3	2	91	ダミー7	2025-03-05 14:32:48
1560	3	2	92	ダミー8	2025-03-05 14:32:48
1561	3	2	93	ダミー9	2025-03-05 14:32:48
1562	3	2	94	ダミー10	2025-03-05 14:32:48
1563	3	2	95	ダミー11	2025-03-05 14:32:48
1564	3	2	96	ダミー12	2025-03-05 14:32:48
1565	3	2	97	ダミー13	2025-03-05 14:32:48
1566	3	2	98	ダミー14	2025-03-05 14:32:48
1567	3	2	99	ダミー15	2025-03-05 14:32:48
1568	3	2	100	ダミー16	2025-03-05 14:32:48
1569	3	2	101	ダミー17	2025-03-05 14:32:48
1570	3	2	102	ダミー18	2025-03-05 14:32:48
1571	3	2	103	ダミー19	2025-03-05 14:32:48
1572	3	2	104	ダミー20	2025-03-05 14:32:48
1573	3	3	63	3	2025-03-05 14:32:48
1574	3	3	64	部門A	2025-03-05 14:32:48
1575	3	3	65	S003	2025-03-05 14:32:48
1576	3	3	66	システム標準名A	2025-03-05 14:32:48
1577	3	3	67	システム名A	2025-03-05 14:32:48
1578	3	3	68	host-003	2025-03-05 14:32:48
1579	3	3	69	OSv1.0	2025-03-05 14:32:48
1581	3	3	71	2023-10-01	2025-03-05 14:32:48
1582	3	3	72	進行中	2025-03-05 14:32:48
1583	3	3	73	2026-03-31	2025-03-05 14:32:48
1584	3	3	74	運用移管済	2025-03-05 14:32:48
1585	3	3	75	2023-11-01	2025-03-05 14:32:48
1586	3	3	76	2024-01-01	2025-03-05 14:32:48
1587	3	3	77	バージョン2.0	2025-03-05 14:32:48
1588	3	3	78	推進中	2025-03-05 14:32:48
1589	3	3	79	ユーザー部門A	2025-03-05 14:32:48
1590	3	3	80	費用部門A	2025-03-05 14:32:48
1591	3	3	81	B001	2025-03-05 14:32:48
1592	3	3	82	予算名A	2025-03-05 14:32:48
1593	3	3	83	100000	2025-03-05 14:32:48
1594	3	3	84	部門B	2025-03-05 14:32:48
1595	3	3	85	ダミー1	2025-03-05 14:32:48
1596	3	3	86	ダミー2	2025-03-05 14:32:48
1597	3	3	87	ダミー3	2025-03-05 14:32:48
1598	3	3	88	ダミー4	2025-03-05 14:32:48
1599	3	3	89	ダミー5	2025-03-05 14:32:48
1600	3	3	90	ダミー6	2025-03-05 14:32:48
1601	3	3	91	ダミー7	2025-03-05 14:32:48
1602	3	3	92	ダミー8	2025-03-05 14:32:48
1603	3	3	93	ダミー9	2025-03-05 14:32:48
1604	3	3	94	ダミー10	2025-03-05 14:32:48
1605	3	3	95	ダミー11	2025-03-05 14:32:48
1606	3	3	96	ダミー12	2025-03-05 14:32:48
1607	3	3	97	ダミー13	2025-03-05 14:32:48
1608	3	3	98	ダミー14	2025-03-05 14:32:48
1609	3	3	99	ダミー15	2025-03-05 14:32:48
1610	3	3	100	ダミー16	2025-03-05 14:32:48
1611	3	3	101	ダミー17	2025-03-05 14:32:48
1612	3	3	102	ダミー18	2025-03-05 14:32:48
1613	3	3	103	ダミー19	2025-03-05 14:32:48
1614	3	3	104	ダミー20	2025-03-05 14:32:48
1615	3	4	63	4	2025-03-05 14:32:48
1616	3	4	64	部門A	2025-03-05 14:32:48
1617	3	4	65	S004	2025-03-05 14:32:48
1618	3	4	66	システム標準名A	2025-03-05 14:32:48
1619	3	4	67	システム名A	2025-03-05 14:32:48
1620	3	4	68	host-004	2025-03-05 14:32:48
1621	3	4	69	OSv1.0	2025-03-05 14:32:48
1622	3	4	70	2023-01-01	2025-03-05 14:32:48
1623	3	4	71	2023-10-01	2025-03-05 14:32:48
1624	3	4	72	進行中	2025-03-05 14:32:48
1625	3	4	73	2026-03-31	2025-03-05 14:32:48
1626	3	4	74	運用移管済	2025-03-05 14:32:48
1627	3	4	75	2023-11-01	2025-03-05 14:32:48
1628	3	4	76	2024-01-01	2025-03-05 14:32:48
1629	3	4	77	バージョン2.0	2025-03-05 14:32:48
1630	3	4	78	推進中	2025-03-05 14:32:48
1631	3	4	79	ユーザー部門A	2025-03-05 14:32:48
1632	3	4	80	費用部門A	2025-03-05 14:32:48
1633	3	4	81	B001	2025-03-05 14:32:48
1634	3	4	82	予算名A	2025-03-05 14:32:48
1635	3	4	83	100000	2025-03-05 14:32:48
1636	3	4	84	部門B	2025-03-05 14:32:48
1637	3	4	85	ダミー1	2025-03-05 14:32:48
1638	3	4	86	ダミー2	2025-03-05 14:32:48
1639	3	4	87	ダミー3	2025-03-05 14:32:48
1640	3	4	88	ダミー4	2025-03-05 14:32:48
1641	3	4	89	ダミー5	2025-03-05 14:32:48
1642	3	4	90	ダミー6	2025-03-05 14:32:48
1643	3	4	91	ダミー7	2025-03-05 14:32:48
1644	3	4	92	ダミー8	2025-03-05 14:32:48
1645	3	4	93	ダミー9	2025-03-05 14:32:48
1646	3	4	94	ダミー10	2025-03-05 14:32:48
1647	3	4	95	ダミー11	2025-03-05 14:32:48
1648	3	4	96	ダミー12	2025-03-05 14:32:48
1649	3	4	97	ダミー13	2025-03-05 14:32:48
1650	3	4	98	ダミー14	2025-03-05 14:32:48
1651	3	4	99	ダミー15	2025-03-05 14:32:48
1652	3	4	100	ダミー16	2025-03-05 14:32:48
1653	3	4	101	ダミー17	2025-03-05 14:32:48
1654	3	4	102	ダミー18	2025-03-05 14:32:48
1655	3	4	103	ダミー19	2025-03-05 14:32:48
1656	3	4	104	ダミー20	2025-03-05 14:32:48
1657	3	5	63	5	2025-03-05 14:32:48
1658	3	5	64	部門A	2025-03-05 14:32:48
1659	3	5	65	S005	2025-03-05 14:32:48
1660	3	5	66	システム標準名B	2025-03-05 14:32:48
1661	3	5	67	システム名B	2025-03-05 14:32:48
1662	3	5	68	host-005	2025-03-05 14:32:48
1663	3	5	69	OSv1.0	2025-03-05 14:32:48
1664	3	5	70	2023-01-01	2025-03-05 14:32:48
1665	3	5	71	2023-10-01	2025-03-05 14:32:48
1666	3	5	72	進行中	2025-03-05 14:32:48
1667	3	5	73	2026-03-31	2025-03-05 14:32:48
1668	3	5	74	運用移管済	2025-03-05 14:32:48
1669	3	5	75	2023-11-01	2025-03-05 14:32:48
1670	3	5	76	2024-01-01	2025-03-05 14:32:48
1671	3	5	77	バージョン2.0	2025-03-05 14:32:48
1672	3	5	78	推進中	2025-03-05 14:32:48
1673	3	5	79	ユーザー部門A	2025-03-05 14:32:48
1674	3	5	80	費用部門A	2025-03-05 14:32:48
1675	3	5	81	B001	2025-03-05 14:32:48
1676	3	5	82	予算名A	2025-03-05 14:32:48
1677	3	5	83	100000	2025-03-05 14:32:48
1678	3	5	84	部門B	2025-03-05 14:32:48
1679	3	5	85	ダミー1	2025-03-05 14:32:48
1680	3	5	86	ダミー2	2025-03-05 14:32:48
1681	3	5	87	ダミー3	2025-03-05 14:32:48
1682	3	5	88	ダミー4	2025-03-05 14:32:48
1683	3	5	89	ダミー5	2025-03-05 14:32:48
1684	3	5	90	ダミー6	2025-03-05 14:32:48
1685	3	5	91	ダミー7	2025-03-05 14:32:48
1686	3	5	92	ダミー8	2025-03-05 14:32:48
1687	3	5	93	ダミー9	2025-03-05 14:32:48
1688	3	5	94	ダミー10	2025-03-05 14:32:48
1689	3	5	95	ダミー11	2025-03-05 14:32:48
1690	3	5	96	ダミー12	2025-03-05 14:32:48
1691	3	5	97	ダミー13	2025-03-05 14:32:48
1692	3	5	98	ダミー14	2025-03-05 14:32:48
1693	3	5	99	ダミー15	2025-03-05 14:32:48
1694	3	5	100	ダミー16	2025-03-05 14:32:48
1695	3	5	101	ダミー17	2025-03-05 14:32:48
1696	3	5	102	ダミー18	2025-03-05 14:32:48
1697	3	5	103	ダミー19	2025-03-05 14:32:48
1698	3	5	104	ダミー20	2025-03-05 14:32:48
1699	3	6	63	6	2025-03-05 14:32:48
1700	3	6	64	部門A	2025-03-05 14:32:48
1701	3	6	65	S006	2025-03-05 14:32:48
1702	3	6	66	システム標準名B	2025-03-05 14:32:48
1703	3	6	67	システム名B	2025-03-05 14:32:48
1704	3	6	68	host-006	2025-03-05 14:32:48
1705	3	6	69	OSv1.0	2025-03-05 14:32:48
1706	3	6	70	2023-01-01	2025-03-05 14:32:48
1707	3	6	71	2023-10-01	2025-03-05 14:32:48
1708	3	6	72	進行中	2025-03-05 14:32:48
1709	3	6	73	2026-03-31	2025-03-05 14:32:48
1710	3	6	74	運用移管済	2025-03-05 14:32:48
1711	3	6	75	2023-11-01	2025-03-05 14:32:48
1712	3	6	76	2024-01-01	2025-03-05 14:32:48
1713	3	6	77	バージョン2.0	2025-03-05 14:32:48
1714	3	6	78	推進中	2025-03-05 14:32:48
1715	3	6	79	ユーザー部門A	2025-03-05 14:32:48
1716	3	6	80	費用部門A	2025-03-05 14:32:48
1717	3	6	81	B001	2025-03-05 14:32:48
1718	3	6	82	予算名A	2025-03-05 14:32:48
1719	3	6	83	100000	2025-03-05 14:32:48
1720	3	6	84	部門B	2025-03-05 14:32:48
1721	3	6	85	ダミー1	2025-03-05 14:32:48
1722	3	6	86	ダミー2	2025-03-05 14:32:48
1723	3	6	87	ダミー3	2025-03-05 14:32:48
1724	3	6	88	ダミー4	2025-03-05 14:32:48
1725	3	6	89	ダミー5	2025-03-05 14:32:48
1726	3	6	90	ダミー6	2025-03-05 14:32:48
1727	3	6	91	ダミー7	2025-03-05 14:32:48
1728	3	6	92	ダミー8	2025-03-05 14:32:48
1729	3	6	93	ダミー9	2025-03-05 14:32:48
1730	3	6	94	ダミー10	2025-03-05 14:32:48
1731	3	6	95	ダミー11	2025-03-05 14:32:48
1732	3	6	96	ダミー12	2025-03-05 14:32:48
1733	3	6	97	ダミー13	2025-03-05 14:32:48
1734	3	6	98	ダミー14	2025-03-05 14:32:48
1735	3	6	99	ダミー15	2025-03-05 14:32:48
1736	3	6	100	ダミー16	2025-03-05 14:32:48
1737	3	6	101	ダミー17	2025-03-05 14:32:48
1738	3	6	102	ダミー18	2025-03-05 14:32:48
1739	3	6	103	ダミー19	2025-03-05 14:32:48
1740	3	6	104	ダミー20	2025-03-05 14:32:48
1741	3	7	63	7	2025-03-05 14:32:48
1742	3	7	64	部門A	2025-03-05 14:32:48
1743	3	7	65	S007	2025-03-05 14:32:48
1744	3	7	66	システム標準名B	2025-03-05 14:32:48
1745	3	7	67	システム名B	2025-03-05 14:32:48
1746	3	7	68	host-007	2025-03-05 14:32:48
1747	3	7	69	OSv1.0	2025-03-05 14:32:48
1748	3	7	70	2023-01-01	2025-03-05 14:32:48
1749	3	7	71	2023-10-01	2025-03-05 14:32:48
1750	3	7	72	進行中	2025-03-05 14:32:48
1751	3	7	73	2026-03-31	2025-03-05 14:32:48
1752	3	7	74	運用移管済	2025-03-05 14:32:48
1753	3	7	75	2023-11-01	2025-03-05 14:32:48
1754	3	7	76	2024-01-01	2025-03-05 14:32:48
1755	3	7	77	バージョン2.0	2025-03-05 14:32:48
1756	3	7	78	推進中	2025-03-05 14:32:48
1757	3	7	79	ユーザー部門A	2025-03-05 14:32:48
1758	3	7	80	費用部門A	2025-03-05 14:32:48
1759	3	7	81	B001	2025-03-05 14:32:48
1760	3	7	82	予算名A	2025-03-05 14:32:48
1761	3	7	83	100000	2025-03-05 14:32:48
1762	3	7	84	部門B	2025-03-05 14:32:48
1763	3	7	85	ダミー1	2025-03-05 14:32:48
1764	3	7	86	ダミー2	2025-03-05 14:32:48
1765	3	7	87	ダミー3	2025-03-05 14:32:48
1766	3	7	88	ダミー4	2025-03-05 14:32:48
1767	3	7	89	ダミー5	2025-03-05 14:32:48
1768	3	7	90	ダミー6	2025-03-05 14:32:48
1769	3	7	91	ダミー7	2025-03-05 14:32:48
1770	3	7	92	ダミー8	2025-03-05 14:32:48
1771	3	7	93	ダミー9	2025-03-05 14:32:48
1772	3	7	94	ダミー10	2025-03-05 14:32:48
1773	3	7	95	ダミー11	2025-03-05 14:32:48
1774	3	7	96	ダミー12	2025-03-05 14:32:48
1775	3	7	97	ダミー13	2025-03-05 14:32:48
1776	3	7	98	ダミー14	2025-03-05 14:32:48
1777	3	7	99	ダミー15	2025-03-05 14:32:48
1778	3	7	100	ダミー16	2025-03-05 14:32:48
1779	3	7	101	ダミー17	2025-03-05 14:32:48
1780	3	7	102	ダミー18	2025-03-05 14:32:48
1781	3	7	103	ダミー19	2025-03-05 14:32:48
1782	3	7	104	ダミー20	2025-03-05 14:32:48
1783	3	8	63	8	2025-03-05 14:32:48
1784	3	8	64	部門A	2025-03-05 14:32:48
1785	3	8	65	S008	2025-03-05 14:32:48
1786	3	8	66	システム標準名B	2025-03-05 14:32:48
1787	3	8	67	システム名B	2025-03-05 14:32:48
1788	3	8	68	host-008	2025-03-05 14:32:48
1789	3	8	69	OSv1.0	2025-03-05 14:32:48
1790	3	8	70	2023-01-01	2025-03-05 14:32:48
1791	3	8	71	2023-10-01	2025-03-05 14:32:48
1792	3	8	72	進行中	2025-03-05 14:32:48
1793	3	8	73	2026-03-31	2025-03-05 14:32:48
1794	3	8	74	運用移管済	2025-03-05 14:32:48
1795	3	8	75	2023-11-01	2025-03-05 14:32:48
1796	3	8	76	2024-01-01	2025-03-05 14:32:48
1797	3	8	77	バージョン2.0	2025-03-05 14:32:48
1798	3	8	78	推進中	2025-03-05 14:32:48
1799	3	8	79	ユーザー部門A	2025-03-05 14:32:48
1800	3	8	80	費用部門A	2025-03-05 14:32:48
1801	3	8	81	B001	2025-03-05 14:32:48
1802	3	8	82	予算名A	2025-03-05 14:32:48
1803	3	8	83	100000	2025-03-05 14:32:48
1804	3	8	84	部門B	2025-03-05 14:32:48
1805	3	8	85	ダミー1	2025-03-05 14:32:48
1806	3	8	86	ダミー2	2025-03-05 14:32:48
1807	3	8	87	ダミー3	2025-03-05 14:32:48
1808	3	8	88	ダミー4	2025-03-05 14:32:48
1809	3	8	89	ダミー5	2025-03-05 14:32:48
1810	3	8	90	ダミー6	2025-03-05 14:32:48
1811	3	8	91	ダミー7	2025-03-05 14:32:48
1812	3	8	92	ダミー8	2025-03-05 14:32:48
1813	3	8	93	ダミー9	2025-03-05 14:32:48
1814	3	8	94	ダミー10	2025-03-05 14:32:48
1815	3	8	95	ダミー11	2025-03-05 14:32:48
1816	3	8	96	ダミー12	2025-03-05 14:32:48
1817	3	8	97	ダミー13	2025-03-05 14:32:48
1818	3	8	98	ダミー14	2025-03-05 14:32:48
1819	3	8	99	ダミー15	2025-03-05 14:32:48
1820	3	8	100	ダミー16	2025-03-05 14:32:48
1821	3	8	101	ダミー17	2025-03-05 14:32:48
1822	3	8	102	ダミー18	2025-03-05 14:32:48
1823	3	8	103	ダミー19	2025-03-05 14:32:48
1824	3	8	104	ダミー20	2025-03-05 14:32:48
1825	3	9	63	9	2025-03-05 14:32:48
1826	3	9	64	部門A	2025-03-05 14:32:48
1827	3	9	65	S009	2025-03-05 14:32:48
1828	3	9	66	システム標準名C	2025-03-05 14:32:48
1829	3	9	67	システム名C	2025-03-05 14:32:48
1830	3	9	68	host-009	2025-03-05 14:32:48
1831	3	9	69	OSv1.0	2025-03-05 14:32:48
1832	3	9	70	2023-01-01	2025-03-05 14:32:48
1833	3	9	71	2023-10-01	2025-03-05 14:32:48
1834	3	9	72	進行中	2025-03-05 14:32:48
1835	3	9	73	2026-03-31	2025-03-05 14:32:48
1836	3	9	74	運用移管済	2025-03-05 14:32:48
1837	3	9	75	2023-11-01	2025-03-05 14:32:48
1838	3	9	76	2024-01-01	2025-03-05 14:32:48
1839	3	9	77	バージョン2.0	2025-03-05 14:32:48
1840	3	9	78	推進中	2025-03-05 14:32:48
1841	3	9	79	ユーザー部門A	2025-03-05 14:32:48
1842	3	9	80	費用部門A	2025-03-05 14:32:48
1843	3	9	81	B001	2025-03-05 14:32:48
1844	3	9	82	予算名A	2025-03-05 14:32:48
1845	3	9	83	100000	2025-03-05 14:32:48
1846	3	9	84	部門B	2025-03-05 14:32:48
1847	3	9	85	ダミー1	2025-03-05 14:32:48
1848	3	9	86	ダミー2	2025-03-05 14:32:48
1849	3	9	87	ダミー3	2025-03-05 14:32:48
1850	3	9	88	ダミー4	2025-03-05 14:32:48
1851	3	9	89	ダミー5	2025-03-05 14:32:48
1852	3	9	90	ダミー6	2025-03-05 14:32:48
1853	3	9	91	ダミー7	2025-03-05 14:32:48
1854	3	9	92	ダミー8	2025-03-05 14:32:48
1855	3	9	93	ダミー9	2025-03-05 14:32:48
1856	3	9	94	ダミー10	2025-03-05 14:32:48
1857	3	9	95	ダミー11	2025-03-05 14:32:48
1858	3	9	96	ダミー12	2025-03-05 14:32:48
1859	3	9	97	ダミー13	2025-03-05 14:32:48
1860	3	9	98	ダミー14	2025-03-05 14:32:48
1861	3	9	99	ダミー15	2025-03-05 14:32:48
1862	3	9	100	ダミー16	2025-03-05 14:32:48
1863	3	9	101	ダミー17	2025-03-05 14:32:48
1864	3	9	102	ダミー18	2025-03-05 14:32:48
1865	3	9	103	ダミー19	2025-03-05 14:32:48
1866	3	9	104	ダミー20	2025-03-05 14:32:48
1867	3	10	63	10	2025-03-05 14:32:48
1868	3	10	64	部門A	2025-03-05 14:32:48
1869	3	10	65	S010	2025-03-05 14:32:48
1870	3	10	66	システム標準名C	2025-03-05 14:32:48
1871	3	10	67	システム名C	2025-03-05 14:32:48
1872	3	10	68	host-010	2025-03-05 14:32:48
1873	3	10	69	OSv1.0	2025-03-05 14:32:48
1875	3	10	71	2023-10-01	2025-03-05 14:32:48
1876	3	10	72	進行中	2025-03-05 14:32:48
1877	3	10	73	2026-03-31	2025-03-05 14:32:48
1878	3	10	74	運用移管済	2025-03-05 14:32:48
1879	3	10	75	2023-11-01	2025-03-05 14:32:48
1880	3	10	76	2024-01-01	2025-03-05 14:32:48
1881	3	10	77	バージョン2.0	2025-03-05 14:32:48
1882	3	10	78	推進中	2025-03-05 14:32:48
1883	3	10	79	ユーザー部門A	2025-03-05 14:32:48
1884	3	10	80	費用部門A	2025-03-05 14:32:48
1885	3	10	81	B001	2025-03-05 14:32:48
1886	3	10	82	予算名A	2025-03-05 14:32:48
1887	3	10	83	100000	2025-03-05 14:32:48
1888	3	10	84	部門B	2025-03-05 14:32:48
1889	3	10	85	ダミー1	2025-03-05 14:32:48
1890	3	10	86	ダミー2	2025-03-05 14:32:48
1891	3	10	87	ダミー3	2025-03-05 14:32:48
1892	3	10	88	ダミー4	2025-03-05 14:32:48
1893	3	10	89	ダミー5	2025-03-05 14:32:48
1894	3	10	90	ダミー6	2025-03-05 14:32:48
1895	3	10	91	ダミー7	2025-03-05 14:32:48
1896	3	10	92	ダミー8	2025-03-05 14:32:48
1897	3	10	93	ダミー9	2025-03-05 14:32:48
1898	3	10	94	ダミー10	2025-03-05 14:32:48
1899	3	10	95	ダミー11	2025-03-05 14:32:48
1900	3	10	96	ダミー12	2025-03-05 14:32:48
1901	3	10	97	ダミー13	2025-03-05 14:32:48
1902	3	10	98	ダミー14	2025-03-05 14:32:48
1903	3	10	99	ダミー15	2025-03-05 14:32:48
1904	3	10	100	ダミー16	2025-03-05 14:32:48
1905	3	10	101	ダミー17	2025-03-05 14:32:48
1906	3	10	102	ダミー18	2025-03-05 14:32:48
1907	3	10	103	ダミー19	2025-03-05 14:32:48
1908	3	10	104	ダミー20	2025-03-05 14:32:48
1909	3	11	63	11	2025-03-05 14:32:48
1910	3	11	64	部門A	2025-03-05 14:32:48
1911	3	11	65	S011	2025-03-05 14:32:48
1912	3	11	66	システム標準名C	2025-03-05 14:32:48
1913	3	11	67	システム名C	2025-03-05 14:32:48
1914	3	11	68	host-011	2025-03-05 14:32:48
1915	3	11	69	OSv1.0	2025-03-05 14:32:48
1916	3	11	70	2023-01-01	2025-03-05 14:32:48
1917	3	11	71	2023-10-01	2025-03-05 14:32:48
1918	3	11	72	進行中	2025-03-05 14:32:48
1919	3	11	73	2026-03-31	2025-03-05 14:32:48
1920	3	11	74	運用移管済	2025-03-05 14:32:48
1921	3	11	75	2023-11-01	2025-03-05 14:32:48
1922	3	11	76	2024-01-01	2025-03-05 14:32:48
1923	3	11	77	バージョン2.0	2025-03-05 14:32:48
1924	3	11	78	推進中	2025-03-05 14:32:48
1925	3	11	79	ユーザー部門A	2025-03-05 14:32:48
1926	3	11	80	費用部門A	2025-03-05 14:32:48
1927	3	11	81	B001	2025-03-05 14:32:48
1928	3	11	82	予算名A	2025-03-05 14:32:48
1929	3	11	83	100000	2025-03-05 14:32:48
1930	3	11	84	部門B	2025-03-05 14:32:48
1931	3	11	85	ダミー1	2025-03-05 14:32:48
1932	3	11	86	ダミー2	2025-03-05 14:32:48
1933	3	11	87	ダミー3	2025-03-05 14:32:48
1934	3	11	88	ダミー4	2025-03-05 14:32:48
1935	3	11	89	ダミー5	2025-03-05 14:32:48
1936	3	11	90	ダミー6	2025-03-05 14:32:48
1937	3	11	91	ダミー7	2025-03-05 14:32:48
1938	3	11	92	ダミー8	2025-03-05 14:32:48
1939	3	11	93	ダミー9	2025-03-05 14:32:48
1940	3	11	94	ダミー10	2025-03-05 14:32:48
1941	3	11	95	ダミー11	2025-03-05 14:32:48
1942	3	11	96	ダミー12	2025-03-05 14:32:48
1943	3	11	97	ダミー13	2025-03-05 14:32:48
1944	3	11	98	ダミー14	2025-03-05 14:32:48
1945	3	11	99	ダミー15	2025-03-05 14:32:48
1946	3	11	100	ダミー16	2025-03-05 14:32:48
1947	3	11	101	ダミー17	2025-03-05 14:32:48
1948	3	11	102	ダミー18	2025-03-05 14:32:48
1949	3	11	103	ダミー19	2025-03-05 14:32:48
1950	3	11	104	ダミー20	2025-03-05 14:32:48
1951	3	12	63	12	2025-03-05 14:32:48
1952	3	12	64	部門A	2025-03-05 14:32:48
1953	3	12	65	S012	2025-03-05 14:32:48
1954	3	12	66	システム標準名C	2025-03-05 14:32:48
1955	3	12	67	システム名C	2025-03-05 14:32:48
1956	3	12	68	host-012	2025-03-05 14:32:48
1957	3	12	69	OSv1.0	2025-03-05 14:32:48
1958	3	12	70	2023-01-01	2025-03-05 14:32:48
1959	3	12	71	2023-10-01	2025-03-05 14:32:48
1960	3	12	72	進行中	2025-03-05 14:32:48
1961	3	12	73	2026-03-31	2025-03-05 14:32:48
1962	3	12	74	運用移管済	2025-03-05 14:32:48
1963	3	12	75	2023-11-01	2025-03-05 14:32:48
1964	3	12	76	2024-01-01	2025-03-05 14:32:48
1965	3	12	77	バージョン2.0	2025-03-05 14:32:48
1966	3	12	78	推進中	2025-03-05 14:32:48
1967	3	12	79	ユーザー部門A	2025-03-05 14:32:48
1968	3	12	80	費用部門A	2025-03-05 14:32:48
1969	3	12	81	B001	2025-03-05 14:32:48
1970	3	12	82	予算名A	2025-03-05 14:32:48
1971	3	12	83	100000	2025-03-05 14:32:48
1972	3	12	84	部門B	2025-03-05 14:32:48
1973	3	12	85	ダミー1	2025-03-05 14:32:48
1974	3	12	86	ダミー2	2025-03-05 14:32:48
1975	3	12	87	ダミー3	2025-03-05 14:32:48
1976	3	12	88	ダミー4	2025-03-05 14:32:48
1977	3	12	89	ダミー5	2025-03-05 14:32:48
1978	3	12	90	ダミー6	2025-03-05 14:32:48
1979	3	12	91	ダミー7	2025-03-05 14:32:48
1980	3	12	92	ダミー8	2025-03-05 14:32:48
1981	3	12	93	ダミー9	2025-03-05 14:32:48
1982	3	12	94	ダミー10	2025-03-05 14:32:48
1983	3	12	95	ダミー11	2025-03-05 14:32:48
1984	3	12	96	ダミー12	2025-03-05 14:32:48
1985	3	12	97	ダミー13	2025-03-05 14:32:48
1986	3	12	98	ダミー14	2025-03-05 14:32:48
1987	3	12	99	ダミー15	2025-03-05 14:32:48
1988	3	12	100	ダミー16	2025-03-05 14:32:48
1989	3	12	101	ダミー17	2025-03-05 14:32:48
1990	3	12	102	ダミー18	2025-03-05 14:32:48
1991	3	12	103	ダミー19	2025-03-05 14:32:48
1992	3	12	104	ダミー20	2025-03-05 14:32:48
1993	3	13	63	13	2025-03-05 14:32:48
1994	3	13	64	部門A	2025-03-05 14:32:48
1995	3	13	65	S013	2025-03-05 14:32:48
1996	3	13	66	システム標準名D	2025-03-05 14:32:48
1997	3	13	67	システム名D	2025-03-05 14:32:48
1998	3	13	68	host-013	2025-03-05 14:32:48
1999	3	13	69	OSv1.0	2025-03-05 14:32:48
2000	3	13	70	2023-01-01	2025-03-05 14:32:48
2001	3	13	71	2023-10-01	2025-03-05 14:32:48
2002	3	13	72	進行中	2025-03-05 14:32:48
2003	3	13	73	2026-03-31	2025-03-05 14:32:48
2004	3	13	74	運用移管済	2025-03-05 14:32:48
2005	3	13	75	2023-11-01	2025-03-05 14:32:48
2006	3	13	76	2024-01-01	2025-03-05 14:32:48
2007	3	13	77	バージョン2.0	2025-03-05 14:32:48
2008	3	13	78	推進中	2025-03-05 14:32:48
2009	3	13	79	ユーザー部門A	2025-03-05 14:32:48
2010	3	13	80	費用部門A	2025-03-05 14:32:48
2011	3	13	81	B001	2025-03-05 14:32:48
2012	3	13	82	予算名A	2025-03-05 14:32:48
2013	3	13	83	100000	2025-03-05 14:32:48
2014	3	13	84	部門B	2025-03-05 14:32:48
2015	3	13	85	ダミー1	2025-03-05 14:32:48
2016	3	13	86	ダミー2	2025-03-05 14:32:48
2017	3	13	87	ダミー3	2025-03-05 14:32:48
2018	3	13	88	ダミー4	2025-03-05 14:32:48
2019	3	13	89	ダミー5	2025-03-05 14:32:48
2020	3	13	90	ダミー6	2025-03-05 14:32:48
2021	3	13	91	ダミー7	2025-03-05 14:32:48
2022	3	13	92	ダミー8	2025-03-05 14:32:48
2023	3	13	93	ダミー9	2025-03-05 14:32:48
2024	3	13	94	ダミー10	2025-03-05 14:32:48
2025	3	13	95	ダミー11	2025-03-05 14:32:48
2026	3	13	96	ダミー12	2025-03-05 14:32:48
2027	3	13	97	ダミー13	2025-03-05 14:32:48
2028	3	13	98	ダミー14	2025-03-05 14:32:48
2029	3	13	99	ダミー15	2025-03-05 14:32:48
2030	3	13	100	ダミー16	2025-03-05 14:32:48
2031	3	13	101	ダミー17	2025-03-05 14:32:48
2032	3	13	102	ダミー18	2025-03-05 14:32:48
2033	3	13	103	ダミー19	2025-03-05 14:32:48
2034	3	13	104	ダミー20	2025-03-05 14:32:48
2035	3	14	63	14	2025-03-05 14:32:48
2036	3	14	64	部門A	2025-03-05 14:32:48
2037	3	14	65	S014	2025-03-05 14:32:48
2038	3	14	66	システム標準名D	2025-03-05 14:32:48
2039	3	14	67	システム名D	2025-03-05 14:32:48
2040	3	14	68	host-014	2025-03-05 14:32:48
2041	3	14	69	OSv1.0	2025-03-05 14:32:48
2042	3	14	70	2023-01-01	2025-03-05 14:32:48
2043	3	14	71	2023-10-01	2025-03-05 14:32:48
2044	3	14	72	進行中	2025-03-05 14:32:48
2045	3	14	73	2026-03-31	2025-03-05 14:32:48
2046	3	14	74	運用移管済	2025-03-05 14:32:48
2047	3	14	75	2023-11-01	2025-03-05 14:32:48
2048	3	14	76	2024-01-01	2025-03-05 14:32:48
2049	3	14	77	バージョン2.0	2025-03-05 14:32:48
2050	3	14	78	推進中	2025-03-05 14:32:48
2051	3	14	79	ユーザー部門A	2025-03-05 14:32:48
2052	3	14	80	費用部門A	2025-03-05 14:32:48
2053	3	14	81	B001	2025-03-05 14:32:48
2054	3	14	82	予算名A	2025-03-05 14:32:48
2055	3	14	83	100000	2025-03-05 14:32:48
2056	3	14	84	部門B	2025-03-05 14:32:48
2057	3	14	85	ダミー1	2025-03-05 14:32:48
2058	3	14	86	ダミー2	2025-03-05 14:32:48
2059	3	14	87	ダミー3	2025-03-05 14:32:48
2060	3	14	88	ダミー4	2025-03-05 14:32:48
2061	3	14	89	ダミー5	2025-03-05 14:32:48
2062	3	14	90	ダミー6	2025-03-05 14:32:48
2063	3	14	91	ダミー7	2025-03-05 14:32:48
2064	3	14	92	ダミー8	2025-03-05 14:32:48
2065	3	14	93	ダミー9	2025-03-05 14:32:48
2066	3	14	94	ダミー10	2025-03-05 14:32:48
2067	3	14	95	ダミー11	2025-03-05 14:32:48
2068	3	14	96	ダミー12	2025-03-05 14:32:48
2069	3	14	97	ダミー13	2025-03-05 14:32:48
2070	3	14	98	ダミー14	2025-03-05 14:32:48
2071	3	14	99	ダミー15	2025-03-05 14:32:48
2072	3	14	100	ダミー16	2025-03-05 14:32:48
2073	3	14	101	ダミー17	2025-03-05 14:32:48
2074	3	14	102	ダミー18	2025-03-05 14:32:48
2075	3	14	103	ダミー19	2025-03-05 14:32:48
2076	3	14	104	ダミー20	2025-03-05 14:32:48
2077	3	15	63	15	2025-03-05 14:32:48
2078	3	15	64	部門A	2025-03-05 14:32:48
2079	3	15	65	S015	2025-03-05 14:32:48
2080	3	15	66	システム標準名D	2025-03-05 14:32:48
2081	3	15	67	システム名D	2025-03-05 14:32:48
2082	3	15	68	host-015	2025-03-05 14:32:48
2083	3	15	69	OSv1.0	2025-03-05 14:32:48
2084	3	15	70	2023-01-01	2025-03-05 14:32:48
2085	3	15	71	2023-10-01	2025-03-05 14:32:48
2086	3	15	72	進行中	2025-03-05 14:32:48
2087	3	15	73	2026-03-31	2025-03-05 14:32:48
2088	3	15	74	運用移管済	2025-03-05 14:32:48
2089	3	15	75	2023-11-01	2025-03-05 14:32:48
2090	3	15	76	2024-01-01	2025-03-05 14:32:48
2091	3	15	77	バージョン2.0	2025-03-05 14:32:48
2092	3	15	78	推進中	2025-03-05 14:32:48
2093	3	15	79	ユーザー部門A	2025-03-05 14:32:48
2094	3	15	80	費用部門A	2025-03-05 14:32:48
2095	3	15	81	B001	2025-03-05 14:32:48
2096	3	15	82	予算名A	2025-03-05 14:32:48
2097	3	15	83	100000	2025-03-05 14:32:48
2098	3	15	84	部門B	2025-03-05 14:32:48
2099	3	15	85	ダミー1	2025-03-05 14:32:48
2100	3	15	86	ダミー2	2025-03-05 14:32:48
2101	3	15	87	ダミー3	2025-03-05 14:32:48
2102	3	15	88	ダミー4	2025-03-05 14:32:48
2103	3	15	89	ダミー5	2025-03-05 14:32:48
2104	3	15	90	ダミー6	2025-03-05 14:32:48
2105	3	15	91	ダミー7	2025-03-05 14:32:48
2106	3	15	92	ダミー8	2025-03-05 14:32:48
2107	3	15	93	ダミー9	2025-03-05 14:32:48
2108	3	15	94	ダミー10	2025-03-05 14:32:48
2109	3	15	95	ダミー11	2025-03-05 14:32:48
2110	3	15	96	ダミー12	2025-03-05 14:32:48
2111	3	15	97	ダミー13	2025-03-05 14:32:48
2112	3	15	98	ダミー14	2025-03-05 14:32:48
2113	3	15	99	ダミー15	2025-03-05 14:32:48
2114	3	15	100	ダミー16	2025-03-05 14:32:48
2115	3	15	101	ダミー17	2025-03-05 14:32:48
2116	3	15	102	ダミー18	2025-03-05 14:32:48
2117	3	15	103	ダミー19	2025-03-05 14:32:48
2118	3	15	104	ダミー20	2025-03-05 14:32:48
2119	3	16	63	16	2025-03-05 14:32:48
2120	3	16	64	部門A	2025-03-05 14:32:48
2121	3	16	65	S016	2025-03-05 14:32:48
2122	3	16	66	システム標準名D	2025-03-05 14:32:48
2123	3	16	67	システム名D	2025-03-05 14:32:48
2124	3	16	68	host-016	2025-03-05 14:32:48
2125	3	16	69	OSv1.0	2025-03-05 14:32:48
2126	3	16	70	2023-01-01	2025-03-05 14:32:48
2127	3	16	71	2023-10-01	2025-03-05 14:32:48
2128	3	16	72	進行中	2025-03-05 14:32:48
2129	3	16	73	2026-03-31	2025-03-05 14:32:48
2130	3	16	74	運用移管済	2025-03-05 14:32:48
2131	3	16	75	2023-11-01	2025-03-05 14:32:48
2132	3	16	76	2024-01-01	2025-03-05 14:32:48
2133	3	16	77	バージョン2.0	2025-03-05 14:32:48
2134	3	16	78	推進中	2025-03-05 14:32:48
2135	3	16	79	ユーザー部門A	2025-03-05 14:32:48
2136	3	16	80	費用部門A	2025-03-05 14:32:48
2137	3	16	81	B001	2025-03-05 14:32:48
2138	3	16	82	予算名A	2025-03-05 14:32:48
2139	3	16	83	100000	2025-03-05 14:32:48
2140	3	16	84	部門B	2025-03-05 14:32:48
2141	3	16	85	ダミー1	2025-03-05 14:32:48
2142	3	16	86	ダミー2	2025-03-05 14:32:48
2143	3	16	87	ダミー3	2025-03-05 14:32:48
2144	3	16	88	ダミー4	2025-03-05 14:32:48
2145	3	16	89	ダミー5	2025-03-05 14:32:48
2146	3	16	90	ダミー6	2025-03-05 14:32:48
2147	3	16	91	ダミー7	2025-03-05 14:32:48
2148	3	16	92	ダミー8	2025-03-05 14:32:48
2149	3	16	93	ダミー9	2025-03-05 14:32:48
2150	3	16	94	ダミー10	2025-03-05 14:32:48
2151	3	16	95	ダミー11	2025-03-05 14:32:48
2152	3	16	96	ダミー12	2025-03-05 14:32:48
2153	3	16	97	ダミー13	2025-03-05 14:32:48
2154	3	16	98	ダミー14	2025-03-05 14:32:48
2155	3	16	99	ダミー15	2025-03-05 14:32:48
2156	3	16	100	ダミー16	2025-03-05 14:32:48
2157	3	16	101	ダミー17	2025-03-05 14:32:48
2158	3	16	102	ダミー18	2025-03-05 14:32:48
2159	3	16	103	ダミー19	2025-03-05 14:32:48
2160	3	16	104	ダミー20	2025-03-05 14:32:48
2161	3	17	63	17	2025-03-05 14:32:48
2162	3	17	64	部門A	2025-03-05 14:32:48
2163	3	17	65	S017	2025-03-05 14:32:48
2164	3	17	66	システム標準名E	2025-03-05 14:32:48
2165	3	17	67	システム名E	2025-03-05 14:32:48
2166	3	17	68	host-017	2025-03-05 14:32:48
2167	3	17	69	OSv1.0	2025-03-05 14:32:48
2168	3	17	70	2023-01-01	2025-03-05 14:32:48
2169	3	17	71	2023-10-01	2025-03-05 14:32:48
2170	3	17	72	進行中	2025-03-05 14:32:48
2171	3	17	73	2026-03-31	2025-03-05 14:32:48
2172	3	17	74	運用移管済	2025-03-05 14:32:48
2173	3	17	75	2023-11-01	2025-03-05 14:32:48
2174	3	17	76	2024-01-01	2025-03-05 14:32:48
2175	3	17	77	バージョン2.0	2025-03-05 14:32:48
2176	3	17	78	推進中	2025-03-05 14:32:48
2177	3	17	79	ユーザー部門A	2025-03-05 14:32:48
2178	3	17	80	費用部門A	2025-03-05 14:32:48
2179	3	17	81	B001	2025-03-05 14:32:48
2180	3	17	82	予算名A	2025-03-05 14:32:48
2181	3	17	83	100000	2025-03-05 14:32:48
2182	3	17	84	部門B	2025-03-05 14:32:48
2183	3	17	85	ダミー1	2025-03-05 14:32:48
2184	3	17	86	ダミー2	2025-03-05 14:32:48
2185	3	17	87	ダミー3	2025-03-05 14:32:48
2186	3	17	88	ダミー4	2025-03-05 14:32:48
2187	3	17	89	ダミー5	2025-03-05 14:32:48
2188	3	17	90	ダミー6	2025-03-05 14:32:48
2189	3	17	91	ダミー7	2025-03-05 14:32:48
2190	3	17	92	ダミー8	2025-03-05 14:32:48
2191	3	17	93	ダミー9	2025-03-05 14:32:48
2192	3	17	94	ダミー10	2025-03-05 14:32:48
2193	3	17	95	ダミー11	2025-03-05 14:32:48
2194	3	17	96	ダミー12	2025-03-05 14:32:48
2195	3	17	97	ダミー13	2025-03-05 14:32:48
2196	3	17	98	ダミー14	2025-03-05 14:32:48
2197	3	17	99	ダミー15	2025-03-05 14:32:48
2198	3	17	100	ダミー16	2025-03-05 14:32:48
2199	3	17	101	ダミー17	2025-03-05 14:32:48
2200	3	17	102	ダミー18	2025-03-05 14:32:48
2201	3	17	103	ダミー19	2025-03-05 14:32:48
2202	3	17	104	ダミー20	2025-03-05 14:32:48
2203	3	18	63	18	2025-03-05 14:32:48
2204	3	18	64	部門A	2025-03-05 14:32:48
2205	3	18	65	S018	2025-03-05 14:32:48
2206	3	18	66	システム標準名E	2025-03-05 14:32:48
2207	3	18	67	システム名E	2025-03-05 14:32:48
2208	3	18	68	host-018	2025-03-05 14:32:48
2209	3	18	69	OSv1.0	2025-03-05 14:32:48
2210	3	18	70	2023-01-01	2025-03-05 14:32:48
2211	3	18	71	2023-10-01	2025-03-05 14:32:48
2212	3	18	72	進行中	2025-03-05 14:32:48
2213	3	18	73	2026-03-31	2025-03-05 14:32:48
2214	3	18	74	運用移管済	2025-03-05 14:32:48
2215	3	18	75	2023-11-01	2025-03-05 14:32:48
2216	3	18	76	2024-01-01	2025-03-05 14:32:48
2217	3	18	77	バージョン2.0	2025-03-05 14:32:48
2218	3	18	78	推進中	2025-03-05 14:32:48
2219	3	18	79	ユーザー部門A	2025-03-05 14:32:48
2220	3	18	80	費用部門A	2025-03-05 14:32:48
2221	3	18	81	B001	2025-03-05 14:32:48
2222	3	18	82	予算名A	2025-03-05 14:32:48
2223	3	18	83	100000	2025-03-05 14:32:48
2224	3	18	84	部門B	2025-03-05 14:32:48
2225	3	18	85	ダミー1	2025-03-05 14:32:48
2226	3	18	86	ダミー2	2025-03-05 14:32:48
2227	3	18	87	ダミー3	2025-03-05 14:32:48
2228	3	18	88	ダミー4	2025-03-05 14:32:48
2229	3	18	89	ダミー5	2025-03-05 14:32:48
2230	3	18	90	ダミー6	2025-03-05 14:32:48
2231	3	18	91	ダミー7	2025-03-05 14:32:48
2232	3	18	92	ダミー8	2025-03-05 14:32:48
2233	3	18	93	ダミー9	2025-03-05 14:32:48
2234	3	18	94	ダミー10	2025-03-05 14:32:48
2235	3	18	95	ダミー11	2025-03-05 14:32:48
2236	3	18	96	ダミー12	2025-03-05 14:32:48
2237	3	18	97	ダミー13	2025-03-05 14:32:48
2238	3	18	98	ダミー14	2025-03-05 14:32:48
2239	3	18	99	ダミー15	2025-03-05 14:32:48
2240	3	18	100	ダミー16	2025-03-05 14:32:48
2241	3	18	101	ダミー17	2025-03-05 14:32:48
2242	3	18	102	ダミー18	2025-03-05 14:32:48
2243	3	18	103	ダミー19	2025-03-05 14:32:48
2244	3	18	104	ダミー20	2025-03-05 14:32:48
2245	3	19	63	19	2025-03-05 14:32:48
2246	3	19	64	部門A	2025-03-05 14:32:48
2247	3	19	65	S019	2025-03-05 14:32:48
2248	3	19	66	システム標準名E	2025-03-05 14:32:48
2249	3	19	67	システム名E	2025-03-05 14:32:48
2250	3	19	68	host-019	2025-03-05 14:32:48
2251	3	19	69	OSv1.0	2025-03-05 14:32:48
2252	3	19	70	2023-01-01	2025-03-05 14:32:48
2253	3	19	71	2023-10-01	2025-03-05 14:32:48
2254	3	19	72	進行中	2025-03-05 14:32:48
2255	3	19	73	2026-03-31	2025-03-05 14:32:48
2256	3	19	74	運用移管済	2025-03-05 14:32:48
2257	3	19	75	2023-11-01	2025-03-05 14:32:48
2258	3	19	76	2024-01-01	2025-03-05 14:32:48
2259	3	19	77	バージョン2.0	2025-03-05 14:32:48
2260	3	19	78	推進中	2025-03-05 14:32:48
2261	3	19	79	ユーザー部門A	2025-03-05 14:32:48
2262	3	19	80	費用部門A	2025-03-05 14:32:48
2263	3	19	81	B001	2025-03-05 14:32:48
2264	3	19	82	予算名A	2025-03-05 14:32:48
2265	3	19	83	100000	2025-03-05 14:32:48
2266	3	19	84	部門B	2025-03-05 14:32:48
2267	3	19	85	ダミー1	2025-03-05 14:32:48
2268	3	19	86	ダミー2	2025-03-05 14:32:48
2269	3	19	87	ダミー3	2025-03-05 14:32:48
2270	3	19	88	ダミー4	2025-03-05 14:32:48
2271	3	19	89	ダミー5	2025-03-05 14:32:48
2272	3	19	90	ダミー6	2025-03-05 14:32:48
2273	3	19	91	ダミー7	2025-03-05 14:32:48
2274	3	19	92	ダミー8	2025-03-05 14:32:48
2275	3	19	93	ダミー9	2025-03-05 14:32:48
2276	3	19	94	ダミー10	2025-03-05 14:32:48
2277	3	19	95	ダミー11	2025-03-05 14:32:48
2278	3	19	96	ダミー12	2025-03-05 14:32:48
2279	3	19	97	ダミー13	2025-03-05 14:32:48
2280	3	19	98	ダミー14	2025-03-05 14:32:48
2281	3	19	99	ダミー15	2025-03-05 14:32:48
2282	3	19	100	ダミー16	2025-03-05 14:32:48
2283	3	19	101	ダミー17	2025-03-05 14:32:48
2284	3	19	102	ダミー18	2025-03-05 14:32:48
2285	3	19	103	ダミー19	2025-03-05 14:32:48
2286	3	19	104	ダミー20	2025-03-05 14:32:48
2287	3	20	63	20	2025-03-05 14:32:48
2288	3	20	64	部門A	2025-03-05 14:32:48
2289	3	20	65	S020	2025-03-05 14:32:48
2290	3	20	66	システム標準名E	2025-03-05 14:32:48
2291	3	20	67	システム名E	2025-03-05 14:32:48
2292	3	20	68	host-020	2025-03-05 14:32:48
2293	3	20	69	OSv1.0	2025-03-05 14:32:48
2294	3	20	70	2023-01-01	2025-03-05 14:32:48
2295	3	20	71	2023-10-01	2025-03-05 14:32:48
2296	3	20	72	進行中	2025-03-05 14:32:48
2297	3	20	73	2026-03-31	2025-03-05 14:32:48
2298	3	20	74	運用移管済	2025-03-05 14:32:48
2299	3	20	75	2023-11-01	2025-03-05 14:32:48
2300	3	20	76	2024-01-01	2025-03-05 14:32:48
2301	3	20	77	バージョン2.0	2025-03-05 14:32:48
2302	3	20	78	推進中	2025-03-05 14:32:48
2303	3	20	79	ユーザー部門A	2025-03-05 14:32:48
2304	3	20	80	費用部門A	2025-03-05 14:32:48
2305	3	20	81	B001	2025-03-05 14:32:48
2306	3	20	82	予算名A	2025-03-05 14:32:48
2307	3	20	83	100000	2025-03-05 14:32:48
2308	3	20	84	部門B	2025-03-05 14:32:48
2309	3	20	85	ダミー1	2025-03-05 14:32:48
2310	3	20	86	ダミー2	2025-03-05 14:32:48
2311	3	20	87	ダミー3	2025-03-05 14:32:48
2312	3	20	88	ダミー4	2025-03-05 14:32:48
2313	3	20	89	ダミー5	2025-03-05 14:32:48
2314	3	20	90	ダミー6	2025-03-05 14:32:48
2315	3	20	91	ダミー7	2025-03-05 14:32:48
2316	3	20	92	ダミー8	2025-03-05 14:32:48
2317	3	20	93	ダミー9	2025-03-05 14:32:48
2318	3	20	94	ダミー10	2025-03-05 14:32:48
2319	3	20	95	ダミー11	2025-03-05 14:32:48
2320	3	20	96	ダミー12	2025-03-05 14:32:48
2321	3	20	97	ダミー13	2025-03-05 14:32:48
2322	3	20	98	ダミー14	2025-03-05 14:32:48
2323	3	20	99	ダミー15	2025-03-05 14:32:48
2324	3	20	100	ダミー16	2025-03-05 14:32:48
2325	3	20	101	ダミー17	2025-03-05 14:32:48
2326	3	20	102	ダミー18	2025-03-05 14:32:48
2327	3	20	103	ダミー19	2025-03-05 14:32:48
2328	3	20	104	ダミー20	2025-03-05 14:32:48
2329	3	21	63	21	2025-03-05 14:32:48
2330	3	21	64	部門A	2025-03-05 14:32:48
2331	3	21	65	S021	2025-03-05 14:32:48
2332	3	21	66	システム標準名F	2025-03-05 14:32:48
2333	3	21	67	システム名F	2025-03-05 14:32:48
2334	3	21	68	host-021	2025-03-05 14:32:48
2335	3	21	69	OSv1.0	2025-03-05 14:32:48
2336	3	21	70	2023-01-01	2025-03-05 14:32:48
2337	3	21	71	2023-10-01	2025-03-05 14:32:48
2338	3	21	72	進行中	2025-03-05 14:32:48
2339	3	21	73	2026-03-31	2025-03-05 14:32:48
2340	3	21	74	運用移管済	2025-03-05 14:32:48
2341	3	21	75	2023-11-01	2025-03-05 14:32:48
2342	3	21	76	2024-01-01	2025-03-05 14:32:48
2343	3	21	77	バージョン2.0	2025-03-05 14:32:48
2344	3	21	78	推進中	2025-03-05 14:32:48
2345	3	21	79	ユーザー部門A	2025-03-05 14:32:48
2346	3	21	80	費用部門A	2025-03-05 14:32:48
2347	3	21	81	B001	2025-03-05 14:32:48
2348	3	21	82	予算名A	2025-03-05 14:32:48
2349	3	21	83	100000	2025-03-05 14:32:48
2350	3	21	84	部門B	2025-03-05 14:32:48
2351	3	21	85	ダミー1	2025-03-05 14:32:48
2352	3	21	86	ダミー2	2025-03-05 14:32:48
2353	3	21	87	ダミー3	2025-03-05 14:32:48
2354	3	21	88	ダミー4	2025-03-05 14:32:48
2355	3	21	89	ダミー5	2025-03-05 14:32:48
2356	3	21	90	ダミー6	2025-03-05 14:32:48
2357	3	21	91	ダミー7	2025-03-05 14:32:48
2358	3	21	92	ダミー8	2025-03-05 14:32:48
2359	3	21	93	ダミー9	2025-03-05 14:32:48
2360	3	21	94	ダミー10	2025-03-05 14:32:48
2361	3	21	95	ダミー11	2025-03-05 14:32:48
2362	3	21	96	ダミー12	2025-03-05 14:32:48
2363	3	21	97	ダミー13	2025-03-05 14:32:48
2364	3	21	98	ダミー14	2025-03-05 14:32:48
2365	3	21	99	ダミー15	2025-03-05 14:32:48
2366	3	21	100	ダミー16	2025-03-05 14:32:48
2367	3	21	101	ダミー17	2025-03-05 14:32:48
2368	3	21	102	ダミー18	2025-03-05 14:32:48
2369	3	21	103	ダミー19	2025-03-05 14:32:48
2370	3	21	104	ダミー20	2025-03-05 14:32:48
2371	3	22	63	22	2025-03-05 14:32:48
2372	3	22	64	部門A	2025-03-05 14:32:48
2373	3	22	65	S022	2025-03-05 14:32:48
2374	3	22	66	システム標準名F	2025-03-05 14:32:48
2375	3	22	67	システム名F	2025-03-05 14:32:48
2376	3	22	68	host-022	2025-03-05 14:32:48
2377	3	22	69	OSv1.0	2025-03-05 14:32:48
2378	3	22	70	2023-01-01	2025-03-05 14:32:48
2379	3	22	71	2023-10-01	2025-03-05 14:32:48
2380	3	22	72	進行中	2025-03-05 14:32:48
2381	3	22	73	2026-03-31	2025-03-05 14:32:48
2382	3	22	74	運用移管済	2025-03-05 14:32:48
2383	3	22	75	2023-11-01	2025-03-05 14:32:48
2384	3	22	76	2024-01-01	2025-03-05 14:32:48
2385	3	22	77	バージョン2.0	2025-03-05 14:32:48
2386	3	22	78	推進中	2025-03-05 14:32:48
2387	3	22	79	ユーザー部門A	2025-03-05 14:32:48
2388	3	22	80	費用部門A	2025-03-05 14:32:48
2389	3	22	81	B001	2025-03-05 14:32:48
2390	3	22	82	予算名A	2025-03-05 14:32:48
2391	3	22	83	100000	2025-03-05 14:32:48
2392	3	22	84	部門B	2025-03-05 14:32:48
2393	3	22	85	ダミー1	2025-03-05 14:32:48
2394	3	22	86	ダミー2	2025-03-05 14:32:48
2395	3	22	87	ダミー3	2025-03-05 14:32:48
2396	3	22	88	ダミー4	2025-03-05 14:32:48
2397	3	22	89	ダミー5	2025-03-05 14:32:48
2398	3	22	90	ダミー6	2025-03-05 14:32:48
2399	3	22	91	ダミー7	2025-03-05 14:32:48
2400	3	22	92	ダミー8	2025-03-05 14:32:48
2401	3	22	93	ダミー9	2025-03-05 14:32:48
2402	3	22	94	ダミー10	2025-03-05 14:32:48
2403	3	22	95	ダミー11	2025-03-05 14:32:48
2404	3	22	96	ダミー12	2025-03-05 14:32:48
2405	3	22	97	ダミー13	2025-03-05 14:32:48
2406	3	22	98	ダミー14	2025-03-05 14:32:48
2407	3	22	99	ダミー15	2025-03-05 14:32:48
2408	3	22	100	ダミー16	2025-03-05 14:32:48
2409	3	22	101	ダミー17	2025-03-05 14:32:48
2410	3	22	102	ダミー18	2025-03-05 14:32:48
2411	3	22	103	ダミー19	2025-03-05 14:32:48
2412	3	22	104	ダミー20	2025-03-05 14:32:48
2413	3	23	63	23	2025-03-05 14:32:48
2414	3	23	64	部門A	2025-03-05 14:32:48
2415	3	23	65	S023	2025-03-05 14:32:48
2416	3	23	66	システム標準名F	2025-03-05 14:32:48
2417	3	23	67	システム名F	2025-03-05 14:32:48
2418	3	23	68	host-023	2025-03-05 14:32:48
2419	3	23	69	OSv1.0	2025-03-05 14:32:48
2420	3	23	70	2023-01-01	2025-03-05 14:32:48
2421	3	23	71	2023-10-01	2025-03-05 14:32:48
2422	3	23	72	進行中	2025-03-05 14:32:48
2423	3	23	73	2026-03-31	2025-03-05 14:32:48
2424	3	23	74	運用移管済	2025-03-05 14:32:48
2425	3	23	75	2023-11-01	2025-03-05 14:32:48
2426	3	23	76	2024-01-01	2025-03-05 14:32:48
2427	3	23	77	バージョン2.0	2025-03-05 14:32:48
2428	3	23	78	推進中	2025-03-05 14:32:48
2429	3	23	79	ユーザー部門A	2025-03-05 14:32:48
2430	3	23	80	費用部門A	2025-03-05 14:32:48
2431	3	23	81	B001	2025-03-05 14:32:48
2432	3	23	82	予算名A	2025-03-05 14:32:48
2433	3	23	83	100000	2025-03-05 14:32:48
2434	3	23	84	部門B	2025-03-05 14:32:48
2435	3	23	85	ダミー1	2025-03-05 14:32:48
2436	3	23	86	ダミー2	2025-03-05 14:32:48
2437	3	23	87	ダミー3	2025-03-05 14:32:48
2438	3	23	88	ダミー4	2025-03-05 14:32:48
2439	3	23	89	ダミー5	2025-03-05 14:32:48
2440	3	23	90	ダミー6	2025-03-05 14:32:48
2441	3	23	91	ダミー7	2025-03-05 14:32:48
2442	3	23	92	ダミー8	2025-03-05 14:32:48
2443	3	23	93	ダミー9	2025-03-05 14:32:48
2444	3	23	94	ダミー10	2025-03-05 14:32:48
2445	3	23	95	ダミー11	2025-03-05 14:32:48
2446	3	23	96	ダミー12	2025-03-05 14:32:48
2447	3	23	97	ダミー13	2025-03-05 14:32:48
2448	3	23	98	ダミー14	2025-03-05 14:32:48
2449	3	23	99	ダミー15	2025-03-05 14:32:48
2450	3	23	100	ダミー16	2025-03-05 14:32:48
2451	3	23	101	ダミー17	2025-03-05 14:32:48
2452	3	23	102	ダミー18	2025-03-05 14:32:48
2453	3	23	103	ダミー19	2025-03-05 14:32:48
2454	3	23	104	ダミー20	2025-03-05 14:32:48
2455	3	24	63	24	2025-03-05 14:32:48
2456	3	24	64	部門A	2025-03-05 14:32:48
2457	3	24	65	S024	2025-03-05 14:32:48
2458	3	24	66	システム標準名F	2025-03-05 14:32:48
2459	3	24	67	システム名F	2025-03-05 14:32:48
2460	3	24	68	host-024	2025-03-05 14:32:48
2461	3	24	69	OSv1.0	2025-03-05 14:32:48
2462	3	24	70	2023-01-01	2025-03-05 14:32:48
2463	3	24	71	2023-10-01	2025-03-05 14:32:48
2464	3	24	72	進行中	2025-03-05 14:32:48
2465	3	24	73	2026-03-31	2025-03-05 14:32:48
2466	3	24	74	運用移管済	2025-03-05 14:32:48
2467	3	24	75	2023-11-01	2025-03-05 14:32:48
2468	3	24	76	2024-01-01	2025-03-05 14:32:48
2469	3	24	77	バージョン2.0	2025-03-05 14:32:48
2470	3	24	78	推進中	2025-03-05 14:32:48
2471	3	24	79	ユーザー部門A	2025-03-05 14:32:48
2472	3	24	80	費用部門A	2025-03-05 14:32:48
2473	3	24	81	B001	2025-03-05 14:32:48
2474	3	24	82	予算名A	2025-03-05 14:32:48
2475	3	24	83	100000	2025-03-05 14:32:48
2476	3	24	84	部門B	2025-03-05 14:32:48
2477	3	24	85	ダミー1	2025-03-05 14:32:48
2478	3	24	86	ダミー2	2025-03-05 14:32:48
2479	3	24	87	ダミー3	2025-03-05 14:32:48
2480	3	24	88	ダミー4	2025-03-05 14:32:48
2481	3	24	89	ダミー5	2025-03-05 14:32:48
2482	3	24	90	ダミー6	2025-03-05 14:32:48
2483	3	24	91	ダミー7	2025-03-05 14:32:48
2484	3	24	92	ダミー8	2025-03-05 14:32:48
2485	3	24	93	ダミー9	2025-03-05 14:32:48
2486	3	24	94	ダミー10	2025-03-05 14:32:48
2487	3	24	95	ダミー11	2025-03-05 14:32:48
2488	3	24	96	ダミー12	2025-03-05 14:32:48
2489	3	24	97	ダミー13	2025-03-05 14:32:48
2490	3	24	98	ダミー14	2025-03-05 14:32:48
2491	3	24	99	ダミー15	2025-03-05 14:32:48
2492	3	24	100	ダミー16	2025-03-05 14:32:48
2493	3	24	101	ダミー17	2025-03-05 14:32:48
2494	3	24	102	ダミー18	2025-03-05 14:32:48
2495	3	24	103	ダミー19	2025-03-05 14:32:48
2496	3	24	104	ダミー20	2025-03-05 14:32:48
181	1	7	7	100700	2025-03-05 14:32:48
35	1	2	6	予算名A	2025-03-05 14:32:48
36	1	2	7	100000	2025-03-05 14:32:48
38	1	2	9	部門B	2025-03-05 14:32:48
1580	3	3	70	2023-01-18	2025-03-05 14:32:48
1874	3	10	70	2023-01-24	2025-03-05 14:32:48
905	2	7	40	2024-01-15	2025-03-05 14:32:48
442	1	16	7	99999899999999	2025-03-05 14:32:48
\.


--
-- TOC entry 4983 (class 0 OID 44549)
-- Dependencies: 231
-- Data for Name: manuals; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.manuals (id, title, content, updated_by, updated_at) FROM stdin;
1	ユーザーガイド	Web Ledgerアプリケーションの使用方法についての説明。	admin	2025-03-05 14:32:48
2	管理者マニュアル	Web Ledgerアプリケーションの管理者向け操作手順。ユーザー管理、台帳管理、レポート生成方法などを詳細に説明します。	admin	2025-03-05 14:32:48
3	一般ユーザーマニュアル	一般ユーザー向けのWeb Ledgerアプリケーションの使用方法。台帳の閲覧、データの入力方法などを説明します。	admin	2025-03-05 14:32:48
\.


--
-- TOC entry 4973 (class 0 OID 44476)
-- Dependencies: 221
-- Data for Name: role_master; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.role_master (id, role_name) FROM stdin;
1	Admin
2	Manager
3	General User
\.


--
-- TOC entry 4975 (class 0 OID 44487)
-- Dependencies: 223
-- Data for Name: users; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.users (id, username, password, role_id) FROM stdin;
1	admin	scrypt:32768:8:1$lzoEZh8lhFDucfVY$5b6a7deaccd26d66913c2cf09b5c76b3e43f11d80645e18a019b12e9b7b5591a5156f793c663fdd86bff477c2e1435a1ac98c8608aefd62738c1931a2b0b501a	1
2	manager1	scrypt:32768:8:1$9gBhsIMcfg1iNk8F$fbb67d3fb4a2a2e491ca7cef6acd8e2d12c4df35deb812c5c168260aa7f7645789fa7f12602a58c46cbb7050545423912fd99c5d2e78a4ef36b8caf3ded8955c	2
3	manager2	scrypt:32768:8:1$1sW2LGxifp44UZeT$45b0c6bc79be125e4d1322205a403d7062cd237dbf63d6ab5d21a028ffbfc1d8bdd2635b29daf655c6b29d6fdd2745c9f1dcaffc763460e78f2fff0cc7b6f14a	2
4	user1	scrypt:32768:8:1$UEAXmlR8udCNiS6n$10e4cb8786eb5ad0f47bce703fe6a054cb302062b4ac9c5dad0106bac9dde99577f08d5fa51712e0403c26b6f2d48c2143dc1d76c25c0754f63abf44db57802e	3
5	user2	scrypt:32768:8:1$MiBDrR9rJzlfP8kn$628b753245556dd9aca79175ec60ee72120e2eeebd186441fa92d92fc93c93a3e6e957bb47739c090c7a9072fa8a4b6ecd9d295b06f32525b9b8fa0bc611262e	3
6	user3	scrypt:32768:8:1$1qB4vu9gK44rGr6x$5faecbce6b4a38fe61da29b6163174d5a87109b8b72d12ec73a820bd2640913b11551eae9d1f113ac1b9cb60d48c4ade63945c383bb44104db50abee82723cc9	3
7	user4	scrypt:32768:8:1$RhZ255FO5lcpuv5y$26ad9db44c3ad2ef698067df688b068b61464777207660479384062df45d6dfe0343b45445caff80d2394e23ea3c040aaeaeb7cd6ede4ac4ad472fc8ea62d1a2	3
\.


--
-- TOC entry 4985 (class 0 OID 44559)
-- Dependencies: 233
-- Data for Name: version_history; Type: TABLE DATA; Schema: web_ledger; Owner: mydbuser
--

COPY web_ledger.version_history (id, version, sprint, update_info, "timestamp") FROM stdin;
1	v1.0	1	基本的な台帳機能の初期リリース（ログイン/ログアウト、Web台帳表示、言語切替、AI分析を含む）。	2025-03-03 12:00:00
2	v2.0	2	マルチ台帳対応（予算、サーバー情報、注文）、UIの改善、包括的なユーザー管理、マニュアル、バージョン履歴の追加。	2025-03-03 12:15:00
3	v3.0	3	台帳種類の選択機能の強化、データベースの正規化、UIの再設計、ファイルアップロード機能の拡充。	2025-03-03 12:30:00
4	v4.0	4	台帳機能の強化（フィルタ行の追加、各セルの直接編集機能追加）、編集データの記録機能の追加。	2025-03-03 12:45:00
5	v4.1	4.1	不具合修正（データ編集履歴モーダルの表示不可是正）	2025-03-03 13:00:00
6	v5.0	5	・Web台帳のレイアウト・テーマのカスタマイズ機能を拡充（adminロールによる台帳の新規作成や項目管理をDB化）\n・台帳の表示列をユーザー別に設定・ダウンロード可能にし、多言語対応（日英）や更新履歴の詳細管理を強化\n・その他，レポート機能やAI連携、パフォーマンス最適化を実施	2025-03-03 13:15:00
\.


--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 234
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.audit_logs_id_seq', 20, true);


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 226
-- Name: ledger_column_master_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.ledger_column_master_id_seq', 104, true);


--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 236
-- Name: ledger_history_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.ledger_history_id_seq', 20, true);


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 224
-- Name: ledger_master_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.ledger_master_id_seq', 3, true);


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 228
-- Name: ledger_records_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.ledger_records_id_seq', 2496, true);


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 230
-- Name: manuals_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.manuals_id_seq', 3, true);


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 220
-- Name: role_master_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.role_master_id_seq', 3, true);


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.users_id_seq', 7, true);


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 232
-- Name: version_history_id_seq; Type: SEQUENCE SET; Schema: web_ledger; Owner: mydbuser
--

SELECT pg_catalog.setval('web_ledger.version_history_id_seq', 6, true);


--
-- TOC entry 4820 (class 2606 OID 44587)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4812 (class 2606 OID 44522)
-- Name: ledger_column_master ledger_column_master_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_column_master
    ADD CONSTRAINT ledger_column_master_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 44627)
-- Name: ledger_history ledger_history_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_history
    ADD CONSTRAINT ledger_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4808 (class 2606 OID 44512)
-- Name: ledger_master ledger_master_ledger_name_key; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_master
    ADD CONSTRAINT ledger_master_ledger_name_key UNIQUE (ledger_name);


--
-- TOC entry 4810 (class 2606 OID 44510)
-- Name: ledger_master ledger_master_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_master
    ADD CONSTRAINT ledger_master_pkey PRIMARY KEY (id);


--
-- TOC entry 4814 (class 2606 OID 44537)
-- Name: ledger_records ledger_records_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_records
    ADD CONSTRAINT ledger_records_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 2606 OID 44557)
-- Name: manuals manuals_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.manuals
    ADD CONSTRAINT manuals_pkey PRIMARY KEY (id);


--
-- TOC entry 4800 (class 2606 OID 44483)
-- Name: role_master role_master_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.role_master
    ADD CONSTRAINT role_master_pkey PRIMARY KEY (id);


--
-- TOC entry 4802 (class 2606 OID 44485)
-- Name: role_master role_master_role_name_key; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.role_master
    ADD CONSTRAINT role_master_role_name_key UNIQUE (role_name);


--
-- TOC entry 4804 (class 2606 OID 44494)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4806 (class 2606 OID 44496)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4818 (class 2606 OID 44567)
-- Name: version_history version_history_pkey; Type: CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.version_history
    ADD CONSTRAINT version_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 44523)
-- Name: ledger_column_master ledger_column_master_ledger_master_id_fkey; Type: FK CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_column_master
    ADD CONSTRAINT ledger_column_master_ledger_master_id_fkey FOREIGN KEY (ledger_master_id) REFERENCES web_ledger.ledger_master(id);


--
-- TOC entry 4825 (class 2606 OID 44543)
-- Name: ledger_records ledger_records_column_id_fkey; Type: FK CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_records
    ADD CONSTRAINT ledger_records_column_id_fkey FOREIGN KEY (column_id) REFERENCES web_ledger.ledger_column_master(id);


--
-- TOC entry 4826 (class 2606 OID 44538)
-- Name: ledger_records ledger_records_ledger_master_id_fkey; Type: FK CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.ledger_records
    ADD CONSTRAINT ledger_records_ledger_master_id_fkey FOREIGN KEY (ledger_master_id) REFERENCES web_ledger.ledger_master(id);


--
-- TOC entry 4823 (class 2606 OID 44497)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: web_ledger; Owner: mydbuser
--

ALTER TABLE ONLY web_ledger.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES web_ledger.role_master(id);


-- Completed on 2025-03-21 19:36:31

--
-- PostgreSQL database dump complete
--

