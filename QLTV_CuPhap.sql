--Cú Pháp
/*Xóa: 
DROP DATADASE <tên DATABASE>

[USE <tên DATABASE>]
DROP TABLE <tên TABLE>;
*/

/*Sửa tên:
ALTER DATABASE <tên DATABASE>
Modify Name =  <tên DATABASE mới>
*/

/*UNIQUE:
Ràng buộc UNIQUE sẽ yêu cầu tất cả các giá trị trong một cột phải khác nhau.
Bạn có thể có nhiều ràng buộc UNIQUE trong mỗi bảng nhưng chỉ có một ràng buộc PRIMARY KEY trong mỗi bảng.
*/


--CREATE DATADASE QLTV <tên DATABASE>
CREATE DATABASE QLTV

USE QLTV
/*CREATE TABLE <tên TABLE>
(<tên cột 1> <data type> [column relationship],    (đặt trong ngoặc vuông nghĩa là không bắt buộc phải có rằng buộc cột)
 <tên cột 1> <data type> [column relationship],
 ...
 <tên cột n> <data type> [column relationship],
 [table relationship]
)
*/

/*
TABLE RELATIONSHIP:
Primary key: khóa chính
foreign key references: khóa ngoài
not null: không rỗng (tức phải có dữ liệu)
check: kiểm tra điều kiện
default: rằng buộc mặc định
*/

CREATE TABLE BOOK(
BookID char(10) primary key,  --khóa chính
Title nchar(50) not null,
Publisher nchar(50),
YearPub int
)

CREATE TABLE READER(
ReaderID char(10) primary key,  --khóa chính
ReaderName nchar(50) not null,
Gender nchar(50),
DateOfBirth date
)

CREATE TABLE BorrowBook(
ReaderID CHAR(10) foreign key references READER(ReaderID), --Cột ReaderID trong bảng READER kết nối với cột ReaderID trong bảng BorrowBook
BookID CHAR(10) NOT NULL,	
StartBorrow date not null,
returnDate date,
EndDate date not null,
Constraint FK foreign key (BookID) references BOOK(BookID),
Constraint PK primary key (ReaderID,BookID,StartBorrow)
)

ALTER DATABASE QLTV
Modify Name =  QLTV_CuPhap

/*
Muốn đổi về chọn sang Master
ALTER DATABASE QLTV_CuPhap
Modify Name =  QLTV
*/

create table newTable(
STT int identity(1,2),
Name char(30) unique,
Year int
)


--drop table newTable