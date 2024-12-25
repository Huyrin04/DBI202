create database QLSV1
go
use QLSV1

create table Student(
StudentID varchar(10) primary key,
StudentFName varchar(150) not null,
StudentLName varchar(150) ,
StudentGender bit not null,
StudentDoB date not null,
StudentAddress varchar(150) not null
)

create table Class(
classCode varchar(150) primary key,
className varchar(150) not null
)

create table Subject(
subjectCode varchar(10) primary key,
subjectName varchar(150) not null,
numOfCredit int
)

create table Scholarship(
schoName varchar(150) primary key,
schoGranted varchar(150) not null
)

create table Exam(
StudentID varchar(10) foreign key references Student(StudentID),
subjectCode varchar(10) foreign key references Subject(subjectCode),  --có thể không cần ghi not null vì nó là mặc định khi bên dưới dùng primary
examDate date,
examScore float not null,
constraint PK primary key (StudentID,subjectCode,examDate)
)

create table StudentScholarship(
StudentID varchar(10) foreign key references Student(StudentID),
schoName varchar(150) foreign key references Scholarship(schoName),
constraint FK primary key (StudentID,schoName)
)

create table StudentClass(
StudentID varchar(10) foreign key references Student(StudentID),
classCode varchar(150) foreign key references Class(classCode),
constraint QK primary key (StudentID,classCode)
)

--NHẬP GIỮ LIỆU

insert into Class 
values('SE1880','LopCongNghe'),
	('MK1881','LopKinhDoanh'),
	('HE1882','LopPhanMem')

insert into Student 
values('He186323','Nguyen','Nam','8','2004','Hanoi'),
      ('He186321','Do','Phong','7','2004','Hanoi'),
      ('He186322','Pham','Nhan','6','2004','Hanoi')

insert into Exam(StudentID,subjectCode, examDate,examScore) 
values('He186323','PRF192','2020','8.2'),
      ('He186321','CSD201','2020','8.7'),
	  ('He186322','OSG202','2020','8.2')

insert into Scholarship 
values('FPTUniversity','100'),
      ('FTUniversity','70'),
	  ('NEUUniversity','50')

insert into Subject (subjectCode,subjectName,numOfCredit) 
values ('PRF192','LapTrinh','3'),
       ('CSD201','CTDLGTT','3'),
	   ('OSG202','HeDieuHanh','3')

insert into StudentClass(StudentID,classCode) 
values ('He186323','SE1880'),
	   ('He186321','MK1881'),
	   ('He186322','HE1882')

insert into StudentScholarship(StudentID,schoName) 
values('He186323','FPTUniversity'),
	  ('He186321','FTUniversity'),
	  ('He186322','NEUUniversity')

--xóa trong Exam
delete 
from  Exam 
from  Student
where Student.StudentID = Exam.StudentID
and Student.studentID = 'He186321'

delete 
from Exam
where Exam.examScore > 8.5


update Subject  --đổi record 
set subjectName = 'Lap Trinh Obj', numOfCredit = '10'
where subjectCode = 'PRF192' 

select * from Subject  -- in ra bảng vừa sử dụng

create table Diem(
Masv nchar(10) not null,
MaMon nchar(10) not null,
DiemThi float, 
constraint check_con check (DiemThi>=0 and DiemThi<=10)  --kiểm tra nhập vào
)

create table Diem2(
Masv nchar(10) not null,
MaMon nchar(10) not null,
DiemThi float default(0)
)
