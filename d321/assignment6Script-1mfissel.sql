CREATE DATABASE assignment6;

-- Connecting to database 
\c assignment6;

-- Relation schemas and instances for assignment 6

CREATE TABLE Student(sid integer,
                     sname text,
                     homeCity text,
                     primary key (sid));

CREATE TABLE Department(deptName text,
                        mainOffice text,
                        primary key (deptName));

CREATE TABLE Major(major text,
                   primary key (major));


CREATE TABLE employedBy(sid integer,
                        deptName text,
                        salary integer,
                        primary key (sid),
                        foreign key (sid) references Student (sid));


CREATE TABLE departmentLocation(deptName text,
                                building text,
                                primary key (deptName, building),
                                foreign key (deptName) references Department (deptName));


CREATE TABLE studentMajor(sid integer,
                          major text,
                          primary key (sid, major),
                          foreign key (sid) references Student (sid),
                          foreign key (major) references Major (major));


CREATE TABLE hasFriend(sid1 integer,
                       sid2 integer,
                       primary key(sid1,sid2),
                       foreign key (sid1) references Student (sid),
                       foreign key (sid2) references Student (sid));


INSERT INTO Student VALUES
     (1001,'Jean','Cupertino'),
     (1002,'Vidya', 'Cupertino'),
     (1003,'Anna', 'Seattle'),
     (1004,'Qin', 'Seattle'),
     (1005,'Megan', 'MountainView'),
     (1006,'Ryan', 'Chicago'),
     (1007,'Danielle','LosGatos'),
     (1008,'Emma', 'Bloomington'),
     (1009,'Hasan', 'Bloomington'),
     (1010,'Linda', 'Chicago'),
     (1011,'Nick', 'MountainView'),
     (1012,'Eric', 'Cupertino'),
     (1013,'Lisa', 'Indianapolis'), 
     (1014,'Deepa', 'Bloomington'), 
     (1015,'Chris', 'Denver'),
     (1016,'YinYue', 'Chicago'),
     (1017,'Latha', 'LosGatos'),
     (1018,'Arif', 'Bloomington'),
     (1019,'John', 'NewYork');


INSERT INTO Department VALUES
     ('CS', 'LuddyHall'),
     ('DataScience', 'LuddyHall'),
     ('Mathematics', 'RawlesHall'),
     ('Physics', 'SwainHall'),
     ('Biology', 'JordanHall'),
     ('Chemistry', 'ChemistryBuilding'),
     ('Astronomy', 'SwainHall');


INSERT INTO employedBy VALUES
     (1001,'CS', 65000),
     (1002,'CS', 45000),
     (1003,'DataScience', 55000),
     (1004,'DataScience', 55000),
     (1005,'Mathematics', 60000),
     (1006,'DataScience', 55000),
     (1007,'Physics', 50000),
     (1008,'DataScience', 50000),
     (1009,'CS',60000),
     (1010,'DataScience', 55000),
     (1011,'Mathematics', 70000), 
     (1012,'CS', 50000),
     (1013,'Physics', 55000),
     (1014,'CS', 50000), 
     (1015,'DataScience', 60000),
     (1016,'DataScience', 55000),
     (1017,'Physics', 60000),
     (1018,'CS', 50000),
     (1019,'Biology', 50000);

INSERT INTO departmentLocation VALUES
   ('CS', 'LindleyHall'),
   ('DataScience', 'LuddyHall'),
   ('DataScience', 'Kinsey'),
   ('DataScience', 'WellsLibrary'),
   ('Mathematics', 'RawlesHall'),
   ('Physics', 'SwainHall'),
   ('Physics', 'ChemistryBuilding'),
   ('Biology', 'JordanHall'),
   ('CS', 'LuddyHall'),
   ('Mathematics', 'SwainHall'),
   ('Physics', 'RawlesHall'),
   ('Biology', 'MultiDisciplinaryBuilding'),
   ('Chemistry', 'ChemistryBuilding');

INSERT INTO Major VALUES
   ('CS'),
   ('DataScience'),
   ('Physics'),
   ('Chemistry'),
   ('Biology');

INSERT INTO studentMajor VALUES
 (1001,'CS'),
 (1001,'DataScience'),
 (1002,'CS'),
 (1002,'DataScience'),
 (1004,'DataScience'),
 (1004,'CS'),
 (1005,'DataScience'),
 (1005,'CS'),
 (1005,'Physics'),
 (1006,'CS'),
 (1006,'Chemistry'),
 (1007,'Chemistry'),
 (1007,'CS'),
 (1009,'Chemistry'),
 (1009,'Physics'),
 (1010,'Physics'),
 (1011,'Physics'),
 (1011,'Chemistry'),
 (1011,'DataScience'),
 (1011,'CS'),
 (1012,'DataScience'),
 (1012,'Chemistry'),
 (1012,'CS'),
 (1013,'CS'),
 (1013,'DataScience'),
 (1013,'Chemistry'),
 (1013,'Physics'),
 (1014,'Chemistry'),
 (1014,'DataScience'),
 (1014,'Physics'),
 (1015,'CS'),
 (1015,'DataScience'),
 (1016,'Chemistry'),
 (1016,'DataScience'),
 (1017,'Physics'),
 (1017,'CS'),
 (1018,'DataScience'),
 (1019,'Physics');

