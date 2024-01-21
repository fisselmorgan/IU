/*
Schema

Person (Pid, Pname, City)
Company (Cname, City)
JobSkill (Skill)
Works (Pid, Cname, Salary)
PersonSkill(Pid,Skill)
Manages(Eid, Mid)
*/

-- 1.	Consider the following Pure SQL query:

SELECT DISTINCT w1.cname
FROM works w1, works w2
WHERE w1.cname = w2.cname AND w1.pid <> w2.pid

-- Formulate an equivalent query in Pure SQL that does not use the DISTINCT clause.

select c.cname
from company c
intersect
select w1.cname
from works w1
where exists (select 1
              from works w2
              where w1.cname = w2.cname
              and w1.pid <> w2.pid)


-- 2.	Let R(A) and S(A,B) be two relations. Consider the following query
SELECT r.A
FROM R r
WHERE r.A NOT IN (SELECT s1.A
                  FROM S s1, S s2
                  WHERE s1.A <> s2.A AND s1.B = SOME (SELECT s.B
                                                      FROM S s
                                                      WHERE s.B <> s2.B));
-- Formulate this query in Pure SQL without using any of the set predicates (NOT) EXISTS, (NOT) IN, θ ALL, and θ SOME predicates. You can use the set operations UNION, INTERSECT, and EXCEPT
-- Eliminating  SOME
SELECT r.A
FROM R r
WHERE r.A NOT IN (SELECT s1.A
                  FROM S s1, S s2, S s 
                  WHERE s1.A <> s2.A AND s1.B = s.B AND s.B <> s2.B);
-- Eliminating NOT IN
SELECT q.A
FROM (
     SELECT c.*
     FROM R r
     EXCEPT
     SELECT c.*
     FROM R r, S s1, S s2, S s 
     WHERE r.A = s1.A AND s1.A <> s2.A AND s1.B = s.B AND s.B <> s2.B
     ) q;


--3. Consider the following constraint: Each manager must have all the skills of each of the employees that he or she manages. Write a Pure SQL boolean query that returns true if this constraint is satisfied in the database, and returns false if this is not the case.

select not exists (select m.mid
                   from manages m, personSkill ps
                   where m.eid = ps.pid
                   and ps.skill not in(select ps2.skill
                                       from personSkill ps2
                                       where ps2.pid = m.mid))

--4. Formulate the following query in Pure SQL (in particular, you cannot use SQL aggregate functions in your solution):

--Find the pid and name of each person who lives in the same city as one or more of his or her managers.

select p.pid, p.name
from person p
where p.city in (select pm.city
                  from manages m, person pm
                  where m.eid = p.pid
                  and m.mid = pm.pid)

--5. Formulate the following query in Pure SQL (in particular, you cannot use SQL aggregate functions in your solution):

--Find the mid of each manager who has a higher salary than at least two employees he or she manages.

select m.mid
from manages m, works w
where exists (select 1
              from works w1, works w2
              where w1.pid <> w2.pid
              and w1.pid = m.eid
              and w1.salary < w.salary
              and w2.pid = m.eid
              and w2.salary < w.salary)

--6. Formulate the following query in Pure SQL (in particular, you cannot use SQL aggregate functions in your solution):

--Find the pairs (c,e) where c is the name of a company and e is the pid of a person who works at the company and who has the highest salary of all the employees working for that company.

select w.name, w.pid
from works w
where w.salary >= ALL (select w1.salary
                        from works w1 where
                        w1.cname = w.cname)

--7. Formulate the following query in Pure SQL (in particular, you cannot use SQL aggregate functions in your solution):

--Find each pairs (c,e) where c is the name of a company and e is the pid of an employee who works for that company and who has at least one manager who lacks at least one of that employee’s job skills.

select w.cname as c, w.pid as e
from works w
where exists (select m.mid
              from manages m
              where m.eid = w.pid
              and exists (select ps.skill
                          from personSkill ps
                          where ps.pid = w.pid
                          and not in (select ps2.skill
                                      from personSkill ps2
                                      where ps2.pid = m.mid)))

--Problem 8: Formulate the following queries in the relational algebra: You can use the abbreviations P, C, JS, PS, W, and M for the relations Person, Company, JobSkill, PersonSkill, worksFor, and Manages.

-- Find the cname of each company that is located in 'Bloomington' but in no other city.

-- Check the pdf for solution

--Problem 9: Formulate the following queries in the relational algebra: You can use the abbreviations P, C, JS, PS, W, and M for the relations Person, Company, JobSkill, PersonSkill, worksFor, and Manages.

-- Find the cname of each company that not only employs persons who live in Bloomington or in Indianapolis.

-- Check the pdf for solution

