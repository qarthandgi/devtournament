-- DROP DATABASE IF EXISTS libra_university;
-- CREATE DATABASE libra_university OWNER yinyang;
-- \c libra_university;

-- make sure to drop if need be, make sure to create with PROPER OWNER, and make sure connected with yinyang user \conninfo


CREATE TYPE season AS ENUM ('spring', 'summer', 'fall');
CREATE TABLE semester (
  id            serial PRIMARY KEY,
  year          NUMERIC(4, 0),
  season        season
);

CREATE TYPE gender AS ENUM ('male', 'female', 'not specified');
CREATE TABLE profile (
  id            serial PRIMARY KEY,
  email         VARCHAR(40) UNIQUE,
  first_name    VARCHAR(20),
  last_name     VARCHAR(20),
  gender        gender DEFAULT 'not specified',
  birth_date    DATE,
  home_zip      INTEGER
);


CREATE TABLE department (
  id            serial PRIMARY KEY,
  name          VARCHAR(60),
  abbreviation  VARCHAR(4),
  established   DATE
);


CREATE TYPE rank AS ENUM ('instructor', 'assistant professor', 'associate professor', 'professor');
CREATE TABLE faculty (
  id            serial PRIMARY KEY,
  profile_id    INTEGER UNIQUE REFERENCES profile (id),
  rank          rank,
  tenure        BOOLEAN DEFAULT FALSE,
  active        BOOLEAN DEFAULT TRUE,
  department_id INTEGER REFERENCES department (id),
  hire_date     DATE,
  salary        NUMERIC(9, 2)
);


ALTER TABLE department ADD COLUMN chair_id INTEGER REFERENCES faculty (id);


CREATE TYPE office AS ENUM ('bursar', 'accounting', 'legal', 'scholarships', 'registrar', 'admissions', 'administration');
CREATE TABLE staff (
  id            serial PRIMARY KEY,
  profile_id    INTEGER UNIQUE REFERENCES profile (id),
  office        office,
  active        BOOLEAN DEFAULT TRUE,
  hire_date     DATE,
  salary        NUMERIC(9, 2)
);

CREATE TYPE degree_type AS ENUM ('Associate', 'Bachelor of Arts', 'Bachelor of Science');
CREATE TABLE student (
  id            serial PRIMARY KEY,
  profile_id    INTEGER UNIQUE REFERENCES profile (id),
  gpa           NUMERIC(3, 2),
  scholarship   NUMERIC(8, 2),
  department_id INTEGER REFERENCES department (id),
  degree_type   degree_type,
  start_semester_id  INTEGER REFERENCES semester (id)
);

CREATE TYPE issue_action AS
  ENUM ('fired', 'suspended without pay', 'suspended with pay', 'reprimanded', 'monetary fine', 'warning', 'no action taken');
CREATE TABLE issue (
  id            serial PRIMARY KEY,
  offender_id   INTEGER REFERENCES profile (id),
  offendee_id   INTEGER REFERENCES profile (id),
  issue_description VARCHAR(1000) DEFAULT 'no description given',
  issue_action  issue_action
);

CREATE TYPE course_type AS ENUM ('core', 'elective');
CREATE TABLE course (
  id            serial PRIMARY KEY,
  department_id INTEGER REFERENCES department (id),
  number        INTEGER,
  name          VARCHAR(90),
  credits       SMALLINT,
  type          course_type
);

CREATE TABLE class (
  id            serial PRIMARY KEY,
  semester_id   INTEGER REFERENCES semester (id),
  faculty_id    INTEGER REFERENCES faculty (id),
  course_id     INTEGER REFERENCES course (id)
);

-- the seat table holds the actual attendance of a student in a class
CREATE TABLE class_seat (
  id            serial PRIMARY KEY,
  class_id      INTEGER REFERENCES class (id),
  student_id    INTEGER REFERENCES student (id),
  grade         NUMERIC(6,3),
  classes_missed SMALLINT
);



INSERT INTO semester (id, year, season)
  VALUES
    (1, 2013, 'fall'),
    (2, 2014, 'spring'),
    (3, 2014, 'fall'),
    (4, 2015, 'spring'),
    (5, 2015, 'fall'),
    (6, 2016, 'spring'),
    (7, 2016, 'fall'),
    (8, 2017, 'spring');



/*

insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (1, 42, 'associate professor', false, true, '2008-06-08', '78000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (2, 65, 'assistant professor', false, true, '2000-02-19', '47000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (4, 95, 'associate professor', false, true, '2006-05-30', '79000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (5, 87, 'associate professor', true, true, '2007-12-02', '60000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (8, 44, 'professor', true, true, '2007-10-15', '108000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (9, 19, 'teaching assistant', false, true, '2002-01-01', '33000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (10, 11, 'professor', false, true, '2001-05-26', '105000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (11, 10, 'teaching assistant', false, true, '2006-10-06', '25000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (12, 73, 'assistant professor', false, true, '2009-03-02', '38000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (13, 46, 'professor', false, true, '2011-07-12', '99000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (15, 68, 'professor', true, true, '2008-02-21', '107000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (20, 106, 'teaching assistant', false, true, '2009-06-05', '32000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (21, 43, 'instructor', false, false, '2005-02-21', '49000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (22, 105, 'professor', false, true, '2000-07-06', '86000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (23, 28, 'associate professor', false, true, '2009-06-20', '63000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (25, 85, 'teaching assistant', false, true, '2002-08-15', '19000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (27, 113, 'assistant professor', false, true, '2007-07-15', '50000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (30, 62, 'professor', false, true, '2005-05-27', '102000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (31, 38, 'assistant professor', false, true, '2000-12-08', '48000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (33, 82, 'associate professor', false, true, '2004-12-24', '75000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (35, 89, 'assistant professor', false, true, '2008-03-10', '40000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (36, 94, 'instructor', false, true, '2004-02-05', '61000.00');
--insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (37, 95, 'instructor', false, true, '2008-07-05', '33000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (38, 31, 'associate professor', false, true, '2001-06-21', '63000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (39, 70, 'associate professor', false, true, '2011-01-22', '63000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (40, 49, 'professor', true, true, '2003-04-29', '89000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (43, 21, 'professor', true, true, '2012-06-19', '78000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (44, 8, 'teaching assistant', false, true, '2000-10-10', '22000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (45, 61, 'professor', false, true, '2010-06-17', '84000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (48, 57, 'assistant professor', false, true, '2004-04-02', '58000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (50, 108, 'teaching assistant', false, true, '2003-05-04', '31000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (51, 59, 'instructor', false, true, '2007-03-08', '55000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (53, 75, 'teaching assistant', false, true, '2006-01-25', '21000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (55, 102, 'assistant professor', false, true, '2006-11-25', '39000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (56, 98, 'associate professor', true, true, '2002-12-09', '66000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (59, 51, 'assistant professor', false, true, '2003-03-17', '36000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (61, 45, 'professor', true, true, '2011-09-26', '82000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (62, 30, 'teaching assistant', false, true, '2005-11-28', '34000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (63, 47, 'associate professor', true, true, '2006-12-01', '70000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (66, 83, 'assistant professor', false, false, '2011-08-11', '51000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (67, 67, 'instructor', false, true, '2004-08-25', '45000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (68, 15, 'assistant professor', false, false, '2004-04-20', '52000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (69, 7, 'teaching assistant', false, true, '2009-01-21', '25000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (70, 39, 'teaching assistant', false, true, '2007-02-09', '25000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (71, 109, 'assistant professor', false, true, '2003-06-07', '54000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (72, 86, 'professor', false, true, '2005-11-13', '88000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (74, 74, 'teaching assistant', false, true, '2001-03-06', '21000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (79, 79, 'instructor', false, true, '2005-10-14', '39000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (83, 66, 'professor', false, true, '2004-10-02', '92000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (85, 25, 'professor', false, true, '2009-09-07', '97000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (86, 72, 'instructor', false, true, '2012-02-29', '49000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (87, 5, 'professor', true, false, '2001-12-08', '98000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (91, 112, 'professor', false, false, '2010-09-29', '80000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (92, 110, 'instructor', false, false, '2000-08-16', '38000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (96, 14, 'professor', true, true, '2004-02-14', '97000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (97, 37, 'teaching assistant', false, false, '2012-05-19', '23000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (99, 103, 'professor', true, true, '2000-02-25', '78000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (100, 3, 'assistant professor', false, true, '2003-07-03', '55000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (101, 84, 'assistant professor', false, true, '2006-06-18', '57000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (102, 55, 'professor', false, true, '2002-03-13', '111000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (103, 99, 'instructor', false, false, '2001-05-04', '45000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (104, 26, 'associate professor', false, true, '2010-12-12', '70000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (106, 20, 'professor', false, false, '2008-09-15', '94000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (107, 88, 'associate professor', false, false, '2011-10-15', '72000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (108, 50, 'assistant professor', false, true, '2008-03-16', '50000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (109, 71, 'associate professor', false, true, '2008-06-05', '63000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (110, 92, 'assistant professor', false, true, '2012-01-09', '48000.00');
--insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (111, 52, 'professor', false, true, '2002-05-18', '93000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (112, 91, 'professor', true, true, '2000-06-14', '104000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (113, 27, 'professor', true, false, '2010-09-02', '91000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (114, 32, 'instructor', false, false, '2005-05-18', '47000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (115, 117, 'instructor', false, true, '2011-11-10', '50000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (116, 34, 'associate professor', false, true, '2010-02-12', '76000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (117, 115, 'professor', true, true, '2002-12-28', '93000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (118, 18, 'assistant professor', false, true, '2003-06-23', '48000.00');
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (120, 29, 'assistant professor', false, true, '2003-08-25', '34000.00');


insert into staff (id, profile_id, office, active, hire_date, salary) values (44, 200, 'accounting', true, '2005-01-06', '77000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (45, 194, 'legal', true, '2005-01-26', '73000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (46, 185, 'scholarships', true, '2007-04-14', '126000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (47, 144, 'registrar', true, '2012-11-11', '80000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (48, 123, 'admissions', true, '2008-01-09', '123000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (49, 151, 'administration', true, '2003-11-25', '193000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (50, 137, 'bursar', true, '2006-04-08', '54000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (51, 153, 'accounting', true, '2012-11-17', '97000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (52, 128, 'legal', true, '2009-04-06', '80000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (53, 188, 'scholarships', false, '2003-10-06', '115000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (54, 186, 'registrar', true, '2010-05-19', '44000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (55, 190, 'admissions', true, '2012-04-09', '119000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (56, 129, 'administration', true, '2004-09-20', '136000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (57, 140, 'bursar', true, '2011-02-07', '44000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (58, 182, 'accounting', true, '2004-07-13', '124000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (59, 136, 'legal', false, '2011-12-16', '63000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (60, 127, 'scholarships', true, '2009-12-16', '63000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (61, 197, 'registrar', true, '2009-07-07', '82000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (62, 178, 'admissions', true, '2005-08-29', '44000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (63, 154, 'administration', true, '2010-01-24', '202000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (64, 162, 'bursar', false, '2012-07-02', '60000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (65, 166, 'accounting', true, '2005-05-08', '61000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (66, 174, 'legal', true, '2003-01-26', '78000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (67, 163, 'scholarships', true, '2007-01-12', '50000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (68, 173, 'registrar', true, '2004-04-09', '50000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (69, 142, 'admissions', true, '2007-10-19', '67000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (70, 175, 'administration', true, '2005-12-18', '94000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (71, 195, 'bursar', true, '2005-02-10', '117000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (72, 156, 'accounting', true, '2005-06-13', '105000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (73, 125, 'legal', true, '2013-05-12', '113000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (74, 165, 'scholarships', true, '2012-12-02', '130000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (75, 191, 'registrar', true, '2003-02-28', '41000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (76, 148, 'admissions', true, '2005-12-17', '79000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (77, 181, 'administration', true, '2004-04-21', '185000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (78, 150, 'bursar', true, '2003-01-23', '76000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (79, 126, 'accounting', true, '2011-03-18', '63000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (80, 164, 'legal', true, '2003-10-29', '45000.00');

*/


--   ---––––––----------------------------------------------------------------------------------------------------------


