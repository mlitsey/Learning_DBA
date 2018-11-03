CREATE TABLE celebs (
   id INTEGER, 
   name TEXT, 
   age INTEGER
);

INSERT INTO celebs (id, name, age) 
VALUES (1, 'Justin Bieber', 21);

INSERT INTO celebs (id, name, age) 
VALUES (2, 'Beyonce Knowles', 33); 

INSERT INTO celebs (id, name, age) 
VALUES (3, 'Jeremy Lin', 26); 

INSERT INTO celebs (id, name, age) 
VALUES (4, 'Taylor Swift', 26);

SELECT name FROM celebs;

UPDATE celebs
SET age = 22
WHERE id = 1;

ALTER TABLE celebs 
ADD COLUMN twitter_handle TEXT;

DELETE FROM celebs 
WHERE twitter_handle IS NULL;

CREATE TABLE celebs (
   id INTEGER PRIMARY KEY, 
   name TEXT UNIQUE,
   date_of_birth TEXT NOT NULL,
   date_of_death TEXT DEFAULT 'Not Applicable',
);


PROJECT

create table friends (
id integer,
name text,
birthday date
);

INSERT INTO friends (id, name, birthday) 
VALUES (1, 'Jane Doe', '1990-05-30'); 

select * from friends;

INSERT INTO friends (id, name, birthday) 
VALUES (2, 'Russell Hack', '1977-06-24'); 

INSERT INTO friends (id, name, birthday) 
VALUES (3, 'Julie Litsey', '1981-09-26'); 

select * from friends;

UPDATE friends
SET name = 'Jane Smith'
WHERE id = 1;

select * from friends;

ALTER TABLE friends 
ADD COLUMN email TEXT;

UPDATE friends
SET email = 'jane@codecademy.com'
WHERE id = 1;

UPDATE friends
SET email = 'Russell@codecademy.com'
WHERE id = 2;

UPDATE friends
SET email = 'Julie@codecademy.com'
WHERE id = 3;

select * from friends;

DELETE FROM friends 
WHERE name IS 'Jane Smith';

select * from friends;