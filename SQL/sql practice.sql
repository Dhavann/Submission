select * from customer;
select * from salesorder;
select * from employee;
select * from orderdetail;
select * from product;
select * from supplier;

use northwind;

select count(so.orderId) as ans
from customer c join salesorder so on c.custid=so.custid
join orderdetail od on so.orderid=od.orderId
join product p on od.productid=p.productid
join supplier s on p.supplierid=s.supplierId
where  c.city!=s.city;

-- 1
select distinct(e.lastname)as name
from employee e join salesorder so on so.employeeId=e.employeeid
join orderdetail o on o.orderId=so.orderId
where (o.unitPrice*o.quantity) >(select avg(unitprice * quantity)as ans from orderdetail);

-- 2
with cte as(
select *,avg(unitPrice * quantity) as aov  from orderdetail group by 1
)
select distinct(e.lastname)as name
from employee e join salesorder so on so.employeeId=e.employeeid
join orderdetail o on o.orderId=so.orderId
join cte c on o.orderid=c.orderid
where (o.unitPrice * o.quantity) > c.aov;

-- 3 

select distinct(e.lastname)as name
from employee e join(select e.employeeid,od.orderid,avg(od.unitPrice*od.quantity) as aov from 
orderdetail od join salesorder so on so.orderid=od.orderid
join employee e on e.employeeid = so.employeeid group by 1,2
)x on e.employeeid=x.employeeid group by 1 having (x.unitPrice*x.quantity) > x.aov;


select e.employeeid,avg(unitprice*quantity)over(partition by '1' ) ;

select count(distinct(employeeid)) as ecount
from(
select e.employeeid,od.orderid, od.unitPrice*od.quantity as ov,avg(od.unitPrice*od.quantity) over(partition by e.employeeid ) as aov 
from orderdetail od join salesorder so on so.orderid=od.orderid
join employee e on e.employeeid = so.employeeid)e 
where ov>aov;

select e.employeeid,od.orderid, od.unitPrice*od.quantity as ov,avg(od.unitPrice*od.quantity) over(partition by e.employeeid ) as aov 
from orderdetail od join salesorder so on so.orderid=od.orderid
join employee e on e.employeeid = so.employeeid

