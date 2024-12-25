use Northwind

select * from Orders

create view Customer_Order 
as 
select c.*, OrderDate    --không cần o.OrderDate vì OrderDate chỉ có trong Orders
from Customers c, Orders o
where c.CustomerID = o.CustomerID 
and year(OrderDate) = 1996
and month(OrderDate) = 7

select * from Customer_Order