--   ****** STAFF
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (152, 'Minnie', 'Poynzer', 'm.poynzer@libra.edu', 'female', '1966-01-13', 37672);
insert into staff (id, profile_id, office, active, hire_date, salary) values (1, 152, 'bursar', true, '2010-11-26', '80000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (131, 'Iris', 'De Roberto', 'i.de_roberto@libra.edu', 'female', '2007-04-29', 36371);
insert into staff (id, profile_id, office, active, hire_date, salary) values (2, 131, 'accounting', false, '2010-11-06', '54000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (168, 'Michel', 'Heisham', 'm.heisham@libra.edu', 'male', '1953-02-16', 37922);
insert into staff (id, profile_id, office, active, hire_date, salary) values (3, 168, 'legal', true, '2010-03-02', '72000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (145, 'Stavro', 'Caveau', 's.caveau@libra.edu', 'male', '1967-11-16', 37337);
insert into staff (id, profile_id, office, active, hire_date, salary) values (4, 145, 'scholarships', true, '2011-07-10', '80000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (193, 'Tallou', 'Akess', 't.akess@libra.edu', 'female', '1986-11-17', 37280);
insert into staff (id, profile_id, office, active, hire_date, salary) values (5, 193, 'registrar', true, '2003-10-08', '128000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (199, 'Marlon', 'Straker', 'm.straker@libra.edu', 'male', '1943-02-01', 37397);
insert into staff (id, profile_id, office, active, hire_date, salary) values (6, 199, 'admissions', true, '2005-06-04', '124000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (180, 'Amelie', 'Antos', 'a.antos@libra.edu', 'female', '1956-07-29', 35889);
insert into staff (id, profile_id, office, active, hire_date, salary) values (7, 180, 'administration', true, '2006-08-06', '163000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (172, 'Jobi', 'Dole', 'j.dole@libra.edu', 'female', '1959-11-11', 36667);
insert into staff (id, profile_id, office, active, hire_date, salary) values (8, 172, 'bursar', true, '2006-03-25', '42000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (176, 'Karlie', 'Bowcock', 'k.bowcock@libra.edu', 'female', '2008-02-04', 36955);
insert into staff (id, profile_id, office, active, hire_date, salary) values (9, 176, 'accounting', true, '2009-08-11', '128000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (161, 'Sydney', 'Nolte', 's.nolte@libra.edu', 'male', '1941-05-12', null);
insert into staff (id, profile_id, office, active, hire_date, salary) values (10, 161, 'legal', false, '2012-10-14', '90000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (122, 'Bernadina', 'Murrigans', 'b.murrigans@libra.edu', 'female', '1979-04-12', null);
insert into staff (id, profile_id, office, active, hire_date, salary) values (11, 122, 'scholarships', true, '2003-01-05', '47000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (164, 'Darcy', 'Kilpatrick', 'd.kilpatrick@libra.edu', 'male', '2007-08-06', 38174);
insert into staff (id, profile_id, office, active, hire_date, salary) values (12, 164, 'registrar', true, '2004-04-01', '122000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (160, 'Michail', 'Lammerts', 'm.lammerts@libra.edu', 'male', '1954-04-05', 37799);
insert into staff (id, profile_id, office, active, hire_date, salary) values (13, 160, 'admissions', true, '2004-07-12', '74000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (159, 'Casie', 'Norkett', 'c.norkett@libra.edu', 'female', '1971-03-25', 38108);
insert into staff (id, profile_id, office, active, hire_date, salary) values (14, 159, 'administration', true, '2009-08-29', '131000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (157, 'Olin', 'Kemitt', 'o.kemitt@libra.edu', 'male', '1935-09-24', 36672);
insert into staff (id, profile_id, office, active, hire_date, salary) values (15, 157, 'bursar', true, '2013-03-13', '50000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (179, 'Felicia', 'Withull', 'f.withull@libra.edu', 'female', '1979-04-28', 37063);
insert into staff (id, profile_id, office, active, hire_date, salary) values (16, 179, 'accounting', true, '2004-06-20', '54000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (170, 'Modesty', 'Romero', 'm.romero@libra.edu', 'female', '1989-10-02', 36044);
insert into staff (id, profile_id, office, active, hire_date, salary) values (17, 170, 'legal', true, '2012-11-16', '69000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (44, 'Keslie', 'Gertz', 'k.gertz@libra.edu', 'female', '1976-06-24', 37565);
insert into staff (id, profile_id, office, active, hire_date, salary) values (18, 44, 'scholarships', false, '2005-05-04', '121000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (155, 'Thea', 'Jenney', 't.jenney@libra.edu', 'female', '2009-05-23', 35635);
insert into staff (id, profile_id, office, active, hire_date, salary) values (19, 155, 'registrar', false, '2010-02-18', '44000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (177, 'Mollie', 'Egel', 'm.egel@libra.edu', 'female', '1988-09-10', 37540);
insert into staff (id, profile_id, office, active, hire_date, salary) values (20, 177, 'admissions', false, '2009-10-01', '103000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (141, 'Benni', 'Goding', 'b.goding@libra.edu', 'female', '2000-11-25', null);
insert into staff (id, profile_id, office, active, hire_date, salary) values (21, 141, 'administration', true, '2008-11-22', '169000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (189, 'Gibbie', 'Hubbold', 'g.hubbold@libra.edu', 'male', '1962-05-13', 35476);
insert into staff (id, profile_id, office, active, hire_date, salary) values (22, 189, 'bursar', true, '2004-11-22', '109000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (146, 'Bertram', 'Buttress', 'b.buttress@libra.edu', 'male', '1953-08-05', 36463);
insert into staff (id, profile_id, office, active, hire_date, salary) values (23, 146, 'accounting', true, '2009-07-16', '45000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (167, 'Charisse', 'Collman', 'c.collman@libra.edu', 'female', '1993-11-03', 38286);
insert into staff (id, profile_id, office, active, hire_date, salary) values (24, 167, 'legal', false, '2006-04-08', '85000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (124, 'Humberto', 'McGorley', 'h.mcgorley@libra.edu', 'male', '1943-01-23', null);
insert into staff (id, profile_id, office, active, hire_date, salary) values (25, 124, 'scholarships', true, '2013-04-09', '91000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (143, 'Dana', 'Wreath', 'd.wreath@libra.edu', 'female', '1986-02-03', null);
insert into staff (id, profile_id, office, active, hire_date, salary) values (26, 143, 'registrar', true, '2005-04-20', '81000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (132, 'Ibby', 'Livingstone', 'i.livingstone@libra.edu', 'female', '1958-02-10', 37643);
insert into staff (id, profile_id, office, active, hire_date, salary) values (27, 132, 'admissions', true, '2009-08-03', '127000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (196, 'Leela', 'Landal', 'l.landal@libra.edu', 'female', '2009-05-16', 35641);
insert into staff (id, profile_id, office, active, hire_date, salary) values (28, 196, 'administration', true, '2003-02-06', '98000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (149, 'Chloris', 'Claussen', 'c.claussen@libra.edu', null, '1941-12-28', 37420);
insert into staff (id, profile_id, office, active, hire_date, salary) values (29, 149, 'bursar', true, '2008-11-13', '62000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (198, 'Hartley', 'Coppens', 'h.coppens@libra.edu', 'male', '1957-08-28', 37265);
insert into staff (id, profile_id, office, active, hire_date, salary) values (30, 198, 'accounting', false, '2012-03-27', '92000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (169, 'Garret', 'Golding', 'g.golding@libra.edu', 'male', '1998-04-08', null);
insert into staff (id, profile_id, office, active, hire_date, salary) values (31, 169, 'legal', true, '2005-11-28', '70000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (121, 'Dougie', 'Barensen', 'd.barensen@libra.edu', 'male', '1955-02-26', 37137);
insert into staff (id, profile_id, office, active, hire_date, salary) values (32, 121, 'scholarships', true, '2007-09-20', '54000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (171, 'Nollie', 'Hearty', 'n.hearty@libra.edu', 'female', '1991-10-26', 35380);
insert into staff (id, profile_id, office, active, hire_date, salary) values (33, 171, 'registrar', true, '2007-10-17', '43000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (183, 'Man', 'Tuting', 'm.tuting@libra.edu', 'male', '1980-09-02', null);
insert into staff (id, profile_id, office, active, hire_date, salary) values (34, 183, 'admissions', true, '2008-07-14', '71000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (308, 'Amberly', 'Saffill', 'a.saffill@libra.edu', 'female', '2004-09-27', 35980);
insert into staff (id, profile_id, office, active, hire_date, salary) values (35, 308, 'administration', true, '2010-10-18', '205000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (192, 'Gabriela', 'Maitland', 'g.maitland@libra.edu', 'female', '1979-09-03', 38011);
insert into staff (id, profile_id, office, active, hire_date, salary) values (36, 192, 'bursar', true, '2007-01-07', '98000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (135, 'Sergent', 'Takle', 's.takle@libra.edu', 'male', '1960-05-05', 35660);
insert into staff (id, profile_id, office, active, hire_date, salary) values (37, 135, 'accounting', true, '2006-12-21', '110000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (138, 'Kurtis', 'Mallall', 'k.mallall@libra.edu', 'male', '1984-10-09', 36464);
insert into staff (id, profile_id, office, active, hire_date, salary) values (38, 138, 'legal', true, '2010-04-29', '75000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (134, 'Otho', 'Pain', 'o.pain@libra.edu', 'male', '1965-06-29', 35816);
insert into staff (id, profile_id, office, active, hire_date, salary) values (39, 134, 'scholarships', true, '2009-04-10', '55000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (133, 'Taylor', 'Olphert', 't.olphert@libra.edu', 'male', '1932-08-23', 37732);
insert into staff (id, profile_id, office, active, hire_date, salary) values (40, 133, 'registrar', true, '2008-09-21', '66000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (130, 'Leonardo', 'Gilson', 'l.gilson@libra.edu', 'male', '1965-07-12', null);
insert into staff (id, profile_id, office, active, hire_date, salary) values (41, 130, 'admissions', true, '2011-11-23', '123000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (184, 'Arlinda', 'Horick', 'a.horick@libra.edu', 'female', '1995-05-24', 38058);
insert into staff (id, profile_id, office, active, hire_date, salary) values (42, 184, 'administration', true, '2004-11-05', '95000.00');

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (187, 'Garry', 'Cunnow', 'g.cunnow@libra.edu', 'male', '1994-05-13', 35931);
insert into staff (id, profile_id, office, active, hire_date, salary) values (43, 187, 'bursar', true, '2005-11-20', '41000.00');

--   ****** END STAFF

--   ---––––––------------------------------------------------------------------------------------------------------------

--   ****** DEPARTMENTS

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (100, 'Ambrosius', 'Blonet', 'a.blonet@libra.edu', 'male', '1981-12-08', 36222);
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (3, 100, 'professor', false, true, '2004-01-19', '111000.00');
insert into department (id, name, abbreviation, established, chair_id) values (1, 'Computer Science', 'CS', '1990-08-01', 3); -- Chair: Ambrosius Blonet
UPDATE faculty SET department_id = 1 WHERE id = 3;

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (33, 'Pamella', 'Hargrave', 'p.hargrave@libra.edu', 'female', '1970-11-02', 36315);
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (82, 33, 'professor', true, true, '1998-08-29', '110000.00');
insert into department (id, name, abbreviation, established, chair_id) values (2, 'Music', 'MUS', '1980-01-01', 82); -- Chair: Pamella Hargrave
UPDATE faculty SET department_id = 2 WHERE id = 82;

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (36, 'Ginny', 'Meineking', 'g.meineking@libra.edu', 'female', '1968-03-04', 35670);
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (94, 36, 'professor', true, true, '2009-01-24', '106000.00');
insert into department (id, name, abbreviation, established, chair_id) values (3, 'Linguistics', 'LING', '2003-06-01', 94); -- Chair: Ginny Meineking
UPDATE faculty SET department_id = 3 WHERE id = 94;

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (40, 'Chadd', 'Fernyhough', 'c.fernyhough@libra.edu', 'male', '1949-05-05', null);
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (49, 40, 'professor', false, true, '2003-01-13', '101000.00');
insert into department (id, name, abbreviation, established, chair_id) values (4, 'Mathematics', 'MATH', '1985-09-10', 49); -- Chair: Chadd Fernyhough
UPDATE faculty SET department_id = 4 WHERE id = 49;

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (2, 'Aileen', 'Orrin', 'a.orrin@libra.edu', null, '1961-05-08', 37636);
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (65, 2, 'professor', false, false, '2005-03-20', '96000.00');
insert into department (id, name, abbreviation, established, chair_id) values (5, 'Economics', 'ECON', '1992-03-02', 65); -- Chair: Aileen Orrin
UPDATE faculty SET department_id = 5 WHERE id = 65;

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (22, 'Genna', 'Rudge', 'g.rudge@libra.edu', 'female', '1969-04-22', 35980);
insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (105, 22, 'professor', true, true, '1993-01-06', '106000.00');
insert into department (id, name, abbreviation, established, chair_id) values (6, 'Liberal Arts', 'LA', '1990-05-30', 105);
UPDATE faculty SET department_id = 6 WHERE id = 105;

--   ****** END DEPARTMENTS


--   ---––––––----------------------------------------------------------------------------------------------------------


--   ****** COMPUTER SCIENCE COURSES AND CLASSES --

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (90, 'Nadya', 'Gayter', 'n.gayter@libra.edu', 'female', '1982-10-23', null); -- Profile: Nadya: 119
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (119, 90, 'instructor', false, true, 1, '2009-02-26', '35000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (9, 'Evered', 'Glassford', 'e.glassford@libra.edu', 'male', '1964-01-18', 36785); -- Profile: Evered: 19
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (19, 9, 'assistant professor', false, false, 1, '2011-09-04', '41000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (24, 'Maurise', 'Smellie', 'm.smellie@libra.edu', 'female', '1953-10-25', 38077); -- Profile: Maurise: 54
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (54, 24, 'associate professor', true, true, 1, '2006-11-22', '68000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (118, 'Ferdinand', 'Monnoyer', 'f.monnoyer@libra.edu', 'male', '1980-09-04', 37994); -- Profile: Ferdinand: 18
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (18, 118, 'professor', false, true, 1, '2007-05-01', '98000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (1, 'Kare', 'Struther', 'k.struther@libra.edu', 'female', '2004-10-22', 36356); -- Profile: Kare: 42
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (42, 1, 'associate professor', false, true, 1, '2000-04-21', '70000.00'); -- Teacher: ^^

insert into course (id, department_id, number, name, credits, type) values (1, 1, 111, 'Intro to Computer Science', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (1, 1, 119, 1), -- Fall 2013 - Nadya
      (2, 1, 18, 1), -- Fall 2013 - Ferdinand
      (3, 3, 119, 1), -- Fall 2014 - Nadya
      (4, 5, 19, 1), -- Fall 2015 - Evered
      (5, 5, 119, 1); -- Fall 2016 - Nadya

insert into course (id, department_id, number, name, credits, type) values (2, 1, 123, 'Mathematical Foundations of Computing', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (6, 2, 19, 2), -- Spring 2014 - Evered
      (7, 4, 54, 2), -- Spring 2015 - Maurise
      (8, 6, 119, 2), -- Spring 2016 - Nadya
      (9, 8, 54, 2); -- Spring 2017 - Maurise

insert into course (id, department_id, number, name, credits, type) values (3, 1, 203, 'Data Structures', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (10, 1, 54, 3), -- Fall 2013 - Maurise
      (11, 3, 19, 3), -- Fall 2014 - Evered
      (12, 5, 119, 3), -- Fall 2015 - Nadya
      (13, 7, 54, 3); -- Fall 2016 - Maurise

insert into course (id, department_id, number, name, credits, type) values (4, 1, 231, 'Computer Architecture', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (14, 2, 19, 4), -- Spring 2014 - Evered
      (15, 4, 119, 4), -- Spring 2015 - Nadya
      (16, 6, 42, 4), -- Spring 2016 - Kare
      (17, 8, 42, 4); -- Spring 2017 - Kare

insert into course (id, department_id, number, name, credits, type) values (5, 1, 302, 'System Programming', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (18, 1, 54, 5), -- Fall 2013 - Maurise
      (19, 3, 18, 5), -- Fall 2014 - Ferdinand
      (20, 5, 18, 5), -- Fall 2015 - Ferdinand
      (21, 7, 42, 5); -- Fall 2016 - Kare

insert into course (id, department_id, number, name, credits, type) values (6, 1, 412, 'Algorithm Design', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (22, 2, 42, 6), -- Spring 2014 - Kare
      (23, 4, 18, 6), -- Spring 2015 - Ferdinand
      (24, 6, 18, 6), -- Spring 2016 - Ferdinand
      (25, 8, 42, 6); -- Spring 2017 - Kare

insert into course (id, department_id, number, name, credits, type) values (7, 1, 412, 'Software Development', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (26, 1, 19, 7), -- Fall 2013 - Evered
      (27, 3, 19, 7), -- Fall 2014 - Evered
      (28, 5, 119, 7), -- Fall 2015 - Nadya
      (29, 7, 42, 7); -- Fall 2016 - Kare

insert into course (id, department_id, number, name, credits, type) values (8, 1, 308, 'System Networking', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (30, 1, 54, 8), -- Fall 2013 - Maurise
      (31, 2, 54, 8), -- Spring 2014 - Maurise
      (32, 3, 19, 8), -- Fall 2014 - Evered
      (33, 5, 119, 8), -- Fall 2015 - Nadya
      (34, 6, 54, 8), -- Spring 2016 - Maurise
      (35, 7, 54, 8); -- Fall 2016 - Maurise

insert into course (id, department_id, number, name, credits, type) values (9, 1, 333, 'User Interface Design', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (36, 2, 54, 9), -- Spring 2014 - Maurise
      (37, 3, 19, 9), -- Fall 2014 - Evered
      (38, 4, 19, 9), -- Spring 2015 - Evered
      (39, 5, 119, 9), -- Fall 2015 - Nadya
      (40, 7, 54, 9), -- Fall 2016 - Maurise
      (41, 7, 54, 9); -- Spring 2017 - Maurise

insert into course (id, department_id, number, name, credits, type) values (10, 1, 465, 'Databases', 4, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (42, 1, 42, 10), -- Fall 2013 - Kare
      (43, 2, 42, 10), -- Spring 2014 - Kare
      (44, 3, 19, 10), -- Fall 2014 - Evered
      (45, 4, 18, 10), -- Spring 2015 - Ferdinand
      (46, 5, 42, 10), -- Fall 2015 - Kare
      (47, 7, 42, 10), -- Fall 2016 - Kare
      (48, 8, 54, 10); -- Spring 2017 - Maurise

insert into course (id, department_id, number, name, credits, type) values (11, 1, 321, 'Complexity Theory', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (49, 1, 18, 11), -- Fall 2013 - Ferdinand
      (50, 3, 42, 11), -- Fall 2014 - Kare
      (51, 4, 18, 11), -- Spring 2015 - Ferdinand
      (52, 5, 119, 11), -- Fall 2015 - Nadya
      (53, 6, 18, 11), -- Spring 2016 - Ferdinand
      (54, 7, 119, 11), -- Fall 2016 - Nadya
      (55, 8, 42, 11); -- Spring 2017 - Kare

insert into course (id, department_id, number, name, credits, type) values (12, 1, 502, 'Machine Learning I', 4, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (56, 1, 18, 12), -- Fall 2013 - Ferdinand
      (57, 3, 42, 12), -- Fall 2014 - Kare
      (58, 5, 18, 12), -- Fall 2015 - Ferdinand
      (59, 7, 42, 12), -- Fall 2016 - Kare
      (60, 8, 42, 12); -- Spring 2017 - Kare

--   ****** END COMPUTER SCIENCE COURSES AND CLASSES

--   ---––––––-------------------------------------------

--   ****** MUSIC COURSES AND CLASSES

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (81, 'Beau', 'Brotherwood', 'b.brotherwood@libra.edu', null, '1998-04-03', null); -- Profile: Beau: 16
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (16, 81, 'professor', false, false, '2003-04-11', '102000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (78, 'Verla', 'Northcote', 'v.northcote@libra.edu', 'female', '1947-11-21', 36337); -- Profile: Verla: 78
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (78, 78, 'associate professor', false, true, '2002-09-24', '67000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (114, 'Fless', 'Beacock', 'f.beacock@libra.edu', 'female', '1990-01-07', 37010); -- Profile: Fless 32
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (32, 114, 'instructor', false, true, '2009-06-10', '40000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (80, 'Samuel', 'Cockitt', 's.cockitt@libra.edu', 'male', '1981-02-05', 35609); -- Profile: Samuel: 58
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (58, 80, 'instructor', false, false, '2010-12-26', '54000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (56, 'Jessica', 'Byne', 'j.byne@libra.edu', 'female', '1952-07-17', null); -- Profile: Jessica: 98
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (98, 56, 'associate professor', false, true, '2005-08-30', '69000.00'); -- Teacher: ^^

insert into course (id, department_id, number, name, credits, type) values (69, 2, 102, 'Musicianship', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (61, 1, 78, 69), -- Fall 2013 - Verla
      (62, 3, 78, 69), -- Fall 2014 - Verla
      (63, 5, 16, 69), -- Fall 2015 - Beau
      (64, 7, 32, 69); -- Fall 2016 - Fless

insert into course (id, department_id, number, name, credits, type) values (13, 2, 108, 'Music History I', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (65, 2, 32, 13), -- Spring 2014 - Fless
      (66, 4, 78, 13), -- Spring 2015 - Verla
      (67, 6, 16, 13), -- Spring 2016 - Beau
      (68, 8, 16, 13); -- Spring 2017 - Beau

insert into course (id, department_id, number, name, credits, type) values (14, 2, 121, 'Theory I', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (69, 1, 78, 14), -- Fall 2013 - Verla
      (70, 3, 78, 14), -- Fall 2014 - Verla
      (71, 5, 16, 14), -- Fall 2015 - Beau
      (72, 7, 58, 14); -- Fall 2016 - Samuel

insert into course (id, department_id, number, name, credits, type) values (15, 2, 149, 'Performance Ensemble I', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (73, 2, 58, 15), -- Spring 2014 - Samuel
      (74, 4, 58, 15), -- Spring 2015 - Samuel
      (75, 6, 16, 15), -- Spring 2016 - Beau
      (76, 8, 78, 15); -- Spring 2017 - Verla

insert into course (id, department_id, number, name, credits, type) values (16, 2, 233, 'Theory II', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (77, 1, 98, 16), -- Fall 2013 - Jessica
      (78, 3, 16, 16), -- Fall 2014 - Beau
      (79, 5, 78, 16), -- Fall 2015 - Verla
      (80, 7, 98, 16); -- Fall 2016 - Jessica

insert into course (id, department_id, number, name, credits, type) values (17, 2, 210, 'Electronic Music & Composition', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (81, 2, 98, 17), -- Spring 2014 - Jessica
      (82, 4, 98, 17), -- Spring 2015 - Jessica
      (83, 6, 98, 17), -- Spring 2016 - Jessica
      (84, 8, 16, 17); -- Spring 2017 - Beau

insert into course (id, department_id, number, name, credits, type) values (18, 2, 322, 'Advanced Theory Topics in Global Music', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (85, 1, 32, 18), -- Fall 2013 - Fless
      (86, 3, 78, 18), -- Fall 2014 - Verla
      (87, 5, 32, 18), -- Fall 2015 - Fless
      (88, 7, 16, 18); -- Fall 2016 - Beau

insert into course (id, department_id, number, name, credits, type) values (19, 2, 184, 'Arranging for Vocals', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (89, 2, 16, 19), -- Spring 2014 - Beau
      (90, 3, 32, 19), -- Fall 2014 - Fless
      (91, 5, 98, 19), -- Fall 2015 - Jessica
      (92, 6, 78, 19), -- Spring 2016 - Verla
      (93, 7, 58, 19), -- Fall 2016 - Samuel
      (94, 8, 98, 19); -- Spring 2017 - Jessica

insert into course (id, department_id, number, name, credits, type) values (20, 2, 212, 'Tonal Harmony and Composition', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (95, 1, 58, 20), -- Fall 2013 - Samuel
      (96, 5, 78, 20), -- Fall 2015 - Verla
      (97, 6, 58, 20), -- Spring 2016 - Samuel
      (98, 8, 58, 20); -- Spring 2017 - Samuel

insert into course (id, department_id, number, name, credits, type) values (21, 2, 274, 'Scoring for Strings', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (99, 2, 58, 21), -- Spring 2014 - Samuel
      (100, 3, 78, 21), -- Fall 2014 - Verla
      (101, 4, 58, 21), -- Spring 2015 - Samuel
      (102, 7, 58, 21); -- Fall 2016 - Samuel

insert into course (id, department_id, number, name, credits, type) values (22, 2, 403, 'World Music Composition', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (103, 1, 78, 22), -- Fall 2013 - Verla
      (104, 3, 32, 22), -- Fall 2014 - Fless
      (105, 4, 32, 22), -- Spring 2015 - Fless
      (106, 5, 98, 22), -- Fall 2015 - Jessica
      (107, 6, 16, 22), -- Spring 2016 - Beau
      (108, 7, 16, 22), -- Fall 2016 - Beau
      (109, 8, 58, 22); -- Spring 2017 - Samuel

--   ****** END MUSIC COURSES AND CLASSES

--   ---––––––-------------------------------------------

--   ****** LINGUISTICS COURSES AND CLASSES

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (111, 'Clary', 'Pickvance', 'c.pickvance@libra.edu', 'female', '1987-08-11', 35749); -- Profile: Clary: 52
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (52, 111, 'professor', false, true, '2001-10-11', '104000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (120, 'Eran', 'Remmer', 'e.remmer@libra.edu', 'female', '1977-11-13', 35569); -- Profile: Eran: 29
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (29, 120, 'instructor', false, true, '2000-03-04', '56000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (76, 'Izak', 'Bradnocke', 'i.bradnocke@libra.edu', 'male', '1993-12-15', 36395); -- Profile: Izak: 17
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (17, 76, 'assistant professor', false, true, '2001-02-04', '53000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (104, 'Ronni', 'Sedwick', 'r.sedwick@libra.edu', 'female', '1940-07-15', 37993); -- Profile: Ronni: 26
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (26, 104, 'associate professor', true, true, '2011-04-16', '67000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (69, 'Cathrine', 'Swan', 'c.swan@libra.edu', 'female', '1932-04-10', 37742); -- Profile: Cathrine: 7
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (7, 69, 'professor', false, true, '2010-03-16', '95000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (17, 'Ronda', 'Emmot', 'r.emmot@libra.edu', 'female', '1998-11-30', 37487); -- Profile: Ronda: 76
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (76, 17, 'associate professor', false, true, '2008-08-04', '65000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (41, 'Martin', 'Lindenberg', 'm.lindenberg@libra.edu', null, '1979-10-04', 37890); -- Profile: Martin: 60
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (60, 41, 'assistant professor', true, true, '2000-07-28', '49000.00'); -- Teacher ^^

insert into course (id, department_id, number, name, credits, type) values (23, 3, 102, 'Intro to Language & Linguistics', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (169, 1, 26, 23), -- Fall 2013 - Ronni
      (170, 3, 26, 23), -- Fall 2014 - Ronni
      (171, 5, 52, 23), -- Fall 2015 - Clary
      (172, 7, 26, 23); -- Fall 2016 - Ronni

insert into course (id, department_id, number, name, credits, type) values (24, 3, 113, 'Phonetics & Phonology', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (173, 2, 17, 24), -- Spring 2014 - Izak
      (174, 4, 29, 24), -- Spring 2015 - Eran
      (175, 6, 26, 24), -- Spring 2016 - Ronni
      (176, 8, 52, 24); -- Spring 2017 - Clary

insert into course (id, department_id, number, name, credits, type) values (25, 3, 212, 'Psychology of Language', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (177, 1, 29, 25), -- Fall 2013 - Eran
      (178, 3, 52, 25), -- Fall 2014 - Clary
      (179, 5, 29, 25), -- Fall 2015 - Eran
      (180, 7, 29, 25); -- Fall 2016 - Eran

insert into course (id, department_id, number, name, credits, type) values (26, 3, 239, 'Intro to Machine Translation', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (181, 2, 26, 26), -- Spring 2014 - Ronni
      (182, 4, 7, 26), -- Spring 2015 - Cathrine
      (183, 6, 7, 26), -- Spring 2016 - Cathrine
      (184, 8, 26, 26); -- Spring 2017 - Ronni

insert into course (id, department_id, number, name, credits, type) values (27, 3, 248, 'Languages of Mesopotamia', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (185, 1, 29, 27), -- Fall 2013 - Eran
      (186, 3, 26, 27), -- Fall 2014 - Ronni
      (187, 5, 7, 27), -- Fall 2015 - Cathrine
      (188, 7, 76, 27); -- Fall 2016 - Ronda

insert into course (id, department_id, number, name, credits, type) values (28, 3, 290, 'Sociolinguistics ', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (306, 2, 7, 28), -- Spring 2014 - Cathrine
      (307, 4, 76, 28), -- Spring 2015 - Ronda
      (308, 6, 7, 28), -- Spring 2016 - Cathrine
      (189, 8, 17, 28); -- Spring 2017 - Izak

insert into course (id, department_id, number, name, credits, type) values (29, 3, 323, 'Deciphering Ancient Languages', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (190, 1, 17, 29), -- Fall 2013 - Izak
      (191, 3, 17, 29), -- Fall 2014 - Izak
      (192, 5, 7, 29), -- Fall 2015 - Cathrine
      (193, 7, 76, 29); -- Fall 2016 - Ronda

insert into course (id, department_id, number, name, credits, type) values (30, 3, 403, 'Linguistics of American Sign Language', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (194, 2, 7, 30), -- Spring 2014 - Cathrine
      (195, 3, 29, 30), -- Fall 2014 - Eran
      (196, 4, 52, 30), -- Spring 2015 - Clary
      (197, 5, 76, 30), -- Fall 2015 - Ronda
      (198, 6, 60, 30), -- Spring 2016 - Martin
      (199, 7, 60, 30); -- Fall 2016 - Martin

insert into course (id, department_id, number, name, credits, type) values (31, 3, 342, 'Introduction to Indo-European', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (200, 3, 26, 31), -- Fall 2014 - Ronni
      (201, 6, 17, 31), -- Spring 2016 - Izak
      (202, 7, 17, 31), -- Fall 2016 - Izak
      (203, 8, 60, 31); -- Spring 2017 - Martin

insert into course (id, department_id, number, name, credits, type) values (32, 3, 383, 'Bilingualism', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (309, 1, 60, 32), -- Fall 2013 - Martin
      (310, 4, 76, 32), -- Spring 2015 - Ronda
      (311, 5, 29, 32), -- Fall 2015 - Eran
      (312, 6, 60, 32), -- Spring 2016 - Martin
      (313, 8, 17, 32); -- Spring 2017 - Izak

insert into course (id, department_id, number, name, credits, type) values (33, 3, 412, 'Advanced Syntax', 4, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (314, 1, 17, 33), -- Fall 2013 - Izak
      (315, 2, 26, 33), -- Spring 2014 - Ronni
      (316, 3, 76, 33), -- Fall 2014 - Ronda
      (317, 5, 29, 33), -- Fall 2015 - Eran
      (318, 8, 60, 33); -- Spring 2017 - Martin

--   ****** END LINGUISTICS COURSES AND CLASSES

--   ---––––––-------------------------------------------

--   ****** MATHEMATICS COURSES AND CLASSES

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (101, 'Gabriell', 'Stratton', 'g.stratton@libra.edu', null, '1935-09-11', 36077); -- Profile: Gabriell: 84
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (84, 101, 'professor', false, true, '2009-11-22', '105000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (58, 'Wakefield', 'Ragsdale', 'w.ragsdale@libra.edu', 'male', '2008-03-17', 36406); -- Profile: Wakefield: 80
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (80, 58, 'associate professor', true, true, '2000-10-07', '78000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (6, 'Lilas', 'Noen', 'l.noen@libra.edu', 'female', '1943-02-02', 38263); -- Profile: Lilas: 77
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (77, 6, 'instructor', false, false, '2004-03-20', '38000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (107, 'Alvin', 'Barthrop', 'a.barthrop@libra.edu', 'male', '1947-09-14', 37288); -- Profile: Alvin: 88
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (88, 107, 'professor', false, false, '2008-09-22', '87000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (93, 'Brucie', 'Schwerin', 'b.schwerin@libra.edu', 'male', '1967-01-17', 38028); -- Profile: Brucie: 93
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (93, 93, 'associate professor', false, true, '2004-04-23', '61000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (60, 'Vito', 'Bigrigg', 'v.bigrigg@libra.edu', 'male', '1940-10-29', 36771); -- Profile: Vito: 41
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (41, 60, 'assistant professor', true, true, '2000-07-31', '53000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (4, 'Clemmie', 'Haldane', 'c.haldane@libra.edu', 'female', '1933-08-07', 36070); -- Profile: Clemmie: 95
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (95, 4, 'professor', false, true, '2002-01-25', '92000.00');

insert into course (id, department_id, number, name, credits, type) values (34, 4, 102, 'Calculus I', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (204, 1, 88, 34), -- Fall 2013 - Alvin
      (205, 3, 77, 34), -- Fall 2014 - Lilas
      (206, 5, 88, 34), -- Fall 2015 - Alvin
      (207, 7, 80, 34); -- Fall 2016 - Wakefield

insert into course (id, department_id, number, name, credits, type) values (35, 4, 212, 'Calculus II', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (208, 2, 84, 35), -- Spring 2014 - Gabriell
      (209, 4, 88, 35), -- Spring 2015 - Alvin
      (210, 6, 88, 35), -- Spring 2016 - Alvin
      (211, 8, 77, 35); -- Spring 2017 - Lilas

insert into course (id, department_id, number, name, credits, type) values (36, 4, 242, 'Discrete Mathematics I', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (212, 1, 93, 36), -- Fall 2013 - Brucie
      (213, 3, 88, 36), -- Fall 2014 - Alvin
      (214, 5, 93, 36), -- Fall 2015 - Brucie
      (215, 7, 77, 36); -- Fall 2016 - Lilas

insert into course (id, department_id, number, name, credits, type) values (37, 4, 292, 'Calculus III', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (216, 2, 80, 37), -- Spring 2014 - Wakefield
      (217, 4, 77, 37), -- Spring 2015 - Lilas
      (218, 6, 80, 37), -- Spring 2016 - Wakefield
      (219, 8, 93, 37); -- Spring 2017 - Brucie

insert into course (id, department_id, number, name, credits, type) values (38, 4, 320, 'Computational Linear Algebra', 3, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (220, 1, 88, 38), -- Fall 2013 - Alvin
      (221, 3, 80, 38), -- Fall 2014 - Wakefield
      (222, 5, 84, 38), -- Fall 2015 - Gabriell
      (223, 7, 93, 38); -- Fall 2016 - Brucie

insert into course (id, department_id, number, name, credits, type) values (39, 4, 422, 'Differential Equations I', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (224, 2, 80, 39), -- Spring 2014 - Wakefield
      (225, 4, 41, 39), -- Spring 2015 - Vito
      (226, 6, 77, 39), -- Spring 2016 - Lilas
      (227, 8, 93, 39); -- Spring 2017 - Brucie

insert into course (id, department_id, number, name, credits, type) values (40, 4, 489, 'Abstract Algebra I', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (228, 1, 41, 40), -- Fall 2013 - Vito
      (229, 3, 84, 40), -- Fall 2014 - Gabriell
      (230, 5, 41, 40), -- Fall 2015 - Vito
      (231, 7, 41, 40); -- Fall 2016 - Vito

insert into course (id, department_id, number, name, credits, type) values (41, 4, 341, 'Integral Equations', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (232, 2, 80, 41), -- Spring 2014 - Wakefield
      (233, 4, 41, 41), -- Spring 2015 - Vito
      (234, 5, 41, 41), -- Fall 2015 - Vito
      (235, 6, 95, 41), -- Spring 2016 - Clemmie
      (236, 8, 93, 41); -- Spring 2017 - Brucie

insert into course (id, department_id, number, name, credits, type) values (42, 4, 382, 'Analysis I', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (237, 1, 93, 42), -- Fall 2013 - Brucie
      (238, 2, 95, 42), -- Spring 2014 - Clemmie
      (239, 3, 84, 42), -- Fall 2014 - Gabriell
      (240, 5, 41, 42), -- Fall 2015 - Vito
      (241, 7, 77, 42); -- Fall 2016 - Lilas

insert into course (id, department_id, number, name, credits, type) values (43, 4, 445, 'Distributed Algorithms', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (242, 4, 95, 43), -- Spring 2015 - Clemmie
      (243, 5, 95, 43), -- Fall 2015 - Clemmie
      (244, 6, 41, 43), -- Spring 2016 - Vito
      (245, 7, 95, 43), -- Fall 2016 - Clemmie
      (246, 8, 93, 43); -- Spring 2017 - Brucie

insert into course (id, department_id, number, name, credits, type) values (44, 4, 532, 'Geometric Combinatorics', 4, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (247, 1, 88, 44), -- Fall 2013 - Alvin
      (248, 2, 41, 44), -- Spring 2014 - Vito
      (249, 3, 95, 44), -- Fall 2014 - Clemmie
      (250, 4, 80, 44), -- Spring 2015 - Wakefield
      (251, 5, 80, 44), -- Fall 2015 - Wakefield
      (252, 6, 77, 44), -- Spring 2016 - Lilas
      (253, 7, 84, 44), -- Fall 2016 - Gabriell
      (254, 8, 41, 44); -- Spring 2017 - Vito

--   ****** END MATHEMATICS COURSES AND CLASSES

--   ---––––––-------------------------------------------

--   ****** ECONOMICS COURSES AND CLASSES

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (23, 'Sandro', 'Antonin', 's.antonin@libra.edu', 'male', '1988-07-31', 35856); -- Profile: Sandro: 28
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (28, 23, 'instructor', false, true, '2008-02-26', '56000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (116, 'Cari', 'Langley', 'c.langley@libra.edu', 'female', '1952-02-26', 38285); -- Profile: Cari: 34
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (34, 116, 'professor', false, true, '2005-11-26', '78000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (35, 'Tessy', 'Harback', 't.harback@libra.edu', 'female', '2003-01-06', null); -- Profile: Tessy: 89
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (89, 35, 'professor', false, true, '2000-03-02', '95000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (16, 'Moina', 'Tattersdill', 'm.tattersdill@libra.edu', 'female', '1983-06-22', 35934); -- Profile: Moina: 81
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (81, 16, 'associate professor', false, false, '2002-03-05', '72000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (63, 'Rowen', 'Holwell', 'r.holwell@libra.edu', 'male', '1950-01-25', 36150); -- Profile: Rowen: 47
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (47, 63, 'associate professor', false, true, '2011-06-06', '64000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (12, 'Evelin', 'Iddy', 'e.iddy@libra.edu', 'male', '1951-12-05', 38242); -- Profile: Evelin: 73
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (73, 12, 'assistant professor', false, true, '2004-01-04', '52000.00'); -- Teacher ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (77, 'Laurella', 'Castille', 'l.castille@libra.edu', 'female', '1939-07-21', null); -- Profile: Laurella: 6
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (6, 77, 'professor', false, false, '2001-02-09', '99000.00'); -- Teacher ^^


insert into course (id, department_id, number, name, credits, type) values (45, 5, 103, 'Principles of Microeconomics', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (255, 1, 34, 45), -- Fall 2013 - Cari
      (256, 3, 89, 45), -- Fall 2014 - Tessy
      (257, 5, 34, 45), -- Fall 2015 - Cari
      (258, 7, 28, 45); -- Fall 2016 - Sandro

insert into course (id, department_id, number, name, credits, type) values (46, 5, 210, 'Principles of Macroeconomics', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (259, 2, 28, 46), -- Spring 2014 - Sandro
      (260, 4, 34, 46), -- Spring 2015 - Cari
      (261, 6, 89, 46), -- Spring 2016 - Tessy
      (262, 8, 81, 46); -- Spring 2017 - Moina

insert into course (id, department_id, number, name, credits, type) values (47, 5, 298, 'International Monetary Economics', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (263, 1, 34, 47), -- Fall 2013 - Cari
      (264, 3, 81, 47), -- Fall 2014 - Moina
      (265, 5, 81, 47), -- Fall 2015 - Moina
      (266, 7, 28, 47); -- Fall 2016 - Sandro

insert into course (id, department_id, number, name, credits, type) values (48, 5, 320, 'Law and Economics', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (267, 2, 81, 48), -- Spring 2014 - Moina
      (268, 4, 89, 48), -- Spring 2015 - Tessy
      (269, 6, 47, 48), -- Spring 2016 - Rowen
      (270, 8, 47, 48); -- Spring 2017 - Rowen

insert into course (id, department_id, number, name, credits, type) values (49, 5, 411, 'Corporate Restructuring', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (271, 1, 47, 49), -- Fall 2013 - Rowen
      (272, 3, 73, 49), -- Fall 2014 - Evelin
      (273, 5, 34, 49), -- Fall 2015 - Cari
      (274, 7, 73, 49); -- Fall 2016 - Evelin

insert into course (id, department_id, number, name, credits, type) values (50, 5, 423, 'Urban Economics', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (275, 2, 73, 50), -- Spring 2014 - Evelin
      (276, 4, 34, 50), -- Spring 2015 - Cari
      (277, 6, 28, 50), -- Spring 2016 - Sandro
      (278, 8, 47, 50); -- Spring 2017 - Rowen

insert into course (id, department_id, number, name, credits, type) values (51, 5, 488, 'Game Theory', 4, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (279, 1, 28, 51), -- Fall 2013 - Sandro
      (280, 3, 73, 51), -- Fall 2014 - Evelin
      (281, 5, 6, 51), -- Fall 2015 - Laurella
      (282, 7, 28, 51); -- Fall 2016 - Sandro

insert into course (id, department_id, number, name, credits, type) values (52, 5, 412, 'Public Finance', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (283, 1, 6, 52), -- Fall 2013 - Laurella
      (284, 2, 6, 52), -- Spring 2014 - Laurella
      (285, 4, 89, 52), -- Spring 2015 - Tessy
      (286, 6, 81, 52), -- Spring 2016 - Moina
      (287, 8, 28, 52); -- Spring 2017 - Sandro

insert into course (id, department_id, number, name, credits, type) values (53, 5, 389, 'Advanced Macroeconomic Theory', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (288, 2, 47, 53), -- Spring 2014 - Rowen
      (289, 3, 73, 53), -- Spring 2014 - Evelin
      (290, 5, 47, 53), -- Spring 2015 - Rowen
      (291, 7, 34, 53), -- Spring 2016 - Cari
      (292, 8, 6, 53); -- Spring 2017 - Laurella

insert into course (id, department_id, number, name, credits, type) values (54, 5, 521, 'Asset Pricing', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (293, 2, 47, 54), -- Spring 2014 - Rowen
      (294, 3, 89, 54), -- Fall 2014 - Tessy
      (295, 5, 47, 54), -- Fall 2015 - Rowen
      (296, 7, 34, 54), -- Fall 2016 - Cari
      (297, 8, 6, 54); -- Spring 2017 - Laurella

insert into course (id, department_id, number, name, credits, type) values (55, 5, 467, 'Health Economics', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (298, 1, 73, 55), -- Fall 2013 - Evelin
      (299, 2, 28, 55), -- Spring 2014 - Sandro
      (300, 3, 73, 55), -- Fall 2014 - Evelin
      (301, 4, 6, 55), -- Spring 2015 - Laurella
      (302, 5, 81, 55), -- Fall 2015 - Moina
      (303, 6, 6, 55), -- Spring 2016 - Laurella
      (304, 7, 34, 55), -- Fall 2016 - Cari
      (305, 8, 28, 55); -- Spring 2017 - Sandro

--   ****** END ECONOMICS COURSES AND CLASSES

--   ---––––––-------------------------------------------

--   ****** LIBERAL ARTS COURSES AND CLASSES

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (96, 'Mercy', 'Spring', 'm.spring@libra.edu', 'female', '2000-10-27', 35674); -- Profile: Mercy: 14
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (14, 96, 'assistant professor', false, true, 6, '2007-08-15', '56000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (52, 'Joel', 'Alenichev', 'j.alenichev@libra.edu', 'male', '1947-12-14', 37891); -- Profile: Joel: 24
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (24, 52, 'assistant professor', false, true, 6, '2007-08-25', '47000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (13, 'Renato', 'Dyment', 'r.dyment@libra.edu', 'male', '1955-04-07', null); -- Profile: Renato: 46
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (46, 13, 'associate professor', false, true, 6, '2002-06-17', '61000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (48, 'Lacy', 'Toten', 'l.toten@libra.edu', 'male', '1956-02-20', 37530); -- Profile: Lacy: 57
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (57, 48, 'associate professor', false, true, 6, '2006-05-20', '67000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (53, 'Hesther', 'Yanyshev', 'h.yanyshev@libra.edu', 'female', '1964-09-21', 37595); -- Profile: Hesther: 75
  insert into faculty (id, profile_id, rank, tenure, active, department_id, hire_date, salary) values (75, 53, 'assistant professor', false, true, 6, '2005-12-22', '55000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (64, 'Benson', 'Eseler', 'b.eseler@libra.edu', 'male', '1932-08-29', 38234); -- Profile: Benson: 64
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (64, 64, 'assistant professor', false, false, '2011-03-31', '57000.00'); -- Teacher: ^^
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (119, 'Sylvia', 'MacCallion', 's.maccallion@libra.edu', 'female', '1947-10-12', 35796); -- Profile: Sylvia: 90
  insert into faculty (id, profile_id, rank, tenure, active, hire_date, salary) values (90, 119, 'associate professor', false, true, '2005-09-21', '71000.00'); -- Teacher: ^^

insert into course (id, department_id, number, name, credits, type) values (56, 6, 102, 'Success at Libra University', 2, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (110, 1, 24, 56), -- Fall 2013 - Joel
      (111, 2, 14, 56), -- Spring 2014 - Mercy
      (112, 3, 14, 56), -- Fall 2014 - Mercy
      (113, 4, 46, 56), -- Spring 2015 - Renato
      (114, 5, 14, 56), -- Fall 2015 - Mercy
      (115, 6, 46, 56), -- Spring 2016 - Renato
      (116, 7, 57, 56), -- Fall 2016 - Lacy
      (117, 8, 57, 56); -- Spring 2017 - Lacy

insert into course (id, department_id, number, name, credits, type) values (57, 6, 103, 'Effective Communication', 2, 'core');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (118, 2, 14, 57), -- Spring 2014 - Mercy
      (119, 4, 57, 57), -- Spring 2015 - Lacy
      (120, 6, 14, 57), -- Spring 2016 - Mercy
      (121, 8, 57, 57); -- Spring 2017 - Lacy

insert into course (id, department_id, number, name, credits, type) values (58, 6, 145, 'Nations and Nationalism', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (122, 1, 46, 58), -- Fall 2013 - Reneto
      (123, 3, 75, 58), -- Fall 2014 - Hesther
      (124, 5, 14, 58), -- Fall 2015 - Mercy
      (125, 7, 46, 58); -- Fall 2016 - Reneto

insert into course (id, department_id, number, name, credits, type) values (59, 6, 212, 'Ancient Religions and Philosophies', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (126, 2, 64, 59), -- Spring 2014 - Benson
      (127, 4, 64, 59), -- Spring 2015 - Benson
      (128, 6, 75, 59), -- Spring 2016 - Hesther
      (129, 8, 64, 59); -- Spring 2017 - Benson

insert into course (id, department_id, number, name, credits, type) values (60, 6, 234, 'History of Modern East Asia', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (130, 1, 75, 60), -- Fall 2013 - Hesther
      (131, 3, 46, 60), -- Fall 2014 - Renato
      (132, 5, 75, 60), -- Fall 2015 - Hesther
      (133, 7, 75, 60); -- Fall 2016 - Hesther

insert into course (id, department_id, number, name, credits, type) values (61, 6, 248, 'Palestinian-Israeli Relations', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (134, 2, 46, 61), -- Spring 2014 - Renato
      (135, 4, 46, 61), -- Spring 2015 - Renato
      (136, 6, 46, 61), -- Spring 2016 - Renato
      (137, 8, 57, 61); -- Spring 2017 - Lacy

insert into course (id, department_id, number, name, credits, type) values (62, 6, 323, 'International Human Rights', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (138, 1, 24, 62), -- Fall 2013 - Joel
      (139, 3, 24, 62), -- Fall 2014 - Joel
      (140, 5, 14, 62), -- Fall 2015 - Mercy
      (141, 7, 75, 62); -- Fall 2016 - Hesther

insert into course (id, department_id, number, name, credits, type) values (63, 6, 412, 'Mythology and Folklore', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (142, 2, 24, 63), -- Spring 2014 - Joel
      (143, 4, 24, 63), -- Spring 2015 - Joel
      (144, 6, 57, 63), -- Spring 2016 - Lacy
      (145, 8, 64, 63); -- Spring 2017 - Benson

insert into course (id, department_id, number, name, credits, type) values (64, 6, 428, 'Gender and Power in History', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (146, 1, 24, 64), -- Fall 2013 - Joel
      (147, 3, 14, 64), -- Fall 2014 - Mercy
      (148, 5, 14, 64), -- Fall 2015 - Mercy
      (149, 7, 14, 64); -- Fall 2016 - Mercy

insert into course (id, department_id, number, name, credits, type) values (65, 6, 378, 'Ethical Theories', 2, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (150, 2, 90, 65), -- Spring 2014 - Sylvia
      (151, 4, 90, 65), -- Spring 2015 - Sylvia
      (152, 6, 57, 65), -- Spring 2016 - Lacy
      (153, 8, 75, 65); -- Spring 2017 - Hesther

insert into course (id, department_id, number, name, credits, type) values (66, 6, 311, 'Theory of Knowledge', 3, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (154, 1, 90, 56), -- Fall 2013 - Sylvia
      (155, 3, 64, 56), -- Fall 2014 - Benson
      (156, 4, 90, 56), -- Spring 2015 - Sylvia
      (157, 5, 24, 56), -- Fall 2015 - Joel
      (158, 7, 64, 56); -- Fall 2016 - Benson

insert into course (id, department_id, number, name, credits, type) values (67, 6, 344, 'History of Rhetoric', 2, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (159, 1, 64, 56), -- Fall 2013 - Benson
      (160, 2, 64, 56), -- Spring 2014 - Benson
      (161, 4, 90, 56), -- Spring 2015 - Sylvia
      (162, 6, 90, 56), -- Spring 2016 - Sylvia
      (163, 8, 75, 56); -- Spring 2017 - Besther

insert into course (id, department_id, number, name, credits, type) values (68, 6, 239, 'Topics in Archaeology', 2, 'elective');
  insert into class (id, semester_id, faculty_id, course_id)
    values
      (164, 1, 90, 56), -- Fall 2013 - Sylvia
      (165, 2, 64, 56), -- Spring 2014 - Benson
      (166, 5, 64, 56), -- Fall 2015 - Benson
      (167, 7, 46, 56), -- Fall 2016 - Renato
      (168, 8, 46, 56); -- Spring 2017 - Renato

--   ****** END LIBERAL ARTS COURSES AND CLASSES

--   ---––––––----------------------------------------------------------------------------------------------------------


--   ****** STUDENTS AND THEIR CLASS SEATS

-- CS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (201, 'Hannah', 'Townes', 'h.townes@libra.edu', 'male', '2000-10-19', 36949);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (1, 201, 3.23, 6000.00, 1, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (1, 1, 1, 89.43, 0), -- CS 111 - Intro to Computer Science
    (2, 61, 1, 89.22, 1), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (3, 6, 1, 78.02, 2), -- CS 123 - Mathematical Foundations of Computing
    (4, 77, 1, 93.33, 0), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2014 - Semester 3
    (5, 10, 1, 91.03, 1), -- CS 203 - Data Structures
    (6, 74, 1, 78, 1), -- LA 145 - Nations and Nationalism
    -- SPRING 2015 - Semester 4
    (7, 15, 1, 83.38, 0), -- CS 231 - Computer Architecture
    (8, 86, 1, 72.90, 3), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2015 - Semester 5
    (9, 20, 1, 81.39, 1), -- CS 302 - System Programming
    (10, 83, 1, 86.00, 0), -- LA 234 - History of Modern East Asia
    -- SPRING 2016 - Semester 6
    (11, 24, 1, 80.32, 0), -- CS 412 - Algorithm Design
    (12, 54, 1, 92.00, 0), -- CS 321 - Complexity Theory
    -- FALL 2016 - Semester 7
    (13, 29, 1, 93.48, 0), -- CS 412 - Software Development
    (14, 47, 1, 94.09, 1), -- CS 465 - Databases
    (15, 100, 1, 73.34, 2), -- LA 428 - Gender and Power in History
    -- SPRING 2017 - Semester 8
    (16, 60, 1, 93.38, 0), -- CS 502 - Machine Learning I
    (17, 104, 1, 88.29, 0); -- LA 378 - Ethical Theories

-- CS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (203, 'Virgie', 'Woodwin', 'v.woodwin@libra.edu', 'male', '1962-02-08', 37284);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (2, 203, 3.28, null, 1, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (18, 1, 2, 86.49, 1), -- CS 111 - Intro to Computer Science
    (19, 61, 2, 90.12, 2), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (20, 6, 2, 89.29, 1), -- CS 123 - Mathematical Foundations of Computing
    (21, 77, 2, 86.23, 1), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2014 - Semester 3
    (22, 10, 2, 93.23, 0), -- CS 203 - Data Structures
    (23, 74, 2, 83.22, 1), -- LA 145 - Nations and Nationalism
    -- SPRING 2015 - Semester 4
    (24, 15, 2, 83.38, 0), -- CS 231 - Computer Architecture
    (25, 94, 2, 90.23, 1), -- LA 412 - Mythology and Folklore
    -- FALL 2015 - Semester 5
    (26, 20, 2, 81.39, 3), -- CS 302 - System Programming
    (27, 83, 2, 86.00, 3), -- LA 234 - History of Modern East Asia
    -- SPRING 2016 - Semester 6
    (28, 24, 2, 85.83, 2), -- CS 412 - Algorithm Design
    (29, 54, 2, 91.00, 0), -- CS 321 - Complexity Theory
    -- FALL 2016 - Semester 7
    (30, 29, 2, 93.48, 1), -- CS 412 - Software Development
    (31, 35, 2, 94.09, 1), -- CS 308 - System Networking
    (32, 109, 2, 84.23, 1), -- LA 311 - Theory of Knowledge
    -- SPRING 2017 - Semester 8
    (33, 60, 2, 93.38, 1), -- CS 502 - Machine Learning I
    (34, 114, 2, 90.95, 2); -- LA 344 - History of Rhetoric

-- CS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (153, 'Kaylyn', 'MacClenan', 'k.macclenan@libra.edu', 'female', '1980-07-08', 35906);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (3, 153, 3.51, 8000.00, 1, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (35, 1, 3, 93.09, 1), -- CS 111 - Intro to Computer Science
    (36, 73, 3, 85.31, 1), -- LA 145 - Nations and Nationalism
    -- SPRING 2014 - Semester 2
    (37, 6, 3, 89.29, 1), -- CS 123 - Mathematical Foundations of Computing
    (38, 77, 3, 86.23, 1), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2014 - Semester 3
    (39, 10, 3, 93.23, 0), -- CS 203 - Data Structures
    (40, 50, 3, 90.2, 1), -- CS 321 - Complexity Theory
    -- SPRING 2015 - Semester 4
    (41, 15, 3, 83.38, 1), -- CS 231 - Computer Architecture
    (42, 86, 3, 68.48, 4), -- LA 234 - Palestinian-Israeli Relations
    -- FALL 2015 - Semester 5
    (43, 20, 3, 89.99, 3), -- CS 302 - System Programming
    (44, 83, 3, 88.23, 3), -- LA 234 - History of Modern East Asia
    -- SPRING 2016 - Semester 6
    (45, 24, 3, 93.89, 1), -- CS 412 - Algorithm Design
    (46, 34, 3, 78.84, 2), -- CS 308 - System Networking
    -- FALL 2016 - Semester 7
    (47, 29, 3, 91.23, 1), -- CS 412 - Software Development
    (48, 47, 3, 84.34, 1), -- CS 365 - Databases
    (49, 109, 3, 90.00, 1), -- LA 311 - Theory of Knowledge
    -- SPRING 2017 - Semester 8
    (50, 60, 3, 93.38, 1), -- CS 502 - Machine Learning I
    (51, 114, 3, 90.95, 2); -- LA 344 - History of Rhetoric

-- CS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (108, 'Lloyd', 'Cranmer', 'l.cranmer@libra.edu', 'male', '2001-10-21', null);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (4, 108, 3.31, 1400.00, 1, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (52, 1, 4, 88.20, 0), -- CS 111 - Intro to Computer Science
    (53, 61, 4, 69.89, 4), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (54, 6, 4, 80.13, 1), -- CS 123 - Mathematical Foundations of Computing
    (55, 93, 4, 86.23, 1), -- LA 412 - Mythology and Folklore
    -- FALL 2014 - Semester 3
    (56, 10, 4, 91.03, 0), -- CS 203 - Data Structures
    (57, 98, 4, 95.31, 1), -- LA 428 - Gender and Power in History
    -- SPRING 2015 - Semester 4
    (58, 15, 4, 78.98, 1), -- CS 231 - Computer Architecture
    (59, 112, 4, 68.48, 1), -- LA 344 - History of Rhetoric
    -- FALL 2015 - Semester 5
    (60, 20, 4, 90.03, 3), -- CS 302 - System Programming
    (61, 117, 4, 94.02, 3), -- LA 234 - Topics in Archaeology
    -- SPRING 2016 - Semester 6
    (62, 24, 4, 93.89, 1), -- CS 412 - Algorithm Design
    (63, 53, 4, 85.03, 0), -- CS 321 - Complexity Theory
    -- FALL 2016 - Semester 7
    (64, 29, 4, 91.23, 1), -- CS 412 - Software Development
    (65, 49, 4, 89.10, 2), -- CS 333 - User Interface Design
    (66, 92, 4, 88.32, 0), -- LA 323 - International Human Rights
    -- SPRING 2017 - Semester 8
    (67, 60, 4, 93.38, 1), -- CS 502 - Machine Learning I
    (68, 104, 4, 97.32, 0); -- LA 378 - Ethical Theories

-- CS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (105, 'Jacqui', 'Densey', 'j.densey@libra.edu', 'female', '1968-11-02', 37632);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (5, 105, 3.71, null, 1, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (69, 1, 5, 90.02, 0), -- CS 111 - Intro to Computer Science
    (70, 73, 3, 85.31, 1), -- LA 145 - Nations and Nationalism
    -- SPRING 2014 - Semester 2
    (71, 6, 5, 80.23, 1), -- CS 123 - Mathematical Foundations of Computing
    (72, 69, 5, 92.41, 0), -- LA 103 - Effective Communication
    -- FALL 2014 - Semester 3
    (73, 10, 5, 91.03, 0), -- CS 203 - Data Structures
    (74, 82, 5, 90.11, 0), -- LA 234 - History of Modern East Asia
    -- SPRING 2015 - Semester 4
    (75, 15, 5, 78.98, 1), -- CS 231 - Computer Architecture
    (76, 112, 5, 99.32, 1), -- LA 344 - History of Rhetoric
    -- FALL 2015 - Semester 5
    (77, 20, 5, 92.23, 3), -- CS 302 - System Programming
    (78, 117, 5, 73.34, 3), -- LA 234 - Topics in Archaeology
    -- SPRING 2016 - Semester 6
    (79, 24, 5, 84.23, 1), -- CS 412 - Algorithm Design
    (80, 53, 5, 82.55, 0), -- CS 321 - Complexity Theory
    -- FALL 2016 - Semester 7
    (81, 29, 5, 96.11, 1), -- CS 412 - Software Development
    (82, 49, 5, 90.94, 2), -- CS 333 - User Interface Design
    (83, 92, 5, 88.32, 0), -- LA 323 - International Human Rights
    -- SPRING 2017 - Semester 8
    (84, 48, 5, 97.94, 0), -- CS 465 - Databases
    (85, 104, 5, 97.32, 0); -- LA 378 - Ethical Theories

-- MUS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (267, 'Marla', 'Gorke', 'm.gorke@libra.edu', 'female', '2008-01-22', 35940);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (6, 267, 3.83, 800.00, 2, 'Associate', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (86, 61, 6, 83.74, 1), -- MUS 102 - Musicianship
    (87, 110, 6, 89.38, 0), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (88, 65, 6, 96.00, 2), -- MUS 108 - Music History I
    (89, 134, 6, 81.50, 0), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2014 - Semester 3
    (90, 70, 6, 91.03, 0), -- MUS 121 - Theory I
    (91, 100, 6, 62.11, 1), -- MUS 274 - Scoring for Strings
    -- SPRING 2015 - Semester 4
    (92, 74, 6, 83.22, 1), -- MUS 149 - Performance Ensemble 1
    (93, 143, 6, 90.11, 0), -- LA 412 - Mythology and Folklore
    -- FALL 2015 - Semester 5
    (94, 79, 6, 82.00, 1), -- MUS - Theory II
    (95, 117, 6, 68.22, 1), -- LA 234 - Topics in Archaeology
    -- SPRING 2016 - Semester 6
    (96, 83, 6, 84.23, 0), -- MUS 210 - Electronic Music & Composition
    (97, 152, 6, 89.20, 0), -- LA 378 - Ethical Theories
    -- FALL 2016 - Semester 7
    (98, 88, 6, 96.11, 1), -- MUS 322 - Advanced Theory Topics in Global Music
    (99, 108, 6, 90.94, 2), -- MUS 403 - World Music Composition
    (100, 93, 6, 78.19, 0), -- MUS 184 - Arranging for Vocals
    -- SPRING 2017 - Semester 8
    (101, 163, 6, 97.94, 0), -- LA 344 - History of Rhetoric
    (102, 168, 6, 97.32, 0); -- LA 239 - Topics in Archaeology

-- MUS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (158, 'Kendra', 'Folan', 'k.folan@libra.edu', 'female', '1980-09-20', null);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (7, 158, 3.83, null, 2, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (103, 61, 7, 78.22, 2), -- MUS 102 - Musicianship
    (104, 110, 7, 63.23, 3), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (105, 65, 7, 90.32, 2), -- MUS 108 - Music History I
    (106, 134, 7, 81.50, 0), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2014 - Semester 3
    (107, 70, 7, 94.11, 0), -- MUS 121 - Theory I
    (108, 139, 7, 77.23, 1), -- LA 323 - International Human Rights
    -- SPRING 2015 - Semester 4
    (109, 74, 7, 98.22, 1), -- MUS 149 - Performance Ensemble 1
    (110, 156, 7, 88.22, 0), -- LA 311 - Theory of Knowledge
    -- FALL 2015 - Semester 5
    (111, 79, 7, 63.88, 3), -- MUS - Theory II
    (112, 148, 7, 68.22, 1), -- LA 428 - Gender and Power in History
    -- SPRING 2016 - Semester 6
    (113, 83, 7, 80.39, 0), -- MUS 210 - Electronic Music & Composition
    (114, 152, 7, 78.22, 0), -- LA 378 - Ethical Theories
    -- FALL 2016 - Semester 7
    (115, 88, 7, 96.11, 1), -- MUS 322 - Advanced Theory Topics in Global Music
    (116, 125, 7, 88.10, 0), -- LA 145 - Nations and Nationalism
    (117, 167, 7, 98.00, 0), -- LA 239 - Topics in Archaeology
    -- SPRING 2017 - Semester 8
    (118, 94, 7, 92.92, 0), -- MUS 184 - Arranging for Vocals
    (119, 109, 7, 90.00, 1); -- MUS 403 - World Music Composition

-- MUS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (139, 'Hermann', 'Alejandre', 'h.alejandre@libra.edu', 'male', '1968-02-07', 36061);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (8, 139, 3.22, null, 2, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (120, 61, 8, 98.00, 0), -- MUS 102 - Musicianship
    (121, 110, 8, 89.23, 1), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (122, 65, 8, 78.32, 2), -- MUS 108 - Music History I
    (123, 142, 8, 80.22, 0), -- LA 412 - Mythology and Folklore
    -- FALL 2014 - Semester 3
    (124, 70, 8, 90.05, 1), -- MUS 121 - Theory I
    (125, 139, 8, 98.50, 1), -- LA 323 - International Human Rights
    -- SPRING 2015 - Semester 4
    (126, 74, 8, 62.22, 1), -- MUS 149 - Performance Ensemble 1
    (127, 161, 8, 88.22, 0), -- LA 344 - History of Rhetoric
    -- FALL 2015 - Semester 5
    (128, 79, 8, 73.22, 2), -- MUS 233 - Theory II
    (129, 148, 8, 90.01, 0), -- LA 428 - Gender and Power in History
    -- SPRING 2016 - Semester 6
    (130, 83, 8, 90.23, 0), -- MUS 210 - Electronic Music & Composition
    (131, 128, 8, 78.22, 0), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2016 - Semester 7
    (132, 88, 8, 90.23, 1), -- MUS 322 - Advanced Theory Topics in Global Music
    (133, 93, 8, 80.94, 0), -- MUS 184 - Arranging for Vocals
    (134, 167, 8, 83.23, 0), -- LA 239 - Topics in Archaeology
    -- SPRING 2017 - Semester 8
    (135, 94, 8, 90.99, 0), -- MUS 184 - Arranging for Vocals
    (136, 109, 8, 98.23, 1); -- MUS 403 - World Music Composition

-- MUS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (344, 'Billy', 'Altree', 'b.altree@libra.edu', 'female', '1987-01-25', null);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (9, 344, 3.92, 9000.00, 2, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (137, 61, 9, 78.23, 1), -- MUS 102 - Musicianship
    (138, 110, 9, 80.23, 1), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (139, 65, 9, 68.02, 0), -- MUS 108 - Music History I
    (140, 160, 9, 80.22, 1), -- LA 344 - History of Rhetoric
    -- FALL 2014 - Semester 3
    (141, 70, 9, 69.33, 1), -- MUS 121 - Theory I
    (142, 139, 9, 63.03, 0); -- LA 323 - International Human Rights

-- MUS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (91, 'Claudius', 'Volke', 'c.volke@libra.edu', 'male', '1994-12-15', 36134);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (10, 91, 3.22, null, 2, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (143, 61, 10, 99.32, 1), -- MUS 102 - Musicianship
    (144, 146, 10, 89.23, 0), -- LA 428 - Gender and Power in History
    -- SPRING 2014 - Semester 2
    (145, 65, 10, 79.22, 1), -- MUS 108 - Music History I
    (146, 126, 10, 89.33, 0), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2014 - Semester 3
    (147, 70, 10, 90.12, 1), -- MUS 121 - Theory I
    (148, 155, 10, 98.50, 2), -- LA 311 - Theory of Knowledge
    -- SPRING 2015 - Semester 4
    (149, 74, 10, 98.00, 1), -- MUS 149 - Performance Ensemble 1
    (150, 119, 10, 88.22, 0), -- LA 103 - Effective Communication
    -- FALL 2015 - Semester 5
    (151, 79, 10, 89.65, 0), -- MUS 233 - Theory II
    (152, 132, 10, 84.22, 1), -- LA 234 - History of Modern East Asia
    -- SPRING 2016 - Semester 6
    (153, 83, 10, 95.47, 0), -- MUS 210 - Electronic Music & Composition
    (154, 144, 10, 89.22, 1), -- LA 412 - Mythology and Folklore
    (155, 136, 10, 92.01, 1), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2016 - Semester 7
    (156, 88, 10, 95.23, 1), -- MUS 322 - Advanced Theory Topics in Global Music
    (157, 102, 10, 89.01, 0), -- MUS 274 - Scoring for Strings
    -- SPRING 2017 - Semester 8
    (158, 94, 10, 97.22, 0), -- MUS 184 - Arranging for Vocals
    (159, 109, 10, 96.34, 1); -- MUS 403 - World Music Composition

-- LING Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (20, 'Levin', 'Ewens', 'l.ewens@libra.edu', 'male', '1997-09-21', 37419);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (11, 20, 3.10, 2000.00, 3, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (160, 169, 11, 80.65, 0), -- LING 102 - Intro to Language & Linguistics
    (161, 146, 11, 89.23, 0), -- LA 428 - Gender and Power in History
    -- SPRING 2014 - Semester 2
    (162, 173, 11, 82.54, 1), -- LING 113 - Phonetics & Phonology
    (163, 134, 11, 82.44, 1), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2014 - Semester 3
    (164, 178, 11, 84.84, 1), -- LING 212 - Psychology of Language
    (165, 155, 11, 92.23, 0), -- LA 311 - Theory of Knowledge
    -- SPRING 2015 - Semester 4
    (166, 182, 11, 93.84, 1), -- LING 239 - Intro to Machine Translation
    (167, 143, 11, 84.94, 0), -- LA 412 - Mythology and Folklore
    -- FALL 2015 - Semester 5
    (168, 187, 11, 71.68, 0), -- LING 248 - Languages of Mesopotamia
    (169, 148, 11, 89.71, 1), -- LA 428 - Gender and Power in History
    -- SPRING 2016 - Semester 6
    (170, 308, 11, 95.47, 0), -- LANG 290 - Sociolinguistics
    (171, 152, 11, 89.22, 1), -- LA 378 - Ethical Theories
    (172, 162, 11, 92.01, 1), -- LA 344 - History of Rhetoric
    -- FALL 2016 - Semester 7
    (173, 193, 11, 93.85, 1), -- LING 323 - Deciphering Ancient Languages
    (174, 202, 11, 79.51, 0), -- LING 342 - Introduction to Indo-European
    -- SPRING 2017 - Semester 8
    (175, 318, 11, 97.22, 0), -- LING 412 - Advanced Syntax
    (176, 313, 11, 96.34, 1); -- LING 383 - Bilingualism

-- LING Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (401, 'Mirelle', 'Yewdall', 'm.yewdall@libra.edu', 'female', '1999-02-17', 37407);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (12, 401, 3.22, 2900.00, 3, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (177, 169, 12, 90.22, 1), -- LING 102 - Intro to Language & Linguistics
    (178, 146, 12, 84.95, 2), -- LA 428 - Gender and Power in History
    -- SPRING 2014 - Semester 2
    (179, 173, 12, 72.44, 1), -- LING 113 - Phonetics & Phonology
    (180, 134, 12, 95.02, 2), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2014 - Semester 3
    (181, 178, 12, 84.84, 1), -- LING 212 - Psychology of Language
    (182, 195, 12, 76.55, 3), -- LING 403 - Linguistics of American Sign Language
    -- SPRING 2015 - Semester 4
    (183, 182, 12, 96.19, 0), -- LING 239 - Intro to Machine Translation
    (184, 151, 12, 84.94, 0), -- LA 378 - Ethical Theories
    -- FALL 2015 - Semester 5
    (185, 187, 12, 85.02, 1), -- LING 248 - Languages of Mesopotamia
    (186, 148, 12, 89.71, 1), -- LA 428 - Gender and Power in History
    (187, 140, 12, 95.93, 1), -- LA 323 - International Human rights
    -- SPRING 2016 - Semester 6
    (188, 308, 12, 91.48, 0), -- LANG 290 - Sociolinguistics
    (189, 312, 12, 83.44, 0), -- LA 383 - Bilingualism
    -- FALL 2016 - Semester 7
    (190, 193, 12, 81.03, 1), -- LING 323 - Deciphering Ancient Languages
    (191, 202, 12, 95.45, 0), -- LING 342 - Introduction to Indo-European
    -- SPRING 2017 - Semester 8
    (192, 163, 12, 85.02, 0), -- LA 344 - History of Rhetoric
    (193, 318, 12, 91.43, 1); -- LING 412 - Advanced Syntax

-- LING Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (540, 'Roddie', 'McElory', 'r.mcelory@libra.edu', 'male', '1944-01-07', 36169);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (13, 540, 3.22, 2900.00, 3, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (194, 169, 13, 74.40, 1), -- LING 102 - Intro to Language & Linguistics
    (195, 159, 13, 99.85, 2), -- LA 344 - History of Rhetoric
    -- SPRING 2014 - Semester 2
    (196, 173, 13, 92.04, 0), -- LING 113 - Phonetics & Phonology
    (197, 118, 13, 92.53, 2), -- LA 103 - Effective Communication
    -- FALL 2014 - Semester 3
    (198, 178, 13, 89.00, 0), -- LING 212 - Psychology of Language
    (199, 123, 13, 79.02, 1), -- LA 145 - Nations and Nationalism
    -- SPRING 2015 - Semester 4
    (200, 182, 13, 100.00, 0), -- LING 239 - Intro to Machine Translation
    (201, 151, 13, 84.94, 0), -- LA 378 - Ethical Theories
    -- FALL 2015 - Semester 5
    (202, 187, 13, 98.40, 1), -- LING 248 - Languages of Mesopotamia
    (203, 132, 13, 85.93, 1), -- LA 234 - History of Modern East Asia
    (204, 166, 13, 70.22, 1), -- LA 239 - Topics in Archaeology
    -- SPRING 2016 - Semester 6
    (205, 308, 13, 94.20, 0), -- LANG 290 - Sociolinguistics
    (206, 312, 13, 90.23, 0), -- LA 383 - Bilingualism
    -- FALL 2016 - Semester 7
    (207, 193, 13, 81.03, 0), -- LING 323 - Deciphering Ancient Languages
    (208, 141, 13, 83.58, 2), -- LA 323 - International Human Rights
    -- SPRING 2017 - Semester 8
    (209, 137, 13, 76.88, 2), -- LA 248 - Palestinian-Israeli Relations
    (210, 318, 13, 90.23, 0); -- LING 412 - Advanced Syntax

-- LING Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (766, 'Marris', 'Belliss', 'm.belliss@libra.edu', 'female', '1996-06-21', 38010);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (14, 766, 3.10, null, 3, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (211, 169, 14, 100.00, 1), -- LING 102 - Intro to Language & Linguistics
    (212, 111, 14, 94.04, 3), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (213, 173, 14, 89.22, 0), -- LING 113 - Phonetics & Phonology
    (214, 160, 14, 90.32, 0), -- LA 344 - History of Rhetoric
    -- FALL 2014 - Semester 3
    (215, 178, 14, 95.30, 2), -- LING 212 - Psychology of Language
    (216, 139, 14, 99.20, 3), -- LA 323 - International Human Rights
    -- SPRING 2015 - Semester 4
    (217, 182, 14, 73.00, 0), -- LING 239 - Intro to Machine Translation
    (218, 156, 14, 87.23, 1), -- LA 311 - Theory of Knowledge
    -- FALL 2015 - Semester 5
    (219, 187, 14, 88.01, 3), -- LING 248 - Languages of Mesopotamia
    (220, 148, 14, 82.42, 2), -- LA 428 - Gender and Power in History
    -- SPRING 2016 - Semester 6
    (221, 308, 14, 92.00, 1), -- LANG 290 - Sociolinguistics
    (222, 144, 14, 89.22, 0), -- LA 412 - Mythology and Folklore
    (223, 136, 14, 78.22, 0), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2016 - Semester 7
    (224, 193, 14, 92.50, 0), -- LING 323 - Deciphering Ancient Languages
    (225, 199, 14, 98.04, 0), -- LING 403 - Linguistics of American Sign Language
    -- SPRING 2017 - Semester 8
    (226, 318, 14, 94.40, 2), -- LING 412 - Advanced Syntax
    (227, 313, 14, 89.22, 1); -- LING 383 - Bilingualism

-- LING Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (262, 'Tiffanie', 'MacAnellye', 't.macanellye@libra.edu', 'female', '1961-09-18', 37018);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (15, 262, 3.85, null, 3, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (228, 169, 15, 87.50, 0), -- LING 102 - Intro to Language & Linguistics
    (229, 111, 15, 75.04, 4), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (230, 173, 15, 90.23, 0), -- LING 113 - Phonetics & Phonology
    (231, 160, 15, 68.95, 0), -- LA 344 - History of Rhetoric
    -- FALL 2014 - Semester 3
    (232, 178, 15, 77.23, 2), -- LING 212 - Psychology of Language
    (233, 147, 15, 99.20, 3), -- LA 428 - Gender and Power in History
    -- SPRING 2015 - Semester 4
    (234, 182, 15, 89.05, 0), -- LING 239 - Intro to Machine Translation
    (235, 119, 15, 87.23, 1), -- LA 103 - Effective Communication
    -- FALL 2015 - Semester 5
    (236, 187, 15, 79.92, 3), -- LING 248 - Languages of Mesopotamia
    (237, 157, 15, 80.84, 1), -- LA 311 - Theory of Knowledge
    -- SPRING 2016 - Semester 6
    (238, 308, 15, 95.34, 1), -- LANG 290 - Sociolinguistics
    (239, 128, 15, 88.34, 0), -- LA 212 - Ancient Religions and Philosophies
    (240, 152, 15, 94.04, 0), -- LA 378 - Ethical Theories
    -- FALL 2016 - Semester 7
    (241, 193, 15, 99.76, 1), -- LING 323 - Deciphering Ancient Languages
    (242, 199, 15, 93.23, 0), -- LING 403 - Linguistics of American Sign Language
    -- SPRING 2017 - Semester 8
    (243, 203, 15, 91.11, 1), -- LING 403 - Introduction to Indo-European
    (244, 313, 15, 76.59, 1); -- LING 383 - Bilingualism

-- MATH Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (307, 'Eileen', 'Howgill', 'e.howgill@libra.edu', 'female', '1975-06-13', null);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (16, 307, 3.85, null, 4, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (245, 204, 16, 93.12, 1), -- MATH 102 - Calculus I
    (246, 111, 16, 85.40, 0), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (247, 208, 16, 95.11, 0), -- MATH 212 - Calculus II
    (248, 142, 16, 78.22, 1), -- LA 412 - Mythology and Folklore
    -- FALL 2014 - Semester 3
    (249, 213, 16, 79.02, 0), -- MATH 242 - Discrete Mathematics
    (250, 147, 16, 83.33, 0), -- LA 428 - Gender and Power in History
    -- SPRING 2015 - Semester 4
    (251, 217, 16, 90.30, 0), -- MATH 292 - Calculus III
    (252, 119, 16, 84.45, 1), -- LA 103 - Effective Communication
    -- FALL 2015 - Semester 5
    (253, 222, 16, 79.92, 3), -- MATH 320 - Computational Linear Algebra
    (254, 166, 16, 91.99, 1), -- LA 239 - Topics in Archaeology
    -- SPRING 2016 - Semester 6
    (255, 226, 16, 96.12, 1), -- MATH 422 - Differential Equations I
    (256, 244, 16, 88.34, 0), -- MATH 445 - Distributed Algorithms
    (257, 136, 16, 94.04, 0), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2016 - Semester 7
    (258, 231, 16, 92.05, 1), -- MATH 489 - Abstract Algebra I
    (259, 158, 16, 82.55, 0), -- LA 66 - Theory of Knowledge
    -- SPRING 2017 - Semester 8
    (260, 254, 16, 99.00, 1), -- MATH 532 - Geometric Combinatorics
    (261, 153, 16, 81.03, 0); -- LA 378 - Ethical Theories

-- MATH Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (624, 'Germana', 'Bourcq', 'g.bourcq@libra.edu', null, '1956-11-08', 37435);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (17, 624, 3.54, null, 4, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (262, 204, 17, 90.45, 1), -- MATH 102 - Calculus I
    (263, 111, 17, 99.50, 0), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (264, 208, 17, 89.05, 0), -- MATH 212 - Calculus II
    (265, 126, 17, 90.05, 1), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2014 - Semester 3
    (266, 213, 17, 73.04, 0), -- MATH 242 - Discrete Mathematics
    (267, 131, 17, 84.76, 0), -- LA 234 - History of Modern East Asia
    -- SPRING 2015 - Semester 4
    (268, 217, 17, 90.44, 0), -- MATH 292 - Calculus III
    (269, 151, 17, 99.45, 1), -- LA 378 - Ethical Theories
    -- FALL 2015 - Semester 5
    (270, 222, 17, 85.04, 2), -- MATH 320 - Computational Linear Algebra
    (271, 234, 17, 96.99, 0), -- MATH 341 - Integral Equations
    -- SPRING 2016 - Semester 6
    (272, 226, 17, 78.95, 1), -- MATH 422 - Differential Equations I
    (273, 244, 17, 80.55, 0), -- MATH 445 - Distributed Algorithms
    (274, 162, 17, 94.04, 0), -- LA 344 - History of Rhetoric
    -- FALL 2016 - Semester 7
    (275, 231, 17, 98.24, 1), -- MATH 489 - Abstract Algebra I
    (276, 158, 17, 62.08, 0), -- LA 66 - Theory of Knowledge
    -- SPRING 2017 - Semester 8
    (277, 254, 17, 88.25, 1), -- MATH 532 - Geometric Combinatorics
    (278, 137, 17, 95.23, 0); -- LA 248 - Palestinian-Israeli Relations

-- MATH Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (415, 'Diego', 'Archard', 'd.archard@libra.edu', 'male', '1955-10-10', null);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (18, 415, 3.42, null, 4, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (279, 204, 18, 89.23, 1), -- MATH 102 - Calculus I
    (280, 122, 18, 80.22, 0), -- LA 145 - Nations and Nationalism
    -- SPRING 2014 - Semester 2
    (281, 208, 18, 78.43, 0), -- MATH 212 - Calculus II
    (282, 126, 18, 79.02, 1), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2014 - Semester 3
    (283, 213, 18, 90.00, 0), -- MATH 242 - Discrete Mathematics
    (284, 147, 18, 84.76, 0), -- LA 428 - Gender and Power in History
    -- SPRING 2015 - Semester 4
    (285, 217, 18, 83.23, 0), -- MATH 292 - Calculus III
    (286, 143, 18, 99.45, 1), -- LA 412 - Mythology and Folklore
    -- FALL 2015 - Semester 5
    (287, 222, 18, 99.32, 2), -- MATH 320 - Computational Linear Algebra
    (288, 157, 18, 96.99, 0), -- LA 311 - Theory of Knowledge
    -- SPRING 2016 - Semester 6
    (289, 226, 18, 90.23, 0), -- MATH 422 - Differential Equations I
    (290, 235, 18, 75.44, 1), -- MATH 341 - Integral Equations
    -- FALL 2016 - Semester 7
    (291, 231, 18, 99.05, 1), -- MATH 489 - Abstract Algebra I
    (292, 125, 18, 79.33, 0), -- LA 145 - Nations and Nationalism
    (293, 141, 18, 92.34, 0), -- LA 323 - International Human Rights
    -- SPRING 2017 - Semester 8
    (294, 254, 18, 96.43, 0), -- MATH 532 - Geometric Combinatorics
    (295, 246, 18, 81.93, 1); -- MATH 445 - Distributed Algorithms

-- MATH Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (568, 'Farly', 'Egan', 'f.egan@libra.edu', 'male', '1995-01-12', 37619);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (19, 568, 3.58, null, 4, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (296, 204, 19, 95.47, 1), -- MATH 102 - Calculus I
    (297, 110, 19, 81.43, 0), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (298, 208, 19, 89.02, 0), -- MATH 212 - Calculus II
    (299, 232, 19, 93.75, 0), -- MATH 341 - Integral Equations
    -- FALL 2014 - Semester 3
    (300, 213, 19, 92.39, 0), -- MATH 242 - Discrete Mathematics
    (301, 155, 19, 84.76, 0), -- LA 311 - Theory of Knowledge
    -- SPRING 2015 - Semester 4
    (302, 217, 19, 88.04, 0), -- MATH 292 - Calculus III
    (303, 127, 19, 93.03, 1), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2015 - Semester 5
    (304, 222, 19, 95.34, 1), -- MATH 320 - Computational Linear Algebra
    (305, 148, 19, 96.99, 0), -- LA 428 - Gender and Power in History
    -- SPRING 2016 - Semester 6
    (306, 226, 19, 91.51, 0), -- MATH 422 - Differential Equations I
    (307, 136, 19, 89.74, 1), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2016 - Semester 7
    (308, 231, 19, 89.82, 1), -- MATH 489 - Abstract Algebra I
    (309, 125, 19, 88.23, 0), -- LA 145 - Nations and Nationalism
    (310, 241, 19, 91.34, 0), -- MATH 382 - Analysis I
    -- SPRING 2017 - Semester 8
    (311, 254, 19, 96.22, 0), -- MATH 532 - Geometric Combinatorics
    (312, 246, 19, 95.23, 1); -- MATH 445 - Distributed Algorithms

-- MATH Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (393, 'Rory', 'Bush', 'r.bush@libra.edu', 'male', '1950-01-12', 36553);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (20, 393, 3.92, null, 4, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (313, 204, 20, 82.03, 1), -- MATH 102 - Calculus I
    (314, 110, 20, 94.02, 2), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (315, 208, 20, 90.23, 0), -- MATH 212 - Calculus II
    (316, 160, 20, 93.75, 0), -- LA 344 - History of Rhetoric
    -- FALL 2014 - Semester 3
    (317, 213, 20, 94.21, 0), -- MATH 242 - Discrete Mathematics
    (318, 131, 20, 87.03, 0), -- LA 234 - History of Modern East Asia
    -- SPRING 2015 - Semester 4
    (319, 217, 20, 83.45, 0), -- MATH 292 - Calculus III
    (320, 242, 20, 91.35, 1), -- MATH 445 - Distributed Algorithms
    -- FALL 2015 - Semester 5
    (321, 222, 20, 97.75, 1), -- MATH 320 - Computational Linear Algebra
    (322, 157, 20, 96.99, 0), -- LA 311 - Theory of Knowledge
    -- SPRING 2016 - Semester 6
    (323, 226, 20, 94.23, 0), -- MATH 422 - Differential Equations I
    (324, 152, 20, 90.34, 1), -- LA 378 - Ethical Theories
    -- FALL 2016 - Semester 7
    (325, 231, 20, 94.23, 1), -- MATH 489 - Abstract Algebra I
    (326, 241, 20, 91.34, 0), -- MATH 382 - Analysis I
    (327, 167, 20, 88.23, 1), -- LA 239 - Topics in Archaeology
    -- SPRING 2017 - Semester 8
    (328, 254, 20, 90.58, 0), -- MATH 532 - Geometric Combinatorics
    (329, 236, 20, 99.85, 1); -- MATH 341 - Integral Equations

-- ECON Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (674, 'Ulrich', 'Achurch', 'u.achurch@libra.edu', 'male', '1999-09-04', null);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (21, 674, 2.92, null, 5, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (330, 255, 21, 72.01, 4), -- ECON 103 - Principles of Microeconomics
    (331, 110, 21, 99.00, 2), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (332, 208, 21, 82.30, 1), -- ECON 210 - Principles of Macroeconomics
    (333, 160, 21, 93.75, 0), -- LA 344 - History of Rhetoric
    -- FALL 2014 - Semester 3
    (334, 264, 21, 94.21, 0), -- ECON 298 - International Monetary Economics
    (335, 139, 21, 87.03, 0), -- LA 323 - International Human Rights
    -- SPRING 2015 - Semester 4
    (336, 268, 21, 70.83, 0), -- ECON 320 - Law and Economics
    (337, 143, 21, 91.35, 1), -- LA 412 - Mythology and Folklore
    -- FALL 2015 - Semester 5
    (338, 273, 21, 97.75, 1), -- ECON 411 - Corporate Restructuring
    (339, 157, 21, 65.99, 0), -- LA 311 - Theory of Knowledge
    -- SPRING 2016 - Semester 6
    (340, 277, 21, 94.23, 0), -- ECON 423 - Urban Economics
    (341, 120, 21, 80.22, 1), -- LA 103 - Effective Communication
    -- FALL 2016 - Semester 7
    (342, 282, 21, 98.50, 1), -- ECON 488 - Game Theory
    (343, 296, 21, 90.90, 0), -- ECON 521 - Asset Pricing
    (344, 133, 21, 83.20, 1), -- LA 234 - History of Modern East Asia
    -- SPRING 2017 - Semester 8
    (345, 305, 21, 76.89, 0), -- ECON 467 - Health Economics
    (346, 287, 21, 70.22, 1); -- ECON 412 - Public Finance

-- ECON Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (248, 'Mathian', 'Hargate', 'm.hargate@libra.edu', 'male', '1932-12-06', null);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (22, 248, 3.92, null, 5, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (347, 255, 22, 80.23, 0), -- ECON 103 - Principles of Microeconomics
    (348, 110, 22, 90.03, 2), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (349, 208, 22, 99.12, 1), -- ECON 210 - Principles of Macroeconomics
    (350, 142, 22, 90.55, 0), -- LA 412 - Mythology and Folklore
    -- FALL 2014 - Semester 3
    (351, 264, 22, 94.50, 0), -- ECON 298 - International Monetary Economics
    (352, 155, 22, 87.03, 0), -- LA 311 - Theory of Knowledge
    -- SPRING 2015 - Semester 4
    (353, 268, 22, 94.23, 0), -- ECON 320 - Law and Economics
    (354, 285, 22, 91.35, 1), -- ECON 412 - Public Finance
    -- FALL 2015 - Semester 5
    (355, 273, 22, 91.32, 1), -- ECON 411 - Corporate Restructuring
    (356, 132, 22, 89.23, 0), -- LA 234 - History of Modern East Asia
    -- SPRING 2016 - Semester 6
    (357, 277, 22, 90.99, 0), -- ECON 423 - Urban Economics
    (358, 120, 22, 89.54, 1), -- LA 103 - Effective Communication
    -- FALL 2016 - Semester 7
    (359, 282, 22, 92.31, 1), -- ECON 488 - Game Theory
    (360, 167, 22, 90.90, 0), -- LA 239 - Topics in Archaeology
    (361, 149, 22, 91.39, 1), -- LA 428 - Gender and Power in History
    -- SPRING 2017 - Semester 8
    (362, 305, 22, 88.65, 0), -- ECON 467 - Health Economics
    (363, 297, 22, 99.08, 1); -- ECON 521 - Asset Pricing

-- ECON Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (835, 'Miguelita', 'Gillibrand', 'm.gillibrand@libra.edu', 'female', '1997-04-09', null);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (23, 835, 3.64, null, 5, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (364, 255, 23, 98.04, 0), -- ECON 103 - Principles of Microeconomics
    (365, 110, 23, 82.44, 2), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (366, 208, 23, 78.45, 2), -- ECON 210 - Principles of Macroeconomics
    (367, 142, 23, 78.55, 3), -- LA 412 - Mythology and Folklore
    -- FALL 2014 - Semester 3
    (368, 264, 23, 99.85, 1), -- ECON 298 - International Monetary Economics
    (369, 294, 23, 80.42, 0), -- ECON 521 - Asset Pricing
    -- SPRING 2015 - Semester 4
    (370, 268, 23, 90.54, 0), -- ECON 320 - Law and Economics
    (371, 161, 23, 82.76, 1), -- LA 344 - History of Rhetoric
    -- FALL 2015 - Semester 5
    (372, 273, 23, 87.66, 1), -- ECON 411 - Corporate Restructuring
    (373, 148, 23, 79.32, 0), -- LA 428 - Gender and Power in History
    -- SPRING 2016 - Semester 6
    (374, 277, 23, 90.99, 0), -- ECON 423 - Urban Economics
    (375, 120, 23, 80.58, 1), -- LA 103 - Effective Communication
    -- FALL 2016 - Semester 7
    (376, 282, 23, 99.02, 1), -- ECON 488 - Game Theory
    (377, 141, 23, 98.55, 0), -- LA 323 - International Human Rights
    (378, 158, 23, 93.02, 1), -- LA 311 - Theory of Knowledge
    -- SPRING 2017 - Semester 8
    (379, 305, 23, 88.65, 0), -- ECON 467 - Health Economics
    (380, 292, 23, 94.66, 1); -- ECON 389 - Advanced Macroeconomic Theory

-- ECON Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (490, 'Keir', 'Cullnean', 'k.cullnean@libra.edu', 'male', '1962-09-14', 37122);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (24, 490, 3.42, 7300.00, 5, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (381, 255, 24, 100.00, 0), -- ECON 103 - Principles of Microeconomics
    (382, 122, 24, 77.23, 1), -- LA 145 - Nations and Nationalism
    -- SPRING 2014 - Semester 2
    (383, 208, 24, 89.02, 2), -- ECON 210 - Principles of Macroeconomics
    (384, 111, 24, 80.43, 3), -- LA 102 - Success at Libra University
    -- FALL 2014 - Semester 3
    (385, 264, 24, 90.09, 1), -- ECON 298 - International Monetary Economics
    (386, 131, 24, 99.00, 0), -- LA 234 - History of Modern East Asia
    -- SPRING 2015 - Semester 4
    (387, 268, 24, 100.00, 0), -- ECON 320 - Law and Economics
    (388, 143, 24, 92.45, 1), -- LA 412 - Mythology and Folklore
    -- FALL 2015 - Semester 5
    (389, 273, 24, 70.09, 1), -- ECON 411 - Corporate Restructuring
    (390, 157, 24, 80.23, 0), -- LA 311 - Theory of Knowledge
    -- SPRING 2016 - Semester 6
    (391, 277, 24, 87.24, 0), -- ECON 423 - Urban Economics
    (392, 286, 24, 89.25, 1), -- ECON 412 - Public Finance
    -- FALL 2016 - Semester 7
    (393, 282, 24, 86.34, 1), -- ECON 488 - Game Theory
    (394, 167, 24, 82.04, 0), -- LA 239 - Topics in Archaeology
    (395, 141, 24, 84.78, 1), -- LA 323 - International Human Rights
    -- SPRING 2017 - Semester 8
    (396, 297, 24, 89.43, 0), -- ECON 521 - Asset Pricing
    (397, 292, 24, 90.22, 1); -- ECON 389 - Advanced Macroeconomic Theory

-- ECON Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (43, 'Eryn', 'Paddemore', 'e.paddemore@libra.edu', 'female', '1966-03-25', 36309);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (25, 43, 3.84, null, 5, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (398, 255, 25, 89.42, 0), -- ECON 103 - Principles of Microeconomics
    (399, 110, 25, 77.05, 1), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (400, 208, 25, 90.42, 2), -- ECON 210 - Principles of Macroeconomics
    (401, 118, 25, 78.24, 3), -- LA 103 - Effective Communication
    -- FALL 2014 - Semester 3
    (402, 264, 25, 89.45, 1), -- ECON 298 - International Monetary Economics
    (403, 139, 25, 99.55, 0), -- LA 323 - International Human Rights
    -- SPRING 2015 - Semester 4
    (404, 268, 25, 98.43, 0), -- ECON 320 - Law and Economics
    (405, 161, 25, 65.12, 1), -- LA 344 - History of Rhetoric
    -- FALL 2015 - Semester 5
    (406, 273, 25, 76.92, 1), -- ECON 411 - Corporate Restructuring
    (407, 132, 25, 89.42, 0), -- LA 234 - History of Modern East Asia
    -- SPRING 2016 - Semester 6
    (408, 277, 25, 83.22, 0), -- ECON 423 - Urban Economics
    (409, 286, 25, 67.42, 1), -- ECON 389 - Advanced Macroeconomic Theory
    -- FALL 2016 - Semester 7
    (410, 282, 25, 99.55, 1), -- ECON 488 - Game Theory
    (411, 296, 25, 78.09, 0), -- ECON 521 - Asset Pricing
    (412, 125, 25, 88.23, 1), -- LA 145 - Nations and Nationalism
    -- SPRING 2017 - Semester 8
    (413, 287, 25, 78.54, 0), -- ECON 412 - Public Finance
    (414, 145, 25, 72.42, 1); -- LA 412 - Mythology and Folklore

-- LING Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (147, 'Sascha', 'South', 's.south@libra.edu', 'male', '1939-04-12', 36774);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (26, 147, 3.44, 8900.00, 3, 'Bachelor of Science', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (415, 169, 26, 99.35, 0), -- LING 102 - Intro to Language & Linguistics
    (416, 122, 26, 80.25, 1), -- LA 145 - Nations and Nationalism
    -- SPRING 2014 - Semester 2
    (417, 173, 26, 85.96, 1), -- LING 113 - Phonetics & Phonology
    (418, 142, 26, 89.42, 3), -- LA 142 - Mythology and Folklore
    -- FALL 2014 - Semester 3
    (419, 178, 26, 93.42, 0), -- LING 212 - Psychology of Language
    (420, 155, 26, 95.28, 4), -- LA 311 - Theory of Knowledge
    -- SPRING 2015 - Semester 4
    (421, 182, 26, 90.06, 2), -- LING 239 - Intro to Machine Translation
    (422, 135, 26, 88.01, 1), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2015 - Semester 5
    (423, 187, 26, 89.86, 0), -- LING 248 - Languages of Mesopotamia
    (424, 132, 26, 87.65, 0), -- LA 235 - History of Modern East Asia
    (425, 197, 26, 81.32, 1), -- LING 403 - Linguistics of American Sign Language
    -- SPRING 2016 - Semester 6
    (426, 308, 26, 79.65, 1), -- LING 290 - Sociolinguistics
    (427, 312, 26, 73.65, 0), -- LING 383 - Bilingualism
    -- FALL 2016 - Semester 7
    (428, 193, 26, 91.56, 0), -- LING 323 - Deciphering Ancient Languages
    (429, 148, 26, 83.24, 1), -- LA 428 - Gender and Power in History
    -- SPRING 2017 - Semester 8
    (430, 203, 26, 78.55, 1), -- LING 342 - Introduction to Indo-European
    (431, 318, 26, 73.19, 0); -- LING 412 - Advanced Syntax

-- MATH Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (347, 'Billy', 'Wiskar', 'b.wiskar@libra.edu', 'female', '1959-03-05', 35877);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (27, 347, 3.72, null, 4, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (432, 204, 27, 82.55, 1), -- MATH 102 - Calculus I
    (433, 110, 27, 91.23, 2), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (434, 208, 27, 94.56, 0), -- MATH 212 - Calculus II
    (435, 126, 27, 82.48, 0), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2014 - Semester 3
    (436, 213, 27, 91.24, 0), -- MATH 242 - Discrete Mathematics
    (437, 123, 27, 95.32, 0), -- LA 145 - Nations and Nationalism
    -- SPRING 2015 - Semester 4
    (438, 217, 27, 80.13, 1), -- MATH 292 - Calculus III
    (439, 135, 27, 70.87, 0), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2015 - Semester 5
    (440, 222, 27, 79.83, 3), -- MATH 320 - Computational Linear Algebra
    (441, 140, 27, 82.54, 1), -- LA 323 - International Human Rights
    -- SPRING 2016 - Semester 6
    (442, 226, 27, 82.83, 3), -- MATH 422 - Differential Equations I
    (443, 244, 27, 84.10, 2), -- MATH 445 - Distributed Algorithms
    -- FALL 2016 - Semester 7
    (444, 231, 27, 90.91, 2), -- MATH 489 - Abstract Algebra I
    (445, 241, 27, 91.48, 1), -- MATH 382 - Analysis I
    (446, 158, 27, 92.30, 2), -- LA 311 - Theory of Knowledge
    -- SPRING 2017 - Semester 8
    (447, 254, 27, 94.23, 0), -- MATH 532 - Geometric Combinatorics
    (448, 236, 27, 99.66, 0); -- MATH 341 - Integral Equations

-- MUS Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (897, 'Bendick', 'Shurey', 'b.shurey@libra.edu', 'male', '1970-07-04', 37960);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (28, 897, 3.83, null, 2, 'Associate', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (449, 61, 28, 83.54, 1), -- MUS 102 - Musicianship
    (450, 130, 28, 98.38, 2), -- LA 234 - History of Modern East Asia
    -- SPRING 2014 - Semester 2
    (451, 65, 28, 90.10, 0), -- MUS 108 - Music History I
    (452, 134, 28, 92.48, 1), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2014 - Semester 3
    (453, 70, 28, 82.34, 1), -- MUS 121 - Theory I
    -- SPRING 2015 - Semester 4
    (454, 74, 28, 88.85, 2), -- MUS 149 - Performance Ensemble 1
    -- FALL 2015 - Semester 5
    (455, 79, 28, 100.00, 2), -- MUS - Theory II
    (456, 148, 28, 98.10, 1), -- LA 428 - Gender and Power in History
    -- SPRING 2016 - Semester 6
    (457, 83, 28, 72.50, 2), -- MUS 210 - Electronic Music & Composition
    (458, 152, 28, 78.94, 1), -- LA 378 - Ethical Theories
    -- FALL 2016 - Semester 7
    (459, 88, 28, 90.11, 4), -- MUS 322 - Advanced Theory Topics in Global Music
    -- SPRING 2017 - Semester 8
    (460, 94, 28, 90.32, 2); -- MUS 184 - Arranging for Vocals

-- MATH Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (205, 'Elsworth', 'Cottom', 'e.cottom@libra.edu', 'male', '1956-08-27', 37167);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (29, 205, 2.65, 2600, 4, 'Bachelor of Arts', 2);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- SPRING 2014 - Semester 1
    (461, 118, 29, 89.89, 1), -- LA 103 - Effective Communication
    (462, 111, 29, 66.68, 0), -- LA 102 - Success at Libra University
    -- FALL 2014 - Semester 2
    (463, 205, 29, 69.94, 1), -- MATH 102 - Calculus I
    (464, 126, 29, 63.24, 2), -- LA 212 - Ancient Religions and Philosophies
    -- SPRING 2015 - Semester 3
    (465, 209, 29, 74.62, 3), -- MATH 212 - Calculus II
    (466, 135, 29, 79.98, 1), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2015 - Semester 4
    (467, 214, 29, 80.83, 0), -- MATH 242 - Discrete Mathematics I
    (468, 132, 29, 82.56, 1), -- LA 234 - History of Modern East Asia
    -- SPRING 2016 - Semester 5
    (469, 218, 29, 84.96, 2), -- MATH 292 - Calculus III
    (470, 152, 29, 79.23, 1), -- LA 378 - Ethical Theories
    -- FALL 2016 - Semester 6
    (471, 223, 29, 99.52, 2), -- MATH 320 - Computational Linear Algebra
    (472, 241, 29, 57.76, 1), -- MATH 382 - Analysis I
    -- SPRING 2017 - Semester 7
    (473, 227, 29, 88.92, 1), -- MATH 422 - Differential Equations I
    (474, 246, 29, 88.22, 0), -- MATH 445 - Distributed Algorithms
    (475, 163, 29, 71.44, 1); -- LA 344 - History of Rhetoric

-- MATH Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (99, 'Kendell', 'Buxy', 'k.buxy@libra.edu', null, '1977-02-19', 36841);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (30, 99, 2.98, null, 4, 'Bachelor of Science', 2);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- SPRING 2014 - Semester 1
    (461, 118, 30, 80.42, 0), -- LA 103 - Effective Communication
    (462, 111, 30, 90.99, 2), -- LA 102 - Success at Libra University
    -- FALL 2014 - Semester 2
    (463, 205, 30, 93.42, 1), -- MATH 102 - Calculus I
    (464, 131, 30, 80.94, 3), -- LA 234 - History of Modern East Asia
    -- SPRING 2015 - Semester 3
    (465, 209, 30, 89.23, 2), -- MATH 212 - Calculus II
    (466, 161, 30, 79.55, 0), -- LA 344 - History of Rhetoric
    -- FALL 2015 - Semester 4
    (467, 214, 30, 80.33, 4), -- MATH 242 - Discrete Mathematics I
    (468, 157, 30, 82.85, 1), -- LA 311 - Theory of Knowledge
    -- SPRING 2016 - Semester 5
    (469, 218, 30, 83.11, 3), -- MATH 292 - Calculus III
    (470, 252, 30, 81.22, 1), -- MATH 532 - Geometric Combinatorics
    -- FALL 2016 - Semester 6
    (471, 223, 30, 89.56, 0), -- MATH 320 - Computational Linear Algebra
    (472, 241, 30, 90.54, 0), -- MATH 382 - Analysis I
    -- SPRING 2017 - Semester 7
    (473, 227, 30, 90.23, 2), -- MATH 422 - Differential Equations I
    (474, 236, 30, 85.21, 0), -- MATH 341 - Integral Equations
    (475, 246, 30, 84.83, 1); -- MATH 445 - Distributed Algorithms


-- LING Student
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (283, 'Ramsay', 'McInnerny', 'r.mcinnerny@libra.edu', 'male', '1976-06-15', 35625);
insert into student (id, profile_id, gpa, scholarship, department_id, degree_type, start_semester_id) values (31, 283, 3.74, 900.00, 3, 'Bachelor of Arts', 1);
insert into class_seat (id, class_id, student_id, grade, classes_missed)
  values
    -- FALL 2013 - Semester 1
    (415, 169, 31, 93.24, 1), -- LING 102 - Intro to Language & Linguistics
    (416, 122, 31, 91.04, 2), -- LA 145 - Nations and Nationalism
    -- SPRING 2014 - Semester 2
    (417, 173, 31, 90.54, 0), -- LING 113 - Phonetics & Phonology
    (418, 160, 31, 95.32, 0), -- LA 344 - History of Rhetoric
    -- FALL 2014 - Semester 3
    (419, 178, 31, 89.65, 1), -- LING 212 - Psychology of Language
    (420, 131, 31, 88.34, 0), -- LA 234 - History of Modern East Asia
    -- SPRING 2015 - Semester 4
    (421, 182, 31, 87.23, 1), -- LING 239 - Intro to Machine Translation
    (422, 143, 31, 80.23, 0), -- LA 412 - Mythology and Folklore
    -- FALL 2015 - Semester 5
    (423, 187, 31, 83.45, 2), -- LING 248 - Languages of Mesopotamia
    (424, 311, 31, 85.23, 1), -- LING 383 - Bilingualism
    (425, 140, 31, 92.03, 0), -- LA 323 - International Human Right
    -- SPRING 2016 - Semester 6
    (426, 308, 31, 89.52, 2), -- LING 290 - Sociolinguistics
    (427, 198, 31, 89.33, 2), -- LING 403 - Linguistics of American Sign Language
    -- FALL 2016 - Semester 7
    (428, 193, 31, 82.54, 1), -- LING 323 - Deciphering Ancient Languages
    (429, 149, 31, 85.66, 0), -- LA 428 - Gender and Power in History
    -- SPRING 2017 - Semester 8
    (430, 203, 31, 89.32, 0), -- LING 342 - Introduction to Indo-European
    (431, 318, 31, 83.54, 0); -- LING 412 - Advanced Syntax
