## Python script  D321  Assignment 4

## domain Person P

P = [{'p': 'Emma'},
 {'p': 'Eric'},
 {'p': 'Vidya'},
 {'p': 'Anna'},
 {'p': 'YinYue'},
 {'p': 'Latha'},
 {'p': 'Qin'},
 {'p': 'Ryan'},
 {'p': 'Deepa'},
 {'p': 'Hasan'},
 {'p': 'Linda'},
 {'p': 'Chris'},
 {'p': 'Lisa'},
 {'p': 'Nick'},
 {'p': 'Arif'},
 {'p': 'Megan'},
 {'p': 'Margaret'},
 {'p': 'Jean'},
 {'p': 'John'},
 {'p': 'Danielle'}]

## Domain course C


C = [{'c': 'AI'},
 {'c': 'DataScience'},
 {'c': 'Algorithms'},
 {'c': 'Complexity'},
 {'c': 'Networks'},
 {'c': 'Databases'},
 {'c': 'Logic'},
 {'c': 'Programming'},
 {'c': 'Physics'},
 {'c': 'D321'}]


## Domain major M

M = [ {'m': 'DataScience'},
 {'m': 'Math'},
 {'m': 'English'},
 {'m': 'Physics'},
 {'m': 'CS'},
 {'m': 'Chemistry'},
 {'m': 'Philosophy'}]


## Unary predicates

professor = [ {'p': 'Jean'},
 {'p': 'Arif'},
 {'p': 'Eric'},
 {'p': 'Pedro'},
 {'p': 'Emma'},
 {'p': 'Anna'}]


student = [ {'p': 'YinYue'},
 {'p': 'Lisa'},
 {'p': 'Margaret'},
 {'p': 'Hasan'},
 {'p': 'Deepa'},
 {'p': 'Megan'},
 {'p': 'Chris'},
 {'p': 'Linda'},
 {'p': 'Latha'},
 {'p': 'Nick'},
 {'p': 'Vidya'},
 {'p': 'Danielle'},
 {'p': 'Qin'},
 {'p': 'Ryan'},
 {'p': 'John'}]



## Binary predicates

enroll = [{'p': 'Nick','c':'Logic'},
 {'p': 'Hasan','c':'Logic'},
 {'p': 'Eric','c':'Complexity'},
 {'p': 'Vidya','c':'DataScience'},
 {'p': 'Jean','c':'Physics'},
 {'p': 'Deepa','c':'Complexity'},
 {'p': 'Megan','c':'AI'},
 {'p': 'Vidya','c':'AI'},
 {'p': 'Hasan','c':'Databases'},
 {'p': 'Deepa','c':'D321'},
 {'p': 'Deepa','c':'D321'},
 {'p': 'Anna','c':'Physics'},
 {'p': 'Danielle','c':'D321'},
 {'p': 'Emma','c':'Complexity'},
 {'p': 'Hasan','c':'Physics'},
 {'p': 'Nick','c':'Programming'},
 {'p': 'Jean','c':'AI'},
 {'p': 'Anna','c':'D321'},
 {'p': 'John','c':'Logic'},
 {'p': 'Jean','c':'Logic'},
 {'p': 'Lisa','c':'Physics'},
 {'p': 'Jean','c':'DataScience'},
 {'p': 'Hasan','c':'Networks'},
 {'p': 'Jean','c':'Complexity'},
 {'p': 'YinYue','c':'AI'},
 {'p': 'John','c':'AI'},
 {'p': 'Chris','c':'DataScience'},
 {'p': 'Margaret','c':'Logic'},
 {'p': 'Latha','c':'Physics'},
 {'p': 'Jean','c':'Networks'},
 {'p': 'Qin','c':'Complexity'},
 {'p': 'Latha','c':'Logic'},
 {'p': 'Deepa','c':'Physics'},
 {'p': 'Linda','c':'Networks'},
 {'p': 'Anna','c':'Databases'},
 {'p': 'Margaret','c':'AI'},
 {'p': 'Linda','c':'Logic'},
 {'p': 'Jean','c':'Programming'},
 {'p': 'Qin','c':'Networks'},
 {'p': 'Eric','c':'Logic'},
 {'p': 'Ryan','c':'DataScience'},
 {'p': 'Latha','c':'Networks'},
 {'p': 'Deepa','c':'Programming'},
 {'p': 'Nick','c':'DataScience'},
 {'p': 'Ryan','c':'D321'},
 {'p': 'Anna','c':'DataScience'},
 {'p': 'Latha','c':'D321'},
 {'p': 'Chris','c':'Programming'},
 {'p': 'Vidya','c':'Complexity'},
 {'p': 'Arif','c':'Programming'},
 {'p': 'Emma','c':'Programming'},
 {'p': 'Margaret','c':'Complexity'},
 {'p': 'Eric','c':'D321'},
 {'p': 'Margaret','c':'Algorithms'},
 {'p': 'Hasan','c':'Algorithms'},
 {'p': 'Hasan','c':'AI'}]