--Problem 10: Using the translation algorithm taught in class, translate each of the following SQL queries into an equivalent SQL queries that can use SQL's JOIN, NATURAL JOIN, CROSS JOIN, UNION, INTERSECT, and EXCEPT operations but that can not use the set predicates [NOT] EXISTS, [NOT] IN, SOME, and ALL. Furthermore, your SQL queries can not use commas `,' in any of their FROM clauses and you can also not use AND in the WHERE clauses.

SELECT p1.pid, p1.pname, p2.pid
FROM Person p1, Person p2
WHERE p1.city = 'Bloomington'
AND p1.pid <> p2.pid
AND p2.pid <> ALL (SELECT w.pid
                  FROM Works w
                  WHERE w.salary > 100000
                  AND p1.pname = 'Eric')

SELECT q.pid1, q.pname1, q.pid2
FROM(
    SELECT p1.pid as pid1, p1.pname as pname1, p2.pid as pid2
    FROM Person p1, Person p2
    WHERE p1.city = 'Bloomington'
    AND p1.pid <> p2.pid
    EXCEPT
    SELECT p1.pid, p1.pname, p2.pid
    FROM Person p1, Person p2, Works w
    WHERE p1.city = 'Bloomington'
    AND p1.pid <> p2.pid
    AND w.salary > 100000
    AND p1.name = 'Eric'
    AND p2.pid = w.pid) q

SELECT q.pid1, q.pname1, q.pid2
FROM(
    SELECT p1.pid as pid1, p1.pname as pname1, p2.pid as pid2
    FROM (SELECT * FROM Person p1 WHERE p1.city = 'Bloomington') join Person p2 on p1.pid <> p2.pid
    EXCEPT
    SELECT p1.pid, p1.pname, p2.pid
    FROM (SELECT * FROM Person p1 WHERE p1.city = 'Bloomington' AND p1.name = 'Eric') join Person p2 on p1.pid <> p2.pid join SELECT * FROM Works w WHERE w.salary > 100000) on p2.pid = w.pid
) q



--Problem 11: Using the translation algorithm taught in class, translate each of the following SQL queries into an equivalent SQL queries that can use SQL's JOIN, NATURAL JOIN, CROSS JOIN, UNION, INTERSECT, and EXCEPT operations but that can not use the set predicates [NOT] EXISTS, [NOT] IN, SOME, and ALL. Furthermore, your SQL queries can not use commas `,' in any of their FROM clauses and you can also not use AND in the WHERE clauses.


SELECT m.mid
FROM Manages m, worksFor w1, worksFor w2
WHERE m.mid = w1.pid AND m.eid = w2.pid AND
w1.salary < w2.salary AND w1.cname = 'Google'

SELECT m.mid
FROM Manages m join (SELECT * FROM worksFor w1 WHERE w1.cname = 'Google') on m.mid = w1.pid join worksFor w2 on (w1.salary < w2.salary and m.eid = w2.pid)

--Problem 12: Optimize the following relational algebra expression.  Show the intermediate steps and specify the optimization rule(s) that you have used.

-- Check the pdf for solution

--Problem 13: 
-- Find the id and name of each person who lives in 'Chicago', works for a company located in 'Seattle', and has 'OperatingSystems' skills.
--Formulate your queries in pure SQL using views.
WITH person_works_seattle AS (SELECT w.pid
                              FROM works w, company c
                              WHERE w.cname = c.cname AND c.city = 'Seattle'),
     person_operatingSys_skills AS (SELECT ps.pid
                                   FROM person_skill ps 
                                   WHERE ps.skill = 'OperatingSystems'
                                   AND ps.pid in (SELECT pid
                                                  FROM person_works_seattle))
select p.pid, p.pname
from person p, person_operatingSys_skills pos 
WHERE p.pid = pos.pid AND p.city = 'Chicago';

--Problem 14:
-- Create a parameterized view ManagerWorksfor (c text, p int, s int) that returns the mid of each manager who works for a company identified by 'c' and knows a person identified by 'p' and has a salary strictly greater than the parameter value 's'.
-- You can test your view for the parameter values  ('Apple', 1019, 30000) and ('Amazon', 1013, 50000).
CREATE OR REPLACE FUNCTION ManagerWorksfor (c text, p int, s int)
RETURNS TABLE (mid int) AS                                                                                                                  $$
WITH managerCompany AS (
          SELECT m.mid
          FROM manages m, works w 
          WHERE m.mid = w.pid 
               AND w.cname = c
               AND w.salary > s
          ),
     managerKnows AS (
          SELECT k.pid1 AS mid
          FROM knows k, managerCompany mc 
          WHERE k.pid2 = p 
               AND k.pid1 = mc.mid
     )
SELECT DISTINCT mid FROM managerKnows;

$$ LANGUAGE SQL;
-- SELECT * FROM ManagerWorksfor ('Apple', 1019, 30000);
-- SELECT * FROM ManagerWorksfor ('Amazon', 1013, 50000);