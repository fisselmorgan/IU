/* In this note, I provide various examples to demonstrate 
RA expression with joins and semi-joins as formulated in SQL.

This examples are based on the schemas used for Assignments 2 and 3 */



\qecho Find the sid and sname of each student who bought a book that cites another book.

select distinct  sid, sname
from   student 
        natural join buys 
        natural join cites ;


\qecho Find the sid and sname of each student who has at least two majors.


select distinct s.sid, s.sname
from   student s
       inner join major m1 on s.sid = m1.sid
       inner join major m2 on (s.sid = m2.sid and m1.major <> m2.major);


\qecho Find the sid of each student who bought exactly one book

select t.sid
from   buys t
except
select distinct  t1.sid
from   buys t1 inner join buys t2 on (t1.sid = t2.sid and t1.bookno <> t2.bookno); 

\qecho Find the bookno of each book that is not cited by a book that cost more than 50.

select bookno
from   book 
except
select citedbookno
from   cites natural inner join (select bookno from book where price > 50) b;

\qecho Find the bookno and title of each book with the second to lowest price.


select distinct q.bookno, q.title
from       
  (select e.* 
   from (select b.*
         from   book b inner join book b1 on b.price > b1.price) e
          except
         select e.*
         from (select b.*
               from   book b inner join book b1 on b.price > b1.price) e
                inner join 
               (select b.*
                from   book b inner join book b1 on b.price > b1.price) e1 on (e.price > e1.price)) q;

/* A translation using the WITH statement is as follows */

with E as                            
   (select b.*
    from  book b inner join book b1 on b.price > b1.price)

select q.bookno, q.title
from       
  (select e.* 
   from E e
   except
   select e.*
   from   E e  inner join E e1 on e.price > e1.price) q;


\qecho Find the bookno of each book that was not bought by all students who major in CS.

select distinct q.bookno
from  
   (select m.sid, b.bookno
    from  (select m.sid from major m where major ='CS') m 
           cross join (select b.bookno from book b) b
            except
           select t.sid, t.bookno
           from   buys t) q;



\qecho Find the bookno and title of each book that was only bought by the student with sid = 1001.

select b.bookno, b.title
from   book b
except
select distinct b.bookno, b.title
from   buys t inner join book b on (t.bookno = b.bookno and t.sid <> 1001);


select b.bookno, b.title
from   book b
except
select distinct b.bookno, b.title
from   book b natural join (select bookno from buys where sid <> 1001) t;


\qecho Find the sid and sname of each student who bought at least two books that cost less than  50.

with E as
  (select distinct t.sid, t.bookno
   from   buys t inner join (select b.* from book b where price < 50) b on (t.bookno = b.bookno and b.price < 50))
select distinct s.sid, s.sname
from student s 
     inner join E e1 on (s.sid = e1.sid)
     inner join E e2 on (e1.sid = e2.sid and e1.bookno <> e2.bookno); 


\qecho Find the sid of each student who not only bought books that cost less than 30.

/* We write this query with using a WHERE clause */

select  distinct q.sid
from
   (select t.sid as sid, t.bookno from buys t
    except
    select s.sid, q1.bookno
    from   (select sid from student) s 
            cross join (select b.bookno 
                        from   book b inner join (select 30 as price) p on (b.price < p.price)) q1) q;

\qecho  Find the pairs of different sid (s1,s2) of students such   that all books bought by student s1 were also bought by student s2.

with S as (select s.sid from student s),
     E1 as (select t1.sid as t1sid, t1.bookno, s2.sid as s2sid
            from   buys t1 cross join S s2),
     E2 as (select s1.sid as s1sid, t2.bookno, t2.sid as s2sid
            from   buys t2 cross join S s1)
select  s1.sid, s2.sid
from    S s1 inner join S s2  on (s1.sid <> s2.sid)                                            
except
select q.t1sid, q.s2sid
from (select e1.t1sid, e1.bookno, e1.s2sid from E1 e1
      except
      select e2.s1sid, e2.bookno, e2.s2sid from E2 e2) q;


\qecho  Find the pair of different booknos $(b_1,b_2)$ that where bought by the same CS students.

with  B as (select b.bookno from book b),

      T  as (select  distinct t.sid, t.bookno  
             from buys t natural join (select distinct m.sid from major m where m.major = 'CS') m),

      E1 as (select t1.bookno as t1bookno, t1.sid, b2.bookno as b2bookno
             from   T t1 cross join B b2),
            
      E2 as (select b1.bookno as b1bookno, t2.sid, t2.bookno as t2bookno
             from   T t2 cross join B b1),
            
      E3 as (select  b1.bookno, b2.bookno
             from    B b1 inner join B b2  on (b1.bookno <> b2.bookno)                                            
             except
             select q.t1bookno, q.b2bookno
             from (select e1.t1bookno, e1.sid, e1.b2bookno from E1 e1
                   except
                   select e2.b1bookno, e2.sid, e2.t2bookno from E2 e2) q),
                               
       E4 as (select  b1.bookno, b2.bookno
              from    B b1 inner join B b2  on (b1.bookno <> b2.bookno)                                            
              except
              select q.b1bookno, q.t2bookno
              from (select e2.b1bookno, e2.sid, e2.t2bookno from E2 e2
                    except
                    select e1.t1bookno, e1.sid, e1.b2bookno from E1 e1) q)                               
                               

select e3.* from E3 e3
intersect
select e4.* from E4 e4;    



\qecho Find the bookno of each book that is cited by all but one book.  

with   book as (select bookno from book)
select q.bbookno
from (select b.bookno as bbookno, b1.bookno
      from   book b cross join book b1
      except 
      select c.bookno, c.citedbookno
      from   cites c 
             ) q

except                                                                            

select q.bbookno
from   
(select b.bookno as bbookno, b1.bookno, b2.bookno
  from   book b
         cross join book b1
         inner join book b2 on b1.bookno <> b2.bookno
  except 
   (select c.citedbookno, c.bookno, b2.bookno
    from   cites c cross join book b2
    union
    select c.citedbookno, b1.bookno, c.bookno
    from  cites c cross join book b1)) q;



