-- Script for Assignment 1

-- Creating database with full name

CREATE DATABASE adcassingment1;

-- Connecting to database 
\c adcassingment1

-- Relation schemas and instances for assignment 1

CREATE TABLE Person(pid integer,
                    pname text,
                    city text,
                    primary key (pid));

CREATE TABLE Company(cname text,
                     headquarter text,
                     primary key (cname));

CREATE TABLE Skill(skill text,
                   primary key (skill));


CREATE TABLE worksFor(pid integer,
                      cname text,
                      salary integer,
                      primary key (pid),
                      foreign key (pid) references Person (pid),
                      foreign key (cname) references Company(cname));


CREATE TABLE companyLocation(cname text,
                             city text,
                             primary key (cname, city),
                             foreign key (cname) references Company (cname));


CREATE TABLE personSkill(pid integer,
                         skill text,
                         primary key (pid, skill),
                         foreign key (pid) references Person (pid) on delete cascade,
                         foreign key (skill) references Skill (skill) on delete cascade);


CREATE TABLE hasManager(eid integer,
                        mid integer,
                        primary key (eid, mid),
                        foreign key (eid) references Person (pid),
                        foreign key (mid) references Person (pid));

CREATE TABLE Knows(pid1 integer,
                   pid2 integer,
                   primary key(pid1, pid2),
                   foreign key (pid1) references Person (pid),
                   foreign key (pid2) references Person (pid));



INSERT INTO Person VALUES
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

INSERT INTO Company VALUES
     ('Apple', 'Cupertino'),
     ('Amazon', 'Seattle'),
     ('Google', 'MountainView'),
     ('Netflix', 'LosGatos'),
     ('Microsoft', 'Redmond'),
     ('IBM', 'NewYork'),
     ('ACM', 'NewYork'),
     ('Yahoo', 'Sunnyvale');


INSERT INTO worksFor VALUES
     (1001,'Apple', 65000),
     (1002,'Apple', 45000),
     (1003,'Amazon', 55000),
     (1004,'Amazon', 55000),
     (1005,'Google', 60000),
     (1006,'Amazon', 60000),
     (1007,'Netflix', 50000),
     (1008,'Amazon', 50000),
     (1009,'Apple',60000),
     (1010,'Amazon', 55000),
     (1011,'Google', 70000), 
     (1012,'Apple', 45000),
     (1013,'Yahoo', 55000),
     (1014,'Apple', 50000), 
     (1015,'Amazon', 60000),
     (1016,'Amazon', 55000),
     (1017,'Netflix', 60000),
     (1018,'Apple', 50000),
     (1019,'Microsoft', 50000);

INSERT INTO companyLocation VALUES
   ('Apple', 'Bloomington'),
   ('Amazon', 'Chicago'),
   ('Amazon', 'Denver'),
   ('Amazon', 'Columbus'),
   ('Google', 'NewYork'),
   ('Netflix', 'Indianapolis'),
   ('Netflix', 'Chicago'),
   ('Microsoft', 'Bloomington'),
   ('Apple', 'Cupertino'),
   ('Amazon', 'Seattle'),
   ('Google', 'MountainView'),
   ('Netflix', 'LosGatos'),
   ('Microsoft', 'Redmond'),
   ('IBM', 'NewYork'),
   ('Yahoo', 'Sunnyvale');

INSERT INTO Skill VALUES
   ('Programming'),
   ('AI'),
   ('Networks'),
   ('OperatingSystems'),
   ('Databases');

