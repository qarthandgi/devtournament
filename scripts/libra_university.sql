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
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (3, 'Gene', 'Pennycord', 'g.pennycord@libra.edu', 'male', '1967-01-25', 38179);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (5, 'Dory', 'Gregor', 'd.gregor@libra.edu', 'male', '1967-10-02', 37291);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (7, 'Rustin', 'Crolly', 'r.crolly@libra.edu', 'male', '2003-10-20', 36880);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (8, 'Norine', 'Careless', 'n.careless@libra.edu', 'female', '1991-02-16', 35897);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (10, 'Sherman', 'Swyne', 's.swyne@libra.edu', 'male', '2001-11-12', 36771);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (11, 'Chuck', 'Dombrell', 'c.dombrell@libra.edu', 'male', '1952-12-19', 37127);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (14, 'Alan', 'Pindell', 'a.pindell@libra.edu', 'male', '1975-04-20', 37161);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (15, 'Osbourn', 'Weatherley', 'o.weatherley@libra.edu', 'male', '1967-11-01', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (18, 'Lurleen', 'Allott', 'l.allott@libra.edu', 'female', '1954-12-26', 35686);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (19, 'Brendin', 'Scholard', 'b.scholard@libra.edu', 'male', '1990-03-12', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (21, 'Peterus', 'Nayshe', 'p.nayshe@libra.edu', 'male', '2006-09-16', 36781);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (25, 'Florie', 'Dowda', 'f.dowda@libra.edu', 'female', '1941-12-21', 36053);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (26, 'Darcie', 'Thamelt', 'd.thamelt@libra.edu', 'female', '2006-04-08', 37566);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (27, 'Cris', 'Mac Giolla Pheadair', 'c.mac_giolla_pheadair@libra.edu', 'male', '1977-02-03', 37818);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (28, 'Rutherford', 'Willatt', 'r.willatt@libra.edu', 'male', '1951-12-03', 35342);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (29, 'Joanne', 'Colerick', 'j.colerick@libra.edu', 'female', '1949-11-20', 38154);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (30, 'Nerty', 'Luscott', 'n.luscott@libra.edu', 'female', '1965-07-06', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (31, 'Leon', 'Gotmann', 'l.gotmann@libra.edu', 'male', '1940-10-05', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (32, 'Daphne', 'Holleran', 'd.holleran@libra.edu', 'female', '1931-12-06', 38165);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (34, 'Rafi', 'Pietruszka', 'r.pietruszka@libra.edu', 'male', '1977-08-17', 36421);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (37, 'Rutger', 'Kuhlen', 'r.kuhlen@libra.edu', 'male', '1933-10-06', 38010);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (38, 'Barclay', 'Rizzolo', 'b.rizzolo@libra.edu', 'male', '1934-01-24', 37553);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (39, 'Marv', 'Bunt', 'm.bunt@libra.edu', 'male', '1944-10-05', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (42, 'Portie', 'Foskew', 'p.foskew@libra.edu', 'male', '1959-03-23', 36041);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (44, 'Keslie', 'Gertz', 'k.gertz@libra.edu', 'female', '1976-06-24', 37565);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (45, 'Albrecht', 'Bonicelli', 'a.bonicelli@libra.edu', 'male', '1987-07-27', 37900);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (46, 'Millie', 'Shavel', 'm.shavel@libra.edu', 'female', '1978-02-28', 35309);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (47, 'Euell', 'Hundey', 'e.hundey@libra.edu', 'male', '1972-04-30', 36329);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (49, 'Sky', 'Saffe', 's.saffe@libra.edu', 'male', '1969-03-26', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (50, 'Yurik', 'Dechelette', 'y.dechelette@libra.edu', 'male', '1957-09-16', 35617);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (51, 'Stillmann', 'Darridon', 's.darridon@libra.edu', 'male', '1948-01-09', 35848);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (54, 'Simona', 'Sherwen', 's.sherwen@libra.edu', 'female', '2008-07-17', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (55, 'Shandie', 'Truman', 's.truman@libra.edu', 'female', '1992-08-01', 37536);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (57, 'Tabby', 'Groomebridge', 't.groomebridge@libra.edu', 'female', '1941-08-20', 37913);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (59, 'Horton', 'de Marco', 'h.de_marco@libra.edu', 'male', '1984-04-02', 38070);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (61, 'Kelsy', 'Kerrigan', 'k.kerrigan@libra.edu', 'female', '1999-10-06', 35355);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (62, 'Ferris', 'Itzkovitch', 'f.itzkovitch@libra.edu', 'male', '1934-10-06', 36160);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (65, 'Cloe', 'Cobon', 'c.cobon@libra.edu', 'female', '2007-12-02', 35557);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (66, 'Stanly', 'Grangier', 's.grangier@libra.edu', 'male', '1931-10-21', 36775);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (67, 'Luce', 'Elcy', 'l.elcy@libra.edu', 'female', '2003-06-17', 36489);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (68, 'Garvey', 'Batchley', 'g.batchley@libra.edu', 'male', '1982-10-06', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (70, 'Micheal', 'Stryde', 'm.stryde@libra.edu', 'male', '1968-11-10', 38155);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (71, 'Josey', 'Allport', 'j.allport@libra.edu', 'female', '1988-03-21', 36192);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (72, 'Melinde', 'Petrichat', 'm.petrichat@libra.edu', 'female', '1992-07-18', 36440);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (73, 'Amerigo', 'Soares', 'a.soares@libra.edu', 'male', '1999-09-23', 35422);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (74, 'Sheffie', 'Sands', 's.sands@libra.edu', 'male', '1949-12-20', 37558);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (75, 'Aurore', 'Prene', 'a.prene@libra.edu', 'female', '1934-02-15', 37497);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (79, 'Jemima', 'Lusher', 'j.lusher@libra.edu', 'female', '1979-12-09', 35563);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (82, 'Raddie', 'Gregg', 'r.gregg@libra.edu', 'male', '2001-02-06', 35939);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (83, 'Kass', 'Coppledike', 'k.coppledike@libra.edu', 'female', '1972-07-31', 36543);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (84, 'Jaquelyn', 'Preddy', 'j.preddy@libra.edu', 'female', '1936-01-08', 37684); -- Profile: Jaquelyn: 84
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (85, 'Gabbey', 'Bills', 'g.bills@libra.edu', 'female', '1946-07-09', 37915);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (86, 'Juliane', 'Kelley', 'j.kelley@libra.edu', 'female', '1996-09-01', 36302);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (87, 'Emmie', 'Probin', 'e.probin@libra.edu', 'female', '1992-10-20', 36601);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (88, 'Ada', 'Abercrombie', 'a.abercrombie@libra.edu', 'female', '1956-04-07', 35683);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (89, 'Dimitri', 'Moles', 'd.moles@libra.edu', 'male', '2006-05-28', 37453);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (92, 'Bink', 'Merill', 'b.merill@libra.edu', 'male', '1968-02-04', 36675);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (94, 'Elwyn', 'Haverson', 'e.haverson@libra.edu', 'male', '1934-02-24', 35603);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (95, 'Justin', 'Bontein', 'j.bontein@libra.edu', 'male', '1982-09-12', 36090);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (97, 'Hewie', 'Stanway', 'h.stanway@libra.edu', 'male', '1977-10-09', 37212);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (98, 'Viviyan', 'Widdowson', 'v.widdowson@libra.edu', 'female', '1966-08-24', 38035);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (99, 'Kendell', 'Buxy', 'k.buxy@libra.edu', null, '1977-02-19', 36841);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (102, 'Cristobal', 'McKea', 'c.mckea@libra.edu', 'male', '1997-11-16', 35438);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (103, 'Annmarie', 'Robathon', 'a.robathon@libra.edu', 'female', '1968-11-22', 35688);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (106, 'Cayla', 'Wisniowski', 'c.wisniowski@libra.edu', null, '1961-11-03', 36542);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (109, 'Dicky', 'Chrispin', 'd.chrispin@libra.edu', 'male', '1985-12-21', 36774);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (110, 'Gray', 'Zoren', 'g.zoren@libra.edu', 'male', '2009-03-11', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (112, 'Glynnis', 'Carmichael', 'g.carmichael@libra.edu', 'female', '1952-04-05', 36369);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (113, 'Archambault', 'Bulbrook', 'a.bulbrook@libra.edu', 'male', '1955-09-01', 35435);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (115, 'Laney', 'Caines', 'l.caines@libra.edu', 'male', '1984-02-28', 36476);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (117, 'Hersch', 'Stienton', 'h.stienton@libra.edu', 'male', '1962-02-11', 37045);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (121, 'Dougie', 'Barensen', 'd.barensen@libra.edu', 'male', '1955-02-26', 37137);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (122, 'Bernadina', 'Murrigans', 'b.murrigans@libra.edu', 'female', '1979-04-12', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (123, 'Tamarra', 'Roggieri', 't.roggieri@libra.edu', 'female', '1977-07-13', 36204);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (124, 'Humberto', 'McGorley', 'h.mcgorley@libra.edu', 'male', '1943-01-23', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (125, 'Mommy', 'Tuckwood', 'm.tuckwood@libra.edu', 'female', '1945-05-29', 35908);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (126, 'Georgeta', 'Salkeld', 'g.salkeld@libra.edu', 'female', '1987-06-24', 35375);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (127, 'Naomi', 'Augar', 'n.augar@libra.edu', 'female', '1972-07-28', 37817);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (128, 'Gottfried', 'Lacaze', 'g.lacaze@libra.edu', 'male', '1985-08-10', 37312);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (129, 'Kit', 'Gellett', 'k.gellett@libra.edu', 'male', '1989-09-28', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (130, 'Leonardo', 'Gilson', 'l.gilson@libra.edu', 'male', '1965-07-12', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (131, 'Iris', 'De Roberto', 'i.de_roberto@libra.edu', 'female', '2007-04-29', 36371);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (132, 'Ibby', 'Livingstone', 'i.livingstone@libra.edu', 'female', '1958-02-10', 37643);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (133, 'Taylor', 'Olphert', 't.olphert@libra.edu', 'male', '1932-08-23', 37732);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (134, 'Otho', 'Pain', 'o.pain@libra.edu', 'male', '1965-06-29', 35816);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (135, 'Sergent', 'Takle', 's.takle@libra.edu', 'male', '1960-05-05', 35660);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (136, 'Ansel', 'Piffe', 'a.piffe@libra.edu', 'male', '1935-11-16', 37587);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (137, 'Lowell', 'Edmund', 'l.edmund@libra.edu', 'male', '1978-11-05', 37360);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (138, 'Kurtis', 'Mallall', 'k.mallall@libra.edu', 'male', '1984-10-09', 36464);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (140, 'Verena', 'Fairleigh', 'v.fairleigh@libra.edu', 'female', '1981-10-20', 35777);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (141, 'Benni', 'Goding', 'b.goding@libra.edu', 'female', '2000-11-25', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (142, 'Saree', 'Ledwidge', 's.ledwidge@libra.edu', 'female', '1984-07-04', 36327);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (143, 'Dana', 'Wreath', 'd.wreath@libra.edu', 'female', '1986-02-03', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (144, 'Weber', 'Temprell', 'w.temprell@libra.edu', 'male', '1940-02-24', 37666);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (145, 'Stavro', 'Caveau', 's.caveau@libra.edu', 'male', '1967-11-16', 37337);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (146, 'Bertram', 'Buttress', 'b.buttress@libra.edu', 'male', '1953-08-05', 36463);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (148, 'Dorian', 'Goalby', 'd.goalby@libra.edu', 'male', '1999-10-28', 37446);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (149, 'Chloris', 'Claussen', 'c.claussen@libra.edu', null, '1941-12-28', 37420);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (150, 'Vinson', 'Cobden', 'v.cobden@libra.edu', 'male', '1941-07-21', 37735);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (151, 'Jaymie', 'Sineath', 'j.sineath@libra.edu', 'male', '1988-06-11', 36763);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (152, 'Minnie', 'Poynzer', 'm.poynzer@libra.edu', 'female', '1966-01-13', 37672);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (154, 'Sebastiano', 'Apps', 's.apps@libra.edu', 'male', '2000-03-16', 36112);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (155, 'Thea', 'Jenney', 't.jenney@libra.edu', 'female', '2009-05-23', 35635);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (156, 'Daron', 'Newall', 'd.newall@libra.edu', 'male', '1968-12-03', 37213);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (157, 'Olin', 'Kemitt', 'o.kemitt@libra.edu', 'male', '1935-09-24', 36672);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (159, 'Casie', 'Norkett', 'c.norkett@libra.edu', 'female', '1971-03-25', 38108);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (160, 'Michail', 'Lammerts', 'm.lammerts@libra.edu', 'male', '1954-04-05', 37799);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (161, 'Sydney', 'Nolte', 's.nolte@libra.edu', 'male', '1941-05-12', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (162, 'Kristine', 'Tuplin', 'k.tuplin@libra.edu', 'female', '1984-07-22', 36208);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (163, 'Cordelie', 'Wardlaw', 'c.wardlaw@libra.edu', 'female', '1966-10-09', 38188);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (164, 'Darcy', 'Kilpatrick', 'd.kilpatrick@libra.edu', 'male', '2007-08-06', 38174);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (165, 'Giulio', 'Sambeck', 'g.sambeck@libra.edu', 'male', '2004-10-28', 35318);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (166, 'Milt', 'Ripsher', 'm.ripsher@libra.edu', 'male', '1990-10-21', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (167, 'Charisse', 'Collman', 'c.collman@libra.edu', 'female', '1993-11-03', 38286);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (168, 'Michel', 'Heisham', 'm.heisham@libra.edu', 'male', '1953-02-16', 37922);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (169, 'Garret', 'Golding', 'g.golding@libra.edu', 'male', '1998-04-08', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (170, 'Modesty', 'Romero', 'm.romero@libra.edu', 'female', '1989-10-02', 36044);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (171, 'Nollie', 'Hearty', 'n.hearty@libra.edu', 'female', '1991-10-26', 35380);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (172, 'Jobi', 'Dole', 'j.dole@libra.edu', 'female', '1959-11-11', 36667);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (173, 'Ingaborg', 'Tomsen', 'i.tomsen@libra.edu', 'female', '1970-04-07', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (174, 'Berrie', 'Espin', 'b.espin@libra.edu', 'female', '1951-08-12', 36418);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (175, 'Trescha', 'Sparrowe', 't.sparrowe@libra.edu', 'female', '1977-11-04', 37746);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (176, 'Karlie', 'Bowcock', 'k.bowcock@libra.edu', 'female', '2008-02-04', 36955);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (177, 'Mollie', 'Egel', 'm.egel@libra.edu', 'female', '1988-09-10', 37540);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (178, 'Ulric', 'Worge', 'u.worge@libra.edu', 'male', '1932-01-01', 36822);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (179, 'Felicia', 'Withull', 'f.withull@libra.edu', 'female', '1979-04-28', 37063);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (180, 'Amelie', 'Antos', 'a.antos@libra.edu', 'female', '1956-07-29', 35889);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (181, 'Hollie', 'Veryard', 'h.veryard@libra.edu', 'female', '1943-08-21', 37990);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (182, 'Felipe', 'Medway', 'f.medway@libra.edu', 'male', '1994-03-25', 36776);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (183, 'Man', 'Tuting', 'm.tuting@libra.edu', 'male', '1980-09-02', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (184, 'Arlinda', 'Horick', 'a.horick@libra.edu', 'female', '1995-05-24', 38058);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (185, 'Jillane', 'Binch', 'j.binch@libra.edu', 'female', '1957-01-07', 35713);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (186, 'Bern', 'Iston', 'b.iston@libra.edu', 'male', '1974-01-12', 38289);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (187, 'Garry', 'Cunnow', 'g.cunnow@libra.edu', 'male', '1994-05-13', 35931);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (188, 'Joela', 'McKeighen', 'j.mckeighen@libra.edu', 'female', '1937-08-31', 35438);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (189, 'Gibbie', 'Hubbold', 'g.hubbold@libra.edu', 'male', '1962-05-13', 35476);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (190, 'Marietta', 'Cawthorne', 'm.cawthorne@libra.edu', 'male', '1939-11-09', 36300);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (191, 'Elsinore', 'Smail', 'e.smail@libra.edu', 'female', '1992-03-30', 35806);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (192, 'Gabriela', 'Maitland', 'g.maitland@libra.edu', 'female', '1979-09-03', 38011);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (193, 'Tallou', 'Akess', 't.akess@libra.edu', 'female', '1986-11-17', 37280);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (194, 'Hilarius', 'Toulmin', 'h.toulmin@libra.edu', 'male', '1982-06-22', 36243);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (195, 'Celie', 'Macek', 'c.macek@libra.edu', 'female', '1948-03-23', 37764);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (196, 'Leela', 'Landal', 'l.landal@libra.edu', 'female', '2009-05-16', 35641);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (197, 'Patric', 'Koeppe', 'p.koeppe@libra.edu', 'male', '1932-08-10', 36994);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (198, 'Hartley', 'Coppens', 'h.coppens@libra.edu', 'male', '1957-08-28', 37265);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (199, 'Marlon', 'Straker', 'm.straker@libra.edu', 'male', '1943-02-01', 37397);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (200, 'Shanna', 'Peebles', 's.peebles@libra.edu', 'female', '1972-08-04', 37063);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (202, 'Kevon', 'Onge', 'k.onge@libra.edu', 'male', '1945-07-01', 37822);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (204, 'Brice', 'Burtwhistle', 'b.burtwhistle@libra.edu', 'male', '1958-05-18', 36233);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (205, 'Elsworth', 'Cottom', 'e.cottom@libra.edu', 'male', '1956-08-27', 37167);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (206, 'Braden', 'Francesconi', 'b.francesconi@libra.edu', 'male', '1951-01-14', 37365);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (207, 'Aaren', 'Scothron', 'a.scothron@libra.edu', 'female', '1967-09-22', 37829);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (208, 'Genni', 'Widdowfield', 'g.widdowfield@libra.edu', 'female', '1944-10-21', 36966);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (209, 'Maurise', 'Skep', 'm.skep@libra.edu', 'male', '1938-01-29', 37812);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (210, 'Daniel', 'Espada', 'd.espada@libra.edu', 'male', '1958-07-16', 37831);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (211, 'Loy', 'Gratrex', 'l.gratrex@libra.edu', 'male', '1934-09-23', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (212, 'Saul', 'Falla', 's.falla@libra.edu', 'male', '1931-06-19', 36061);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (213, 'Coop', 'Coultass', 'c.coultass@libra.edu', 'male', '1937-09-27', 37156);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (214, 'Carlina', 'Renols', 'c.renols@libra.edu', 'female', '1942-03-21', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (215, 'Kiley', 'Cressingham', 'k.cressingham@libra.edu', 'male', '1987-06-24', 36300);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (216, 'Shanta', 'Acland', 's.acland@libra.edu', 'female', '1941-03-12', 37282);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (217, 'Nowell', 'Izaac', 'n.izaac@libra.edu', 'male', '2002-11-09', 36284);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (218, 'Mureil', 'Gabey', 'm.gabey@libra.edu', 'female', '1965-10-14', 35284);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (219, 'Tuck', 'Hansana', 't.hansana@libra.edu', 'male', '1990-02-15', 36919);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (220, 'Karee', 'Barrack', 'k.barrack@libra.edu', 'female', '1992-05-27', 37286);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (221, 'Thalia', 'Gogerty', 't.gogerty@libra.edu', 'female', '1957-04-11', 36599);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (222, 'Kaylil', 'Maren', 'k.maren@libra.edu', 'female', '1957-06-10', 38019);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (223, 'Tish', 'Akenhead', 't.akenhead@libra.edu', 'female', '1991-01-08', 37490);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (224, 'Bud', 'Leabeater', 'b.leabeater@libra.edu', 'male', '1947-09-04', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (225, 'Anabel', 'Smallpiece', 'a.smallpiece@libra.edu', 'female', '1981-09-21', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (226, 'Sylvan', 'Booeln', 's.booeln@libra.edu', 'male', '1986-04-14', 36852);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (227, 'Fina', 'Gabler', 'f.gabler@libra.edu', 'female', '2005-04-16', 37454);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (228, 'Lyndel', 'Bradock', 'l.bradock@libra.edu', 'female', '1947-11-26', 36330);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (229, 'Chilton', 'Abden', 'c.abden@libra.edu', 'male', '1989-04-28', 37366);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (230, 'Eugen', 'Giacobo', 'e.giacobo@libra.edu', 'male', '1951-04-24', 35791);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (231, 'Stearne', 'Kermit', 's.kermit@libra.edu', 'male', '1987-09-26', 36000);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (232, 'Ollie', 'Deeprose', 'o.deeprose@libra.edu', 'male', '1998-08-10', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (233, 'Aldon', 'Byles', 'a.byles@libra.edu', 'male', '2005-02-03', 36374);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (234, 'Shoshana', 'Leipelt', 's.leipelt@libra.edu', 'female', '1983-10-21', 35332);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (235, 'Aylmar', 'Curneen', 'a.curneen@libra.edu', 'male', '1994-07-21', 37094);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (236, 'Weylin', 'Deacock', 'w.deacock@libra.edu', 'male', '1947-11-04', 36275);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (237, 'Georgie', 'McQuirter', 'g.mcquirter@libra.edu', 'male', '1956-03-29', 35382);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (238, 'Florian', 'Warrick', 'f.warrick@libra.edu', 'male', '1997-01-20', 36337);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (239, 'Paulina', 'Vedyasov', 'p.vedyasov@libra.edu', 'female', '1941-07-16', 37660);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (240, 'Wallie', 'Clilverd', 'w.clilverd@libra.edu', 'male', '1978-12-23', 35368);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (241, 'Gisela', 'Lindores', 'g.lindores@libra.edu', 'female', '1954-09-04', 37875);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (242, 'Burnaby', 'Tesseyman', 'b.tesseyman@libra.edu', 'male', '1976-11-26', 37653);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (243, 'Noella', 'Rabbitts', 'n.rabbitts@libra.edu', 'female', '2000-10-19', 35953);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (244, 'Gabriela', 'Malham', 'g.malham@libra.edu', 'female', '1941-12-01', 38191);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (245, 'Carmelia', 'Gatlin', 'c.gatlin@libra.edu', 'female', '2000-08-08', 36605);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (246, 'Roslyn', 'Wildbore', 'r.wildbore@libra.edu', 'female', '2000-10-05', 36902);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (247, 'Chrystel', 'Kayes', 'c.kayes@libra.edu', 'female', '2005-04-26', 38186);

insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (249, 'Tamar', 'Eyam', 't.eyam@libra.edu', 'female', '1969-02-19', 37044);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (250, 'Glennis', 'Skewis', 'g.skewis@libra.edu', 'female', '1972-11-06', 36121);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (251, 'Greggory', 'Hatje', 'g.hatje@libra.edu', 'male', '1989-03-17', 36366);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (252, 'Brittany', 'Lindores', 'b.lindores@libra.edu', 'female', '1934-05-19', 36344);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (253, 'Brockie', 'Diack', 'b.diack@libra.edu', 'male', '1938-01-02', 37884);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (254, 'Killian', 'Father', 'k.father@libra.edu', 'male', '1981-10-22', 38076);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (255, 'Rozalie', 'Ghelarducci', 'r.ghelarducci@libra.edu', 'female', '2000-04-05', 35803);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (256, 'Kit', 'Misk', 'k.misk@libra.edu', 'female', '1981-09-06', 36642);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (257, 'Beatrix', 'Colmore', 'b.colmore@libra.edu', 'female', '1988-04-26', 37445);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (258, 'Osgood', 'Ainley', 'o.ainley@libra.edu', 'male', '1937-05-20', 36510);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (259, 'Desi', 'Luciano', 'd.luciano@libra.edu', 'male', '1970-04-29', 35426);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (260, 'Maudie', 'Mion', 'm.mion@libra.edu', 'female', '1953-07-20', 35547);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (261, 'Murray', 'M''Chirrie', 'm.m''chirrie@libra.edu', 'male', '1964-09-24', 35965);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (263, 'Rockie', 'Dorrington', 'r.dorrington@libra.edu', 'male', '1949-03-10', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (264, 'Junina', 'Hawford', 'j.hawford@libra.edu', 'female', '1940-12-02', 36102);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (265, 'Shena', 'Beston', 's.beston@libra.edu', 'female', '1973-03-31', 36647);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (266, 'Sandy', 'Viggars', 's.viggars@libra.edu', 'male', '1932-07-02', 36139);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (268, 'Mela', 'Burghall', 'm.burghall@libra.edu', 'female', '1974-12-03', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (269, 'Alec', 'Drains', 'a.drains@libra.edu', null, '1970-11-18', 36856);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (270, 'Laurent', 'Patise', 'l.patise@libra.edu', 'male', '1981-01-15', 37636);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (271, 'Datha', 'holmes', 'd.holmes@libra.edu', 'female', '1961-03-07', 37898);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (272, 'Aliza', 'Faichney', 'a.faichney@libra.edu', 'female', '1990-03-23', 36246);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (273, 'Fayth', 'Trulocke', 'f.trulocke@libra.edu', 'female', '1982-03-28', 36249);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (274, 'Lilas', 'Parsand', 'l.parsand@libra.edu', 'female', '1980-07-13', 35318);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (275, 'Alexine', 'Sarath', 'a.sarath@libra.edu', 'female', '1947-06-08', 35382);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (276, 'Myrlene', 'Dowles', 'm.dowles@libra.edu', 'female', '1936-06-17', 38124);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (277, 'Katherina', 'Songer', 'k.songer@libra.edu', 'female', '1990-05-27', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (278, 'Lucilia', 'Lampett', 'l.lampett@libra.edu', 'female', '1956-09-25', 38047);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (279, 'Heloise', 'Crimes', 'h.crimes@libra.edu', 'female', '1974-10-14', 35659);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (280, 'Gavan', 'Emblen', 'g.emblen@libra.edu', 'male', '1956-09-29', 38156);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (281, 'Evvy', 'Scuse', 'e.scuse@libra.edu', 'female', '1965-05-24', 37607);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (282, 'Rupert', 'Surmeyer', 'r.surmeyer@libra.edu', 'male', '1964-11-03', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (283, 'Ramsay', 'McInnerny', 'r.mcinnerny@libra.edu', 'male', '1976-06-15', 35625);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (284, 'Alejoa', 'Bellard', 'a.bellard@libra.edu', 'male', '1934-04-10', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (285, 'Adam', 'Di Filippo', 'a.di_filippo@libra.edu', 'male', '1998-09-07', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (286, 'Shae', 'Varcoe', 's.varcoe@libra.edu', 'male', '1953-05-28', 35683);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (287, 'Gene', 'Wrigley', 'g.wrigley@libra.edu', 'male', '1940-02-12', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (288, 'Rolando', 'Lawes', 'r.lawes@libra.edu', 'male', '1998-09-23', 36724);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (289, 'Anneliese', 'Hilldrop', 'a.hilldrop@libra.edu', 'female', '1963-01-31', 37047);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (290, 'Bren', 'Nanson', 'b.nanson@libra.edu', 'male', '1981-12-18', 37522);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (291, 'Darline', 'Allcoat', 'd.allcoat@libra.edu', 'female', '1983-10-26', 36925);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (292, 'Gert', 'Ffrench', 'g.ffrench@libra.edu', 'female', '1947-12-25', 37589);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (293, 'Chadd', 'Reidshaw', 'c.reidshaw@libra.edu', 'male', '1973-08-15', 37218);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (294, 'Roxanna', 'Aucott', 'r.aucott@libra.edu', 'female', '1996-11-15', 35381);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (295, 'Ned', 'Gabby', 'n.gabby@libra.edu', 'male', '1965-08-27', 36873);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (296, 'Jason', 'Howsden', 'j.howsden@libra.edu', 'male', '2000-08-09', 35694);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (297, 'Reinhold', 'Witherdon', 'r.witherdon@libra.edu', 'male', '1978-09-06', 35475);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (298, 'Ardyth', 'Clemenza', 'a.clemenza@libra.edu', 'female', '1938-04-13', 37271);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (299, 'Nikaniki', 'MacGettigen', 'n.macgettigen@libra.edu', 'female', '1989-10-23', 38197);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (300, 'Roobbie', 'Newbury', 'r.newbury@libra.edu', 'female', '2001-01-23', 35303);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (301, 'Stewart', 'Twaite', 's.twaite@libra.edu', 'male', '1955-09-27', 36411);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (302, 'Cinderella', 'Brigge', 'c.brigge@libra.edu', 'female', '1932-05-26', 37214);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (303, 'Craggie', 'Lofty', 'c.lofty@libra.edu', 'male', '1990-02-03', 37778);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (304, 'Ashton', 'Standbrook', 'a.standbrook@libra.edu', 'male', '1942-04-15', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (305, 'Chet', 'Hardwich', 'c.hardwich@libra.edu', 'male', '1954-04-02', 35442);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (306, 'Rodger', 'Wimbridge', 'r.wimbridge@libra.edu', 'male', '1986-05-11', 37064);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (308, 'Amberly', 'Saffill', 'a.saffill@libra.edu', 'female', '2004-09-27', 35980);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (309, 'Erina', 'Shilston', 'e.shilston@libra.edu', 'female', '1971-02-06', 37334);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (310, 'Sunny', 'Noah', 's.noah@libra.edu', 'female', '1980-11-27', 37962);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (311, 'Margot', 'McAusland', 'm.mcausland@libra.edu', 'female', '1984-03-02', 36712);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (312, 'Glendon', 'McIlrath', 'g.mcilrath@libra.edu', 'male', '1962-04-07', 36444);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (313, 'Bessie', 'Bartrap', 'b.bartrap@libra.edu', 'female', '1942-06-09', 37147);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (314, 'Lucius', 'Fewlass', 'l.fewlass@libra.edu', 'male', '1950-02-13', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (315, 'Flem', 'Keets', 'f.keets@libra.edu', 'male', '2007-08-23', 38131);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (316, 'Bernarr', 'Hewkin', 'b.hewkin@libra.edu', 'male', '1954-06-17', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (317, 'Vernon', 'Feron', 'v.feron@libra.edu', 'male', '2002-12-15', 38220);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (318, 'Aldis', 'Millar', 'a.millar@libra.edu', null, '1999-05-18', 36510);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (319, 'Zacharia', 'Durbridge', 'z.durbridge@libra.edu', 'male', '1988-08-30', 35686);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (320, 'Zak', 'Himsworth', 'z.himsworth@libra.edu', 'male', '1995-01-27', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (321, 'Jessie', 'Olligan', 'j.olligan@libra.edu', 'male', '1971-01-12', 36520);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (322, 'Lissie', 'Melton', 'l.melton@libra.edu', 'female', '1931-05-06', 35961);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (323, 'Flinn', 'Sacchetti', 'f.sacchetti@libra.edu', 'male', '1966-07-29', 35723);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (324, 'Wright', 'Downer', 'w.downer@libra.edu', 'male', '1965-07-17', 35667);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (325, 'Ketti', 'Chellingworth', 'k.chellingworth@libra.edu', 'female', '1964-01-16', 35455);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (326, 'Karylin', 'Sholl', 'k.sholl@libra.edu', 'female', '1956-12-11', 37211);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (327, 'Joleen', 'De Bischop', 'j.de_bischop@libra.edu', 'female', '1982-04-17', 35548);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (328, 'Irma', 'Loosley', 'i.loosley@libra.edu', 'female', '1980-12-14', 36976);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (329, 'Halsey', 'Eyles', 'h.eyles@libra.edu', null, '2001-05-03', 36675);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (330, 'Marjorie', 'Hofer', 'm.hofer@libra.edu', null, '1959-04-19', 37380);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (331, 'Thom', 'Kilshaw', 't.kilshaw@libra.edu', 'male', '1930-07-08', 37586);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (332, 'Faber', 'Laxon', 'f.laxon@libra.edu', 'male', '1961-07-10', 37752);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (333, 'Hedvige', 'Gerler', 'h.gerler@libra.edu', 'female', '1968-05-30', 35801);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (334, 'Lorie', 'Laite', 'l.laite@libra.edu', 'female', '1956-07-12', 35895);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (335, 'Stormie', 'Harryman', 's.harryman@libra.edu', 'female', '1951-12-03', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (336, 'Dex', 'Tilte', 'd.tilte@libra.edu', 'male', '1988-08-20', 37553);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (337, 'Ilyssa', 'Fey', 'i.fey@libra.edu', 'female', '1955-03-20', 36656);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (338, 'Ives', 'Plott', 'i.plott@libra.edu', 'male', '1967-12-28', 36707);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (339, 'Tann', 'Dignall', 't.dignall@libra.edu', 'male', '1941-06-11', 36044);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (340, 'Denver', 'Kasting', 'd.kasting@libra.edu', 'male', '1998-12-28', 37670);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (341, 'Franciska', 'Shepland', 'f.shepland@libra.edu', 'female', '2000-03-30', 37885);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (342, 'Cristina', 'Bruun', 'c.bruun@libra.edu', 'female', '1942-12-26', 35290);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (343, 'Amber', 'Pyatt', 'a.pyatt@libra.edu', 'female', '1972-10-21', 35341);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (345, 'Tonnie', 'Tubby', 't.tubby@libra.edu', 'male', '1945-12-23', 35956);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (346, 'Onfroi', 'Hestrop', 'o.hestrop@libra.edu', 'male', '1998-12-14', 35920);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (348, 'Benedick', 'Cartmale', 'b.cartmale@libra.edu', 'male', '1978-09-16', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (349, 'Brennan', 'Prier', 'b.prier@libra.edu', 'male', '1940-06-11', 36310);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (350, 'Bethany', 'Benettolo', 'b.benettolo@libra.edu', 'female', '1965-07-23', 37080);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (351, 'Sonia', 'Etienne', 's.etienne@libra.edu', null, '1986-09-20', 35919);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (352, 'Maddi', 'Schust', 'm.schust@libra.edu', 'female', '1993-08-14', 37618);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (353, 'Hollis', 'Stirgess', 'h.stirgess@libra.edu', 'male', '1948-03-21', 36422);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (354, 'Zondra', 'Hugnot', 'z.hugnot@libra.edu', 'female', '1953-08-31', 36772);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (355, 'Charmain', 'Niezen', 'c.niezen@libra.edu', 'female', '1994-06-11', 36844);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (356, 'Reine', 'Haruard', 'r.haruard@libra.edu', 'female', '1943-09-15', 37932);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (357, 'Chad', 'Chapell', 'c.chapell@libra.edu', 'female', '1950-06-21', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (358, 'Ruggiero', 'Heibel', 'r.heibel@libra.edu', 'male', '1980-12-20', 36059);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (359, 'Lida', 'Fennelow', 'l.fennelow@libra.edu', 'female', '1954-06-24', 37140);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (360, 'Sim', 'Scamwell', 's.scamwell@libra.edu', 'male', '2003-06-02', 38038);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (361, 'Darcy', 'Finn', 'd.finn@libra.edu', 'male', '1950-01-14', 38046);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (362, 'Annis', 'Munden', 'a.munden@libra.edu', 'female', '1931-03-31', 37420);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (363, 'Eddi', 'Lurner', 'e.lurner@libra.edu', 'female', '1985-06-20', 37153);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (364, 'Ganny', 'Bariball', 'g.bariball@libra.edu', 'male', '1930-01-31', 37316);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (365, 'Lindsay', 'Cosans', 'l.cosans@libra.edu', 'female', '1987-05-19', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (366, 'Cord', 'Kopacek', 'c.kopacek@libra.edu', 'male', '1941-11-10', 38273);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (367, 'Jacki', 'Pordall', 'j.pordall@libra.edu', 'female', '1948-03-01', 36318);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (368, 'Meredeth', 'Harvett', 'm.harvett@libra.edu', 'male', '1942-04-30', 38190);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (369, 'Rick', 'Livoir', 'r.livoir@libra.edu', 'male', '1944-10-19', 37518);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (370, 'Bowie', 'Willowby', 'b.willowby@libra.edu', 'male', '1952-04-17', 37952);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (371, 'Ara', 'Gave', 'a.gave@libra.edu', 'female', '1988-07-11', 36458);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (372, 'Jenica', 'Bosanko', 'j.bosanko@libra.edu', 'female', '1944-04-30', 36738);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (373, 'Torie', 'Saffon', 't.saffon@libra.edu', 'female', '1942-01-24', 35392);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (374, 'Chaunce', 'Ferroni', 'c.ferroni@libra.edu', 'male', '1989-10-02', 37380);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (375, 'Augustine', 'Arthurs', 'a.arthurs@libra.edu', 'male', '1955-03-15', 36011);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (376, 'Randi', 'Follet', 'r.follet@libra.edu', 'male', '1984-02-04', 36122);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (377, 'Elmer', 'Tatlock', 'e.tatlock@libra.edu', 'male', '1980-12-22', 36910);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (378, 'Renaldo', 'Mackneis', 'r.mackneis@libra.edu', 'male', '1982-01-14', 35815);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (379, 'Happy', 'Croyden', 'h.croyden@libra.edu', 'female', '1978-01-31', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (380, 'Sam', 'Haldin', 's.haldin@libra.edu', 'male', '1936-04-08', 35466);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (381, 'Ina', 'Tchaikovsky', 'i.tchaikovsky@libra.edu', 'female', '1974-09-01', 37878);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (382, 'Marisa', 'Boulden', 'm.boulden@libra.edu', 'female', '1977-05-21', 35495);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (383, 'Eachelle', 'Edwardson', 'e.edwardson@libra.edu', 'female', '1998-10-18', 36791);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (384, 'Perrine', 'O''Shaughnessy', 'p.o''shaughnessy@libra.edu', 'female', '1950-03-14', 37424);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (385, 'Suki', 'Castagnier', 's.castagnier@libra.edu', 'female', '1954-09-29', 35383);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (386, 'Waverley', 'Aspinell', 'w.aspinell@libra.edu', 'male', '1961-06-01', 35956);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (387, 'Vern', 'Fullwood', 'v.fullwood@libra.edu', null, '1968-04-01', 36929);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (388, 'Caty', 'De la Yglesias', 'c.de_la_yglesias@libra.edu', 'female', '1972-10-14', 37086);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (389, 'Kendrick', 'McIsaac', 'k.mcisaac@libra.edu', 'male', '1975-08-08', 35521);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (390, 'Currey', 'Ruckert', 'c.ruckert@libra.edu', 'male', '1987-09-18', 36301);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (391, 'Estel', 'Rampton', 'e.rampton@libra.edu', 'female', '1952-01-16', 35732);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (392, 'Ursulina', 'Northern', 'u.northern@libra.edu', 'female', '1948-06-29', 37446);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (394, 'Virgil', 'Waight', 'v.waight@libra.edu', 'male', '1973-08-27', 38245);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (395, 'Kalie', 'Caldes', 'k.caldes@libra.edu', 'female', '1942-08-31', 37266);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (396, 'Jesse', 'Ayshford', 'j.ayshford@libra.edu', 'female', '1958-06-28', 37994);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (397, 'Averill', 'Cutten', 'a.cutten@libra.edu', 'male', '1948-01-12', 36683);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (398, 'Jay', 'Harken', 'j.harken@libra.edu', 'male', '1935-01-25', 35900);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (399, 'Amelia', 'Cannon', 'a.cannon@libra.edu', 'female', '1937-04-14', 37930);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (400, 'Raynell', 'McCrachen', 'r.mccrachen@libra.edu', 'female', '1944-06-12', 36756);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (402, 'Koo', 'Giddons', 'k.giddons@libra.edu', 'female', '1971-05-29', 37356);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (403, 'Abie', 'Wadley', 'a.wadley@libra.edu', 'male', '1992-11-08', 36581);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (404, 'Jozef', 'MacRinn', 'j.macrinn@libra.edu', 'male', '1971-10-26', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (405, 'Aubrey', 'Bande', 'a.bande@libra.edu', 'female', '1991-12-04', 36958);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (406, 'Way', 'Gotthard.sf', 'w.gotthardsf@libra.edu', 'male', '1987-01-17', 36997);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (407, 'Hephzibah', 'Ritchard', 'h.ritchard@libra.edu', 'female', '1976-09-24', 36416);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (408, 'Laurice', 'Kleinlerer', 'l.kleinlerer@libra.edu', 'female', '1933-08-05', 37782);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (409, 'Kearney', 'Moylan', 'k.moylan@libra.edu', 'male', '1975-05-14', 37632);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (410, 'Giacobo', 'Volke', 'g.volke@libra.edu', 'male', '1981-05-15', 35983);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (411, 'Merrill', 'Lynam', 'm.lynam@libra.edu', 'male', '1993-01-18', 37312);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (412, 'Nealson', 'Ionn', 'n.ionn@libra.edu', 'male', '1963-01-12', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (413, 'Gail', 'Dillintone', 'g.dillintone@libra.edu', 'male', '1945-04-28', 35931);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (414, 'Ruggiero', 'Kirby', 'r.kirby@libra.edu', 'male', '1960-06-28', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (416, 'Martina', 'Haney`', 'm.haney`@libra.edu', 'female', '1967-10-30', 36049);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (417, 'Say', 'Shallcrass', 's.shallcrass@libra.edu', 'male', '1934-06-17', 38200);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (418, 'Anthea', 'Treadgall', 'a.treadgall@libra.edu', 'female', '1982-01-24', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (419, 'Deanne', 'Baudesson', 'd.baudesson@libra.edu', 'female', '1974-05-28', 37530);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (420, 'Daniel', 'Deeson', 'd.deeson@libra.edu', 'male', '1958-06-02', 37794);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (421, 'Imogene', 'Fearick', 'i.fearick@libra.edu', 'female', '1958-12-02', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (422, 'Chiquita', 'Campes', 'c.campes@libra.edu', 'female', '2003-08-16', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (423, 'Damara', 'Liggons', 'd.liggons@libra.edu', 'female', '1990-01-05', 37410);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (424, 'Fielding', 'Semarke', 'f.semarke@libra.edu', 'male', '1972-03-29', 35356);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (425, 'Caitlin', 'Ninnotti', 'c.ninnotti@libra.edu', 'female', '1990-05-02', 36354);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (426, 'Hasty', 'Kobierra', 'h.kobierra@libra.edu', 'male', '1966-01-16', 35787);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (427, 'Gwendolen', 'Gwilt', 'g.gwilt@libra.edu', null, '1969-03-27', 36141);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (428, 'Kellby', 'Schellig', 'k.schellig@libra.edu', 'male', '1988-01-18', 38268);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (429, 'Chet', 'Andriulis', 'c.andriulis@libra.edu', 'male', '1938-01-01', 36334);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (430, 'Christiano', 'Kingshott', 'c.kingshott@libra.edu', 'male', '1944-12-15', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (431, 'Carly', 'Kalkofen', 'c.kalkofen@libra.edu', 'male', '1991-04-01', 35351);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (432, 'Cara', 'Heatlie', 'c.heatlie@libra.edu', 'female', '2001-08-11', 37080);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (433, 'Jacqui', 'Takis', 'j.takis@libra.edu', 'female', '1963-05-13', 36677);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (434, 'Aida', 'Albin', 'a.albin@libra.edu', 'female', '1983-08-24', 35493);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (435, 'Bran', 'Piburn', 'b.piburn@libra.edu', 'male', '1974-09-02', 36843);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (436, 'Wyn', 'Hatherley', 'w.hatherley@libra.edu', 'male', '2001-02-03', 38128);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (437, 'Sanders', 'Quinnelly', 's.quinnelly@libra.edu', 'male', '1966-06-04', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (438, 'Ferdie', 'Fleg', 'f.fleg@libra.edu', 'male', '1967-06-13', 37737);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (439, 'Dahlia', 'Cavozzi', 'd.cavozzi@libra.edu', 'female', '1994-09-17', 35617);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (440, 'Christie', 'Striker', 'c.striker@libra.edu', 'male', '1937-02-28', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (441, 'Sonnie', 'Cunningham', 's.cunningham@libra.edu', null, '1930-09-27', 35645);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (442, 'Brannon', 'Studholme', 'b.studholme@libra.edu', 'male', '1969-04-27', 37662);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (443, 'Bobinette', 'Forward', 'b.forward@libra.edu', 'female', '1950-04-07', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (444, 'Zebedee', 'Ionn', 'z.ionn@libra.edu', 'male', '1977-06-14', 38272);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (445, 'Lucille', 'Slavin', 'l.slavin@libra.edu', 'female', '1941-10-13', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (446, 'Jeana', 'Smallbone', 'j.smallbone@libra.edu', 'female', '1996-05-15', 35780);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (447, 'Fifi', 'Aiton', 'f.aiton@libra.edu', null, '1930-06-30', 37812);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (448, 'Elnore', 'Kinghorne', 'e.kinghorne@libra.edu', 'female', '1971-11-25', 38030);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (449, 'Shandra', 'Craydon', 's.craydon@libra.edu', 'female', '1996-08-24', 37735);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (450, 'Ev', 'Burdge', 'e.burdge@libra.edu', 'male', '1938-01-06', 37827);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (451, 'Morgun', 'Ewers', 'm.ewers@libra.edu', 'male', '1981-07-12', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (452, 'Mallorie', 'Glasscott', 'm.glasscott@libra.edu', 'female', '1966-11-03', 36761);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (453, 'Lothario', 'Donat', 'l.donat@libra.edu', 'male', '1951-07-19', 36624);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (454, 'Addie', 'Poat', 'a.poat@libra.edu', 'male', '1964-11-25', 37349);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (455, 'Aldus', 'Purchase', 'a.purchase@libra.edu', 'male', '2002-10-15', 37019);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (456, 'Sibelle', 'Fallawe', 's.fallawe@libra.edu', 'female', '1990-04-01', 38256);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (457, 'Kayne', 'Reace', 'k.reace@libra.edu', 'male', '1936-11-22', 35776);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (458, 'Gunner', 'Bichard', 'g.bichard@libra.edu', 'male', '1942-04-20', 35727);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (459, 'Sigfried', 'Vail', 's.vail@libra.edu', 'male', '1944-09-08', 38091);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (460, 'Gnni', 'Von Welden', 'g.von_welden@libra.edu', 'female', '1964-08-13', 36642);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (461, 'Maurine', 'Finley', 'm.finley@libra.edu', 'female', '1988-08-08', 37246);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (462, 'Kermy', 'Markovich', 'k.markovich@libra.edu', 'male', '1969-12-06', 37129);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (463, 'Chandler', 'Kirsch', 'c.kirsch@libra.edu', 'male', '1940-06-30', 35381);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (464, 'Talbert', 'De Caroli', 't.de_caroli@libra.edu', 'male', '1947-07-19', 35332);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (465, 'Averil', 'Oakey', 'a.oakey@libra.edu', 'female', '1959-10-28', 37402);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (466, 'Gar', 'Manssuer', 'g.manssuer@libra.edu', 'male', '1974-11-16', 35342);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (467, 'Ayn', 'McBoyle', 'a.mcboyle@libra.edu', 'female', '1938-12-27', 38206);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (468, 'Giovanni', 'Doyland', 'g.doyland@libra.edu', 'male', '1935-02-26', 35767);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (469, 'Linnea', 'Mansford', 'l.mansford@libra.edu', 'female', '2001-12-11', 38021);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (470, 'Jock', 'Fer', 'j.fer@libra.edu', 'male', '1982-09-01', 37550);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (471, 'Galven', 'Hiscocks', 'g.hiscocks@libra.edu', 'male', '1955-11-05', 35500);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (472, 'Scott', 'Bawden', 's.bawden@libra.edu', 'male', '1984-05-18', 37206);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (473, 'Lorain', 'Likly', 'l.likly@libra.edu', 'female', '1983-01-07', 36233);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (474, 'Ramon', 'Bassick', 'r.bassick@libra.edu', 'male', '1992-05-03', 35569);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (475, 'Rodolphe', 'Greatrex', 'r.greatrex@libra.edu', 'male', '1940-08-31', 36955);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (476, 'Dyan', 'Broxholme', 'd.broxholme@libra.edu', 'female', '2009-05-31', 35952);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (477, 'Daniel', 'Castellan', 'd.castellan@libra.edu', 'male', '1945-10-05', 37019);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (478, 'Carrissa', 'Fine', 'c.fine@libra.edu', 'female', '1940-11-21', 36141);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (479, 'Hilary', 'Twiggins', 'h.twiggins@libra.edu', 'female', '1991-04-28', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (480, 'Nicolais', 'O''Conor', 'n.o''conor@libra.edu', 'male', '1963-11-11', 36508);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (481, 'Camella', 'Fairtlough', 'c.fairtlough@libra.edu', 'female', '1990-04-29', 37496);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (482, 'Andy', 'Snartt', 'a.snartt@libra.edu', 'female', '1986-08-18', 36529);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (483, 'Tammy', 'Gomersal', 't.gomersal@libra.edu', 'male', '1994-08-03', 35485);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (484, 'Nathanael', 'Le Marchand', 'n.le_marchand@libra.edu', 'male', '1950-12-17', 35992);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (485, 'Enid', 'Chastand', 'e.chastand@libra.edu', 'female', '1944-07-07', 37272);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (486, 'Carine', 'Gozard', 'c.gozard@libra.edu', 'female', '1939-02-03', 37795);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (487, 'Candace', 'Widdecombe', 'c.widdecombe@libra.edu', 'female', '1970-03-24', 36863);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (488, 'Berny', 'Dracey', 'b.dracey@libra.edu', 'male', '1974-11-25', 35285);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (489, 'Burk', 'Johansen', 'b.johansen@libra.edu', 'male', '1976-02-10', 38146);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (491, 'Robert', 'Emmines', 'r.emmines@libra.edu', 'male', '1942-04-06', 35435);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (492, 'Hillery', 'Womersley', 'h.womersley@libra.edu', 'male', '2004-09-16', 37810);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (493, 'Candi', 'Maillard', 'c.maillard@libra.edu', 'female', '1954-08-01', 37820);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (494, 'Erwin', 'Josefer', 'e.josefer@libra.edu', 'male', '1965-03-23', 38258);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (495, 'Dukie', 'Gasker', 'd.gasker@libra.edu', 'male', '1993-05-30', 37447);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (496, 'Jesse', 'Walls', 'j.walls@libra.edu', null, '1951-09-22', 36814);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (497, 'Ebeneser', 'Keyser', 'e.keyser@libra.edu', 'male', '1947-01-05', 37699);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (498, 'Yale', 'Gilliard', 'y.gilliard@libra.edu', 'male', '1941-10-01', 35354);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (499, 'Richard', 'Krolman', 'r.krolman@libra.edu', 'male', '1986-09-25', 37448);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (500, 'Simona', 'Drioli', 's.drioli@libra.edu', 'female', '1936-11-25', 36583);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (501, 'Cyrille', 'Fernao', 'c.fernao@libra.edu', null, '1956-05-18', 37078);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (502, 'Milena', 'Eccles', 'm.eccles@libra.edu', 'female', '1986-03-02', 38114);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (503, 'Audrie', 'Bourne', 'a.bourne@libra.edu', 'female', '1961-01-02', 37137);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (504, 'Vite', 'Mourgue', 'v.mourgue@libra.edu', 'male', '1944-04-16', 37316);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (505, 'Marijo', 'Richt', 'm.richt@libra.edu', 'female', '1938-03-21', 37784);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (506, 'Corey', 'Burgoyne', 'c.burgoyne@libra.edu', 'male', '1932-11-21', 36445);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (507, 'Sallee', 'Yewen', 's.yewen@libra.edu', 'female', '1946-02-11', 36123);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (508, 'Mariellen', 'Volk', 'm.volk@libra.edu', 'female', '2001-02-06', 35902);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (509, 'Cammie', 'Standidge', 'c.standidge@libra.edu', 'female', '1952-07-02', 35385);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (510, 'Tobin', 'Von Oertzen', 't.von_oertzen@libra.edu', 'male', '1942-01-28', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (511, 'Ilysa', 'Norbury', 'i.norbury@libra.edu', 'female', '1985-11-28', 36476);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (512, 'Katya', 'Wilderspoon', 'k.wilderspoon@libra.edu', 'female', '1972-01-27', 37955);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (513, 'Carolina', 'Soigne', 'c.soigne@libra.edu', 'female', '1957-04-15', 35600);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (514, 'Carroll', 'Heindle', 'c.heindle@libra.edu', 'female', '1944-02-22', 37796);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (515, 'Sarena', 'Bourdas', 's.bourdas@libra.edu', 'female', '2001-03-26', 36180);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (516, 'Gabbie', 'Farny', 'g.farny@libra.edu', 'female', '1945-10-15', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (517, 'Lewiss', 'Abelson', 'l.abelson@libra.edu', 'male', '1993-04-11', 36215);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (518, 'Dynah', 'Chivrall', 'd.chivrall@libra.edu', 'female', '2008-04-16', 36749);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (519, 'Atlante', 'Kimberly', 'a.kimberly@libra.edu', 'female', '1987-08-26', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (520, 'Flossy', 'Gindghill', 'f.gindghill@libra.edu', 'female', '1956-02-16', 38223);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (521, 'Reade', 'Rooper', 'r.rooper@libra.edu', 'male', '1988-07-15', 37457);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (522, 'Tamera', 'Aldwinckle', 't.aldwinckle@libra.edu', 'female', '1943-07-01', 37631);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (523, 'Darda', 'Copnell', 'd.copnell@libra.edu', 'female', '1946-02-26', 35927);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (524, 'Jeniece', 'Allabush', 'j.allabush@libra.edu', 'female', '1932-02-22', 35297);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (525, 'Francene', 'Jinks', 'f.jinks@libra.edu', 'female', '1957-07-27', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (526, 'Giana', 'Blakely', 'g.blakely@libra.edu', 'female', '1995-11-30', 36005);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (527, 'Marchelle', 'Canon', 'm.canon@libra.edu', 'female', '1962-02-20', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (528, 'Elvis', 'Trengrove', 'e.trengrove@libra.edu', 'male', '1988-09-04', 36749);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (529, 'Izaak', 'Dowson', 'i.dowson@libra.edu', 'male', '1949-12-31', 36819);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (530, 'Florette', 'O''Carroll', 'f.o''carroll@libra.edu', 'female', '1941-10-05', 35566);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (531, 'Morty', 'Jirka', 'm.jirka@libra.edu', 'male', '1936-12-24', 38272);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (532, 'Phedra', 'Brierton', 'p.brierton@libra.edu', 'female', '1950-05-06', 38294);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (533, 'Corrinne', 'Sheridan', 'c.sheridan@libra.edu', 'female', '1963-05-20', 37285);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (534, 'Winona', 'Rotherforth', 'w.rotherforth@libra.edu', 'female', '1980-07-06', 35576);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (535, 'Ranique', 'Brasener', 'r.brasener@libra.edu', 'female', '1938-07-23', 36155);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (536, 'Kendra', 'Grahlman', 'k.grahlman@libra.edu', 'female', '1935-03-05', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (537, 'Aloysius', 'Turnell', 'a.turnell@libra.edu', 'male', '1993-08-06', 35716);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (538, 'Nester', 'Thal', 'n.thal@libra.edu', 'male', '2006-09-19', 37621);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (539, 'Gregory', 'Mil', 'g.mil@libra.edu', 'male', '1978-02-05', 35796);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (541, 'Gawen', 'Perrett', 'g.perrett@libra.edu', null, '1948-12-31', 35361);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (542, 'Dalston', 'Jobb', 'd.jobb@libra.edu', 'male', '1960-12-20', 37166);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (543, 'Loni', 'Darcey', 'l.darcey@libra.edu', 'female', '1938-07-24', 36839);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (544, 'Nickolai', 'Tutt', 'n.tutt@libra.edu', 'male', '1955-05-18', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (545, 'Babbette', 'Dewhirst', 'b.dewhirst@libra.edu', 'female', '1949-05-25', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (546, 'Benito', 'Chester', 'b.chester@libra.edu', 'male', '2005-12-07', 36022);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (547, 'Starlene', 'Waters', 's.waters@libra.edu', 'female', '1977-08-20', 35800);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (548, 'Modestia', 'Arnaudon', 'm.arnaudon@libra.edu', 'female', '1938-03-01', 36193);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (549, 'Jazmin', 'Pluthero', 'j.pluthero@libra.edu', 'female', '1979-04-12', 36706);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (550, 'Mahala', 'Dorbin', 'm.dorbin@libra.edu', 'female', '1976-09-25', 36449);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (551, 'Nissy', 'Hengoed', 'n.hengoed@libra.edu', 'female', '1987-04-06', 36258);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (552, 'Elliot', 'Duly', 'e.duly@libra.edu', 'male', '1955-10-23', 38017);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (553, 'Florida', 'Kloska', 'f.kloska@libra.edu', 'female', '1999-02-19', 37910);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (554, 'Piper', 'Sans', 'p.sans@libra.edu', 'female', '1966-03-08', 37238);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (555, 'Gerri', 'Henker', 'g.henker@libra.edu', 'male', '1993-12-14', 35657);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (556, 'Mikaela', 'Pezey', 'm.pezey@libra.edu', 'female', '1979-06-18', 38021);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (557, 'Hattie', 'Bowdrey', 'h.bowdrey@libra.edu', 'female', '2006-10-13', 35742);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (558, 'Ida', 'Dix', 'i.dix@libra.edu', 'female', '1937-01-26', 37262);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (559, 'Roxi', 'Cathesyed', 'r.cathesyed@libra.edu', 'female', '1930-02-12', 37190);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (560, 'Lorry', 'Chipman', 'l.chipman@libra.edu', 'male', '1965-10-29', 37435);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (561, 'Wallas', 'Emby', 'w.emby@libra.edu', 'male', '2002-06-30', 36666);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (562, 'Derward', 'Bottoms', 'd.bottoms@libra.edu', 'male', '1984-08-13', 37427);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (563, 'Mercedes', 'Roscow', 'm.roscow@libra.edu', 'female', '2000-10-09', 36372);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (564, 'Olimpia', 'Lintott', 'o.lintott@libra.edu', 'female', '2002-04-29', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (565, 'Agnella', 'Wallsworth', 'a.wallsworth@libra.edu', 'female', '1931-11-06', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (566, 'Harley', 'Baglow', 'h.baglow@libra.edu', 'male', '1967-01-27', 35419);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (567, 'Elberta', 'Yarker', 'e.yarker@libra.edu', 'female', '1994-10-26', 36159);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (569, 'Danny', 'Prodrick', 'd.prodrick@libra.edu', 'male', '2007-08-01', 35950);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (570, 'Marris', 'Tink', 'm.tink@libra.edu', 'female', '2001-12-31', 35822);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (571, 'Bessie', 'Hartgill', 'b.hartgill@libra.edu', 'female', '1969-05-09', 37068);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (572, 'Reggis', 'Ganders', 'r.ganders@libra.edu', null, '1939-02-07', 36474);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (573, 'Virginia', 'McClelland', 'v.mcclelland@libra.edu', 'female', '1948-11-24', 35605);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (574, 'Hy', 'Drissell', 'h.drissell@libra.edu', 'male', '2005-03-06', 36312);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (575, 'Corry', 'Koenen', 'c.koenen@libra.edu', 'female', '1976-10-01', 37981);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (576, 'Clemente', 'Duiged', 'c.duiged@libra.edu', 'male', '1975-05-13', 35446);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (577, 'Gaultiero', 'Meddemmen', 'g.meddemmen@libra.edu', 'male', '2009-09-04', 36405);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (578, 'Jorge', 'Rudeforth', 'j.rudeforth@libra.edu', 'male', '2003-11-17', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (579, 'Jamaal', 'Pesic', 'j.pesic@libra.edu', 'male', '1955-06-09', 35794);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (580, 'Mathew', 'Skippings', 'm.skippings@libra.edu', 'male', '1999-02-19', 36000);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (581, 'Kipper', 'Swarbrigg', 'k.swarbrigg@libra.edu', 'male', '1943-05-17', 37204);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (582, 'Vernor', 'Verman', 'v.verman@libra.edu', 'male', '1932-02-23', 36628);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (583, 'Tove', 'Crispe', 't.crispe@libra.edu', null, '1953-06-29', 35835);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (584, 'Coleen', 'Byk', 'c.byk@libra.edu', 'female', '1985-05-18', 38200);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (585, 'Almeria', 'Luney', 'a.luney@libra.edu', 'female', '1949-06-21', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (586, 'Geneva', 'Easum', 'g.easum@libra.edu', 'female', '1984-05-21', 37667);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (587, 'Parry', 'Webborn', 'p.webborn@libra.edu', 'male', '1941-07-27', 37167);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (588, 'Cristal', 'Jozaitis', 'c.jozaitis@libra.edu', 'female', '1937-06-05', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (589, 'Durante', 'Domek', 'd.domek@libra.edu', null, '1993-07-11', 37561);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (590, 'Wilfrid', 'Pahler', 'w.pahler@libra.edu', null, '1958-11-03', 36938);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (591, 'Alecia', 'Hesey', 'a.hesey@libra.edu', 'female', '2004-06-14', 37583);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (592, 'Donn', 'Simister', 'd.simister@libra.edu', 'male', '1981-08-31', 36633);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (593, 'Hattie', 'Pittel', 'h.pittel@libra.edu', null, '2000-01-21', 35451);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (594, 'Nadeen', 'Elsby', 'n.elsby@libra.edu', 'female', '1931-03-29', 37651);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (595, 'Araldo', 'Maccrae', 'a.maccrae@libra.edu', 'male', '1933-01-27', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (596, 'Taffy', 'Atyeo', 't.atyeo@libra.edu', 'female', '2002-03-30', 38266);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (597, 'Jerrilee', 'Danbrook', 'j.danbrook@libra.edu', 'female', '1972-03-27', 37648);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (598, 'Doti', 'Dougan', 'd.dougan@libra.edu', 'female', '1955-01-01', 36019);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (599, 'Banky', 'Blase', 'b.blase@libra.edu', 'male', '1990-04-08', 35619);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (600, 'Ronda', 'Rowbrey', 'r.rowbrey@libra.edu', 'female', '1948-04-24', 37228);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (601, 'Kristoforo', 'Stother', 'k.stother@libra.edu', 'male', '1932-01-25', 35820);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (602, 'Chip', 'Broomer', 'c.broomer@libra.edu', 'male', '1930-08-02', 35823);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (603, 'Jeannie', 'Emlin', 'j.emlin@libra.edu', 'female', '1973-04-19', 37976);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (604, 'Francis', 'Lanston', 'f.lanston@libra.edu', 'male', '1936-06-13', 35933);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (605, 'Sherlocke', 'Honisch', 's.honisch@libra.edu', 'male', '1954-10-30', 38156);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (606, 'Hart', 'Colquhoun', 'h.colquhoun@libra.edu', 'male', '2002-11-23', 36879);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (607, 'Glyn', 'Digance', 'g.digance@libra.edu', 'female', '1996-11-19', 35739);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (608, 'Kizzee', 'Ramard', 'k.ramard@libra.edu', 'female', '1953-05-20', 35970);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (609, 'Anitra', 'Easbie', 'a.easbie@libra.edu', 'female', '1967-11-06', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (610, 'Kellen', 'Goodsal', 'k.goodsal@libra.edu', 'female', '1946-02-06', 36177);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (611, 'Tadd', 'Batcheldor', 't.batcheldor@libra.edu', 'male', '1942-09-27', 38059);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (612, 'Kurt', 'Ucceli', 'k.ucceli@libra.edu', 'male', '1943-09-17', 35577);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (613, 'Ole', 'Brunt', 'o.brunt@libra.edu', 'male', '1956-11-03', 37540);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (614, 'Cleon', 'Wicher', 'c.wicher@libra.edu', 'male', '1959-02-27', 37603);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (615, 'Olivie', 'Paolacci', 'o.paolacci@libra.edu', 'female', '1942-06-13', 36382);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (616, 'Hy', 'Falconar', 'h.falconar@libra.edu', 'male', '1943-05-03', 37747);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (617, 'Gustie', 'Crighton', 'g.crighton@libra.edu', 'female', '1982-06-06', 38250);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (618, 'Phineas', 'Simounet', 'p.simounet@libra.edu', 'male', '1988-04-08', 37446);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (619, 'Yuri', 'MacGrath', 'y.macgrath@libra.edu', 'male', '1961-01-24', 37763);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (620, 'Rainer', 'Prevett', 'r.prevett@libra.edu', 'male', '2009-04-23', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (621, 'Camellia', 'Cornborough', 'c.cornborough@libra.edu', 'female', '1963-05-25', 36961);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (622, 'Rafael', 'Doddridge', 'r.doddridge@libra.edu', 'male', '1969-03-12', 38178);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (623, 'Betta', 'Larderot', 'b.larderot@libra.edu', 'female', '1977-06-17', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (625, 'Grace', 'Timperley', 'g.timperley@libra.edu', 'male', '2004-12-02', 37602);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (626, 'Edd', 'Berns', 'e.berns@libra.edu', null, '2002-07-29', 37054);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (627, 'Thorvald', 'Middlebrook', 't.middlebrook@libra.edu', 'male', '1977-04-29', 37250);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (628, 'Agnes', 'Streatley', 'a.streatley@libra.edu', 'female', '1993-03-25', 36459);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (629, 'Cilka', 'Coat', 'c.coat@libra.edu', 'female', '1998-08-22', 35757);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (630, 'Lian', 'Stebbings', 'l.stebbings@libra.edu', 'female', '1956-04-01', 37247);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (631, 'Aubrey', 'Yakob', 'a.yakob@libra.edu', 'male', '2001-09-22', 35994);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (632, 'Dulcinea', 'Chew', 'd.chew@libra.edu', 'female', '1947-05-09', 35755);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (633, 'Lamond', 'Marval', 'l.marval@libra.edu', 'male', '1974-08-09', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (634, 'Matteo', 'Tear', 'm.tear@libra.edu', 'male', '2008-09-11', 37224);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (635, 'Ezra', 'Laskey', 'e.laskey@libra.edu', 'male', '1941-01-20', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (636, 'Jeri', 'Fairn', 'j.fairn@libra.edu', 'female', '1982-03-22', 36774);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (637, 'Jonah', 'Shrieve', 'j.shrieve@libra.edu', 'male', '1949-11-04', 35708);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (638, 'Bealle', 'Doolan', 'b.doolan@libra.edu', 'male', '1962-07-19', 38275);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (639, 'Lothario', 'Bouts', 'l.bouts@libra.edu', 'male', '1985-11-14', 37004);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (640, 'Walker', 'Stuckow', 'w.stuckow@libra.edu', 'male', '1949-12-22', 37637);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (641, 'Hewitt', 'Dussy', 'h.dussy@libra.edu', 'male', '1946-08-13', 36727);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (642, 'Denni', 'Vale', 'd.vale@libra.edu', 'female', '1985-12-17', 35821);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (643, 'Emelen', 'Coie', 'e.coie@libra.edu', 'male', '2000-07-29', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (644, 'Urbano', 'Timmons', 'u.timmons@libra.edu', 'male', '1946-12-28', 37686);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (645, 'Guinevere', 'Turton', 'g.turton@libra.edu', null, '1971-11-01', 36225);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (646, 'Melisenda', 'Noulton', 'm.noulton@libra.edu', 'female', '1988-04-08', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (647, 'Dulcie', 'Brine', 'd.brine@libra.edu', 'female', '1999-02-06', 38135);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (648, 'Jonell', 'Dugget', 'j.dugget@libra.edu', 'female', '1989-05-03', 36940);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (649, 'Forester', 'Dewbury', 'f.dewbury@libra.edu', 'male', '1984-10-02', 36321);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (650, 'Delia', 'Greatrex', 'd.greatrex@libra.edu', 'female', '1992-01-29', 35741);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (651, 'Jervis', 'Spaduzza', 'j.spaduzza@libra.edu', 'male', '2004-05-26', 37508);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (652, 'Myrtice', 'Maiklem', 'm.maiklem@libra.edu', null, '1976-08-25', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (653, 'Belvia', 'Sisley', 'b.sisley@libra.edu', 'female', '1954-11-13', 38164);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (654, 'Baldwin', 'Petkens', 'b.petkens@libra.edu', 'male', '1969-06-14', 36844);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (655, 'Carri', 'Nevill', 'c.nevill@libra.edu', 'female', '1962-03-10', 37147);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (656, 'Adler', 'Fountaine', 'a.fountaine@libra.edu', 'male', '1946-05-16', 35707);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (657, 'Dorian', 'McVicker', 'd.mcvicker@libra.edu', 'male', '1935-07-19', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (658, 'Iggie', 'Keighly', 'i.keighly@libra.edu', 'male', '1941-07-13', 37933);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (659, 'Bobbie', 'Augustus', 'b.augustus@libra.edu', 'male', '1935-08-06', 36247);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (660, 'Enos', 'Linwood', 'e.linwood@libra.edu', 'male', '1994-02-26', 38174);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (661, 'Reeva', 'Cliff', 'r.cliff@libra.edu', 'female', '1933-08-25', 35605);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (662, 'Fayre', 'Temblett', 'f.temblett@libra.edu', 'female', '1984-01-23', 38175);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (663, 'Dennison', 'Filewood', 'd.filewood@libra.edu', 'male', '1965-08-31', 37031);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (664, 'Buck', 'Learmont', 'b.learmont@libra.edu', 'male', '1994-04-12', 37623);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (665, 'Madelin', 'Gaishson', 'm.gaishson@libra.edu', 'female', '1991-04-16', 35512);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (666, 'Julie', 'Hutchin', 'j.hutchin@libra.edu', 'female', '1948-02-10', 36775);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (667, 'Margy', 'Golda', 'm.golda@libra.edu', 'female', '1930-10-28', 37604);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (668, 'Lory', 'Powley', 'l.powley@libra.edu', 'female', '1942-03-19', 36205);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (669, 'Pearle', 'Pyatt', 'p.pyatt@libra.edu', 'female', '1981-08-11', 36334);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (670, 'Margareta', 'Harlowe', 'm.harlowe@libra.edu', 'female', '1943-04-02', 35532);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (671, 'Johnath', 'Iacopetti', 'j.iacopetti@libra.edu', 'female', '1966-01-01', 38053);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (672, 'Aylmar', 'Stygall', 'a.stygall@libra.edu', 'male', '2007-06-13', 36646);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (673, 'Winni', 'Aliman', 'w.aliman@libra.edu', 'female', '1992-04-12', 35491);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (675, 'Johnette', 'Cumpsty', 'j.cumpsty@libra.edu', 'female', '1945-09-04', 36459);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (676, 'Spenser', 'Hercock', 's.hercock@libra.edu', 'male', '1970-08-15', 36516);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (677, 'Daniela', 'Cleworth', 'd.cleworth@libra.edu', 'female', '1936-02-23', 35767);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (678, 'Garland', 'Baniard', 'g.baniard@libra.edu', 'female', '2002-04-25', 35384);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (679, 'Cello', 'Ledgley', 'c.ledgley@libra.edu', 'male', '1986-08-16', 36520);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (680, 'Rosaline', 'Reede', 'r.reede@libra.edu', 'female', '1930-10-11', 35651);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (681, 'Alisa', 'MacNess', 'a.macness@libra.edu', 'female', '1975-01-22', 36156);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (682, 'Pen', 'Scase', 'p.scase@libra.edu', 'female', '1960-09-07', 36358);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (683, 'Correy', 'Farrimond', 'c.farrimond@libra.edu', 'male', '1977-06-12', 37344);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (684, 'Leonora', 'Burdis', 'l.burdis@libra.edu', 'female', '1989-05-17', 37367);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (685, 'Llywellyn', 'Brigham', 'l.brigham@libra.edu', 'male', '1930-11-10', 37663);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (686, 'Barnebas', 'McClintock', 'b.mcclintock@libra.edu', null, '1950-07-11', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (687, 'Ephraim', 'Sheehan', 'e.sheehan@libra.edu', 'male', '1970-06-23', 37731);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (688, 'Lindsay', 'Mitkov', 'l.mitkov@libra.edu', 'male', '2002-05-28', 36901);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (689, 'Linda', 'Magor', 'l.magor@libra.edu', null, '1974-03-25', 36309);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (690, 'Brnaba', 'Bradbury', 'b.bradbury@libra.edu', 'male', '1937-07-14', 35912);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (691, 'Harlin', 'Dineges', 'h.dineges@libra.edu', 'male', '1993-03-25', 38104);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (692, 'Allx', 'Arndell', 'a.arndell@libra.edu', 'female', '1996-03-18', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (693, 'Emile', 'McEttigen', 'e.mcettigen@libra.edu', 'male', '2005-09-12', 38040);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (694, 'Shea', 'Bushel', 's.bushel@libra.edu', null, '1988-10-03', 36007);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (695, 'Glenine', 'Dougher', 'g.dougher@libra.edu', 'female', '1998-02-05', 35403);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (696, 'Monique', 'Walster', 'm.walster@libra.edu', 'female', '1947-07-08', 36162);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (697, 'Royall', 'Keynes', 'r.keynes@libra.edu', 'male', '1952-03-07', 36246);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (698, 'Remus', 'Burchess', 'r.burchess@libra.edu', 'male', '1971-06-03', 36050);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (699, 'Hugibert', 'Blunsom', 'h.blunsom@libra.edu', 'male', '1980-10-05', 38072);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (700, 'Benedick', 'Cottrill', 'b.cottrill@libra.edu', 'male', '1939-09-30', 36021);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (701, 'Moss', 'MacGuffog', 'm.macguffog@libra.edu', 'male', '1972-10-21', 38162);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (702, 'Sky', 'Lewsam', 's.lewsam@libra.edu', 'male', '1933-02-14', 35399);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (703, 'Dotty', 'Vannoni', 'd.vannoni@libra.edu', 'female', '1991-02-05', 36533);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (704, 'Andra', 'Heddon', 'a.heddon@libra.edu', 'female', '1958-01-09', 37337);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (705, 'Goddard', 'Moralis', 'g.moralis@libra.edu', 'male', '1950-08-25', 35456);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (706, 'Becki', 'Petrelli', 'b.petrelli@libra.edu', 'female', '2007-09-30', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (707, 'Husain', 'Ding', 'h.ding@libra.edu', 'male', '1939-09-12', 36764);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (708, 'Clement', 'Bockmaster', 'c.bockmaster@libra.edu', 'male', '1963-05-20', 38140);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (709, 'Fidela', 'Feirn', 'f.feirn@libra.edu', null, '1953-02-16', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (710, 'Rolfe', 'Stalman', 'r.stalman@libra.edu', 'male', '1944-10-06', 36828);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (711, 'Tiphani', 'Pendergast', 't.pendergast@libra.edu', 'female', '1981-09-17', 37578);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (712, 'Bettye', 'Keme', 'b.keme@libra.edu', 'female', '1973-07-25', 36638);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (713, 'Pacorro', 'Clowsley', 'p.clowsley@libra.edu', null, '1988-12-18', 36957);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (714, 'Nickolas', 'Plowes', 'n.plowes@libra.edu', 'male', '1949-06-05', 36314);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (715, 'Judon', 'Quested', 'j.quested@libra.edu', 'male', '1995-01-07', 36083);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (716, 'Gilberte', 'Malins', 'g.malins@libra.edu', 'female', '1970-01-14', 35984);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (717, 'Wynny', 'Kenwin', 'w.kenwin@libra.edu', 'female', '1945-01-20', 35726);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (718, 'Aguistin', 'Jillard', 'a.jillard@libra.edu', 'male', '1997-03-20', 36698);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (719, 'Karole', 'Van Niekerk', 'k.van_niekerk@libra.edu', 'female', '1973-12-17', 36698);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (720, 'Madella', 'Caplan', 'm.caplan@libra.edu', 'female', '1933-09-22', 35845);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (721, 'Jana', 'Halsey', 'j.halsey@libra.edu', 'female', '1997-10-22', 37281);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (722, 'Giffie', 'Gilhool', 'g.gilhool@libra.edu', 'male', '1965-02-19', 37598);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (723, 'Vincents', 'Foulds', 'v.foulds@libra.edu', 'male', '2003-06-29', 35410);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (724, 'Gerhardine', 'Regler', 'g.regler@libra.edu', 'female', '1992-01-23', 35478);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (725, 'Patton', 'Fransewich', 'p.fransewich@libra.edu', 'male', '1975-08-20', 35943);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (726, 'Skipper', 'Frid', 's.frid@libra.edu', 'male', '1970-08-18', 37521);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (727, 'Diego', 'Cochran', 'd.cochran@libra.edu', 'male', '1992-04-08', 36422);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (728, 'Tanner', 'Gollin', 't.gollin@libra.edu', 'male', '1937-09-02', 35894);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (729, 'Dolly', 'Barnfather', 'd.barnfather@libra.edu', 'female', '1968-10-15', 37094);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (730, 'Alia', 'Gosling', 'a.gosling@libra.edu', 'female', '1979-01-14', 36233);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (731, 'Palm', 'Cakes', 'p.cakes@libra.edu', 'male', '1937-07-01', 37977);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (732, 'Pegeen', 'Turley', 'p.turley@libra.edu', 'female', '1931-07-30', 38037);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (733, 'Tawnya', 'Llorens', 't.llorens@libra.edu', 'female', '1999-12-12', 37809);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (734, 'Cecilio', 'Kenworth', 'c.kenworth@libra.edu', 'male', '1962-10-18', 36454);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (735, 'Booth', 'Sprowell', 'b.sprowell@libra.edu', 'male', '1966-10-01', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (736, 'Kimberli', 'Wemm', 'k.wemm@libra.edu', 'female', '1935-02-11', 35617);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (737, 'Helsa', 'Luckings', 'h.luckings@libra.edu', 'female', '2000-10-27', 38291);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (738, 'Danielle', 'Snazel', 'd.snazel@libra.edu', 'female', '1949-02-23', 35640);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (739, 'Cesare', 'Kunisch', 'c.kunisch@libra.edu', 'male', '1935-09-12', 38104);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (740, 'Maxwell', 'Fere', 'm.fere@libra.edu', 'male', '1942-11-16', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (741, 'Cherey', 'Perri', 'c.perri@libra.edu', 'female', '1972-10-27', 35817);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (742, 'Dana', 'Palay', 'd.palay@libra.edu', 'male', '2007-08-10', 37326);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (743, 'Amie', 'Phil', 'a.phil@libra.edu', 'female', '1991-09-24', 37066);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (744, 'Godwin', 'Reveley', 'g.reveley@libra.edu', 'male', '1937-08-12', 37601);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (745, 'Cally', 'Niche', 'c.niche@libra.edu', 'female', '1947-12-06', 36814);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (746, 'Norton', 'Sapson', 'n.sapson@libra.edu', 'male', '1976-01-21', 35854);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (747, 'Pepita', 'D''eathe', 'p.d''eathe@libra.edu', 'female', '1980-12-29', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (748, 'Gardner', 'Ciciari', 'g.ciciari@libra.edu', 'male', '1949-09-26', 37326);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (749, 'Kevan', 'Hedney', 'k.hedney@libra.edu', 'male', '1964-04-06', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (750, 'Travis', 'Charlewood', 't.charlewood@libra.edu', 'male', '1935-06-18', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (751, 'Eugenie', 'Eberst', 'e.eberst@libra.edu', 'female', '1990-11-10', 35545);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (752, 'Kippy', 'Dwyr', 'k.dwyr@libra.edu', 'male', '1971-05-30', 36560);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (753, 'Jacob', 'Bricham', 'j.bricham@libra.edu', 'male', '1933-05-28', 36961);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (754, 'Dierdre', 'Hucquart', 'd.hucquart@libra.edu', 'female', '1941-10-16', 37296);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (755, 'Dall', 'Thorius', 'd.thorius@libra.edu', 'male', '1964-04-26', 35926);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (756, 'Margy', 'Wagenen', 'm.wagenen@libra.edu', 'female', '1933-08-03', 36687);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (757, 'Cindi', 'Rossbrooke', 'c.rossbrooke@libra.edu', 'female', '1968-08-06', 37010);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (758, 'Josee', 'Libbe', 'j.libbe@libra.edu', 'female', '2008-12-01', 37334);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (759, 'Trudie', 'Van de Vlies', 't.van_de_vlies@libra.edu', 'female', '1967-05-09', 36543);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (760, 'Padgett', 'Limpricht', 'p.limpricht@libra.edu', 'male', '1939-09-06', 35297);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (761, 'Car', 'Smurfitt', 'c.smurfitt@libra.edu', 'male', '1984-03-01', 35434);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (762, 'Lockwood', 'Catteroll', 'l.catteroll@libra.edu', 'male', '1972-06-05', 38199);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (763, 'Ferdinanda', 'Camilli', 'f.camilli@libra.edu', 'female', '1964-06-17', 37992);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (764, 'Bailey', 'Auty', 'b.auty@libra.edu', 'male', '1949-05-28', 37835);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (765, 'Clayson', 'Puzey', 'c.puzey@libra.edu', 'male', '1941-10-08', 36292);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (767, 'Corbett', 'Bounds', 'c.bounds@libra.edu', 'male', '1990-03-18', 38289);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (768, 'Reena', 'Form', 'r.form@libra.edu', 'female', '1969-01-13', 36100);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (769, 'Bernadette', 'Levey', 'b.levey@libra.edu', 'female', '1937-07-11', 35693);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (770, 'Vinson', 'Simoncelli', 'v.simoncelli@libra.edu', 'male', '1973-01-12', 37487);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (771, 'Trent', 'Idwal Evans', 't.idwal_evans@libra.edu', 'male', '2006-04-04', 36293);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (772, 'Yalonda', 'Merrell', 'y.merrell@libra.edu', 'female', '1970-08-22', 35705);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (773, 'Hailee', 'Valentine', 'h.valentine@libra.edu', 'female', '1962-12-06', 36770);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (774, 'Mable', 'Chorley', 'm.chorley@libra.edu', 'female', '2005-08-15', 35294);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (775, 'Knox', 'Pavey', 'k.pavey@libra.edu', null, '1947-07-27', 38275);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (776, 'Lance', 'Cawsby', 'l.cawsby@libra.edu', 'male', '1995-09-03', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (777, 'Elsy', 'Stille', 'e.stille@libra.edu', 'female', '1953-03-02', 36902);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (778, 'Lorain', 'Kamall', 'l.kamall@libra.edu', 'female', '1955-05-30', 36538);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (779, 'Guenna', 'Ravelus', 'g.ravelus@libra.edu', 'female', '1982-12-11', 36053);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (780, 'Brady', 'Weare', 'b.weare@libra.edu', 'male', '1944-05-25', 37832);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (781, 'Willdon', 'Coppens', 'w.coppens@libra.edu', 'male', '1965-04-10', 36159);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (782, 'Culley', 'Rountree', 'c.rountree@libra.edu', 'male', '1981-06-18', 38216);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (783, 'Tatiana', 'Murdoch', 't.murdoch@libra.edu', 'female', '2002-03-16', 36741);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (784, 'Tanner', 'Tattersdill', 't.tattersdill@libra.edu', 'male', '2009-10-31', 35698);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (785, 'Johannah', 'Simmans', 'j.simmans@libra.edu', 'female', '1935-01-23', 36800);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (786, 'Nappy', 'Plowes', 'n.plowes2@libra.edu', 'male', '1975-02-14', 35744);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (787, 'Dylan', 'Najafian', 'd.najafian@libra.edu', 'male', '1965-09-25', 38059);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (788, 'Kingsly', 'Toretta', 'k.toretta@libra.edu', 'male', '1974-08-14', 35630);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (789, 'Valenka', 'Tilliards', 'v.tilliards@libra.edu', null, '1961-05-04', 36239);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (790, 'Brena', 'Spering', 'b.spering@libra.edu', 'female', '1942-05-17', 37631);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (791, 'Rana', 'Abramzon', 'r.abramzon@libra.edu', 'female', '2009-03-16', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (792, 'Frayda', 'Putten', 'f.putten@libra.edu', 'female', '1998-10-02', 37668);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (793, 'Randene', 'McCuaig', 'r.mccuaig@libra.edu', 'female', '1959-01-03', 38045);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (794, 'Ingrim', 'Robjohns', 'i.robjohns@libra.edu', 'male', '1999-12-02', 38197);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (795, 'Jean', 'Peaseman', 'j.peaseman@libra.edu', 'female', '1964-04-10', 37357);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (796, 'Hadrian', 'Statham', 'h.statham@libra.edu', 'male', '1998-02-02', 35475);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (797, 'Griselda', 'Stoffers', 'g.stoffers@libra.edu', 'female', '1984-02-01', 37038);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (798, 'Myrilla', 'Joseff', 'm.joseff@libra.edu', 'female', '1992-08-03', 37358);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (799, 'Burtie', 'Dunphie', 'b.dunphie@libra.edu', 'male', '2001-02-18', 37986);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (800, 'Anastasia', 'Jozsef', 'a.jozsef@libra.edu', 'female', '1970-01-25', 36849);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (801, 'Valerie', 'Lorait', 'v.lorait@libra.edu', 'female', '1942-12-28', 35514);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (802, 'Levey', 'Cameron', 'l.cameron@libra.edu', 'male', '1934-05-14', 35672);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (803, 'Graehme', 'Patroni', 'g.patroni@libra.edu', 'male', '1945-04-02', 38044);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (804, 'Cora', 'Velasquez', 'c.velasquez@libra.edu', 'female', '1971-09-09', 38186);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (805, 'Nicole', 'Milkins', 'n.milkins@libra.edu', 'female', '1995-07-13', 36495);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (806, 'Lila', 'Klaaassen', 'l.klaaassen@libra.edu', 'female', '1991-04-24', 37555);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (807, 'Elwira', 'Roman', 'e.roman@libra.edu', 'female', '1993-09-15', 36467);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (808, 'Birch', 'Keaveney', 'b.keaveney@libra.edu', 'male', '1983-01-16', 35864);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (809, 'Andriette', 'Magor', 'a.magor@libra.edu', 'female', '1977-01-01', 37796);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (810, 'Noami', 'Trudgian', 'n.trudgian@libra.edu', 'female', '1991-04-16', 35721);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (811, 'Renell', 'Maywood', 'r.maywood@libra.edu', 'female', '1951-03-15', 37633);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (812, 'Thain', 'Cockrell', 't.cockrell@libra.edu', 'male', '1995-12-15', 36670);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (813, 'Janaye', 'Tackle', 'j.tackle@libra.edu', null, '1976-06-22', 37341);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (814, 'Jabez', 'Flacke', 'j.flacke@libra.edu', 'male', '1941-05-11', 35838);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (815, 'Gaylene', 'Switsur', 'g.switsur@libra.edu', 'female', '2005-11-04', 36478);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (816, 'Maison', 'McDuff', 'm.mcduff@libra.edu', 'male', '1989-05-06', 36630);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (817, 'Taber', 'Glencrosche', 't.glencrosche@libra.edu', 'male', '1995-06-21', 35792);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (818, 'Roger', 'Olland', 'r.olland@libra.edu', 'male', '1963-09-09', 38208);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (819, 'Rosabelle', 'Rimell', 'r.rimell@libra.edu', 'female', '1963-02-14', 36247);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (820, 'Carr', 'Whartonby', 'c.whartonby@libra.edu', 'male', '1973-01-23', 37441);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (821, 'Erick', 'Heintzsch', 'e.heintzsch@libra.edu', 'male', '1994-09-19', 37785);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (822, 'Elset', 'Forsaith', 'e.forsaith@libra.edu', 'female', '1939-12-07', 38182);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (823, 'Ricardo', 'Jacobsohn', 'r.jacobsohn@libra.edu', 'male', '1960-02-08', 37777);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (824, 'Baxter', 'Halwill', 'b.halwill@libra.edu', 'male', '1967-06-10', 37656);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (825, 'Francesco', 'Winsbury', 'f.winsbury@libra.edu', null, '1975-10-08', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (826, 'Tessy', 'Deluce', 't.deluce@libra.edu', 'female', '1941-06-08', 38179);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (827, 'Raviv', 'Bowser', 'r.bowser@libra.edu', 'male', '1936-09-18', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (828, 'Jillane', 'Brugsma', 'j.brugsma@libra.edu', 'female', '1940-05-03', 37929);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (829, 'Wilek', 'Sowle', 'w.sowle@libra.edu', 'male', '1988-11-05', 35622);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (830, 'Briana', 'Mauro', 'b.mauro@libra.edu', 'female', '1986-11-06', 37765);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (831, 'Benyamin', 'Sutton', 'b.sutton@libra.edu', 'male', '1937-07-08', 35956);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (832, 'Shina', 'Laxtonne', 's.laxtonne@libra.edu', 'female', '1944-01-25', 35631);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (833, 'Annabell', 'Feldhuhn', 'a.feldhuhn@libra.edu', 'female', '1993-08-12', 37808);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (834, 'Kiley', 'Benaine', 'k.benaine@libra.edu', null, '1998-05-27', 37022);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (836, 'Selby', 'Swoffer', 's.swoffer@libra.edu', 'male', '1961-04-08', 36126);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (837, 'Alric', 'Andrelli', 'a.andrelli@libra.edu', 'male', '1987-04-17', 36944);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (838, 'Seth', 'Kraft', 's.kraft@libra.edu', 'male', '1946-06-21', 38213);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (839, 'Allyn', 'Juschka', 'a.juschka@libra.edu', 'female', '1937-01-28', 35411);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (840, 'Davey', 'Sturdy', 'd.sturdy@libra.edu', 'male', '1977-05-07', 37458);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (841, 'Tova', 'Dixsee', 't.dixsee@libra.edu', 'female', '1993-04-26', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (842, 'Kimmy', 'Alvarez', 'k.alvarez@libra.edu', null, '1996-02-05', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (843, 'Lesya', 'De Lascy', 'l.de_lascy@libra.edu', 'female', '1978-11-04', 38177);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (844, 'Giuseppe', 'Longhorn', 'g.longhorn@libra.edu', 'male', '2007-12-11', 37224);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (845, 'Quinn', 'Sinkins', 'q.sinkins@libra.edu', 'female', '2009-04-05', 35850);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (846, 'Craggie', 'Kharchinski', 'c.kharchinski@libra.edu', 'male', '1990-11-23', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (847, 'Damiano', 'Dowd', 'd.dowd@libra.edu', 'male', '1945-04-20', 37165);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (848, 'Franklin', 'Finder', 'f.finder@libra.edu', 'male', '2007-01-01', 36347);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (849, 'Forbes', 'Heijnen', 'f.heijnen@libra.edu', 'male', '1990-08-02', 36978);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (850, 'Avie', 'Prichet', 'a.prichet@libra.edu', 'female', '1951-08-29', 35955);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (851, 'Ophelie', 'Christopherson', 'o.christopherson@libra.edu', 'female', '1994-08-08', 38138);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (852, 'Haslett', 'Brunskill', 'h.brunskill@libra.edu', 'male', '1930-01-30', 37880);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (853, 'Cullin', 'Southon', 'c.southon@libra.edu', 'male', '1977-04-05', 36839);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (854, 'Sonny', 'Storrie', 's.storrie@libra.edu', 'male', '1939-09-06', 36953);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (855, 'Mikkel', 'Furmenger', 'm.furmenger@libra.edu', 'male', '1977-10-22', 35979);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (856, 'Barnard', 'Tuckett', 'b.tuckett@libra.edu', 'male', '1954-11-25', 35726);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (857, 'Dyann', 'Gillan', 'd.gillan@libra.edu', 'female', '1934-08-16', 37172);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (858, 'Brittany', 'Sproule', 'b.sproule@libra.edu', 'female', '2006-04-18', 35712);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (859, 'Conchita', 'Geillier', 'c.geillier@libra.edu', 'female', '1993-01-07', 36510);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (860, 'Haven', 'Exell', 'h.exell@libra.edu', 'male', '1972-10-04', 37670);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (861, 'Shellysheldon', 'Elkin', 's.elkin@libra.edu', 'male', '1985-12-06', 38133);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (862, 'Biddie', 'Vasyutochkin', 'b.vasyutochkin@libra.edu', 'female', '1998-01-27', 37409);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (863, 'Leyla', 'Autry', 'l.autry@libra.edu', 'female', '1983-04-01', 37320);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (864, 'April', 'Valett', 'a.valett@libra.edu', 'female', '1974-03-14', 38282);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (865, 'Merrilee', 'Kenzie', 'm.kenzie@libra.edu', 'female', '1940-09-25', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (866, 'Hughie', 'Mc Queen', 'h.mc_queen@libra.edu', 'male', '1977-03-23', 35548);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (867, 'Annmaria', 'Fazzioli', 'a.fazzioli@libra.edu', 'female', '1950-04-26', 36084);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (868, 'Dorita', 'Shillom', 'd.shillom@libra.edu', 'female', '1993-08-25', 37072);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (869, 'Cam', 'Delgado', 'c.delgado@libra.edu', 'male', '1954-03-20', 35372);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (870, 'Saree', 'Skrzynski', 's.skrzynski@libra.edu', 'female', '1996-03-13', 37944);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (871, 'Kimmi', 'Cockroft', 'k.cockroft@libra.edu', 'female', '1966-06-13', 36734);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (872, 'Weber', 'Pocknoll', 'w.pocknoll@libra.edu', null, '1948-02-22', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (873, 'Rubia', 'Burnip', 'r.burnip@libra.edu', 'female', '1931-07-10', 37731);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (874, 'Boniface', 'Perillo', 'b.perillo@libra.edu', 'male', '1974-07-10', 36553);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (875, 'Eal', 'Bampton', 'e.bampton@libra.edu', 'male', '1974-05-24', 35988);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (876, 'Rosanne', 'Brazier', 'r.brazier@libra.edu', 'female', '1949-09-24', 38108);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (877, 'Alejandra', 'Buckleigh', 'a.buckleigh@libra.edu', 'female', '1980-08-31', 37090);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (878, 'Sybille', 'Garbert', 's.garbert@libra.edu', 'female', '2006-06-30', 35672);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (879, 'Estevan', 'Goodnow', 'e.goodnow@libra.edu', 'male', '1934-08-10', 37213);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (880, 'Davide', 'Patzelt', 'd.patzelt@libra.edu', 'male', '1968-01-13', 38160);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (881, 'Hadleigh', 'Querrard', 'h.querrard@libra.edu', null, '1985-07-14', 36940);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (882, 'Zollie', 'Jevon', 'z.jevon@libra.edu', 'male', '1980-08-22', 37428);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (883, 'Elliott', 'Messam', 'e.messam@libra.edu', 'male', '1964-02-17', 38189);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (884, 'Juliet', 'Tremmil', 'j.tremmil@libra.edu', 'female', '1987-03-19', 36277);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (885, 'Betteanne', 'Brislane', 'b.brislane@libra.edu', 'female', '1968-07-04', 36985);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (886, 'Caspar', 'O''Hannay', 'c.o''hannay@libra.edu', 'male', '1950-01-06', 38216);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (887, 'Jarrod', 'Stocken', 'j.stocken@libra.edu', 'male', '1935-09-02', 38201);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (888, 'Winfield', 'Collop', 'w.collop@libra.edu', 'male', '1965-08-04', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (889, 'Tobye', 'Antoni', 't.antoni@libra.edu', 'female', '1991-04-26', 37410);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (890, 'Sherlock', 'Buttriss', 's.buttriss@libra.edu', 'male', '1987-01-29', 36405);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (891, 'Marthena', 'Wolfe', 'm.wolfe@libra.edu', 'female', '1981-07-29', 35791);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (892, 'Imogen', 'Goulborn', 'i.goulborn@libra.edu', 'female', '1950-07-17', 35380);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (893, 'Desmond', 'Petera', 'd.petera@libra.edu', 'male', '1965-05-09', 36955);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (894, 'Yard', 'Denacamp', 'y.denacamp@libra.edu', 'male', '1936-02-03', 37937);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (895, 'Kristian', 'Gildersleaves', 'k.gildersleaves@libra.edu', 'male', '1982-10-27', 37966);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (896, 'Ulrick', 'Watchorn', 'u.watchorn@libra.edu', 'male', '1930-03-28', 35711);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (897, 'Bendick', 'Shurey', 'b.shurey@libra.edu', 'male', '1970-07-04', 37960);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (898, 'Jilli', 'Howat', 'j.howat@libra.edu', 'female', '1971-07-18', 36270);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (899, 'Elizabeth', 'Pelosi', 'e.pelosi@libra.edu', null, '1971-08-24', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (900, 'Rozina', 'Mazzilli', 'r.mazzilli@libra.edu', null, '1936-12-17', 35391);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (901, 'Sibby', 'Mewe', 's.mewe@libra.edu', 'female', '1944-12-18', 37242);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (902, 'Corri', 'Moncreif', 'c.moncreif@libra.edu', 'female', '1932-10-01', 36296);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (903, 'Clarance', 'Candwell', 'c.candwell@libra.edu', 'male', '1985-02-06', 36073);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (904, 'Gothart', 'Banville', 'g.banville@libra.edu', 'male', '1939-01-01', 37406);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (905, 'Kenny', 'Blind', 'k.blind@libra.edu', 'male', '1992-04-22', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (906, 'Urbain', 'Camacho', 'u.camacho@libra.edu', 'male', '1962-09-20', 36120);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (907, 'Slade', 'Gorstidge', 's.gorstidge@libra.edu', 'male', '1977-11-23', 35423);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (908, 'Dyann', 'Sea', 'd.sea@libra.edu', 'female', '1959-06-18', 38032);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (909, 'Blaire', 'Antoniewski', 'b.antoniewski@libra.edu', 'female', '1966-04-18', 37174);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (910, 'Maureen', 'McAline', 'm.mcaline@libra.edu', 'female', '1941-03-24', 35672);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (911, 'Nikos', 'Beckers', 'n.beckers@libra.edu', 'male', '1944-08-08', 37651);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (912, 'Town', 'Rawcliff', 't.rawcliff@libra.edu', 'male', '1965-11-02', 37034);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (913, 'Cully', 'Fromont', 'c.fromont@libra.edu', 'male', '1982-06-26', 37312);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (914, 'Evin', 'Duny', 'e.duny@libra.edu', 'male', '1962-12-15', 35901);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (915, 'Cicely', 'Allgood', 'c.allgood@libra.edu', 'female', '1940-05-02', 37979);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (916, 'Angelica', 'Zealy', 'a.zealy@libra.edu', 'female', '1963-10-19', 36354);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (917, 'Xylia', 'Iannitti', 'x.iannitti@libra.edu', 'female', '1984-10-26', 35471);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (918, 'Kimble', 'Domm', 'k.domm@libra.edu', 'male', '2004-03-23', 35676);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (919, 'Gil', 'Mallock', 'g.mallock@libra.edu', 'male', '1981-05-20', 36038);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (920, 'Rhodia', 'Duell', 'r.duell@libra.edu', 'female', '1959-03-27', 35363);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (921, 'Aldon', 'Clipston', 'a.clipston@libra.edu', 'male', '1970-05-18', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (922, 'Gerrie', 'Carrell', 'g.carrell@libra.edu', 'male', '1984-10-31', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (923, 'Rana', 'Deverale', 'r.deverale@libra.edu', 'female', '1998-10-23', 35743);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (924, 'Frans', 'Bewfield', 'f.bewfield@libra.edu', 'male', '1933-08-27', 36053);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (925, 'Olenka', 'Meus', 'o.meus@libra.edu', 'female', '1936-12-27', 36952);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (926, 'Kylie', 'Kneaphsey', 'k.kneaphsey@libra.edu', 'male', '1977-06-05', 36334);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (927, 'Quill', 'Kilday', 'q.kilday@libra.edu', 'male', '1941-04-27', 36141);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (928, 'Ignacius', 'Meadows', 'i.meadows@libra.edu', 'male', '1980-05-16', 36992);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (929, 'Zebulon', 'MacGorman', 'z.macgorman@libra.edu', 'male', '1998-09-19', 37844);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (930, 'Jaine', 'Marginson', 'j.marginson@libra.edu', 'female', '1952-12-27', 36476);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (931, 'Verene', 'Ibell', 'v.ibell@libra.edu', 'female', '1991-11-23', 37591);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (932, 'Willis', 'Peschet', 'w.peschet@libra.edu', 'male', '1942-06-13', 37095);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (933, 'De', 'Perot', 'd.perot@libra.edu', 'female', '1940-02-08', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (934, 'Nichols', 'Shaul', 'n.shaul@libra.edu', 'male', '1949-10-28', 36294);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (935, 'Roseline', 'Wornum', 'r.wornum@libra.edu', null, '1939-04-28', 35943);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (936, 'Camila', 'Stockton', 'c.stockton@libra.edu', 'female', '1986-03-18', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (937, 'Baird', 'Codron', 'b.codron@libra.edu', 'male', '1997-10-11', 37438);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (938, 'Lelia', 'Leisk', 'l.leisk@libra.edu', 'female', '2009-08-26', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (939, 'Jemima', 'Huffer', 'j.huffer@libra.edu', 'female', '1982-04-26', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (940, 'Brynn', 'Attryde', 'b.attryde@libra.edu', 'female', '1995-10-27', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (941, 'Salmon', 'Gazey', 's.gazey@libra.edu', 'male', '1995-03-16', 37543);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (942, 'Patrica', 'Grono', 'p.grono@libra.edu', 'female', '1963-02-22', 37246);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (943, 'Esme', 'Mingard', 'e.mingard@libra.edu', 'male', '1969-08-16', 36686);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (944, 'Frasier', 'Bonifas', 'f.bonifas@libra.edu', 'male', '1948-12-30', 38178);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (945, 'Jacquie', 'Barnbrook', 'j.barnbrook@libra.edu', 'female', '1977-07-04', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (946, 'Effie', 'Woolstenholmes', 'e.woolstenholmes@libra.edu', 'female', '1977-10-09', 36218);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (947, 'Meggie', 'Gallardo', 'm.gallardo@libra.edu', 'female', '2002-01-12', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (948, 'Lise', 'Fardy', 'l.fardy@libra.edu', 'female', '1947-09-17', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (949, 'Putnam', 'Livermore', 'p.livermore@libra.edu', 'male', '1959-11-09', 37478);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (950, 'Garold', 'Baynard', 'g.baynard@libra.edu', 'male', '1964-02-10', 36914);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (951, 'Jereme', 'Kisbee', 'j.kisbee@libra.edu', 'male', '1945-03-11', 35391);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (952, 'Tiffani', 'Balling', 't.balling@libra.edu', 'female', '1994-03-26', 36757);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (953, 'Isak', 'Aasaf', 'i.aasaf@libra.edu', 'male', '1937-10-06', 36106);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (954, 'Corney', 'Vader', 'c.vader@libra.edu', 'male', '1930-07-08', 35670);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (955, 'Beniamino', 'Kiely', 'b.kiely@libra.edu', 'male', '2007-06-26', 37704);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (956, 'Sheppard', 'Scatchar', 's.scatchar@libra.edu', 'male', '1966-04-29', 36001);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (957, 'Carmela', 'Lax', 'c.lax@libra.edu', 'female', '2007-08-25', 37996);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (958, 'Lilias', 'Yitzowitz', 'l.yitzowitz@libra.edu', 'female', '1987-04-07', 37649);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (959, 'Sheelagh', 'Bonnick', 's.bonnick@libra.edu', 'female', '1970-08-19', 36982);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (960, 'Cristine', 'Gravell', 'c.gravell@libra.edu', 'female', '1977-08-03', 36369);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (961, 'Gav', 'Keneforde', 'g.keneforde@libra.edu', 'male', '1945-10-27', 37035);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (962, 'Geno', 'De Bruin', 'g.de_bruin@libra.edu', 'male', '1961-08-13', 36858);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (963, 'Cathie', 'Broschke', 'c.broschke@libra.edu', 'female', '1936-08-12', 36755);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (964, 'Mabel', 'MacAdam', 'm.macadam@libra.edu', 'female', '1947-04-12', 36518);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (965, 'Datha', 'Roo', 'd.roo@libra.edu', 'female', '1977-06-05', 37605);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (966, 'Cy', 'Patey', 'c.patey@libra.edu', 'male', '1946-08-07', 36186);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (967, 'Maris', 'Erratt', 'm.erratt@libra.edu', 'female', '2006-03-02', 37971);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (968, 'Ariadne', 'MacNaughton', 'a.macnaughton@libra.edu', 'female', '1954-09-14', 37040);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (969, 'Yorgos', 'Attersoll', 'y.attersoll@libra.edu', 'male', '1941-12-05', 38186);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (970, 'Rowe', 'Phipard-Shears', 'r.phipard-shears@libra.edu', 'female', '2006-06-26', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (971, 'Staffard', 'Orrick', 's.orrick@libra.edu', 'male', '1951-11-06', 37247);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (972, 'Lianne', 'Tinman', 'l.tinman@libra.edu', 'female', '1992-04-20', 36540);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (973, 'Lindie', 'Bente', 'l.bente@libra.edu', 'female', '1937-02-23', 37300);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (974, 'Kendre', 'Engelmann', 'k.engelmann@libra.edu', 'female', '1952-06-13', 36600);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (975, 'Thelma', 'Claybourn', 't.claybourn@libra.edu', 'female', '1946-03-11', 37970);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (976, 'Peggy', 'Etchells', 'p.etchells@libra.edu', 'female', '1984-02-11', 35806);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (977, 'Louisette', 'Dorkens', 'l.dorkens@libra.edu', 'female', '1975-05-03', 36344);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (978, 'Obediah', 'Woolbrook', 'o.woolbrook@libra.edu', 'male', '1988-05-16', 37275);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (979, 'Tanney', 'Copozio', 't.copozio@libra.edu', 'male', '1991-07-08', 35749);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (980, 'Adler', 'Searson', 'a.searson@libra.edu', 'male', '1940-05-09', 36566);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (981, 'Terry', 'Norledge', 't.norledge@libra.edu', 'male', '1973-01-04', 36342);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (982, 'Daniele', 'McAusland', 'd.mcausland@libra.edu', 'female', '1938-08-06', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (983, 'Danyelle', 'Melly', 'd.melly@libra.edu', 'female', '1989-01-17', 35424);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (984, 'Alexis', 'Humpage', 'a.humpage@libra.edu', 'male', '1975-06-22', 36563);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (985, 'Fonzie', 'Shewan', 'f.shewan@libra.edu', 'male', '1990-03-04', 37672);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (986, 'Karly', 'Sibbson', 'k.sibbson@libra.edu', 'female', '1964-03-11', 35766);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (987, 'Kalil', 'Chatin', 'k.chatin@libra.edu', 'male', '1980-06-13', 35743);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (988, 'Vanessa', 'Castanho', 'v.castanho@libra.edu', 'female', '1933-08-26', null);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (989, 'Galvin', 'Ellins', 'g.ellins@libra.edu', null, '1953-08-05', 36140);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (990, 'Con', 'Wakelam', 'c.wakelam@libra.edu', 'female', '1956-09-01', 37405);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (991, 'Matty', 'Lethby', 'm.lethby@libra.edu', 'male', '1974-12-20', 36545);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (992, 'Susanne', 'Yakutin', 's.yakutin@libra.edu', 'female', '1970-05-28', 36441);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (993, 'Wheeler', 'Beenham', 'w.beenham@libra.edu', 'male', '1996-01-16', 37276);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (994, 'Hetty', 'Dana', 'h.dana@libra.edu', 'female', '1977-03-03', 37325);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (995, 'Dominic', 'Breyt', 'd.breyt@libra.edu', null, '1933-02-21', 35287);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (996, 'Willie', 'Screase', 'w.screase@libra.edu', 'male', '1969-09-11', 37545);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (997, 'Sydney', 'Ede', 's.ede@libra.edu', null, '1953-05-13', 35669);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (998, 'Naoma', 'Swinford', 'n.swinford@libra.edu', 'female', '1960-07-08', 36916);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (999, 'Isak', 'Carreck', 'i.carreck@libra.edu', 'male', '1971-06-14', 37934);
insert into profile (id, first_name, last_name, email, gender, birth_date, home_zip) values (1000, 'Carmelita', 'Wesson', 'c.wesson@libra.edu', 'female', '2004-06-22', 36786);


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


insert into staff (id, profile_id, office, active, hire_date, salary) values (1, 152, 'bursar', true, '2010-11-26', '80000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (2, 131, 'accounting', false, '2010-11-06', '54000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (3, 168, 'legal', true, '2010-03-02', '72000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (4, 145, 'scholarships', true, '2011-07-10', '80000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (5, 193, 'registrar', true, '2003-10-08', '128000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (6, 199, 'admissions', true, '2005-06-04', '124000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (7, 180, 'administration', true, '2006-08-06', '163000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (8, 172, 'bursar', true, '2006-03-25', '42000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (9, 176, 'accounting', true, '2009-08-11', '128000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (10, 161, 'legal', false, '2012-10-14', '90000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (11, 122, 'scholarships', true, '2003-01-05', '47000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (12, 147, 'registrar', true, '2004-04-01', '122000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (13, 160, 'admissions', true, '2004-07-12', '74000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (14, 159, 'administration', true, '2009-08-29', '131000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (15, 157, 'bursar', true, '2013-03-13', '50000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (16, 179, 'accounting', true, '2004-06-20', '54000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (17, 170, 'legal', true, '2012-11-16', '69000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (18, 158, 'scholarships', false, '2005-05-04', '121000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (19, 155, 'registrar', false, '2010-02-18', '44000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (20, 177, 'admissions', false, '2009-10-01', '103000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (21, 141, 'administration', true, '2008-11-22', '169000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (22, 189, 'bursar', true, '2004-11-22', '109000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (23, 146, 'accounting', true, '2009-07-16', '45000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (24, 167, 'legal', false, '2006-04-08', '85000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (25, 124, 'scholarships', true, '2013-04-09', '91000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (26, 143, 'registrar', true, '2005-04-20', '81000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (27, 132, 'admissions', true, '2009-08-03', '127000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (28, 196, 'administration', true, '2003-02-06', '98000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (29, 149, 'bursar', true, '2008-11-13', '62000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (30, 198, 'accounting', false, '2012-03-27', '92000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (31, 169, 'legal', true, '2005-11-28', '70000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (32, 121, 'scholarships', true, '2007-09-20', '54000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (33, 171, 'registrar', true, '2007-10-17', '43000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (34, 183, 'admissions', true, '2008-07-14', '71000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (35, 139, 'administration', true, '2010-10-18', '205000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (36, 192, 'bursar', true, '2007-01-07', '98000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (37, 135, 'accounting', true, '2006-12-21', '110000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (38, 138, 'legal', true, '2010-04-29', '75000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (39, 134, 'scholarships', true, '2009-04-10', '55000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (40, 133, 'registrar', true, '2008-09-21', '66000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (41, 130, 'admissions', true, '2011-11-23', '123000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (42, 184, 'administration', true, '2004-11-05', '95000.00');
insert into staff (id, profile_id, office, active, hire_date, salary) values (43, 187, 'bursar', true, '2005-11-20', '41000.00');
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
    (313, 204, 27, 82.55, 1), -- MATH 102 - Calculus I
    (314, 110, 27, 91.23, 3), -- LA 102 - Success at Libra University
    -- SPRING 2014 - Semester 2
    (315, 208, 27, 94.56, 0), -- MATH 212 - Calculus II
    (316, 126, 27, 82.48, 0), -- LA 212 - Ancient Religions and Philosophies
    -- FALL 2014 - Semester 3
    (317, 213, 27, 91.24, 0), -- MATH 242 - Discrete Mathematics
    (318, 123, 27, 95.32, 0), -- LA 145 - Nations and Nationalism
    -- SPRING 2015 - Semester 4
    (319, 217, 27, 80.13, 0), -- MATH 292 - Calculus III
    (320, 135, 27, 70.87, 1), -- LA 248 - Palestinian-Israeli Relations
    -- FALL 2015 - Semester 5
    (321, 222, 27, 79.83, 4), -- MATH 320 - Computational Linear Algebra
    (322, 140, 27, 82.54, 1), -- LA 323 - International Human Rights
    -- SPRING 2016 - Semester 6
    (323, 226, 27, 82.83, 3), -- MATH 422 - Differential Equations I
    (324, 244, 27, 84.10, 2), -- MATH 445 - Distributed Algorithms
    -- FALL 2016 - Semester 7
    (325, 231, 27, 90.91, 2), -- MATH 489 - Abstract Algebra I
    (326, 241, 27, 91.48, 1), -- MATH 382 - Analysis I
    (327, 158, 27, 92.30, 2), -- LA 311 - Theory of Knowledge
    -- SPRING 2017 - Semester 8
    (328, 254, 27, 94.23, 0), -- MATH 532 - Geometric Combinatorics
    (329, 236, 27, 99.66, 0); -- MATH 341 - Integral Equations