INSERT INTO hasFriend VALUES
 (1001,1008),
 (1001,1012),
 (1001,1014),
 (1001,1019),
 (1002,1001),
 (1002,1002),
 (1002,1011),
 (1002,1014),
 (1002,1015),
 (1003,1004),
 (1004,1002),
 (1004,1003),
 (1004,1012),
 (1004,1013),
 (1004,1014),
 (1004,1019),
 (1005,1015),
 (1006,1003),
 (1006,1004),
 (1006,1006),
 (1007,1008),
 (1007,1013),
 (1007,1016),
 (1007,1017),
 (1008,1001),
 (1008,1007),
 (1008,1015),
 (1008,1019),
 (1009,1001),
 (1009,1005),
 (1009,1013),
 (1010,1008),
 (1010,1013),
 (1010,1014),
 (1011,1005),
 (1011,1009),
 (1011,1010),
 (1011,1011),
 (1012,1011),
 (1013,1002),
 (1013,1007),
 (1013,1018),
 (1014,1005),
 (1014,1006),
 (1014,1012),
 (1014,1017),
 (1015,1002),
 (1015,1003),
 (1015,1005),
 (1015,1011),
 (1015,1015),
 (1015,1018),
 (1016,1004),
 (1016,1006),
 (1016,1015),
 (1017,1013),
 (1017,1014),
 (1017,1019),
 (1018,1004),
 (1018,1007),
 (1018,1009),
 (1018,1010),
 (1018,1013),
 (1019,1001),
 (1019,1006),
 (1019,1008),
 (1019,1013);

\qecho 'Problem 1'

--student is employed by a dept that is not mathematics
--student lives in bloomington
--student makes more than 10000 salary

SELECT s.sid, s.homeCity, e.deptName, e.salary
FROM Student s, employedBy e
WHERE s.homeCity = 'Bloomington'
AND e.salary >= 10000
AND s.sid = e.sid
AND e.deptName <> 'Mathematics';

\qecho 'Problem 2'
SELECT s.sid, s.sname 
FROM Student s
WHERE EXISTS (SELECT d.deptName, e.sid
               FROM employedBy e, Department d
               WHERE d.deptName = e.deptName
               AND s.sid = e.sid 
               AND d.mainOffice = 'LuddyHall'
               AND EXISTS(SELECT s2.sid, f.sid2
                    FROM Student s2, hasFriend f
                    WHERE s.sid = f.sid1 
                    AND s2.sid = f.sid2 
                    AND s2.homeCity <> 'Bloomington'
                    ));



\qecho 'Problem 3'
SELECT m.major
FROM Major m 
WHERE m.major not in (SELECT sm.major
                    FROM studentMajor sm, Student s
                    WHERE s.sid = sm.sid
                    AND sm.major = m.major
                    AND s.homeCity = 'Bloomington');

\qecho 'Problem 4'


\qecho 'Problem 5'
-- Find the sid, sname of each student who (a) has home homeCity Bloomington, (b)
-- works for a department where he or she earns a salary that is higher than
-- 20000, and (c) has at least one friend.


\qecho 'Problem 6'
-- Find the pairs $(d_1, d_2)$ of names of different departments whose main offices
-- are located in the same building.

\qecho 'Problem 7'
-- Find the sid and sname of each student whose home homeCity
-- different than those of his or her friends.

\qecho 'Problem 8'
-- Find each major that is the major of at most 2 students.

\qecho 'Problem 9'
-- Find the sid, sname, and salary of each student who has at least two
-- friends such that these friends have a common major but provided that
-- it is not the ‘Mathematics’ major.

\qecho 'Problem 10'
-- Find the deptName of each department that not only employs students
-- whose home homeCity is Indianapolis.  (In other words, there exists at
-- least one student who is employed by such a department whose home homeCity
-- is not Indianapolis.)


\qecho 'Problem 11'
-- For each department, list its name along with the highest salary made
-- by students who are employed by it.



\qecho 'Problem 12'
-- Find the sid and sname of each student $s$ who is employed by a
-- department $d$ and who has a salary that is strictly higher than the
-- salary of each of his friends who is employed by that department $d$.



\qecho 'Problem 17'
-- Find the sid of each student who has at least 3 friends who have at
-- most 2 majors.

\qecho 'Problem 18'

-- Find the deptName of each department with the lowest average salary of
-- the salaries of students who work for that department.

\qecho 'Problem 19'
-- Find the pairs (s1,s2) of sids of different students who have exactly
-- the same number of friends.

\qecho 'Problem 20'
-- Find the sid of each student who is employed in a department d and
-- whose salary is strictly less than the salary of each of his or her
-- friends who are also employed in department d.

-- Connect to default database
\c postgres;

-- Drop database created for this assignment
DROP DATABASE assignment6;





