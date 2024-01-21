-- SQL Script for Assignment 4

-- Creating database with full name

CREATE DATABASE d321dvgassignment4;


-- Connecting to database 
\c d321dvgassignment4


-- Domains

CREATE TABLE P(p text);
CREATE TABLE C(c text);
CREATE TABLE M(m text);

INSERT INTO P VALUES
 ('Emma'),
 ('Eric'),
 ('Vidya'),
 ('Anna'),
 ('YinYue'),
 ('Latha'),
 ('Qin'),
 ('Ryan'),
 ('Deepa'),
 ('Hasan'),
 ('Linda'),
 ('Chris'),
 ('Lisa'),
 ('Nick'),
 ('Arif'),
 ('Megan'),
 ('Margaret'),
 ('Jean'),
 ('John'),
 ('Danielle');

INSERT INTO C VALUES
 ('AI'),
 ('DataScience'),
 ('Algorithms'),
 ('Complexity'),
 ('Networks'),
 ('Databases'),
 ('Logic'),
 ('Programming'),
 ('Physics'),
 ('D321');

INSERT INTO M VALUES
 ('DataScience'),
 ('Math'),
 ('English'),
 ('Physics'),
 ('CS'),
 ('Chemistry'),
 ('Philosophy');

-- Unary Predicates

CREATE TABLE Professor(p text);
CREATE TABLE Student(p text);


INSERT INTO Professor VALUES
 ('Jean'),
 ('Arif'),
 ('Eric'),
 ('Pedro'),
 ('Emma'),
 ('Anna');


INSERT INTO Student VALUES
 ('YinYue'),
 ('Lisa'),
 ('Margaret'),
 ('Hasan'),
 ('Deepa'),
 ('Megan'),
 ('Chris'),
 ('Linda'),
 ('Latha'),
 ('Nick'),
 ('Vidya'),
 ('Danielle'),
 ('Qin'),
 ('Ryan'),
 ('John');

-- Binary Predicates

CREATE TABLE Enroll (p text,
                     c text);

CREATE TABLE Teaches (p text,
                      c text);

CREATE TABLE hasMajor (p text,
                       m text);


CREATE TABLE Knows(p1 text,
                   p2 text);


INSERT INTO Enroll VALUES 
 ('Nick','Logic'),
 ('Hasan','Logic'),
 ('Eric','Complexity'),
 ('Vidya','DataScience'),
 ('Jean','Physics'),
 ('Deepa','Complexity'),
 ('Megan','AI'),
 ('Vidya','AI'),
 ('Hasan','Databases'),
 ('Deepa','D321'),
 ('Deepa','D321'),
 ('Anna','Physics'),
 ('Danielle','D321'),
 ('Emma','Complexity'),
 ('Hasan','Physics'),
 ('Nick','Programming'),
 ('Jean','AI'),
 ('Anna','D321'),
 ('John','Logic'),
 ('Jean','Logic'),
 ('Lisa','Physics'),
 ('Jean','DataScience'),
 ('Hasan','Networks'),
 ('Jean','Complexity'),
 ('YinYue','AI'),
 ('John','AI'),
 ('Chris','DataScience'),
 ('Margaret','Logic'),
 ('Latha','Physics'),
 ('Jean','Networks'),
 ('Qin','Complexity'),
 ('Latha','Logic'),
 ('Deepa','Physics'),
 ('Linda','Networks'),
 ('Anna','Databases'),
 ('Margaret','AI'),
 ('Linda','Logic'),
 ('Jean','Programming'),
 ('Qin','Networks'),
 ('Eric','Logic'),
 ('Ryan','DataScience'),
 ('Latha','Networks'),
 ('Deepa','Programming'),
 ('Nick','DataScience'),
 ('Ryan','D321'),
 ('Anna','DataScience'),
 ('Latha','D321'),
 ('Chris','Programming'),
 ('Vidya','Complexity'),
 ('Arif','Programming'),
 ('Emma','Programming'),
 ('Margaret','Complexity'),
 ('Eric','D321'),          
 ('Margaret','Algorithms'),
 ('Hasan', 'Algorithms'),
 ('Hasan', 'AI');

INSERT INTO Teaches VALUES
 ('Jean','Databases'),
 ('Emma','Networks'),
 ('Eric','Databases'),
 ('Eric','D321'),
 ('Emma','Algorithms'),
 ('Pedro','AI'),
 ('Emma','Complexity'),
 ('Anna','Complexity'),
 ('Jean','Logic'),
 ('Arif','Networks'),
 ('Emma','Logic'),
 ('Anna','AI'),
 ('Eric','Logic'),
 ('Anna','D321'),
 ('Eric','AI'),
 ('Emma','Physics'),
 ('Eric','Networks'),
 ('Emma','DataScience'),
 ('Jean','D321');


