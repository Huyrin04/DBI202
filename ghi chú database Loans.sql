--Loans(mượn): LoanID(mã mượn, mỗi lần mượn sẽ có 1 mã), MemberID(mã khách), LoanDate(ngày mượn), LoanDue(hạn trả)
--LoanDetails: LoanDetailID(đại diện cho từng cuốn sách cụ thể trong một lần mượn sách), returnDate (ngày trả)
--(ví dụ A mượn 2 quyển sách thì lần mượn đó có LoanID=1 và 2 quyển sách mượn có LoanDetailID là 1 và 2)
--Members(mã khách, tên khách,...)
--Authors(tác giả)
--Genger(thể loại)
--Title(tiêu đề)
--borrowed(đã mượn)
--longest-running(tồn tại lâu nhất)

--Q2
--Select all loans issued by the member with MemberID=1 as follows
--(Chọn tất cả các khoản mượn do thành viên phát hành có MemberID=1 như sau)
select LoanID, LoanDate, DueDate
from Loans
where MemberID = 1

--Q3
--Write a query to select the Title, AuthorName, and GenreName of all books published after the year 2010.
--(Viết truy vấn để chọn Tiêu đề, Tên tác giả và Tên thể loại của tất cả các cuốn sách được xuất bản sau năm 2010.)
select Title, AuthorName, GenreName
from 
(select Title, AuthorName, GenreID
from Books b join Authors au
on b.AuthorID = au.AuthorID
where b.PublicationYear > 2010)X
join Genres g
on X.GenreID = g.GenreID

--Q4
--Write a query to select BookID, Title, and AuthorName of the books that are written by the author 'J.K. Rowling'
--(Viết truy vấn để chọn BookID, Title và AuthorName của những cuốn sách được viết bởi tác giả 'J.K. Rowling')
select BookID, Title, AuthorName
from Books b join Authors au
on b.AuthorID = au.AuthorID
where AuthorName= 'J.K. Rowling'

--Q5
--Write a query to calculate the book with the highest number of copies
--(Viết câu truy vấn tính sách có số bản in nhiều nhất)
select top 1 with ties Title, count(CopyID) as MaxTotalCopies
from Books b join BookCopies bc
on b.BookID = bc.BookID
group by bc.BookID, b.Title 
order by count(CopyID) desc


--Q6
--Print information about overdue transactions with a loan date of January 2021
--(In thông tin giao dịch quá hạn có ngày mượn là tháng 1/2021)
select Title, MemberName, LoanDate, DueDate, ReturnDate
from 
(select MemberName, LoanDate, DueDate, ReturnDate, BookID
from
(select m.MemberName, LoanDate, DueDate, ReturnDate, CopyID
from
(select LoanDate, DueDate, ReturnDate, MemberID, CopyID
from Loans l join LoanDetails ld
on l.LoanID = ld. LoanID)X
join Members m on X.MemberID = m.MemberID)Y
join BookCopies on Y.CopyID = BookCopies.CopyID)Z
join Books on Z.BookID = Books.BookID
where DueDate < ReturnDate
and YEAR(LoanDate) =2021 and MONTH(LoanDate)=1

--Q7
--Write a query to find all the book copy that has been borrowed the most. Display the CopyID, Title, and TotalBorrows.
--(Viết truy vấn để tìm tất cả các bản sách copy được mượn nhiều nhất. Hiển thị CopyID, Tiêu đề và tổng mượn.)
--C1: 185/33/151
select top 1 with ties bc.CopyID, Title, count(LoanDetailID) as totalBrrows
from BookCopies bc 
join LoanDetails l on l.CopyID = bc.CopyID
join Books b on b.BookID = bc.BookID
group by bc.CopyID, Title
order by totalBrrows desc

--C2: 33/151/185
select Y.CopyID, Title, Y.borrowns as TotalBrrows from
(select BookCopies.CopyID, x.borrowns, BookID from
(select top 1 with ties BookCopies.CopyID, count(LoanID) as borrowns from BookCopies left join LoanDetails
on LoanDetails.CopyID = BookCopies.CopyID
group by BookCopies.CopyID
order by borrowns desc)X
join BookCopies on BookCopies.CopyID = X.CopyID)Y
join Books on Books.BookID = Y.BookID

--C3:33/185/151
select  bc.CopyID, Title, count(LoanDetailID) as totalBrrows
from BookCopies bc 
join LoanDetails l on l.CopyID = bc.CopyID
join Books b on b.BookID = bc.BookID
group by bc.CopyID, Title
having count(l.LoanDetailID) = 
(select max(BrrowCount) 
from(select COUNT(LoanDetailID) as BrrowCount from LoanDetails group by CopyID) as SubQuery)

