use Northwind

insert into Products(ProductName, SupplierID, CategoryID, QuantityPerUnit)
values('SE1881', 10, 1, '27 student')

select top 50 percent Products.*    -- 50% tức chỉ in ra một nửa bảng, có thể thay đổi %, .* để lấy toàn bộ thuộc tính
from Products, Categories
where Products.CategoryID = Categories.CategoryID
and CategoryName = 'Beverages'
--and CategoryName <> 'Beverages' -- Dấu <> : khác

-- as để in ra với một cái tên khác
-- phải convert cho cùng kiểu dữu liệu
select ProductID, ProductName as "Product Name", SupplierID, ProductName +' '+ convert(nvarchar(40),SupplierID) as SumProduct_Supplier
from Products p, Categories c      -- p, c là bí danh, sau khi đặt thì phải dùng nó
where p.CategoryID = c.CategoryID 
and CategoryName = 'Beverages'

select distinct SupplierID  --  DISTINCT: Loại bỏ tất cả các giá trị trùng lặp khỏi bộ kết quả.
from Products p, Categories c     
where p.CategoryID = c.CategoryID 
and CategoryName = 'Beverages'

select Products.*, CategoryName   
from Products, Categories
where Products.CategoryID = Categories.CategoryID
and UnitsInStock between 100 and 150
and CategoryName like 'c%'         -- %c% miễn là có chữ c thì in, c%: phải có c đầu câu, %c: phải có c cuối câu
--and UnitsInStock > 39 and ReorderLevel > 10

select Products.*, CategoryName   
from Products, Categories
where Products.CategoryID = Categories.CategoryID
and CategoryName like 'c%' 
and ProductName like '%e_'  --kết thúc là e và 1 kí tự bất kì (dấu _ đại diện cho 1 kí tự)

select Products.* 
from Products, Categories
where Products.CategoryID = Categories.CategoryID
and ProductName like '[c,d]%' --bắt đầu bằng c or d thì in

-- ORDER BY
-- ASC: sắp xếp tăng dần, DESC: sắp xếp giảm dần
select Products.* 
from Products, Categories
where Products.CategoryID = Categories.CategoryID
order by ProductName, UnitsInStock desc -- ưu tiên sắp xếp cho ProductName rồi mới đến UnitsInStock

select*
from Products

select*
from Categories

select *
from Orders
where year(OrderDate) = 1997 
and month(OrderDate) = 2
and day(OrderDate) = 3

select max(OrderDate)
from Orders

select max(YEAR(OrderDate))
from Orders

select getdate()

select convert(char(10),getdate(),111) --không có 111 sẽ ra tiếng anh, có thể đổi 110, 112, 113, 114


--------------------------------------------------------------
--------------------------------------------------------------

use SE1881

--GROUP BY
select s.Class_ID, Class_Name, count(s.Student_ID) as SoLuongSinhVienClass
from Class c, Student s
where s.Class_ID = c.Class_ID
group by s.Class_ID, Class_Name --Class_ID tham gia vào phân nhóm nên ghi ở group by, Class_Name không tham gia vào phân nhóm, 
                                --nhưng ở select ta in nó ra nên ta vẫn phải thêm nó sau group by

select count(Class_ID) as SoLuongSinhVien
from Student

select s.Class_ID, Class_Name, count(s.Student_ID) as SoLuongSinhVienClass
from Class c, Student s
where s.Class_ID = c.Class_ID 
group by s.Class_ID, Class_Name 
having count(s.Student_ID) > 5


-- Begin Transaction, nếu không lỗi (tức values hợp lệ) thì sẽ insert, lỗi sẽ kết thúc
begin transaction sp
insert into Student 
values('16', 'Huy', 109)
if(@@ERROR <> 0) rollback transaction sp
commit transaction

--Cach dung max trong where
select *
from Student
where Student_ID = (select max(Class_ID) from Class)