INSERT INTO hasMajor VALUES
('Qin','Chemistry'),
 ('Danielle','Chemistry'),
 ('Megan','Chemistry'),
 ('John','Chemistry'),
 ('Lisa','English'),
 ('YinYue','Physics'),
 ('Margaret','English'),
 ('Latha','Math'),
 ('Deepa','English'),
 ('Nick','Chemistry'),
 ('Hasan','English'),
 ('Megan','DataScience'),
 ('John','English'),
 ('Danielle','Physics'),
 ('Latha','Chemistry'),
 ('Danielle','Math'),  
 ('Hasan','DataScience'),
 ('Margaret','Physics');



INSERT INTO Knows VALUES
 ('Jean','Megan'),
 ('Nick','Megan'),
 ('Margaret','Lisa'),
 ('Danielle','YinYue'),
 ('Eric','Megan'),
 ('Nick','Margaret'),
 ('Lisa','John'),
 ('Qin','Chris'),
 ('Vidya','Margaret'),
 ('Ryan','Emma'),
 ('Latha','Emma'),
 ('Hasan','Vidya'),
 ('Vidya','Anna'),
 ('Anna','Deepa'),
 ('Emma','Jean'),
 ('Deepa','Qin'),
 ('Megan','Deepa'),
 ('Danielle','Hasan'),
 ('Vidya','Latha'),
 ('Lisa','YinYue'),
 ('Anna','Linda'),
 ('Emma','Linda'),
 ('Hasan','Danielle'),
 ('Chris','Eric'),
 ('Ryan','Eric'),
 ('Qin','Qin'),
 ('YinYue','Emma'),
 ('Ryan','Hasan'),
 ('Megan','Eric'),
 ('Deepa','Linda'),
 ('Qin','YinYue'),
 ('Vidya','YinYue'),
 ('Eric','Qin'),
 ('Lisa','Jean'),
 ('Danielle','Nick'),
 ('Eric','Ryan'),
 ('Linda','John'),
 ('Lisa','Margaret'),
 ('Qin','Nick'),
 ('Ryan','Linda'),
 ('Chris','Lisa'),
 ('Chris','Anna'),
 ('Anna','Lisa'),
 ('Arif','Arif'),
 ('Nick','Qin'),
 ('Arif','Latha'),
 ('Margaret','Latha'),
 ('Anna','Arif'),
 ('Megan','Margaret'),
 ('Deepa','Hasan'),
 ('Arif','YinYue');


-- Boolean functions for unary predicates Student(p) and Professor(p)

create or replace function Student(p text) 
returns boolean as
$$
select p in (select * from Student);
$$ language sql;


create or replace function Professor(p text) 
returns boolean as
$$
select p in (select * from Professor);
$$ language sql;


-- Boolean functions for binary predicates Enroll(p,c), Teaches (p,c),
-- hasMajor(p,m), and Knows(p_1,p_2)


create or replace function Enroll(p text, c text)

returns boolean as
$$
select (p,c) in (select * from Enroll);
$$ language sql;



create or replace function Teaches(p text, c text)
returns boolean as
$$
select (p,c) in (select * from Teaches);
$$ language sql;



create or replace function hasMajor(p text, m text)
returns boolean as
$$
select (p,m) in (select * from hasMajor);
$$ language sql;



create or replace function Knows(p1 text, p2 text)
returns boolean as
$$
select (p1,p2) in (select * from Knows);
$$ language sql;


create or replace function Implies(P boolean, Q boolean)
returns boolean as
$$
select not P or Q;
$$ language sql;


create or replace function Iff(P boolean, Q boolean)
returns boolean as
$$
select (P and Q) or (not P and not Q);
$$ language sql;


\qecho 'Problem 5.a'
-- Some student knows a professor who teaches the ‘Databases’ course.

-- Your SQL code for this problem must go here

SELECT true = SOME(
    SELECT Student(Person1.p)
    AND true = SOME(
        SELECT Professor(Person2.p) 
        AND Knows(Person1.p,Person2.p) 
        AND Teaches(Person2.p, 'Databases')
        FROM P Person2) 
        FROM P Person1)
AS sentenceSatisfied;


-- SELECT true = SOME(
--     SELECT Student(Person1.p) 
--     FROM P Person1, P Person2
--     WHERE Knows(Person1.p, Person2.p)
--     AND Professor(Person2.p)
--     AND Teaches(Person2.p, 'Databases')
--     ) AS sentenceSatisfied;


\qecho 'Problem 6.a'
-- Each course taught by professor ‘Anna’ is taken by at least two
-- students.



-- Your SQL code for this problem must go here


SELECT true = ALL(SELECT Implies(Teaches('Anna', Course.c) AND Professor('Anna'),
     true = SOME(SELECT Student(Person1.p) AND Student(Person2.p) AND Person2.p <> Person1.p
            AND Enroll(Person1.p, Course.c) 
            AND Enroll(Person2.p, Course.c)
            FROM P Person1, P Person2))
            FROM C Course);