teaches = [{'p': 'Jean','c':'Databases'},
 {'p': 'Emma','c':'Networks'},
 {'p': 'Eric','c':'Databases'},
 {'p': 'Eric','c':'D321'},
 {'p': 'Emma','c':'Algorithms'},
 {'p': 'Pedro','c':'AI'},
 {'p': 'Emma','c':'Complexity'},
 {'p': 'Anna','c':'Complexity'},
 {'p': 'Jean','c':'Logic'},
 {'p': 'Arif','c':'Networks'},
 {'p': 'Emma','c':'Logic'},
 {'p': 'Anna','c':'AI'},
 {'p': 'Eric','c':'Logic'},
 {'p': 'Anna','c':'D321'},
 {'p': 'Eric','c':'AI'},
 {'p': 'Emma','c':'Physics'},
 {'p': 'Eric','c':'Networks'},
 {'p': 'Emma','c':'DataScience'},
 {'p': 'Jean','c':'D321'}]




hasmajor = [ {'p': 'Qin','m':'Chemistry'},
 {'p': 'Danielle','m':'Chemistry'},
 {'p': 'Megan','m':'Chemistry'},
 {'p': 'John','m':'Chemistry'},
 {'p': 'Lisa','m':'English'},
 {'p': 'YinYue','m':'Physics'},
 {'p': 'Margaret','m':'English'},
 {'p': 'Latha','m':'Math'},
 {'p': 'Deepa','m':'English'},
 {'p': 'Nick','m':'Chemistry'},
 {'p': 'Hasan','m':'English'},
 {'p': 'Megan','m':'DataScience'},
 {'p': 'John','m':'English'},
 {'p': 'Danielle','m':'Physics'},
 {'p': 'Latha','m':'Chemistry'},
 {'p': 'Danielle','m':'Math'},
 {'p': 'Hasan','m':'DataScience'},
 {'p': 'Margaret','m':'Physics'}]




knows = [{'p1': 'Jean','p2':'Megan'},
 {'p1': 'Nick','p2':'Megan'},
 {'p1': 'Margaret','p2':'Lisa'},
 {'p1': 'Danielle','p2':'YinYue'},
 {'p1': 'Eric','p2':'Megan'},
 {'p1': 'Nick','p2':'Margaret'},
 {'p1': 'Lisa','p2':'John'},
 {'p1': 'Qin','p2':'Chris'},
 {'p1': 'Vidya','p2':'Margaret'},
 {'p1': 'Ryan','p2':'Emma'},
 {'p1': 'Latha','p2':'Emma'},
 {'p1': 'Hasan','p2':'Vidya'},
 {'p1': 'Vidya','p2':'Anna'},
 {'p1': 'Anna','p2':'Deepa'},
 {'p1': 'Emma','p2':'Jean'},
 {'p1': 'Deepa','p2':'Qin'},
 {'p1': 'Megan','p2':'Deepa'},
 {'p1': 'Danielle','p2':'Hasan'},
 {'p1': 'Vidya','p2':'Latha'},
 {'p1': 'Lisa','p2':'YinYue'},
 {'p1': 'Anna','p2':'Linda'},
 {'p1': 'Emma','p2':'Linda'},
 {'p1': 'Hasan','p2':'Danielle'},
 {'p1': 'Chris','p2':'Eric'},
 {'p1': 'Ryan','p2':'Eric'},
 {'p1': 'Qin','p2':'Qin'},
 {'p1': 'YinYue','p2':'Emma'},
 {'p1': 'Ryan','p2':'Hasan'},
 {'p1': 'Megan','p2':'Eric'},
 {'p1': 'Deepa','p2':'Linda'},
 {'p1': 'Qin','p2':'YinYue'},
 {'p1': 'Vidya','p2':'YinYue'},
 {'p1': 'Eric','p2':'Qin'},
 {'p1': 'Lisa','p2':'Jean'},
 {'p1': 'Danielle','p2':'Nick'},
 {'p1': 'Eric','p2':'Ryan'},
 {'p1': 'Linda','p2':'John'},
 {'p1': 'Lisa','p2':'Margaret'},
 {'p1': 'Qin','p2':'Nick'},
 {'p1': 'Ryan','p2':'Linda'},
 {'p1': 'Chris','p2':'Lisa'},
 {'p1': 'Chris','p2':'Anna'},
 {'p1': 'Anna','p2':'Lisa'},
 {'p1': 'Arif','p2':'Arif'},
 {'p1': 'Nick','p2':'Qin'},
 {'p1': 'Arif','p2':'Latha'},
 {'p1': 'Margaret','p2':'Latha'},
 {'p1': 'Anna','p2':'Arif'},
 {'p1': 'Megan','p2':'Margaret'},
 {'p1': 'Deepa','p2':'Hasan'},
 {'p1': 'Arif','p2':'YinYue'}]



