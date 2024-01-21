SELECT s.sid
FROM Student s
WHERE NOT EXISTS (SELECT 1
                  FROM Enroll e
                  WHERE e.sid = s.sid AND
                  e.cno NOT IN (SELECT c.cno
                                FROM Course c
                                WHERE c.dept = ‘CS’))

Convert NOT EXISTS

select q.sid
from (select s.sid, s.sname
      from student s
      except
      select s.sid, s.sname
      from student s, enroll e
      where e.sid = s.sid
      and e.cno not in (select c.cno
                        from course c
                        where c.dept = 'CS')) q

select q1.sid
from (select s.sid, s.sname
      from student s
      except
      select q2.sid, q2.sname
      from (select s.sid, s.sname, e.sid, e.cno
            from student s, enroll e
            where e.sid = s.sid
            except
            select s.sid, s.sname, e.sid, e.cno
            from student s, enroll e, course c
            where c.dept = 'CS' and e.cno = c.cno)) q2 ) q1


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT s.sid
FROM Student s
WHERE NOT EXISTS (SELECT 1
                  FROM Course c
                  WHERE c.dept = ‘CS’ AND
                  c.cno NOT IN (SELECT e.cno
                                FROM Enroll e
                                WHERE e.sid = s.sid))


select q1.sid
from (select s.sid, s.sname
      from student s
      except
      select s.sid, s.sname
      from student s, course c
      where c.dept = 'CS'
      and c.cno not in (select e.cno
                        from enroll e
                        where e.sid = s.sid)) q1


select q1.sid
from (select s.sid, s.sname
      from student s
      except
      select q2.sid, q2.sname
      from (select s.sid, s.sname, c.cno, c.dept
            from student s, course c
            where c.dept = 'CS'
            except
            select s.sid, s.sname, c.cno, c.dept
            from student s, course c, enroll e
            where e.sid = s.sid and c.cno = e.cno) q2 ) q1


      select s.sid, s.sname
      from student s, course c
      where c.dept = 'CS'
      and c.cno not in (select e.cno
                        from enroll e
                        where e.sid = s.sid)) q1