INSERT INTO personSkill VALUES
 (1001,'Programming'),
 (1001,'AI'),
 (1002,'Programming'),
 (1002,'AI'),
 (1004,'AI'),
 (1004,'Programming'),
 (1005,'AI'),
 (1005,'Programming'),
 (1005,'Networks'),
 (1006,'Programming'),
 (1006,'OperatingSystems'),
 (1007,'OperatingSystems'),
 (1007,'Programming'),
 (1009,'OperatingSystems'),
 (1009,'Networks'),
 (1010,'Networks'),
 (1011,'Networks'),
 (1011,'OperatingSystems'),
 (1011,'AI'),
 (1011,'Programming'),
 (1012,'AI'),
 (1012,'OperatingSystems'),
 (1012,'Programming'),
 (1013,'Programming'),
 (1013,'OperatingSystems'),
 (1013,'Networks'),
 (1014,'OperatingSystems'),
 (1014,'AI'),
 (1014,'Networks'),
 (1015,'Programming'),
 (1015,'AI'),
 (1016,'OperatingSystems'),
 (1016,'AI'),
 (1017,'Networks'),
 (1017,'Programming'),
 (1018,'AI'),
 (1019,'Networks');

INSERT INTO hasManager VALUES
 (1004, 1003),
 (1006, 1003),
 (1015, 1003),
 (1016, 1004),
 (1016, 1006),
 (1008, 1015),
 (1010, 1008),
 (1013, 1007),
 (1017, 1013),
 (1002, 1001),
 (1009, 1001),
 (1014, 1012),
 (1011, 1005);


INSERT INTO Knows VALUES
 (1011,1009),
 (1007,1016),
 (1011,1010),
 (1003,1004),
 (1006,1004),
 (1002,1014),
 (1009,1005),
 (1018,1009),
 (1007,1017),
 (1017,1019),
 (1019,1013),
 (1016,1015),
 (1001,1012),
 (1015,1011),
 (1019,1006),
 (1013,1002),
 (1018,1004),
 (1013,1007),
 (1014,1006),
 (1004,1014),
 (1001,1014),
 (1010,1013),
 (1010,1014),
 (1004,1019),
 (1018,1007),
 (1014,1005),
 (1015,1018),
 (1014,1017),
 (1013,1018),
 (1007,1008),
 (1005,1015),
 (1017,1014),
 (1015,1002),
 (1018,1013),
 (1018,1010),
 (1001,1008),
 (1012,1011),
 (1002,1015),
 (1007,1013),
 (1008,1007),
 (1004,1002),
 (1015,1005),
 (1009,1013),
 (1004,1012),
 (1002,1011),
 (1004,1013),
 (1008,1001),
 (1008,1019),
 (1019,1008),
 (1001,1019),
 (1019,1001),
 (1004,1003),
 (1006,1003),
 (1015,1003),
 (1016,1004),
 (1016,1006),
 (1008,1015),
 (1010,1008),
 (1017,1013),
 (1002,1001),
 (1009,1001),
 (1011,1005),
 (1014,1012);



\qecho 'Problem 1'

-- Provide 4 conceptually different examples that illustrate how the
-- presence or absence of primary and foreign keys affect inserts and
-- deletes in these relations.\footnote{Consider the lecture notes about keys, foreign keys, and inserts and deletes as a guide to solve this problem.}

-- To solve this problem, you will need to experiment with the relation schemas and instances for this assignment.
-- For example,
-- a) you may consider altering primary keys and foreign key constraints and then consider various sequences of insert and delete operations; or
-- b) you may consider changing the given relation instances to observe the desired effects.

-- You can modify the provided SQL file, to change the structure of the tables and/or entries in them.
-- Once done with this, you can drop the database, then recreate and populate it again with the original data by running the file FA23_B461_Assignment1.sql for the rest of the assignment.
-- If this is not done, you will face issues in getting the right output for the below questions.

-- Certain inserts and deletes should succeed but others should generate error conditions.

-- The SQL code that corresponds to each of these four examples should be included in the assignment1.sql file (even though it may generate error conditions.)


\qecho 'Problem 1 conceptual example 1'

\qecho 'Problem 1 conceptual example 2'

\qecho 'Problem 1 conceptual example 3'

\qecho 'Problem 1 conceptual example 4'


\qecho 'Problem 2'

