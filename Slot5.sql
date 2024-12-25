create table Sell1
(bar char(10),
beer char(10),
price float)

create table Sell2
(bar char(10),
beer char(10),
price float)

insert into Sell1 
values('Joe''s', 'Bud', 2.50),
	  ('Joe''s', 'Miller', 2.75),
	  ('Sue''s', 'Bud', 2.50)

insert into Sell2 
values('Joe''s', 'Bud', 2.50),
	  ('Joe''s', 'Miller', 2.75),
	  ('Sue''s', 'Miller', 3.00)

Select * from Sell1 union select * from Sell2  --hợp cả 2 lại

Select * from Sell1 except select * from Sell2 --in ra phần chỉ có trong Sell1

Select * from Sell1 intersect select * from Sell2  --in ra phần giống nhau 

Select bar, beer from Sell1  --in ra cột bar và beer

Select price, bar + beer as Sum1 from Sell1  --in ra cột price và cột Sum1, cột Sum1 chứa giá trị của cột bar và beer

Select price as price2, price as price3 from Sell1  --đổi tên và in ra

Select * from Sell1 -- select * là quét toàn bộ cột <=> Sell1.bar, Sell1.beer, Sell1.price, Sell2.bar, Sell2.beer, Sell2.price = *
where beer = 'Bud'

Select * from Sell1, Sell2 --nhân 2 bản ghi lại với nhau (tích đề các)

Select Sell1.bar, Sell1.beer, Sell1.price, Sell2.bar from Sell1, Sell2

Select * from Sell1, Sell2   
where Sell1.bar = Sell2.bar --kết nối tự nhiên

Select Sell1.bar, Sell1.beer, Sell2.bar, Sell2.beer from Sell1, Sell2   
where Sell1.bar = Sell2.bar --kết nối tự nhiên

Select * from Sell1 Sel --đặt bí danh (một cách đổi tên)
where Sel.bar = 'Joe''s'

exec Sp_rename 'Sell1', 'R' --đổi tên, thay đổi đối tượng, còn update thay đổi dữ liệu

