use Northwind

select * from Orders

--tạo thủ tục
create proc sp_OrderDetail  --proc là viết tắt procedure
as
begin
	select od.*
	from [Order Details] od, Orders o
	where od.OrderID = o.OrderID
	and CustomerID = 'VINET'
	and year(OrderDate) = 1996
end

-- gọi thủ tục
exec sp_OrderDetail

-- xóa thủ tục
drop procedure sp_OrderDetail

-- ghi đè lại câu lệnh mới cho thủ tục
-- thay create proc -> alter proc


-- SỬ DỤNG THỦ TỤC NHẬP THAM SỐ TỪ BÊN NGOÀI VÀO
alter proc sp_OrderDetail  
@CustomerID nchar(5),   --sử dụng tham số được người dùng nhập vào
@orderDate int          --sử dụng tham số được người dùng nhập vào
as
begin
	select od.*
	from [Order Details] od, Orders o
	where od.OrderID = o.OrderID
	and CustomerID = @CustomerID
	and year(OrderDate) = @orderDate
end

exec sp_OrderDetail 'VINET', 1996 -- không có tham số bên trên thì khi gọi ra phải đi kèm tham số
                                  -- nếu gán @CustomerID nchar(5) = 'VINET', @orderDate int  = 1996 bên trên thì exec không cần tham số nữa


-- đếm và in ra số bản ghi bằng OUTPUT
alter proc sp_OrderDetail  
@CustomerID nchar(5) = 'VINET',
@orderDate int = 1996,           
@count int OUTPUT
as
begin
    set @count = 0
	select @count = count(*)
	from [Order Details] od, Orders o
	where od.OrderID = o.OrderID
	and CustomerID = @CustomerID
	and year(OrderDate) = @orderDate
end

declare @dem int   -- cái này sẽ lấy dự liệu đã đếm được
exec sp_OrderDetail @count = @dem OUTPUT 
print @dem 

