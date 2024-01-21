CREATE TABLE student(sid text NOT NULL,
                     sname varchar(30),
                     age integer,
                     primary key(sid));

CREATE TABLE course(cno text NOT NULL,
                    cname varchar(20),
                    dept varchar(15),
                    primary key(cno));


CREATE TABLE enroll(sid text,
                    cno text,
                    primary key(sid,cno),
                    foreign key(sid) references student(sid),
                    foreign key(cno) references course(cno));

INSERT INTO student VALUES('s1', 'John', 23);
INSERT INTO student VALUES('s2', 'Ellen',20);
INSERT INTO student VALUES('s3', 'Eric', 30);
INSERT INTO student VALUES('s4', 'Mark', 22);
INSERT INTO student VALUES('s5', 'Ann', 22);

INSERT INTO course VALUES ('c1', 'Dbs', 'CS'),
                          ('c2', 'AI', 'CS'),
                          ('c3', 'Calc1', 'Math'),
                          ('c4', 'Calc2', 'Math');

INSERT INTO enroll VALUES ('s1', 'c1'),
                          ('s1', 'c2'),
                          ('s1', 'c3'),
                          ('s2', 'c2'),
                          ('s3', 'c3'),
                          ('s5', 'c1'),
                          ('s5', 'c2');
