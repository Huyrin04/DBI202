select * from Orders

create trigger XyLyNhap_Orders
on Orders
with encryption
for insert
as
if not exists (select * from inserted
			where CustomerID < 3 
				or CustomerID > 2024)
	begin 
		print N'Nhập không thành công'
		rollback tran
	end 
else print N'Nhập thành công'

--- insert into Orders
--- values(............)

--disable trigger Orders --dùng để tắt trigger
--enable trigger Orders  --dùng để bật lại trigger



 