-- SELECT
--     true = ALL(
--         SELECT Implies(
--             Teaches('Anna',Course.c) 
--             AND Professor('Anna')
--             ,
--             --Teaches('Anna',Course.c) 
--             --AND Professor('Anna')
--             Person1.p <> Person2.p
--             AND Student(Person1.p) 
--             AND Student(Person2.p) 
--             AND Enroll(Person1.p, Course.c) 
--             AND Enroll(Person2.p, Course.c)
--         )
--         FROM C Course, P Person1, P Person2
--     )AS sentenceSatisfied;


-- SELECT 
--     true = ALL(SELECT Teaches('Anna',Course.c) AND Professor('Anna')
--         FROM C Course
--         WHERE Implies(Teaches('Anna',Course.c) AND Professor('Anna'),
--         SELECT true = SOME(SELECT Student(Person1.p) 
--             FROM P Person1, P Person2
--             WHERE (Person1.p <> Person2.p) 
--             AND Student(Person2.p) 
--             AND Enroll(Person1.p, Course.c) AND Enroll(Person2.p,Course.c)))
--     AS sentenceSatisfied;



-- SELECT
--     true = ALL(SELECT Teaches('Anna',Course.c)
--     AND Professor('Anna'))
--     FROM C Course;

\qecho 'Problem 7.a'
-- Find the majors of students who are enrolled in the course `Algorithms'

-- Your SQL code for this problem must go here

SELECT m 
FROM M
WHERE true = SOME(SELECT hasMajor(p,m) AND Enroll(p,'Algorithms') 
FROM P );


-- SELECT * FROM M Major 
-- WHERE (SELECT true = SOME(SELECT Student(Person.p)
--         FROM P Person 
--         WHERE Student(Person.p) AND Enroll(Person.p,'Algorithms')));

-- SELECT *
-- FROM M Major
-- WHERE (SELECT true = SOME(
--     SELECT Student(Person.p) 
--     FROM P Person
--     ));
-- WHERE Enroll(Person.p, 'Algorithms')
-- hasMajor(Person.p, Major.m) AND 



\qecho 'Problem 8.a'
-- Find each student who knows a student who takes a course taught by
-- professor ‘Emma’ or a course taught by professor ‘Arif' or by Professor 'Anna'.

-- Your SQL code for this problem must go here

SELECT p
FROM Student Person1
WHERE true = SOME(SELECT Knows(Person1.p, Person2.p) 
    AND (Teaches('Arif',Course.c) 
    OR Teaches('Anna',Course.c)
    OR Teaches('Emma',Course.c)) 
    AND Enroll(Person2.p, Course.c)
    FROM Student Person2, C Course);


\qecho 'Problem 9.a'
-- Find each pair of different students who both know a same professor
-- who teaches the course ‘Databases’

-- Your SQL code for this problem must go here
SELECT Person1.p, Person2.p
FROM Student Person1, Student Person2
WHERE true = SOME(SELECT Knows(Person1.p, Professor.p) 
    AND Knows(Person2.p, Professor.p) 
    AND Teaches(Professor.p,'Databases') 
    AND Person1.p <> Person2.p
    FROM Professor Professor);



\qecho 'Problem 10.a'
-- Find each professor who only teaches courses taken by all students
-- who major in `DataScience'

-- Your SQL code for this problem must go here
SELECT P 
FROM Professor
WHERE true = ALL(SELECT Implies(Teaches(Professor.p,Course.c), 
        true = ALL(SELECT Implies(hasMajor(Student.p, 'DataScience'), Enroll(Student.p,Course.c) ) 
            FROM Student Student))
            FROM C Course );


\qecho 'Problem 11.a'
-- Find each professor who does not know any student who majors in
-- both ‘DataScience’ and in ‘Chemistry'

-- Your SQL code for this problem must go here
SELECT P
FROM Professor 
WHERE not true = SOME(SELECT hasMajor(Student.p,'DataScience') 
    AND hasMajor(Student.p, 'Chemistry') 
    AND Knows(Professor.p, Student.p)
    FROM Student Student);


\qecho 'Problem 12.a'

-- Find each pair of different students who have a common major and who
-- take none of the courses taught by professor `Pedro'

-- Your SQL code for this problem must go here
SELECT Person1.p, Person2.p
FROM Student Person1, Student Person2
WHERE Person1.p <> Person2.p 
AND true = SOME(SELECT hasMajor(Person1.p,Major.m) 
    AND hasMajor(Person2.p,Major.m)
AND true = ALL(SELECT Implies(Teaches('Pedro',Course.c), 
     (not Enroll(Person1.p, Course.c) AND not Enroll(Person2.p,course.c)) )
FROM C Course)
FROM M Major);


-- !!!!!!!!!!!!!!!!!
-- KEEP the statement below in your submission.
-- We need to grade your assignment and want to need upload in our database
-- your database!!!!!!!!

\c postgres


DROP DATABASE d321dvgassignment4;


