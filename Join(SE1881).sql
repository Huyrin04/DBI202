use SE1881

create table Class(
Class_ID int primary key,
Class_Name nchar(30) not null
)

insert into Class 
values (106,'Lop SE1881'),
(107,'Lop SE1882'),
(201,'Lop SE1883'),
(202,'Lop SE1884')

create table Student(
Student_ID int primary key,
Name nchar(30) not null,
Class_ID char(10)
)

insert into Student 
values(1,'A',106),
(2,'B',106),
(3,'C',106),
(4,'D',106),
(5,'E',106),
(6,'F',107),
(7,'G',107),
(8,'H',107),
(9,'I',107),
(10,'J',107),
(11,'K',107),
(12,'L',107),
(13,'M',108),
(14,'N',Null),
(15,'M',Null)

select*
from Student

-- inner join
select*
from Class B inner join Student A
on B.Class_ID = A.Class_ID    -- kết nối qua Class_ID

select A.*, B.Class_Name -- hiển thị full A và chỉ thêm trường Class_Name của B
from Class B inner join Student A
on B.Class_ID = A.Class_ID 

-- right outer join
select *
from Class B right outer join Student A  --không cần outer cũng đc, B viết trước thì Class là bảng left, Student là bảng right 
on B.Class_ID = A.Class_ID 

select *
from Class B full join Student A  
on B.Class_ID = A.Class_ID 

create table Employees(
Employee_ID int primary key,
Name char(1) not null,
Manager_ID int  --người quản lý
)

insert into Employees
values(101,'A',null),
(102,'B',101),
(103,'C',101),
(119,'D',101),
(120,'E',200),
(200,'F',200)

select convert(char(3),a.Employee_ID) + ' managed by ' + convert(char(3),b.Employee_ID)
from Employees A, Employees B
where a.Manager_ID = b.Employee_ID



create table movies(
title varchar(20),
year int,
length int, 
genre varchar(20), 
studioName varchar(20)
)

create table starsIn(
movieTitle varchar(20), 
movieYear int, 
starName varchar(20)
)

SELECT m.studioName
FROM movies m
WHERE m.title in
(select movieTitle
from starsIn 
where starName = 'Harrison Ford'
) 
and m.year in 
(select movieYear
from starsIn 
where starName = 'Harrison Ford'
)

SELECT DISTINCT m.studioName
FROM movies m join starsIn s 
ON m.title = s.movieTitle AND m.year = s.movieYear
WHERE s.starName = 'Harrison Ford';


