CREATE DATABASE assignment5;
\c assignment5

CREATE TABLE Person(
username TEXT PRIMARY KEY,
number TEXT ,
address TEXT NOT NULL);

CREATE TABLE Pet(
firstname TEXT PRIMARY KEY, 
lastname TEXT ,
birthdate TEXT NOT NULL,
owner TEXT NOT NULL REFERENCES Person(username),
seller TEXT REFERENCES Person(username)
); 

CREATE TABLE Dog(
firstname TEXT PRIMARY KEY REFERENCES Pet(firstname),
lastname TEXT ,
breed TEXT NOT NULL
);

CREATE TABLE Snake(
firstname TEXT PRIMARY KEY REFERENCES Pet(firstname),
lastname TEXT ,
venom TEXT NOT NULL
);

CREATE TABLE Barked_At(
dog TEXT REFERENCES Dog(firstname),
snake TEXT REFERENCES Snake(firstname)
);

CREATE TABLE Play_Friend(
firstname1 TEXT REFERENCES Pet(firstname),
lastname1 TEXT ,
firstname2 TEXT REFERENCES Pet(firstname),
lastname2 TEXT ,
since TEXT NOT NULL
); 

\c postgres
DROP DATABASE assignment5;