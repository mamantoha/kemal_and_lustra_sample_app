--
-- PostgreSQL database dump
--

\restrict pEJFT1w4f1sOHPceS3nvgwcTX4X2DubDciRNTNpeACGWqM3mpL2auy98ArR0Mzi

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.2

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
-- Name: tsv_trigger_insert_posts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tsv_trigger_insert_posts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.tsv :=
    setweight(to_tsvector('pg_catalog.simple', coalesce(new.title, '')), 'A') ||
    setweight(to_tsvector('pg_catalog.simple', coalesce(new.content, '')), 'B');
  return new;
end
$$;


ALTER FUNCTION public.tsv_trigger_insert_posts() OWNER TO postgres;

--
-- Name: tsv_trigger_update_posts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tsv_trigger_update_posts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  SELECT setweight(to_tsvector('pg_catalog.simple', coalesce(title, '')), 'A') ||
         setweight(to_tsvector('pg_catalog.simple', coalesce(content, '')), 'B') ||
         setweight(to_tsvector('pg_catalog.simple', coalesce(authors.name, '')), 'C') ||
         setweight(to_tsvector('pg_catalog.simple', coalesce((string_agg(tags.name, ' ')), '')), 'B')
    INTO new.tsv
    FROM posts
    JOIN authors ON authors.id = posts.author_id
    LEFT JOIN post_tags ON post_tags.post_id = posts.id
    LEFT JOIN tags ON tags.id = post_tags.tag_id
    WHERE posts.id = new.id
    GROUP BY posts.id, authors.id;
  return new;
end
$$;


ALTER FUNCTION public.tsv_trigger_update_posts() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __lustra_metadatas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.__lustra_metadatas (
    metatype text NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.__lustra_metadatas OWNER TO postgres;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    name text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admins_id_seq OWNER TO postgres;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    id bigint NOT NULL,
    name text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    posts_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authors_id_seq OWNER TO postgres;

--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- Name: post_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_tags (
    tag_id bigint NOT NULL,
    post_id bigint NOT NULL
);


ALTER TABLE public.post_tags OWNER TO postgres;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    title text,
    content text,
    tsv tsvector,
    author_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    kind text NOT NULL
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: relationships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relationships (
    leader_id bigint NOT NULL,
    follower_id bigint NOT NULL
);


ALTER TABLE public.relationships OWNER TO postgres;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Data for Name: __lustra_metadatas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.__lustra_metadatas (metatype, value) FROM stdin;
migration	-1
migration	1577358899
migration	1579449109
migration	1579600159
migration	1760436047
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (id, name, created_at, updated_at, posts_count) FROM stdin;
3	Tom	2026-02-17 11:17:16.187	2026-02-17 11:17:16.187	0
1	John	2026-02-17 11:17:16.175	2026-02-17 11:17:16.175	2
2	Jane	2026-02-17 11:17:16.186	2026-02-17 11:17:16.186	2
\.


--
-- Data for Name: post_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_tags (tag_id, post_id) FROM stdin;
1	1
2	2
1	3
2	3
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, title, content, tsv, author_id, created_at, updated_at, kind) FROM stdin;
1	About poney	Poney are cool	'about':1A 'are':4B 'cool':5B 'john':6C 'poney':2A,3B 'ruby':7B	1	2026-02-17 11:17:16.188	2026-02-17 11:17:16.222	test
2	About dog and cat	Cat and dog are cool. But not as much as poney	'about':1A 'and':3A,6B 'are':8B 'as':12B,14B 'but':10B 'cat':4A,5B 'cool':9B 'crystal':17B 'dog':2A,7B 'john':16C 'much':13B 'not':11B 'poney':15B	1	2026-02-17 11:17:16.199	2026-02-17 11:17:16.224	test
3	You won't believe: She raises her poney like as star!	She's col because poney are cool	'are':17B 'as':10A 'because':15B 'believe':4A 'col':14B 'cool':18B 'crystal':21B 'her':7A 'jane':19C 'like':9A 'poney':8A,16B 'raises':6A 'ruby':20B 's':13B 'she':5A,12B 'star':11A 't':3A 'won':2A 'you':1A	2	2026-02-17 11:17:16.202	2026-02-17 11:17:16.226	test
4	Post without tags	Test posts without tags	'jane':8C 'post':1A 'posts':5B 'tags':3A,7B 'test':4B 'without':2A,6B	2	2026-02-17 11:17:16.204	2026-02-17 11:17:16.227	test
\.


--
-- Data for Name: relationships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relationships (leader_id, follower_id) FROM stdin;
1	2
1	4
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, name, created_at, updated_at) FROM stdin;
1	ruby	2026-02-17 11:17:16.215	2026-02-17 11:17:16.215
2	crystal	2026-02-17 11:17:16.216	2026-02-17 11:17:16.216
\.


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, false);


--
-- Name: authors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authors_id_seq', 3, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 4, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 2, true);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: __lustra_metadatas_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX __lustra_metadatas_idx ON public.__lustra_metadatas USING btree (metatype, value);


--
-- Name: admins_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admins_created_at ON public.admins USING btree (created_at);


--
-- Name: admins_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admins_name ON public.admins USING btree (name);


--
-- Name: admins_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admins_updated_at ON public.admins USING btree (updated_at);


--
-- Name: authors_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX authors_created_at ON public.authors USING btree (created_at);


--
-- Name: authors_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX authors_name ON public.authors USING btree (name);


--
-- Name: authors_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX authors_updated_at ON public.authors USING btree (updated_at);


--
-- Name: post_tags_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_tags_post_id ON public.post_tags USING btree (post_id);


--
-- Name: post_tags_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_tags_tag_id ON public.post_tags USING btree (tag_id);


--
-- Name: post_tags_tag_id_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX post_tags_tag_id_post_id ON public.post_tags USING btree (tag_id, post_id);


--
-- Name: posts_author_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_author_id ON public.posts USING btree (author_id);


--
-- Name: posts_content; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX posts_content ON public.posts USING btree (content);


--
-- Name: posts_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_created_at ON public.posts USING btree (created_at);


--
-- Name: posts_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_title ON public.posts USING btree (title);


--
-- Name: posts_tsv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_tsv ON public.posts USING gin (tsv);


--
-- Name: posts_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX posts_updated_at ON public.posts USING btree (updated_at);


--
-- Name: relationships_follower_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX relationships_follower_id ON public.relationships USING btree (follower_id);


--
-- Name: relationships_leader_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX relationships_leader_id ON public.relationships USING btree (leader_id);


--
-- Name: relationships_leader_id_follower_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX relationships_leader_id_follower_id ON public.relationships USING btree (leader_id, follower_id);


--
-- Name: tags_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tags_created_at ON public.tags USING btree (created_at);


--
-- Name: tags_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tags_name ON public.tags USING btree (name);


--
-- Name: tags_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tags_updated_at ON public.tags USING btree (updated_at);


--
-- Name: posts tsv_insert_posts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tsv_insert_posts BEFORE INSERT ON public.posts FOR EACH ROW EXECUTE FUNCTION public.tsv_trigger_insert_posts();


--
-- Name: posts tsv_update_posts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tsv_update_posts BEFORE UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.tsv_trigger_update_posts();


--
-- Name: post_tags post_tags_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: post_tags post_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: posts posts_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: relationships relationships_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT relationships_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: relationships relationships_leader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relationships
    ADD CONSTRAINT relationships_leader_id_fkey FOREIGN KEY (leader_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict pEJFT1w4f1sOHPceS3nvgwcTX4X2DubDciRNTNpeACGWqM3mpL2auy98ArR0Mzi