--Q8:
--Create a procedure proc2, with the input as @AuthorID, @publicationYear outputs the total number of books written by this author and published in publication Year.
--DECLARE @TotalBook INT
--EXEC proc2 1,1997,@TotalBook OUTPUT
--SELECT @TotalBook AS NumberOfBook
--(Tạo thủ tục proc2, với đầu vào là @AuthorID, @publicationYear xuất ra tổng số sách do tác giả này viết và xuất bản trong Năm xuất bản.
create proc proc2 
@Author int,
@publicationYear int,
@TotalBook int OUTPUT
as
begin 
--lệnh set dùng để sửa giá trị
set @TotalBook=    
	(select count(BookID) 
	from Books
	group by AuthorID, PublicationYear
	having AuthorID = @Author and PublicationYear = @publicationYear)
end

--hoặc: 
--begin 
--	select @TotalBook = count(BookID) 
--	from Books
--	group by AuthorID, PublicationYear
--	having AuthorID = @Author and PublicationYear = @publicationYear
--end

--Q9
--Write a trigger Tr2 to display detailed information of a book after a new book is inserted into the Books table. The information to be displayed includes: BookID, Title, AuthorName, and GenreName.
--(Viết trigger Tr2 để hiển thị thông tin chi tiết của một cuốn sách sau khi một cuốn sách mới được chèn vào bảng Books. Thông tin được hiển thị bao gồm: BookID, Title, AuthorName và GenreName.)
--INSERT INTO dbo.Books
--(BookID,Title,AuthorID, PublicationYear,ISBN,GenreID)
--VALUES
--(150,'Ahihi',1,2024,9780590353489,1)
create trigger tr2
on Books
after insert
as
begin 
	select X.BookID, X.Title, X.AuthorName, GenreName from
	(select inserted.BookID, inserted.Title, inserted.GenreID, AuthorName from inserted left join Authors a
	on a.AuthorID = inserted.AuthorID)X
	join Genres g
	on g.GenreID = X.GenreID
end

--Q10
-- ví dụ bắt chèn authorID của người có tên 'J.K. Rowling', thì ta ghi 
-- values((select AuthorID from Authors where AuthorName = 'J.K. Rowling'))

--C2: update <table>
--set AuthorID = (select AuthorID from Authors where AuthorName = 'J.K. Rowling')
--where <biến đã insert>

--Q11:
--Write a query to find the top 5 authors who have written the most books. Display the AuthorName and the number of books they have written.
--(Viết một truy vấn để tìm ra 5 tác giả viết nhiều sách nhất. Hiển thị Tên tác giả và số lượng sách họ đã viết.)
SELECT a.AuthorName, COUNT(b.BookID) AS NumberOfBooks
FROM  Authors a join Books b 
ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorName
ORDER BY NumberOfBooks DESC
offset 0 rows fetch next 5 rows only -- Bỏ qua 0 hàng đầu tiên, lấy 5 hàng tiếp theo

--Q12:
--Write a query to list the titles and authors of books that have not been borrowed at all.
--(Viết câu truy vấn để liệt kê tên sách và tác giả những cuốn sách chưa mượn.)
select Title, AuthorName
from
	(SELECT b.Title, a.AuthorName, bc.CopyID
	FROM Books b 
	join Authors a on b.AuthorID = a.AuthorID 
	full join BookCopies bc on bc.BookID = b.BookID)X
full join LoanDetails ld on ld.CopyID = X.CopyID
where LoanDetailID is null
group by Title, AuthorName --có thể bỏ group by và thêm distinct

--Q13: 
--Write a query to select the title and year of publication of the oldest book in the database.
--(Viết truy vấn để chọn tiêu đề và năm xuất bản của cuốn sách cổ nhất trong cơ sở dữ liệu.)
SELECT top 1 Title, PublicationYear
FROM  Books
ORDER BY PublicationYear ASC

--Q14:
--Write a query to display the total number of books for each genre. Display the GenreName and the total number of books.
--(Viết truy vấn để hiển thị tổng số sách của từng thể loại. Hiển thị Tên thể loại và tổng số sách.)
select g.GenreName, COUNT(b.BookID) AS TotalBooks
from Genres g join Books b 
on g.GenreID = b.GenreID
group by g.GenreName;

--Q15: 
--Write a query to find the authors who have published books in more than one genre. Display the AuthorName and the genres.
--(Viết truy vấn để tìm các tác giả đã xuất bản sách ở nhiều thể loại. Hiển thị Tên tác giả và thể loại.)
select a.AuthorName, STRING_AGG(g.GenreName, ', ') AS Genres
from Authors a
join Books b ON a.AuthorID = b.AuthorID
join Genres g ON b.GenreID = g.GenreID
GROUP BY  a.AuthorName
having count(distinct g.GenreID) > 1;

--Q16:
--Write a query to calculate the average year of publication for books by each author. Display the AuthorName and the average year of publication.
--(Viết truy vấn tính số năm xuất bản trung bình của mỗi tác giả. Hiển thị Tên tác giả và năm xuất bản trung bình.)
SELECT  a.AuthorName,  AVG(b.PublicationYear) AS AverageYear
FROM  Authors a join Books b 
ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorName

--Q17:
--Write a query to display the detailed information of books (Title, AuthorName, GenreName) that have been borrowed more than 5 times.
--(Viết câu truy vấn hiển thị thông tin chi tiết các cuốn sách (Tiêu đề, Tên tác giả, Tên thể loại) đã được mượn trên 5 lần.)
select Title, AuthorName, GenreName
from
(select Title, AuthorName, GenreName, X.BookID, CopyID
from
	(SELECT  b.Title,  a.AuthorName, g.GenreName, BookID
	FROM Books b
	JOIN Authors a ON b.AuthorID = a.AuthorID
	JOIN Genres g ON b.GenreID = g.GenreID)X
full join BookCopies bc on bc.BookID = X.BookID)Y  --phải lấy cả những quyển ko đc copy
full join LoanDetails ld on ld.CopyID = Y.CopyID
group by Title, AuthorName, GenreName
having count(LoanDetailID) > 5

--Q18:
--Write a query to list the authors who have not published any books in the last 5 years. Display the AuthorName and the last year they published a book.
--(Viết truy vấn để liệt kê các tác giả chưa xuất bản cuốn sách nào trong 5 năm qua. Hiển thị Tên tác giả và năm cuối cùng họ xuất bản một cuốn sách.)
SELECT a.AuthorName,  MAX(b.PublicationYear) AS LastYearPublished
FROM  Authors a join Books b 
ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorName
HAVING MAX(b.PublicationYear) < YEAR(GETDATE()) - 5; --getdate trả về ngày giờ hệ thống hiện tại

--Q19:
--Create a stored procedure named Proc1 to calculate the number of books borrowed by a given member where member_id INT is the input parameter of the procedure and NumberOfBooks INT is the output parameter of the procedure.
--(Tạo một thủ tục lưu sẵn có tên Proc1 để tính số lượng sách được một thành viên nhất định mượn trong đó member_id INT là tham số đầu vào của thủ tục và NumberOfBooks INT là tham số đầu ra của thủ tục.)
--DECLARE @x INT
--Exec Proc1 35, @x OUTPUT
--SELECT @x as NumberOfBooks
create proc proc1 
@member_id int, 
@NumberOfBooks int output
as
begin
	select @NumberOfBooks = count(distinct bc.BookID)
	from Loans l 
	join LoanDetails ld on l.MemberID = @member_id and l.LoanID = ld.LoanID
	join BookCopies bc on ld.CopyID = bc.CopyID
end

--Q20:
--Create a trigger named Trigger1 for the delete statements on the “BookCopies” table so that when we call a delete statement to delete one or more rows from the “BookCopies” table, the system will automatically delete also from the “LoanDetails” table all the loan details of the deleted Copy Book.
--(Tạo một trình kích hoạt có tên Trigger1 cho các câu lệnh xóa trên bảng “BookCopies” để khi chúng ta gọi một câu lệnh xóa để xóa một hoặc nhiều hàng khỏi bảng “BookCopies”, hệ thống cũng sẽ tự động xóa tất cả các dòng khỏi bảng “LoanDetails” chi tiết mượn của Sổ sao chép đã bị xóa.)
--(hoặc đề nói delete all information related to BookCopies : xóa tất cả thông tin liên quan đến BookCopies, thì ta thấy LoanDetails tham chiếu đến khóa chính ở BookCopies, nên ta cũng phải xóa nd lquan ở loanDetails)
--DELETE FROM BookCopies WHERE CopyID = 10
create or alter trigger trig1
on BookCopies
instead of delete
as
begin
--delete from LoanDetails
	delete from LoanDetails 
	where CopyID in (select CopyID from deleted)
--delete from BookCopies
	delete from BookCopies
	where CopyID in (select CopyID from deleted)
end