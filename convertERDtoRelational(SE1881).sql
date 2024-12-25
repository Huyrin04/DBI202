create database SE1881
use SE1881
/*
create table Agent(
aName varchar(10) not null,
cName varchar(10) not null,
city varchar(30) not null,
phone varchar(11),
Constraint PK primary key (aName, cName)
)

create table Presenter(
SIN varchar(10) primary key,
fName varchar(20) not null,
lName varchar(20) not null,
aName varchar(10),
cName varchar(10),
hair varchar(20), 
constraint FK foreign key(aName, cName) references Agent(aName, cName)
)

create table ProdComp(
pcName varchar(20) primary key,
netWorth varchar(30) not null,
country varchar(30) not null,
)

create table Show(
sName varchar(20) primary key,
station varchar(20) not null,
season varchar(20) not null,
pcName varchar(20) foreign key references ProdComp(pcName)
)

create table Presents(
SIN varchar(10) foreign key references Presenter(SIN),
sName varchar(20) foreign key references Show(sName),
times date,
rating int,
constraint PK1 primary key(SIN, sName),  --hoặc không cần constraint PK1
)
*/

create table Teachers(
TeacherID int primary key,
Name nvarchar(50) not null,
Address nvarchar(200) not null,
Gender char(1) not null,
)

create table Classes(
GroupID char(6) not null,
courseID char(6) not null,
NoCredits int not null,
Semester char(10) not null,
year int not null,
ClassID int primary key,
TeacherID int foreign key references Teachers(TeacherID),
)

create table Students(
StudentID int primary key,
Name nvarchar(50) not null,
Address nvarchar(200) not null,
Gender char(1) not null,
)

create table Attend(
Date date,
Slot int,
Attend bit,
StudentID int,
ClassID int,
primary key(Date, Slot),
foreign key(StudentID) references Students(StudentID),
foreign key(ClassID) references Classes(ClassID),
)