-- Find the ID and name of each person that satisfies all the 3 conditions 
-- (a) lives in Chicago, 
-- (b) has operating systems skill, and
-- (c) works for a company where he or she earns a salary that is less than or equal to 55000.
select p.pid, p.pname
from person p
where p.city='Chicago' 
        and exists (select 1 from worksFor w where w.pid = p.pid and w.salary <= 55000) 
        and exists (select 1 from personskill ps where ps.pid = p.pid and ps.skill='OperatingSystems') order by 1;


\qecho 'Problem 3'
-- Find the ID of each person who knows at least 3 persons.
select distinct k1.pid1 from knows k1, knows k2, knows k3
where k1.pid1 = k2.pid1 and k2.pid1 = k3.pid1 and k1.pid1 = k3.pid1
and k1.pid2 <> k2.pid2 and k2.pid2 <> k3.pid2 and k1.pid2 <> k3.pid2 order by 1;


\qecho 'Problem 4'
-- Find the ID and name of each person who lives in Bloomington and who has manager who lives in Cupertino.
select p.pid,p.pname from person p where p.city='Bloomington'
and exists (select 1 from hasmanager hm,person p1 where hm.eid=p.pid and hm.mid=p1.pid and p1.city='Cupertino' );


\qecho 'Problem 5'
-- Find the pairs of companies (cname1, cname2) such that the companies are not located in the same city. 
-- (The output should contain both (cname1,cname2) and (cname2,cname1) pairs ).
select distinct cl1.cname, cl2.cname
from companyLocation cl1, companyLocation cl2
where cl1.cname <> cl2.cname
and not exists (
				select 1 from companyLocation cl3
				where cl3.cname = cl1.cname and cl3.city in (
					select cl4.city from companyLocation cl4 where cl4.cname = cl2.cname
				)
) order by 1;

\qecho 'Problem 6'
-- For each company, list the company name along with the highest salary earned by any employee who works for that company. 
-- (The query is expected to return the company name and salary fields as output).
select distinct w.cname, w.salary
from worksFor w
where not exists (select 1
                from worksFor w1
                where w1.cname=w.cname and w1.salary > w.salary);

\qecho 'Problem 7'
-- Find the ID, name and salary of each person who manages an employee who manages at least one other employee having Networks skill.
select hm1.mid,p.pname,w.salary
from hasmanager hm1,worksfor w,person p
where p.pid=w.pid and hm1.mid=p.pid and exists
    (select 1 from personskill ps,hasmanager hm where ps.skill='Networks' and hm.mid=hm1.eid and ps.pid=hm.eid);
    
\qecho 'Problem 8'
-- Find the ID and name of each employee whose salary is higher than the salary of each of his or her managers.
-- (Employees who have no manager should not be included.)
select p.pid, p.pname
from person p, hasmanager hm  where p.pid = hm.eid and not exists (
    select 1 from worksfor w1, worksfor w2
    where w1.pid = p.pid and w2.pid = hm.mid and w1.salary<= w2.salary) ;

\qecho 'Problem 9'
-- Find the ID and name of each person who lives in a city that is different than each city in which his or her managers live.
-- (Persons who have no manager should not be included in the answer.)
select p.pid, p.pname from person p where p.pid in(
select hm.eid from hasmanager hm
INTERSECT
select p1.pid
from person p1 where not exists(
    select 1 from person p2,  hasmanager hm  where p1.pid = hm.eid
    and hm.mid = p2.pid and p1.city = p2.city)
);

\qecho 'Problem 10'
-- Find the ID, name, and salary of each employee who has at least two managers such that these managers have a common job skill 
-- but provided that the skill is not `Networks'.
select p.pid, p.pname from person p where exists(
    select 1 from hasmanager hm1, hasmanager hm2, personSkill ps1, personSkill ps2
    where p.pid = hm1.eid and p.pid = hm2.eid and hm1.mid <> hm2.mid and ps1.skill <> 'Networks' and ps1.skill = ps2.skill);
    
-- Connect to default database
\c postgres;

-- Drop database created for this assignment
DROP DATABASE adcassingment1;
