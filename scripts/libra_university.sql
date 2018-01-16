CREATE DATABASE libra_university OWNER nilesbrandon;
\c libra_university;


CREATE TYPE season AS ENUM ('spring', 'summer', 'fall');
CREATE TABLE SEMESTER (
  id            serial PRIMARY KEY,
  year          NUMERIC(4, 0),
  season        season,
  start_date    DATE,
  end_date      DATE
);

CREATE TABLE profile (
  id            serial PRIMARY KEY,
  email         VARCHAR(40) UNIQUE,
  first_name    VARCHAR(20),
  last_name     VARCHAR(20),
  birth_date    DATE
);

CREATE TYPE leave_reason AS ENUM ('fired', 'resigned', 'abandoned', 'other');

CREATE TYPE rank AS ENUM ('teaching assistant', 'instructor', 'assistant professor', 'associate professor', 'professor');
CREATE TABLE faculty (
  id            serial PRIMARY KEY,
  profile_id    INTEGER UNIQUE REFERENCES profile (id),
  rank          rank,
  tenure        BOOLEAN NOT NULL DEFAULT FALSE,
  active        BOOLEAN NOT NULL DEFAULT TRUE,
  hire_date     DATE NOT NULL DEFAULT CURRENT_DATE,
  leave_date    DATE,
  leave_reason  leave_reason
);

CREATE TYPE office AS ENUM ('bursar', 'accounting', 'legal', 'scholarships', 'registrar', 'admissions');
CREATE TABLE staff (
  id            serial PRIMARY KEY,
  profile_id    INTEGER UNIQUE REFERENCES profile (id),
  office        office,
  active        BOOLEAN NOT NULL DEFAULT TRUE,
  hire_date     DATE NOT NULL DEFAULT CURRENT_DATE,
  leave_date    DATE,
  leave_reason  leave_reason
);

CREATE TABLE student (
  id            serial PRIMARY KEY,
  profile_id    INTEGER UNIQUE REFERENCES profile (id),
  -- CONTINUE HERE
);

CREATE TYPE issue_action AS ENUM ('fired', 'suspended without pay', 'suspended with pay', 'reprimand', 'fine', 'warning');
CREATE TABLE issue (
  id            serial PRIMARY KEY,
  offender_id   INTEGER REFERENCES profile (id),
  offendee_id   INTEGER REFERENCES profile (id),
  issue_description VARCHAR(1000)
);

CREATE TABLE department (
  id            serial PRIMARY KEY,
  name          VARCHAR(60),
  abbreviation  VARCHAR(4),
  established   DATE,
  chair_id      INTEGER REFERENCES faculty (id)
);

CREATE TABLE course (
  id            serial PRIMARY KEY,
  department    INTEGER REFERENCES department (id),
  number        INTEGER,
  name          VARCHAR(90),
  teacher       INTEGER REFERENCES faculty (id)
);


-- class
-- student



INSERT INTO profile (email, first_name, last_name) VALUES ('gregl@libra.com', 'Greg', 'Landolm');
INSERT INTO profile (email, first_name, last_name) VALUES ('maddieh@libra.com', 'Maddie', 'Hong');
INSERT INTO profile (email, first_name, last_name) VALUES ('test@libra.com', 'Testing', 'Account');

INSERT INTO faculty (profile_id, tenure) VALUES ((SELECT id FROM profile WHERE email = 'maddieh@libra.com'), FALSE);
INSERT INTO faculty (profile_id, tenure) VALUES ((SELECT id FROM profile WHERE email = 'test@libra.com'), TRUE);
