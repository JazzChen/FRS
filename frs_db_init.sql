-- create user frs

CREATE USER frs login password 'frs';


-- create database frs_db

CREATE DATABASE frs_db WITH owner = frs encoding='UTF-8';


-- connect to frs_db

\c frs_db

-- Create tables

CREATE TABLE collectionreport (
  rptdate date NOT NULL,
  overduetotalcount integer DEFAULT 0 NOT NULL,
  overduetotalamount numeric DEFAULT 0 NOT NULL,
  overduecollectfailcount integer DEFAULT 0 NOT NULL,
  overduecollectfailamount numeric DEFAULT 0 NOT NULL,
  duecollecttotalcount integer DEFAULT 0 NOT NULL,
  duecollecttotalamount numeric DEFAULT 0 NOT NULL,
  duecollectfailcount integer DEFAULT 0 NOT NULL,
  duecollectfailamount numeric DEFAULT 0 NOT NULL,
  earlysettletotalcount integer DEFAULT 0 NOT NULL,
  earlysettletotalamount numeric DEFAULT 0 NOT NULL
);

ALTER TABLE ONLY collectionreport
    ADD CONSTRAINT collectionreport_pkey PRIMARY KEY (rptdate);

ALTER TABLE public.collectionreport OWNER TO frs;


CREATE TABLE disbursereport (
  rptdate date NOT NULL,
  disbursetotalcount integer DEFAULT 0 NOT NULL,
  disbursetotalamount numeric DEFAULT 0 NOT NULL,
  withdrawtotalcount integer DEFAULT 0 NOT NULL,
  withdrawtotalamount numeric DEFAULT 0 NOT NULL,
  withdrawfailcount integer DEFAULT 0 NOT NULL,
  withdrawfailamount numeric DEFAULT 0 NOT NULL
);

ALTER TABLE ONLY disbursereport
    ADD CONSTRAINT disbursereport_pkey PRIMARY KEY (rptdate);

ALTER TABLE public.disbursereport OWNER TO frs;


CREATE TABLE roles (
  id serial NOT NULL,
  role character varying(255),
  createdat timestamp without time zone,
  updatedat timestamp without time zone,
  description text
);

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);

ALTER TABLE public.roles OWNER TO frs;


CREATE TABLE users (
  id serial NOT NULL,
  name character varying(255) NOT NULL,
  mobile character varying(255),
  roleid character varying(255) NOT NULL,
  email character varying(255) NOT NULL,
  encryptedpassword character varying(255) NOT NULL,
  createdat timestamp without time zone,
  updatedat timestamp without time zone,
  signincount integer DEFAULT 0 NOT NULL,
  currentsigninat timestamp without time zone,
  currentsigninip character varying(255),
  locked boolean,
  failedattempts integer DEFAULT 0 NOT NULL,
  lockedat timestamp without time zone
);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pky PRIMARY KEY (id);

ALTER TABLE public.users OWNER TO frs;


GRANT ALL ON SCHEMA public TO frs;

