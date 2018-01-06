CREATE DATABASE libra_university OWNER nilesbrandon;
\c libra_university;

CREATE TABLE auth_user (
  id          serial PRIMARY KEY,
  email       varchar(40) UNIQUE,
  first_name  varchar(20),
  last_name   varchar(20)
);

CREATE TABLE professor (
  id          SERIAL PRIMARY KEY,
  auth_user_id     INTEGER REFERENCES auth_user (id),
  tenure      BOOLEAN
);

INSERT INTO auth_user (email, first_name, last_name) VALUES ('gregl@libra.com', 'Greg', 'Landolm');
INSERT INTO auth_user (email, first_name, last_name) VALUES ('maddieh@libra.com', 'Maddie', 'Hong');
INSERT INTO auth_user (email, first_name, last_name) VALUES ('test@libra.com', 'Testing', 'Account');


INSERT INTO professor (auth_user_id, tenure) values ((SELECT id FROM auth_user WHERE email = 'maddieh@libra.com'), FALSE);
INSERT INTO professor (auth_user_id, tenure) values ((SELECT id FROM auth_user WHERE email = 'test@libra.com'), TRUE);