## Boolean functions for unary predicates Student(p) and Professor(p)

def Student(p): return p in student

def Professor(p): return p in professor


## Boolean functions for binary predicates Enroll(p,c), Teaches (p,c),
## hasMajor(p,m), and Knows(p_1,p_2)


def Enroll(p,c): return {'p':p['p'],'c':c['c']} in enroll

def Teaches(p,c): return {'p':p['p'],'c':c['c']} in teaches

def hasMajor(p,m): return {'p':p['p'],'m':m['m']} in hasmajor

def Knows(p1,p2): return {'p1':p1['p'],'p2':p2['p']} in knows

## Boolean function for Implies

def Implies (P, Q): return not P or Q

## Function to print the answers
def print_Answer(L):  print("\n".join((str(x) for x in L)))  ## function to print elements of list one line at a time


print('Problem 5.a')
## Some student knows a professor who teaches the ‘Databases’
## course.

## Your Python code for this problem must go here

print(any([Student(person1) 
and any([Professor(person2) 
and Knows(person1,person2) 
and Teaches(person2,{'c':'Databases'}) 
for person2 in P]) 
for person1 in P]))


# any([Student(Person1) and Knows(Person1, Person2) 
#     for Person1 in P)

# [{'p': Person1['P'],'p':Person2['P'], 'c':Courses['C']}
#     for Person1 in P
#         for Person2 in P
#             for Courses in C
#                 if Student(Person1) and Professor(Person2) and Knows(Person1,Person2) and Teaches(Person2,'Databases') ]

# any([Student(Person1) 
# and Knows(Person1, Person2) 
# and Teaches(Person2,)
# for Person2 in P
# for Person1 in P])
print('Problem 6.a')
## Each course taught by professor ‘Anna’ is taken by at least two
## students.

## Your Python code for this problem must go here
print(all([Implies(Teaches({'p':'Anna'},course) 
and Professor('Anna'), 
any([any([Student(person1) 
and Student(person2) 
and person1 != person2 
and Enroll(person1, course)
and Enroll(person2, course)
for person1 in P])for person2 in P]))for course in C]))

print('Problem 6.e')

print(not any([Teaches({'p':'Anna'},c) and Professor('Anna') and not any([Student(student1) and Student(student2) 
and student1 != student2 
and Enroll(student1,c) and Enroll(student2,c) for student1,student2 in P])for c in C]))

print('Problem 7.a')
## Find the majors of students who are enrolled in the course `Algorithms'

## Your Python code for this problem must go here
print_Answer([m for m in M 
if any([Student(p) 
and hasMajor(p,m) 
and Enroll(p,{'c':'Algorithms'})
for p in P])])

print('Problem 8.a')
## Find each student who knows a student who takes a course taught by
## professor ‘Emma’ or a course taught by professor ‘Arif' or by Professor 'Anna'.

## Your Python code for this problem must go here
print_Answer([student1 for student1 in student if 
any([Knows(student1,student2) 
and any([Enroll(student2,c) 
and Teaches({'p':'Emma'},c) 
or Teaches({'p':'Arif'},c) 
or Teaches({'p':'Anna'},c)for c in C ])for student2 in student])])

print('Problem 9.a')
## Find each pair of different students who both know a same professor
## who teaches the course ‘Databases’

## Your Python code for this problem must go here
print_Answer((student1,student2) for student1 in P for student2 in P  
if Student(student1) and Student(student2) 
and student1 != student2 
and any([Teaches(p,{'c':'Databases'}) and Knows(student1,p) and Knows(student2,p) for p in P]))

print('Problem 10.a')
## Find each professor who only teaches courses taken by all students
## who major in `DataScience'

## Your Python code for this problem must go here
print_Answer([p for p in professor 
if all([Implies(Teaches(p,c), 
all(Implies(hasMajor(s,{'m':'DataScience'}), 
Enroll(s,c)) for s in student))]
for c in C)])


print('Problem 11.a')
## Find each professor who does not know any student who majors in
## both ‘DataScience’ and in ‘Physics

## Your Python code for this problem must go here
print_Answer([p for p in professor 
if not any([hasMajor(s,{'m':'Data Science'}) and hasMajor(s,{'m':'Chemistry'}) and Knows(p,s) for s in student])])

print('Problem 12.a')

## Find each pair of different students who have a common major and who
## take none of the courses taught by professor `Pedro'

## Your Python code for this problem must go here
print_Answer([(student1,student2) for student1 in P for student2 in P 
if Student(student1) 
and Student(student2) 
and student1 != student2 
and any([hasMajor(student1,m) 
and hasMajor(student2,m) 
and not any([Teaches({'p':'Pedro'}, course) 
and (Enroll(student1,course) or Enroll(student2,course)) 
for course in C])for m in M])])
